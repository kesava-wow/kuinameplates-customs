Kui_Nameplates_Customs
======================
A collection of custom.lua scripts and patches for Kui_Nameplates_Core.

Notable files
-------------

* [Detection icon](https://raw.githubusercontent.com/kesava-wow/kuinameplates-customs/master/custom.detection-icon.lua) - adds an icon to mobs in Suramar which can remove your Masquerade buff (and one in Highmountain who has it for some reason).
* [Target scale](https://raw.githubusercontent.com/kesava-wow/kuinameplates-customs/master/custom.target-scale.lua) - scales up the currently targeted nameplate in a non-pixel-perfect way.
* [Aura mods](https://raw.githubusercontent.com/kesava-wow/kuinameplates-customs/master/custom.simple-aura-mods.lua) - some configurable modifications for auras.

How do I use this?
------------------

### If you don't know LUA
1. Download [Kui_Nameplates_Custom.zip](https://github.com/kesava-wow/kuinameplates-customs/raw/master/Kui_Nameplates_Custom.zip) and install it like any other addon.
2. Click one of the custom.\*.lua files in the list above ("Save as" will NOT work for this link)
3. Right click -> "Save as..." on the "Raw" link at the top right of that file's code block
4. Save the file to the Kui_Nameplates_Custom folder you just installed
5. Rename the file to custom.lua (overwriting the old file if necessary)
6. Launch the game and make sure Kui_Nameplates_Custom shows in the addon list and is enabled

Note that if you want to use more than one of these modifications at a time, you'll need to either manually merge the scripts, or add more files to the Kui_Nameplates_Custom.toc list.

### If you do know LUA
Just install the Custom module and modify the custom.lua file as you require. Example modifications are available both here and in the main repo (BarAuras, PreLegion, and of course all the built-in modules). The ClassPowers and Auras modules have commented documentation at the top of their files.

