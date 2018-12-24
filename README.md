Kui_Nameplates_Customs
======================
A collection of custom scripts for Kui_Nameplates_Core, intended as templates for those who have some scripting knowledge and want to make simple changes.

These need to be updated manually when a KNP update breaks them.

Notable files
-------------

* [Detection icon](https://raw.githubusercontent.com/kesava-wow/kuinameplates-customs/master/custom.detection-icon.lua) - adds an icon to mobs in Suramar which can remove your Masquerade buff (and one in Highmountain who has it for some reason).
* [Target scale](https://raw.githubusercontent.com/kesava-wow/kuinameplates-customs/master/custom.target-scale.lua) - scales up the currently targeted nameplate in a non-pixel-perfect way.
* [Aura mods](https://raw.githubusercontent.com/kesava-wow/kuinameplates-customs/master/custom.simple-aura-mods.lua) - some configurable modifications for auras.

How do I use this?
------------------

### If you don't know LUA
1. Download [Kui_Nameplates_Custom.zip](https://github.com/kesava-wow/kuinameplates-customs/raw/master/Kui_Nameplates_Custom.zip) and install it like any other addon.
    - By extracting the `Kui_Nameplates_Custom` folder into `World of Warcraft/_retail_/Interface/AddOns`
2. Click one of the custom.\*.lua files in the list above ("Save as" will NOT work for this link)
    - If you end up on a [page like this](https://github.com/kesava-wow/kuinameplates-customs/raw/master/virus-example.png), you can just save the page (CTRL+S).
    - If you end up on a GitHub webpage, [find this button](https://github.com/kesava-wow/kuinameplates-customs/raw/master/this-is-the-raw-link.png), right click it, and hit "Save as..." (or whatever equivalent there is in your browser).
3. Save the file within the `Kui_Nameplates_Custom` folder you just extracted
4. Rename the file to custom.lua (overwriting the old file if necessary)
5. Launch the game and make sure Kui_Nameplates_Custom shows in the addon list and is enabled

Note that if you want to use more than one of these modifications at a time, you'll need to either manually merge the scripts, or add more files to the Kui_Nameplates_Custom.toc list.

### If you do know LUA
Just install the Custom module and modify the custom.lua file as you require. Example modifications are available both here and in the main repo (BarAuras, PreLegion, and of course all the built-in modules). The ClassPowers and Auras modules have commented documentation at the top of their files.

