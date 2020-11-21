:: Setup filesystem links to the modes and vscript directories to live reload these scripts.

mklink /j "%programfiles(x86)%\Steam\steamapps\common\Left 4 Dead 2\left4dead2\scripts\vscripts" vscripts
mklink /j "%programfiles(x86)%\Steam\steamapps\common\Left 4 Dead 2\left4dead2\modes" modes
