#=================================================================================
# pigmint_controls_plugin.gd
#---------------------------------------------------------------------------------
# Description: Plugin Script
# Project:     "Pigmint Controls", a custom controls Plugin for Godot 3
#              https://github.com/Echopraxium/pigmint_controls
# Author:      Echopraxium 2020
# Version:     0.0.20 (2020/01/14) AAAA/MM/DD
#=================================================================================
# https://docs.godotengine.org/en/3.1/tutorials/plugins/editor/making_plugins.html
tool
extends EditorPlugin

func _enter_tree():
    # Initialization of the plugin goes here
    # Add the new type with a name, a parent type, a script and an icon
    add_custom_type("PigletColorSelect", "TextureButton",
                    preload("res://addons/pigmint_controls/buttons/ColorSelect/piglet_color_select.gd"), 
                    preload("res://addons/pigmint_controls/buttons/ColorSelect/piglet_color_select_icon.png"))

func _exit_tree():
    # Clean-up of the plugin goes here
    # Always remember to remove it from the engine when deactivated
    remove_custom_type("PigletColorSelect")