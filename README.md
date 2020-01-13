# PigMint Controls
A plugin which provides custom controls (mainly for drawing apps) for [Godot Engine](https://godotengine.org/). In this first release, there **PigletColorSelect**, it's a Color Picker button. 
It provides a mean for the user to select Foreground/Background colors.

![PigMint Controls](./buttons/ColorSelect/Piglet_Color_Select_Screenshot.png)

## How to install the Plugin?
1. Download as a zip file from github. You should get a file named `pigmint_controls-master.zip`
2. Use Godot's FileSystem panel to create a **addons** folder at the root of your *Godot* project. 
3. Use the **AssetLib** button (top center of Godot main window): select the zip then `Import`, `Open` and `Install`
4. Now you have a `pigmint_controls-master` folder at the same level than `addons`. Rename it to `pigmint_controls` then move it under `addons` folder with a drag and drop. 
5. You should now have the following: `my_godot_project/addons/pigmint_controls`.
6. Check that the plugin is known by Godot: use the **AssetLib** button then `Plugins` and activate it (with the ComboList button in the `Status` column).

## How to use a PigletColorSelect
1. Create a 2D scene in your *Godot* project.
2. Create a container (e.g. a `HBoxContainer` or `VBoxContainer`) as a child of the 2D scene.
3. Select this container then use the right mouse button (to open the context menu) and select `Add Child Node`
4. In the `Search` field, input `Pig` to find more quickly the `PigletColorSelect` node. Select it and then `Create`

## Interactions
Once you have a `PigletColorSelect` in your scene you will see a button with a custom icon (24x24 pixels). This button has in fact 4 selectable **parts** each one for a specific *interaction*:
1. **Select Foreground color**: a left mouse button click in the small square of the top left part. This will popup a `ColorPicker` which allows the user to select a color.
2. **Select Background color**: a click in the small square of the bottom right part. This will also popup a `ColorPicker`.
3. **Switch Foreground/Background colors**: a click on the double arrow in the top right part.
4. **Reset Foreground/Background colors**: a click on the bottom left part (a tiny white square under a tiny black square, these are the `Reset colors`).

## Events
There are 4 custom signals which can be connected to handle each of the possible *interactions*
1. `foreground_color_changed(fg_color)`: the connected function will receive the *Foreground color* when it has been changed by the user.
2. `background_color_changed(bg_color)`: the connected function will receive the *Background color* when it has been changed by the user.
3. `colors_switch(piglet_color_select_control)`: the connected function will receive the `PigletColorSelect` button when the user *Switches* colors.
4. `colors_reset(piglet_color_select_control)`: the connected function will receive the `PigletColorSelect` button when the user *Resets* colors.

## Properties
There are 2 properties on `PigletColorSelect`. They can be accessed with setters and getters:
1. `ForegroundColor`
```
	set_foreground_color(color)
	get_foreground_color()
```
2. `BackgroundColor`	
```
	set_background_color(color)
	get_background_color()
```
