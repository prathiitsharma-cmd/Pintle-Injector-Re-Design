%% PINTLE INJECTOR + SPIRAL MANIFOLD — SIZING SCRIPT (v2, reintegrated)
%
% PURPOSE:
% This script calculates the physical dimensions required to build a spiral
% (volute) manifold for a liquid rocket engine injector, using real LOX/LCH4
% cryogenic-liquid properties and a NASA CEA design point.
%
% CHANGE LOG (v2 vs. the stripped-down v1 in this conversation):
%  - Reintegrated the non-dimensional/spray-quality checks (K1, Weber
%    number, Re_fuel, Re_ox, empirical spray-angle correlation).
%  - Reintegrated the vane-count vs. pressure-drop sensitivity sweep.
%  - Reintegrated console diagnostics: scale-effect margin flag and
%    pressure-drop-vs-budget flag.
%  - Reintegrated the summary/limitations log.
%  - Re-added the missing "pressure drop breakdown" plot.
%  - Fixed a bug: stray "[cite: 3]" text had been left outside comments on
%    two executable lines (TMR and theta_cone_deg), which would have thrown
%    an "undefined variable 'cite'" error at runtime. Removed.
%
% NOTE: because the fuel here is LIQUID methane (LCH4), not gaseous methane,
% there is no compressibility/Mach check (that only applies to a gas-side
% exit) — that omission from v1 is correct and has been left as-is.

clear; clc; close all;

%% =========================================================================
%  SECTION 0 — ASSUMPTIONS (READ THIS BEFORE TRUSTING ANY NUMBER BELOW)
% =========================================================================
%
%  A1. Propellants: Liquid Oxygen (LOX, oxidizer) + Liquid Methane (LCH4,
%      fuel) — BOTH liquid. This differs from the METU thesis's own
%      LOX/GCH4 (gas fuel) mission; several thesis-derived equations
%      (Weber number, spray-angle correlation) were originally fit for a
%      liquid-gas system and are carried over here as approximations, not
%      as validated liquid-liquid correlations (see A12).
%
%  A2. Injector architecture: oxidizer-centered pintle — LOX flows down
%      the central pintle rod and exits RADIALLY at the tip through the
%      variable opening; LCH4 flows through the fixed OUTER ANNULAR gap
%      and exits AXIALLY.
%
%  A3. Design point: a single hardcoded NASA CEA result (O/F = 3.2,
%      Thrust = 750 N, Pc = 20 bar, C* = 1831.2 m/s, Cf = 1.4876) is used
%      as the design condition. This is OUR OWN CEA run for LOX/LCH4, not
%      one of the thesis's own LOX/GCH4 table rows — there is no
%      multi-point table or throttle sweep here, unlike the original
%      thesis-table version of this script.
%
%  A4. Baseline geometry: Table 3.1, Injector Type-1 from the METU thesis
%      (pintle angle 20 deg, annular gap 0.5 mm, pintle tip diameter 8 mm,
%      pintle gap thickness 1.5 mm, pintle rod diameter 3 mm) is ADOPTED
%      DIRECTLY rather than re-derived from empirical correlations, so
%      that any measured difference between manifold designs can be
%      attributed to the manifold, not to a re-sized pintle tip. Because
%      this geometry was validated at a DIFFERENT design point (thesis
%      LOX/GCH4 table), Sections 4-5 below exist specifically to check
%      that the borrowed geometry still produces sane velocities/spray
%      numbers under our actual LOX/LCH4 design point — treat it as a
%      checked starting point, not an unquestioned one.
%
%  A5. Thin-annulus approximation: exit flow areas (both the LOX radial
%      opening and the LCH4 annular gap) are approximated as
%      (pi * diameter * gap_thickness). Standard for pintle injectors
%      where gap << diameter (true here: 0.5 mm gap vs 8 mm diameter).
%
%  A6. Propellant properties are real cryogenic-liquid reference values
%      (LOX and LCH4 near their respective boiling points), not the
%      ideal-gas GCH4 placeholder used in an earlier draft of this script.
%
%  A7. Spiral manifold "bleed-off" model (Section 6, NOT from the thesis):
%      flow remaining inside the spiral cavity decreases LINEARLY with
%      angle theta, from full fuel flow at theta = 0 deg toward zero at
%      theta = 360 deg, but is FLOORED at 5% of the starting area so the
%      channel never collapses to zero (which would crash downstream
%      CAD/CFD tools). A more refined (non-linear) bleed-off profile could
%      replace this later if CFD shows the linear assumption isn't
%      accurate enough.
%
%  A8. Target uniformity condition: CONSTANT VELOCITY around the full 360
%      degrees (classical spiral-casing design logic).
%
%  A9. Cross-section shape: the spiral channel is assumed CIRCULAR at
%      every angular station, purely for a first-pass sizing estimate. A
%      real design would likely use a rectangular or shaped channel to fit
%      the injector body envelope.
%
%  A10. Boundary layer estimate (Section 7): a laminar flat-plate
%       approximation (delta ~ 5*Dh/sqrt(Re)) is used for the scale-effect
%       check, even though Re_local is actually turbulent (~1e5). This
%       OVERestimates delta_BL, which UNDERestimates the margin — i.e. the
%       check is conservative in the safe direction, not exact. Not a
%       substitute for CFD.
%
%  A11. Pressure drop estimate (Section 8): standard pipe-flow friction
%       (laminar 64/Re, turbulent Blasius 0.316/Re^0.25) plus a single
%       lumped minor-loss coefficient for the turning vanes. The vane loss
%       coefficient is a PLACEHOLDER (typical flow-straightener range,
%       swept for sensitivity in Section 9) and should be replaced with a
%       real value once vane geometry is finalized.
%
%  A12. Weber number (Section 5): uses the thesis's own Eq. 11 structure
%       (rho_fuel * Ltod * dV^2 / sigma), which was physically an
%       AERODYNAMIC Weber number for a liquid-gas system (gas shears a
%       liquid sheet). Our fuel is now liquid, so this is genuinely
%       liquid-liquid impingement, not aerodynamic shear — the formula is
%       carried over as a QUALITATIVE atomization indicator only (using
%       fuel-side density and surface tension consistently), not a
%       validated liquid-liquid breakup model.
%
%  A13. Spiral envelope radii (R_spiral_start/end_mm, Section 6) are
%       UNJUSTIFIED PLACEHOLDER values, not derived from mass flow or
%       channel size — only used to compute path length for the friction
%       pressure-drop estimate. Replace with values set by the actual
%       injector body OD and packaging constraints before trusting the
%       Section 8 pressure-drop result.
%
% =========================================================================

%% =========================================================================
%  SECTION 1 — CONSTANTS AND BASELINE GEOMETRY
% =========================================================================

g0 = 9.80665;           % [m/s^2] standard gravity

% --- Injector Baseline Geometry (METU Thesis Type-1) ---
alpha_deg = 20;      % [deg] pintle tip angle
tag_mm    = 0.5;     % [mm]  outer ring gap where LCH4 (fuel) exits
Dt_mm     = 8;       % [mm]  diameter of the central pintle tip
tpg_mm    = 1.5;     % [mm]  pintle gap thickness
Dp_mm     = 3;       % [mm]  diameter of the central rod
Ltod_mm   = 0.5;     % [mm]  pintle opening distance at max thrust

%% =========================================================================
%  SECTION 2 — THERMODYNAMIC DESIGN POINT (NASA CEA OUTPUTS)
% =========================================================================

OF      = 3.2;         % [-]   O/F by weight
Pc_bar  = 20.0;        % [bar] chamber pressure
Pc_Pa   = Pc_bar * 1e5;% [Pa]
Thrust  = 750.0;       % [N]   target max thrust

Cstar   = 1831.2;      % [m/s] characteristic velocity
Cf      = 1.4876;      % [-]   thrust coefficient

mdotTotal = Thrust / (Cstar * Cf);              % [kg/s]
mdotOx    = mdotTotal * (OF / (OF + 1));        % [kg/s] LOX
mdotFuel  = mdotTotal * (1 / (OF + 1));         % [kg/s] LCH4

%% =========================================================================
%  SECTION 3 — PROPELLANT PROPERTIES (CRYOGENIC LIQUIDS)
% =========================================================================

% --- LOX at 111 K ---
rho_LOX   = 1134;      % [kg/m^3]
mu_LOX    = 1.86e-4;   % [Pa.s]
sigma_LOX = 0.013;     % [N/m]  surface tension

% --- LCH4 at 139 K ---
rho_CH4   = 402;       % [kg/m^3]
mu_CH4    = 1.05e-4;   % [Pa.s]
sigma_CH4 = 0.013;     % [N/m] surface tension, literature range ~0.012-0.015 N/m
                       % near LCH4 boiling point (needed for the Weber number
                       % in Section 5 — see note there)

%% =========================================================================
%  SECTION 4 — EXIT VELOCITIES
% =========================================================================

Dt   = Dt_mm   * 1e-3;
tag  = tag_mm  * 1e-3;
Ltod = Ltod_mm * 1e-3;

% --- LCH4 (fuel) side ---
A_fuel = pi * Dt * tag;                 % [m^2]
V_fuel = mdotFuel / (rho_CH4 * A_fuel); % [m/s]

% --- LOX (oxidizer) side ---
A_ox = pi * Dt * Ltod;                  % [m^2]
V_ox = mdotOx / (rho_LOX * A_ox);       % [m/s]

fprintf('=== Exit velocities ===\n');
fprintf('V_fuel (LCH4, annular)  = %.2f m/s\n', V_fuel);
fprintf('V_ox   (LOX, radial)    = %.2f m/s\n\n', V_ox);

%% =========================================================================
%  SECTION 5 — NON-DIMENSIONAL NUMBERS (REINTEGRATED)
% =========================================================================
% These check spray/mixing quality, not just manifold geometry: TMR and the
% momentum-based cone angle tell you the spray shape; K1, Weber number, and
% the two Reynolds numbers tell you whether the flow will actually atomize
% well, and the empirical correlation cross-checks the momentum result.

% Total Momentum Ratio (TMR)
TMR = (mdotOx * V_ox * cosd(alpha_deg)) / ...
      (mdotFuel * V_fuel + mdotOx * V_ox * sind(alpha_deg));

% Spray half-cone angle from momentum balance
theta_cone_deg = acosd(1 / (1 + TMR));

% K1 characteristic number: K1 = (Vfuel*tag)/(Vox*Ltod)
K1 = (V_fuel * tag) / (V_ox * Ltod);

% Weber number — atomization indicator (higher We = better sheet breakup)
% NOTE: this formula (rho_fuel * Ltod * dV^2 / sigma) is the thesis's own
% Eq. 11, written for LOX/GCH4 (liquid oxidizer + GAS fuel) — physically it
% is an AERODYNAMIC Weber number: the low-density, fast gas shears the LOX
% liquid sheet, so sigma there is correctly the LOX surface tension (the
% sheet being torn apart). Our fuel is now LIQUID methane, not gas, so this
% is genuinely liquid-liquid impingement, not aerodynamic shear — the
% thesis formula doesn't strictly apply anymore. Using sigma_CH4 here keeps
% density and surface tension on the same (fuel) side, which is the more
% defensible minimal fix, but treat this number as a qualitative "is it >>
% 1?" sanity check only, not a validated liquid-liquid breakup model.
We = rho_CH4 * Ltod * (V_fuel - V_ox)^2 / sigma_CH4;

% Reynolds numbers on each exit stream
Re_fuel = rho_CH4 * V_fuel * tag  / mu_CH4;   % fuel side (annular gap)
Re_ox   = rho_LOX * V_ox   * Ltod / mu_LOX;   % oxidizer side (radial opening)

% Empirical spray half-angle correlation (independent cross-check on
% the momentum-based theta_cone_deg above; thesis reports ~14.6% typical
% disagreement between the two as expected, not an error)
xi = (90 - alpha_deg) / 90;
S  = 1.15 + 1.35 * xi;
p  = 1.30 + 0.90 * xi;
theta_spray_empirical_deg = 90 * xi * exp((S - 0.2) / (1 + (K1/90)^p) - S);

fprintf('=== Non-dimensional numbers & spray angle estimates ===\n');
fprintf('K1 (characteristic number)            = %.3f\n', K1);
fprintf('TMR                                   = %.3f\n', TMR);
fprintf('Spray half-angle from momentum (Eq.4) = %.1f deg\n', theta_cone_deg);
fprintf('Spray half-angle, empirical fit       = %.1f deg\n', theta_spray_empirical_deg);
fprintf('Weber number                          = %.1f\n', We);
fprintf('Re_fuel (annular, LCH4 side)          = %.0f\n', Re_fuel);
fprintf('Re_ox (radial, LOX side)              = %.0f\n\n', Re_ox);

%% =========================================================================
%  SECTION 6 — SPIRAL MANIFOLD DESIGN (WITH AREA CUTOFF)
% =========================================================================

Q_fuel = mdotFuel / rho_CH4;    % [m^3/s]

theta_deg = linspace(0, 360, 361);          % [deg]
Q_remaining = Q_fuel * (1 - theta_deg/360); % [m^3/s]

V_target = V_fuel;

A_theoretical = Q_remaining / V_target;     % [m^2]

A_0 = A_theoretical(1);
A_min = 0.05 * A_0;                         % 5% minimum floor

A_required = max(A_theoretical, A_min);     % [m^2]

r_channel = sqrt(A_required / pi);          % [m]
Dh_channel = 2 * r_channel;                 % [m]

% PLACEHOLDER — UNJUSTIFIED, NEEDS A REAL DESIGN BASIS:
% These two numbers are NOT derived from anything upstream (not from mass
% flow, not from channel size) — they are an assumed physical envelope for
% where the spiral sits relative to the pintle centerline, only used to
% compute path length (R_spiral) for the friction pressure-drop estimate
% in Section 8. Replace with values set by your actual injector body OD,
% guide-bushing/actuator clearances, and manufacturing envelope once known
% — a linear 25->15mm shrink has no hydraulic or geometric justification
% on its own, it was chosen only as a plausible-looking placeholder.
R_spiral_start_mm = 25;   % [mm]
R_spiral_end_mm   = 15;   % [mm]
R_spiral = linspace(R_spiral_start_mm, R_spiral_end_mm, length(theta_deg)) * 1e-3; % [m]

%% =========================================================================
%  SECTION 7 — SCALE-EFFECT CHECK (BOUNDARY LAYER) — with reintegrated flag
% =========================================================================

Re_local = rho_CH4 .* V_target .* Dh_channel ./ mu_CH4;

% NOTE: delta ~ 5*Dh/sqrt(Re) is the LAMINAR flat-plate boundary layer
% formula. Re_local here is ~O(1e5), i.e. turbulent, where the real
% boundary layer would actually be THINNER (turbulent BL thickness scales
% closer to Re^-0.2, not Re^-0.5). So this deliberately OVERESTIMATES
% delta_BL, which underestimates margin below — conservative in the safe
% direction for a first-pass go/no-go filter, not a correctness bug. Swap
% for a turbulent flat-plate correlation (delta ~ 0.37*x/Re_x^0.2) if a
% tighter (less conservative) estimate is needed later.
delta_BL = 5 * Dh_channel ./ sqrt(Re_local);   % [m]

margin = r_channel - delta_BL;                 % [m]

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
    fprintf('     CFD verification before committing.\n');
end
fprintf('\n');

%% =========================================================================
%  SECTION 8 — PRESSURE DROP ESTIMATE — with reintegrated budget check
% =========================================================================

f = zeros(size(Re_local));
for i = 1:length(Re_local)
    if Re_local(i) < 2300
        f(i) = 64 / Re_local(i);                  % laminar
    else
        f(i) = 0.316 / Re_local(i)^0.25;          % turbulent, Blasius
    end
end

dTheta_rad = deg2rad(theta_deg(2) - theta_deg(1));
dL = R_spiral .* dTheta_rad;   % [m]

dP_friction_segment = f .* (dL ./ Dh_channel) .* (0.5 * rho_CH4 .* V_target.^2);
dP_friction_total = sum(dP_friction_segment);   % [Pa]

K_vane = 0.3;   % [-] placeholder loss coefficient for the turning vanes
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
%  SECTION 9 — SENSITIVITY SWEEP (REINTEGRATED)
%  Vane count vs. total pressure drop, so a vane count can be chosen
%  against the budget instead of just assuming K_vane = 0.3 blind.
% =========================================================================

vane_counts = [6, 8, 12, 16, 24];
K_vane_of_n = 0.02 * vane_counts;    % placeholder: crude linear loss-vs-count model

dP_vane_sweep = K_vane_of_n * 0.5 * rho_CH4 * V_fuel^2;
dP_total_sweep = dP_friction_total + dP_vane_sweep;   % friction term unchanged by vane count

fprintf('=== Sensitivity sweep (Section 9) — vane count vs pressure drop ===\n');
for i = 1:length(vane_counts)
    fprintf('  %2d vanes -> total dP = %.4f bar\n', vane_counts(i), dP_total_sweep(i)/1e5);
end
fprintf('\n');

%% =========================================================================
%  SECTION 10 — VISUALIZATION PLOTS
% =========================================================================

figure('Name','Spiral manifold — area and channel size vs angle');
subplot(2,1,1);
plot(theta_deg, A_required*1e6, 'LineWidth', 1.5);
xlabel('\theta (deg)'); ylabel('Required area (mm^2)');
title('Stage C: Cross-sectional area profile (stops at 5% floor)');
grid on;

subplot(2,1,2);
plot(theta_deg, r_channel*1e3, 'LineWidth', 1.5);
xlabel('\theta (deg)'); ylabel('Equivalent channel radius (mm)');
title('Stage D: Equivalent circular channel size');
grid on;

figure('Name','Spiral manifold — plan view');
x_spiral = R_spiral .* cosd(theta_deg) * 1e3;   % [mm]
y_spiral = R_spiral .* sind(theta_deg) * 1e3;   % [mm]
plot(x_spiral, y_spiral, 'LineWidth', 2); axis equal; grid on;
xlabel('x (mm)'); ylabel('y (mm)');
title('Spiral manifold outer-wall envelope (Top-Down View)');

figure('Name','Scale-effect check');
plot(theta_deg, r_channel*1e3, 'LineWidth', 1.5); hold on;
plot(theta_deg, delta_BL*1e3, 'LineWidth', 1.5);
plot(theta_deg, margin*1e3, '--', 'LineWidth', 1.5);
yline(0, 'k:');
legend('Channel radius', 'Boundary layer thickness', 'Margin', 'Location', 'best');
xlabel('\theta (deg)'); ylabel('mm');
title('Section 7: Channel size vs. boundary layer thickness');
grid on;

figure('Name','Pressure drop breakdown');   % re-added, was missing in v1
bar(categorical({'Friction','Vanes','Budget'}), ...
    [dP_friction_total, dP_vanes, dP_budget]/1e5);
ylabel('Pressure drop (bar)');
title('Section 8: pressure drop vs. budget');
grid on;

figure('Name','Sensitivity: vane count vs pressure drop');   % reintegrated
plot(vane_counts, dP_total_sweep/1e5, '-o', 'LineWidth', 1.5);
yline(dP_budget/1e5, 'r--', 'Budget');
xlabel('Number of turning vanes'); ylabel('Total manifold \DeltaP (bar)');
title('Section 9: vane-count sensitivity (crude placeholder model)');
grid on;

%% =========================================================================
%  SECTION 11 — SUMMARY / LIMITATIONS LOG (REINTEGRATED)
% =========================================================================

fprintf('=== SUMMARY ===\n');
fprintf('Design point: O/F=%.1f, Thrust=%.0f N, Pc=%.2f bar\n', OF, Thrust, Pc_bar);
fprintf('Spray half-angle (momentum): %.1f deg | (empirical): %.1f deg\n', ...
    theta_cone_deg, theta_spray_empirical_deg);
fprintf('Weber number: %.1f | Re_fuel: %.0f | Re_ox: %.0f\n', We, Re_fuel, Re_ox);
fprintf('Min scale-effect margin: %.4f mm at theta=%.0f deg\n', minMargin*1e3, theta_deg(minIdx));
fprintf('Total manifold pressure drop: %.4f bar vs budget %.4f bar\n', dP_total/1e5, dP_budget/1e5);
fprintf('\n');
fprintf('REMEMBER:\n');
fprintf(' - Linear bleed-off and constant-velocity target are simplifying\n');
fprintf('   choices, not proven-optimal — Section 9 sweep is a starting point only.\n');
fprintf(' - Vane loss coefficients (Sections 8-9) are placeholders, not measured values.\n');
fprintf(' - Weber number (Section 5) uses a thesis formula written for a LIQUID-GAS\n');
fprintf('   (LOX/GCH4) system; our LOX/LCH4 case is liquid-liquid, so treat We as a\n');
fprintf('   qualitative sanity check only, not a validated atomization prediction.\n');
fprintf(' - Boundary layer estimate (Section 7) uses the laminar flat-plate formula\n');
fprintf('   at a turbulent Re — this OVERestimates delta_BL, so the margin result is\n');
fprintf('   conservative (safe direction), not exact.\n');
fprintf(' - R_spiral_start/end (Section 6) are UNJUSTIFIED placeholder envelope values —\n');
fprintf('   replace with real body OD / packaging constraints before trusting dP results.\n');
fprintf(' - This script does NOT replace CFD or cold-flow testing — treat every\n');
fprintf('   number here as a go/no-go filter, not a final design value.\n');
