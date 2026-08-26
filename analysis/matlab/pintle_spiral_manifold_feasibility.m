%% PINTLE INJECTOR + SPIRAL/VANE MANIFOLD — PRELIMINARY FEASIBILITY STUDY
%
%   Purpose : Check, mathematically, whether the "spiral (volute) cavity +
%             turning vanes" manifold concept is dimensionally and
%             physically reasonable for a LOX / LCH4 movable pintle
%             injector, BEFORE any CAD or CFD work is done.
%
%   Status  : Thesis / research-study level. This is NOT a build-ready
%             design. If the project is later built, the propellants
%             will likely be swapped for cold-flow simulants (water/air),
%             and this script should be re-run with those properties.
%
%   Primary reference for formulae and baseline dimensions:
%     Erkal, B. (2019). "Design of a Pintle Injector." MSc Thesis,
%     Middle East Technical University (METU).
%     https://etd.lib.metu.edu.tr/upload/12624543/index.pdf
%     -> Section 2.2 "Design of Outlet Region" (mass flow / geometry
%        procedure, Eqs. 1, 5-10)
%     -> Section 1.1.1 (Weber/Reynolds definitions, Eqs. 11-13; cone
%        angle correlation, Eqs. 4, 15-16)
%     -> Table 2.3 (LOX/GCH4 design condition data)
%     -> Table 3.1 (Type-1 injector baseline geometry)
%
%   The spiral+vane manifold itself is NOT in the thesis — it is our own
%   idea (borrowed from Francis turbine spiral-casing theory). Section 6
%   onward is original work built on top of the thesis's flow numbers,
%   clearly separated from the thesis-sourced equations above it.
%
% =========================================================================

clear; clc; close all;

%% =========================================================================
%  SECTION 0 — ASSUMPTIONS (READ THIS BEFORE TRUSTING ANY NUMBER BELOW)
% =========================================================================
%
%  A1. Propellants: Liquid Oxygen (LOX, oxidizer) + Gaseous Methane
%      (GCH4, fuel), matching the thesis's own mission (this is a
%      research-study choice, not yet a hardware/cold-flow choice).
%
%  A2. Injector architecture: oxidizer-centered pintle (LOX flows down
%      the central pintle rod and exits RADIALLY at the tip through the
%      variable opening; GCH4 flows through the fixed OUTER ANNULAR gap
%      and exits AXIALLY). This matches the thesis's Section 2.1 and its
%      step 9 ("annular gap ... velocity of GCH4").
%
%  A3. Design point: we use the thesis's own Table 2.3 "highest thrust"
%      row (O/F = 4, 750 N, Pc = 64.15 bar) as the baseline design
%      condition, since it is the one fully worked out with real
%      LOX/GCH4 numbers in the thesis.
%
%  A4. Baseline geometry: Table 3.1, Injector Type-1 (pintle angle 20 deg,
%      annular gap 0.5 mm, pintle tip diameter 8 mm, pintle gap thickness
%      1.5 mm, pintle rod diameter 3 mm) is used as the starting
%      geometry, since it is the thesis's best-performing configuration
%      (lowest SMD, widest spray cone).
%
%  A5. Thin-annulus approximation: exit flow areas (both the LOX radial
%      opening and the GCH4 annular gap) are approximated as
%      (pi * diameter * gap_thickness). This is standard for pintle
%      injectors where gap << diameter (true here: 0.5 mm gap vs 8 mm
%      diameter, ~6%), and is the same simplification implicit in the
%      thesis's own K1 definition (Eq. 1).
%
%  A6. Propellant properties are NOT given explicitly in the extracted
%      thesis text (no fuel injection temperature is stated for the real
%      LOX/GCH4 condition). The values below are standard reference
%      values / reasonable placeholders and MUST be replaced with actual
%      NASA CEA or REFPROP output before this is treated as final:
%         - LOX modeled as saturated liquid oxygen near its boiling point
%         - GCH4 modeled as an ideal gas at an ASSUMED 300 K injection
%           temperature and local chamber pressure (both flagged below)
%
%  A7. Spiral manifold "bleed-off" model (Section 6 onward, our own
%      addition, not from the thesis): flow remaining inside the spiral
%      cavity decreases LINEARLY with angle theta, from the full fuel
%      flow rate at theta = 0 deg down to zero at theta = 360 deg. This
%      is the simplest physically-reasonable assumption (uniform
%      circumferential bleed-off) and is exactly the assumption a
%      Francis turbine spiral casing design also makes as a first pass.
%      A more refined (non-linear) bleed-off profile could replace this
%      later if CFD shows the linear assumption isn't accurate enough.
%
%  A8. Target uniformity condition: CONSTANT VELOCITY around the full
%      360 degrees (matches the classical spiral-casing design logic
%      discussed in the METU thesis's motivation for Francis-turbine-style
%      distribution, and is simpler to justify than a constant-pressure
%      target for a first-pass feasibility check).
%
%  A9. Cross-section shape: the spiral channel is assumed CIRCULAR at
%      every angular station, purely for a first-pass sizing estimate.
%      A real design would likely use a rectangular or shaped channel to
%      fit the injector body envelope — swap Section 6's area-to-radius
%      conversion for a rectangular-channel version once envelope
%      constraints are known.
%
%  A10. Boundary layer estimate (Section 7): a laminar flat-plate
%       approximation (delta ~ 5*Dh/sqrt(Re)) is used for the scale-effect
%       check. This is a coarse, conservative first-pass tool, not a
%       substitute for CFD (Phase 8 of the project checklist).
%
%  A11. Pressure drop estimate (Section 8): standard pipe-flow friction
%       (laminar 64/Re, turbulent Blasius 0.316/Re^0.25) plus a single
%       lumped minor-loss coefficient for the turning vanes. The vane
%       loss coefficient is a PLACEHOLDER (typical flow-straightener
%       range) and should be replaced with a real value once vane
%       geometry is finalized.
%
%  A12. This script treats GCH4 as locally incompressible for the area/
%       velocity calculations (standard low-Mach-number simplification),
%       but explicitly checks the local Mach number so that the
%       assumption's validity can be judged, not just assumed.
%
% =========================================================================


%% =========================================================================
%  SECTION 1 — CONSTANTS AND THESIS REFERENCE DATA
% =========================================================================

g0 = 9.80665;           % [m/s^2] standard gravity, used in Eq. 5/7 (T = mdot*Isp*g0)

% --- Table 2.3 of the thesis: LOX/GCH4 design condition data ---
% Columns follow the thesis table exactly (O/F ratio, chamber pressure,
% characteristic velocity, thrust coefficient, thrust, fuel mass flow,
% oxidizer mass flow, tracing opening distance Ltod).
OF_table          = [1,      2,      3,      4     ];
Pc_table_bar      = [20.00,  39.76,  53.93,  64.15 ];   % [bar]
Cstar_table_ms    = [1346.0, 1787.3, 1839.1, 1756.8];   % [m/s]  (C*)
Cf_table          = [1.51,   1.51,   1.52,   1.52  ];   % [-]    (thrust coefficient)
Thrust_table_N    = [232.27, 461.79, 630.57, 750.00];   % [N]
mdotFuel_table_kg = [0.0571, 0.0568, 0.0564, 0.0562];   % [kg/s] GCH4
mdotOx_table_kg   = [0.0571, 0.113,  0.169,  0.22  ];   % [kg/s] LOX
Ltod_table_mm     = [0.04,   0.15,   0.32,   0.50  ];   % [mm]   pintle tracing opening distance

% --- Table 3.1 of the thesis: Injector Type-1 baseline geometry ---
alpha_deg = 20;      % [deg] pintle angle
tag_mm    = 0.5;     % [mm]  annular gap thickness (GCH4 / fuel side)
Dt_mm     = 8;       % [mm]  pintle tip diameter
tpg_mm    = 1.5;     % [mm]  pintle gap thickness
Dp_mm     = 3;       % [mm]  pintle rod diameter

fprintf('=== Reference geometry: Thesis Table 3.1, Injector Type-1 ===\n');
fprintf('Pintle angle alpha = %.1f deg | tag = %.2f mm | Dt = %.2f mm | Dp = %.2f mm\n\n', ...
    alpha_deg, tag_mm, Dt_mm, Dp_mm);


%% =========================================================================
%  SECTION 2 — SELECT THE DESIGN POINT
% =========================================================================
% We use the highest-thrust row (O/F = 4, 750 N) as our baseline design
% condition, per Assumption A3. Change designIdx to study a different
% throttle point from the same table.

designIdx = 4;

OF      = OF_table(designIdx);
Pc_bar  = Pc_table_bar(designIdx);
Pc_Pa   = Pc_bar * 1e5;
Cstar   = Cstar_table_ms(designIdx);
Cf      = Cf_table(designIdx);
Thrust  = Thrust_table_N(designIdx);
mdotFuel = mdotFuel_table_kg(designIdx);   % [kg/s] GCH4
mdotOx   = mdotOx_table_kg(designIdx);     % [kg/s] LOX
Ltod_mm  = Ltod_table_mm(designIdx);       % [mm]

% Sanity check using the thesis's own Eq. (5)/(7): T = mdot_total * Isp * g0
Isp_check = Cstar * Cf / g0;                     % [s], since Isp = C*Cf/g0
mdotTotal_check = Thrust / (Isp_check * g0);     % [kg/s]
fprintf('=== Design point check (Table 2.3, O/F = %d) ===\n', OF);
fprintf('Thrust = %.2f N | Pc = %.2f bar | C* = %.1f m/s | Cf = %.2f\n', ...
    Thrust, Pc_bar, Cstar, Cf);
fprintf('mdot_total from Eq.5/7 check = %.4f kg/s (table sum = %.4f kg/s)\n\n', ...
    mdotTotal_check, mdotFuel + mdotOx);


%% =========================================================================
%  SECTION 3 — PROPELLANT PROPERTIES (SEE ASSUMPTION A6)
% =========================================================================

% --- LOX (liquid oxygen), standard reference values near boiling point ---
rho_LOX   = 1141;      % [kg/m^3]
mu_LOX    = 1.9e-4;    % [Pa.s]
sigma_LOX = 0.013;     % [N/m] surface tension (used in Weber number, Eq.11)

% --- GCH4 (gaseous methane), ideal-gas placeholder — REPLACE WITH CEA ---
T_fuel_assumed_K = 300;      % [K] ASSUMED injection temperature (placeholder)
R_CH4            = 518.3;    % [J/(kg.K)] specific gas constant for methane
gamma_CH4        = 1.30;     % [-] ratio of specific heats, typical for CH4
mu_CH4           = 1.1e-5;   % [Pa.s]

% Local GCH4 density via ideal gas law, using chamber pressure as a proxy
% for local injection pressure (simplification — a real design should use
% the actual upstream manifold pressure, which is higher than Pc by the
% injector's pressure drop budget).
rho_CH4 = Pc_Pa / (R_CH4 * T_fuel_assumed_K);   % [kg/m^3]

fprintf('=== Propellant properties (placeholders flagged in Assumption A6) ===\n');
fprintf('LOX: rho = %.1f kg/m^3, mu = %.2e Pa.s, sigma = %.4f N/m\n', ...
    rho_LOX, mu_LOX, sigma_LOX);
fprintf('GCH4: rho = %.3f kg/m^3 (at %.0f K, %.2f bar, ideal gas)\n\n', ...
    rho_CH4, T_fuel_assumed_K, Pc_bar);


%% =========================================================================
%  SECTION 4 — EXIT VELOCITIES (Assumption A5, thin-annulus areas)
% =========================================================================

% Unit conversions to SI (meters) for all geometric quantities
Dt   = Dt_mm   * 1e-3;
tag  = tag_mm  * 1e-3;
Ltod = Ltod_mm * 1e-3;

% GCH4 (fuel) side: fixed annular gap, axial exit
A_fuel = pi * Dt * tag;                 % [m^2] thin-annulus approximation
V_fuel = mdotFuel / (rho_CH4 * A_fuel); % [m/s]

% LOX (oxidizer) side: variable radial opening at the pintle tip
A_ox = pi * Dt * Ltod;                  % [m^2] thin-annulus approximation
V_ox = mdotOx / (rho_LOX * A_ox);       % [m/s]

% Speed of sound in GCH4, for a choking sanity check (thesis step 9 does
% exactly this check when sizing the annular gap)
a_CH4 = sqrt(gamma_CH4 * R_CH4 * T_fuel_assumed_K);   % [m/s]
Mach_fuel = V_fuel / a_CH4;

fprintf('=== Exit velocities & choking check ===\n');
fprintf('V_fuel (GCH4, annular)  = %.1f m/s | Mach = %.2f\n', V_fuel, Mach_fuel);
fprintf('V_ox   (LOX, radial)    = %.1f m/s\n', V_ox);
if Mach_fuel > 0.3
    fprintf('  -> Mach > 0.3: compressibility effects are becoming significant.\n');
    fprintf('     The incompressible manifold treatment in Section 6 is a\n');
    fprintf('     simplification; revisit with a compressible model if this\n');
    fprintf('     number gets much closer to 1.\n');
end
fprintf('\n');


%% =========================================================================
%  SECTION 5 — NON-DIMENSIONAL NUMBERS (Thesis Eqs. 1, 4, 10, 11, 12, 13, 15, 16)
% =========================================================================

% K1 characteristic number, thesis Eq. (1): K1 = (Vgas*tann)/(Vliq*Lopen)
% Used here as a consistency check against the thesis's own design logic
% (this is the number the thesis tunes tag/Ltod to control).
K1 = (V_fuel * tag) / (V_ox * Ltod);

% Total Momentum Ratio, thesis Eq. (10), adapted from water/air (cold flow)
% notation to the real LOX/GCH4 propellants used in this design study:
TMR = (mdotOx * V_ox * cosd(alpha_deg)) / ...
      (mdotFuel * V_fuel + mdotOx * V_ox * sind(alpha_deg));

% Spray half-cone angle from momentum balance, thesis Eq. (4):
%   cos(theta) = 1 / (1 + TMR)
theta_cone_deg = acosd(1 / (1 + TMR));

% Weber number, thesis Eq. (11)
We = rho_CH4 * Ltod * (V_fuel - V_ox)^2 / sigma_LOX;

% Reynolds numbers, thesis Eqs. (12) and (13)
Re_fuel = rho_CH4 * V_fuel * tag  / mu_CH4;   % gas side (annular gap)
Re_ox   = rho_LOX * V_ox   * Ltod / mu_LOX;   % liquid side (radial opening)

% Empirical spray half-angle correlation, thesis Eqs. (15)-(16)
% (fitted by the thesis against its own PDPA + shadowgraph data — treat
% this as an independent cross-check against the Eq.(4) momentum result)
xi = (90 - alpha_deg) / 90;
S  = 1.15 + 1.35 * xi;
p  = 1.30 + 0.90 * xi;
theta_spray_empirical_deg = 90 * xi * exp((S - 0.2) / (1 + (K1/90)^p) - S);

fprintf('=== Non-dimensional numbers & spray angle estimates ===\n');
fprintf('K1 (characteristic number, Eq.1)     = %.3f\n', K1);
fprintf('TMR (Eq.10)                          = %.3f\n', TMR);
fprintf('Spray half-angle from Eq.4 (momentum) = %.1f deg\n', theta_cone_deg);
fprintf('Spray half-angle from Eq.15-16 (empirical fit) = %.1f deg\n', theta_spray_empirical_deg);
fprintf('Weber number (Eq.11)                 = %.1f\n', We);
fprintf('Re_fuel (Eq.12, gas/annular side)     = %.0f\n', Re_fuel);
fprintf('Re_ox (Eq.13, liquid/radial side)     = %.0f\n\n', Re_ox);
fprintf('NOTE: the thesis reports ~14.6%% average difference between Eq.4 and\n');
fprintf('the empirical fit in its own validation — treat any similar gap here\n');
fprintf('as expected, not as an error in this script.\n\n');


%% =========================================================================
%  SECTION 6 — SPIRAL MANIFOLD DESIGN (OUR OWN CONCEPT, SEE ASSUMPTIONS A7-A9)
%  This section is NOT from the thesis. It uses the GCH4 (fuel) mass flow
%  rate and target velocity computed above as inputs to size a spiral
%  cavity feeding the fuel annular gap uniformly around the circumference.
% =========================================================================

% --- Stage A: inputs already available from Sections 1-4 ---
Q_fuel = mdotFuel / rho_CH4;    % [m^3/s] volumetric flow rate to distribute

% --- Stage B: linear bleed-off model (Assumption A7) ---
theta_deg = linspace(0, 360, 361);          % [deg] angular stations, 1-deg resolution
theta_rad = deg2rad(theta_deg);
Q_remaining = Q_fuel * (1 - theta_deg/360); % [m^3/s] flow still inside the spiral at each theta

% --- Stage C: required cross-sectional area for constant velocity (Assumption A8) ---
V_target = V_fuel;                          % hold the same velocity as the annular exit
A_required = Q_remaining / V_target;        % [m^2], via continuity: A = Q/V
A_required(end) = eps;                      % avoid exact zero at theta=360 (numerical only)

% --- Stage D: convert area to a physical channel size (Assumption A9) ---
r_channel = sqrt(A_required / pi);          % [m] "radius" of an equivalent circular channel
Dh_channel = 2 * r_channel;                 % [m] hydraulic diameter (circular section)

% --- Envelope geometry: outer spiral wall radial position (for path length only) ---
% These bound the injector body envelope and are DESIGN INPUTS, separate
% from the channel sizing above. Adjust to your actual body envelope.
R_spiral_start_mm = 25;   % [mm] radius at theta = 0 (largest, at the inlet)
R_spiral_end_mm   = 15;   % [mm] radius at theta = 360 (smallest, at the "tongue")
R_spiral = linspace(R_spiral_start_mm, R_spiral_end_mm, length(theta_deg)) * 1e-3; % [m]

fprintf('=== Spiral manifold sizing (Section 6, our own concept) ===\n');
fprintf('Q_fuel to distribute = %.3e m^3/s\n', Q_fuel);
fprintf('Channel radius range: %.3f mm (theta=0) to %.3f mm (theta=360)\n', ...
    r_channel(1)*1e3, r_channel(end)*1e3);
fprintf('NOTE: r_channel is the FLOW-CARRYING channel size, NOT the spiral''s\n');
fprintf('position relative to the pintle centerline (that''s R_spiral, set\n');
fprintf('separately above as an envelope input).\n\n');


%% =========================================================================
%  SECTION 7 — SCALE-EFFECT CHECK (Assumption A10)
%  This is the step that tests whether the "area = constant velocity"
%  assumption actually holds at injector scale (millimeters), rather than
%  turbine scale (meters).
% =========================================================================

Re_local = rho_CH4 .* V_target .* Dh_channel ./ mu_CH4;   % local Reynolds number

% Laminar flat-plate boundary layer thickness approximation:
%   delta ~ 5 * x / sqrt(Re_x)   -- here we use the channel's own hydraulic
% diameter as the characteristic length, which is a coarse but standard
% first-pass estimate for internal flow development.
delta_BL = 5 * Dh_channel ./ sqrt(Re_local);   % [m]

margin = r_channel - delta_BL;   % [m] positive = boundary layer is a small
                                  % fraction of the channel; negative/small
                                  % = the "area = constant velocity"
                                  % assumption is breaking down there

fprintf('=== Scale-effect check (Section 7) ===\n');
fprintf('Re_local range: %.0f (theta=0) to %.0f (theta=360)\n', Re_local(1), Re_local(end));
[minMargin, minIdx] = min(margin);
fprintf('Minimum channel-vs-boundary-layer margin = %.4f mm at theta = %.0f deg\n', ...
    minMargin*1e3, theta_deg(minIdx));
if minMargin <= 0
    fprintf('  -> FLAG: margin is zero or negative somewhere along the spiral.\n');
    fprintf('     The boundary layer would occupy the whole channel there —\n');
    fprintf('     the constant-velocity assumption is NOT valid at that point.\n');
    fprintf('     Consider: larger envelope radius, non-linear bleed-off profile,\n');
    fprintf('     or accepting a non-constant-velocity target instead.\n');
elseif minMargin < 0.1e-3
    fprintf('  -> CAUTION: margin is positive but small (<0.1 mm). Worth a closer\n');
    fprintf('     look with CFD before committing to this envelope.\n');
else
    fprintf('  -> Margin looks reasonable for a first-pass design. Proceed to\n');
    fprintf('     CFD verification (Phase 8) to confirm.\n');
end
fprintf('\n');


%% =========================================================================
%  SECTION 8 — PRESSURE DROP ESTIMATE (Assumption A11)
% =========================================================================

% Friction factor per station (laminar vs turbulent correlation)
f = zeros(size(Re_local));
for i = 1:length(Re_local)
    if Re_local(i) < 2300
        f(i) = 64 / Re_local(i);                  % laminar
    else
        f(i) = 0.316 / Re_local(i)^0.25;           % turbulent, Blasius
    end
end

% Arc length per angular step, using the envelope radius R_spiral
dTheta_rad = theta_rad(2) - theta_rad(1);
dL = R_spiral .* dTheta_rad;   % [m] arc length of each angular segment

% Frictional pressure drop per segment (Darcy-Weisbach), then summed
dP_friction_segment = f .* (dL ./ Dh_channel) .* (0.5 * rho_CH4 .* V_target.^2);
dP_friction_total = sum(dP_friction_segment);   % [Pa]

% Minor loss from the turning vanes (Assumption A11 — placeholder K value)
K_vane = 0.3;   % [-] PLACEHOLDER loss coefficient, typical flow-straightener range
dP_vanes = K_vane * 0.5 * rho_CH4 * V_fuel^2;   % [Pa]

dP_total = dP_friction_total + dP_vanes;        % [Pa]

% Compare against a pressure-drop budget (rule of thumb: ~15-25% of Pc)
dP_budget_fraction = 0.20;
dP_budget = dP_budget_fraction * Pc_Pa;

fprintf('=== Pressure drop estimate (Section 8) ===\n');
fprintf('Frictional dP along spiral = %.1f Pa (%.4f bar)\n', dP_friction_total, dP_friction_total/1e5);
fprintf('Vane minor-loss dP          = %.1f Pa (%.4f bar)\n', dP_vanes, dP_vanes/1e5);
fprintf('TOTAL manifold dP           = %.1f Pa (%.4f bar)\n', dP_total, dP_total/1e5);
fprintf('Budget (%.0f%% of Pc)         = %.1f Pa (%.4f bar)\n', ...
    dP_budget_fraction*100, dP_budget, dP_budget/1e5);
if dP_total > dP_budget
    fprintf('  -> FLAG: estimated manifold pressure drop EXCEEDS the budget.\n');
    fprintf('     Consider a larger envelope, fewer/thinner vanes, or a\n');
    fprintf('     revised bleed-off profile.\n');
else
    fprintf('  -> Within budget for this first-pass estimate.\n');
end
fprintf('\n');


%% =========================================================================
%  SECTION 9 — PLOTS
% =========================================================================

figure('Name','Spiral manifold — area and channel size vs angle');
subplot(2,1,1);
plot(theta_deg, A_required*1e6, 'LineWidth', 1.5);
xlabel('\theta (deg)'); ylabel('Required area (mm^2)');
title('Stage C: cross-sectional area profile A(\theta)');
grid on;
subplot(2,1,2);
plot(theta_deg, r_channel*1e3, 'LineWidth', 1.5);
xlabel('\theta (deg)'); ylabel('Equivalent channel radius (mm)');
title('Stage D: equivalent circular channel size');
grid on;

figure('Name','Spiral manifold — plan view');
% Convert envelope radius + angle to Cartesian for a top-down view sketch
x_spiral = R_spiral .* cosd(theta_deg) * 1e3;   % [mm]
y_spiral = R_spiral .* sind(theta_deg) * 1e3;   % [mm]
plot(x_spiral, y_spiral, 'LineWidth', 2); axis equal; grid on;
xlabel('x (mm)'); ylabel('y (mm)');
title('Spiral manifold outer-wall envelope (plan view)');

figure('Name','Scale-effect check');
plot(theta_deg, r_channel*1e3, 'LineWidth', 1.5); hold on;
plot(theta_deg, delta_BL*1e3, 'LineWidth', 1.5);
plot(theta_deg, margin*1e3, '--', 'LineWidth', 1.5);
yline(0, 'k:');
legend('Channel radius', 'Boundary layer thickness', 'Margin', 'Location', 'best');
xlabel('\theta (deg)'); ylabel('mm');
title('Section 7: channel size vs. boundary layer thickness');
grid on;

figure('Name','Pressure drop breakdown');
bar(categorical({'Friction','Vanes','Budget'}), ...
    [dP_friction_total, dP_vanes, dP_budget]/1e5);
ylabel('Pressure drop (bar)');
title('Section 8: pressure drop vs. budget');
grid on;


%% =========================================================================
%  SECTION 10 — SENSITIVITY SWEEP (design-space exploration)
%  Vary vane count (via a simplified loss-coefficient model) and target
%  velocity, and see how minimum margin and total pressure drop respond.
%  This is a CRUDE placeholder relationship (Assumption A11) — replace
%  K_vane_of_n with a real correlation or CFD-derived values once vane
%  geometry is finalized.
% =========================================================================

vane_counts = [6, 8, 12, 16, 24];
K_vane_of_n = 0.02 * vane_counts;    % PLACEHOLDER: crude linear loss-vs-count model

dP_vane_sweep = K_vane_of_n * 0.5 * rho_CH4 * V_fuel^2;
dP_total_sweep = dP_friction_total + dP_vane_sweep;   % friction term unchanged by vane count

figure('Name','Sensitivity: vane count vs pressure drop');
plot(vane_counts, dP_total_sweep/1e5, '-o', 'LineWidth', 1.5);
yline(dP_budget/1e5, 'r--', 'Budget');
xlabel('Number of turning vanes'); ylabel('Total manifold \DeltaP (bar)');
title('Section 10: crude vane-count sensitivity (replace placeholder model before trusting)');
grid on;

fprintf('=== Sensitivity sweep (Section 10) — vane count vs pressure drop ===\n');
for i = 1:length(vane_counts)
    fprintf('  %2d vanes -> total dP = %.4f bar\n', vane_counts(i), dP_total_sweep(i)/1e5);
end
fprintf('\n');


%% =========================================================================
%  SECTION 11 — SUMMARY / LIMITATIONS LOG
% =========================================================================

fprintf('=== SUMMARY ===\n');
fprintf('Design point: O/F=%d, Thrust=%.0f N, Pc=%.2f bar\n', OF, Thrust, Pc_bar);
fprintf('Spray half-angle (momentum, Eq.4): %.1f deg | (empirical, Eq.15-16): %.1f deg\n', ...
    theta_cone_deg, theta_spray_empirical_deg);
fprintf('Min scale-effect margin: %.4f mm at theta=%.0f deg\n', minMargin*1e3, theta_deg(minIdx));
fprintf('Total manifold pressure drop: %.4f bar vs budget %.4f bar\n', dP_total/1e5, dP_budget/1e5);
fprintf('\n');
fprintf('REMEMBER (see Section 0 for full list):\n');
fprintf(' - GCH4 properties are placeholders (Assumption A6) — replace with CEA output.\n');
fprintf(' - Linear bleed-off (A7) and constant-velocity target (A8) are simplifying\n');
fprintf('   choices, not proven-optimal — Section 10 sweep is a starting point only.\n');
fprintf(' - This script does NOT replace CFD (Phase 8) or cold-flow testing (Phase 11)\n');
fprintf('   from the project checklist — treat every number here as a go/no-go filter,\n');
fprintf('   not a final design value.\n');
