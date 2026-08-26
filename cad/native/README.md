# Native CAD files

This folder is where native SolidWorks part/assembly files (`.SLDPRT`, `.SLDASM`, `.SLDDRW`) belong once they're added to version control.

Nothing is checked in here yet — the current CAD is only available as neutral `.step` exports in [`../exports`](../exports), which any CAD package can open. If/when native files are added here, consider setting up [Git LFS](https://git-lfs.com/) for them, since SolidWorks files can get large and don't diff well as text.
