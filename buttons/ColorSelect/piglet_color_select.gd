#=================================================================================
# piglet_color_select.gd
#---------------------------------------------------------------------------------
# Description: Script for "Pigmint Controls" Plugin for Godot 3
# Author:      Echopraxium (aka Michel Kern) 2020
# Version:     0.0.1 (2020/01/09) AAAA/MM/DD
#=================================================================================
# https://docs.godotengine.org/en/3.1/tutorials/plugins/editor/making_plugins.html
# http://www.alexhoratio.co.uk/2018/08/godot-complete-guide-to-control-nodes.html
tool
extends TextureButton

const PLUGIN_NAME = "PigMint Controls"

#------------------ Custom Signals --------------------
signal foreground_color_changed(fg_color)
signal background_color_changed(bg_color)
signal colors_switch(piglet_color_select_control)
signal colors_reset(piglet_color_select_control)
#------------------------------------------------------


var _g_img_path = "res://addons/pigmint_controls/Buttons/ColorSelect/piglet_color_select.png"

#---------------------- Colors -----------------------
const BLACK_COLOR            = Color(0,0,0)
const WHITE_COLOR            = Color(1,1,1)
const RED_COLOR              = Color(1,0,0)
const GREEN_COLOR            = Color(0,1,0)
const BLUE_COLOR             = Color(0,0,1)
const YELLOW_COLOR           = Color(1,1,0)
const MAGENTA_COLOR          = Color(1,0,1)
const CYAN_COLOR             = Color(0,1,1)
#-----------------------------------------------------


#---------- Button parts: position and size ----------
const FG_BG_PART_SIZE        = 9
const BG_PART_START          = 14

const SWITCH_PART_START_X    = 12
const SWITCH_PART_START_Y    = 2
const SWITCH_PART_SIZE       = 10

const RESET_PART_START_X     = 0
const RESET_PART_START_Y     = 14
const RESET_PART_SIZE        = 10
#-----------------------------------------------------


#---------------- Button part codes-------------------
const NO_PART_CODE            = 0
const FOREGROUND_PART_CODE    = 1
const BACKGROUND_PART_CODE    = 2
const SWITCH_PART_CODE        = 3
const RESET_PART_CODE         = 4
#-----------------------------------------------------

var _g_clicked_part_code      = NO_PART_CODE

var _g_foreground_color       = BLACK_COLOR
var _g_background_color       = WHITE_COLOR

var _g_reset_foreground_color = BLACK_COLOR
var _g_reset_background_color = WHITE_COLOR

var _g_added_to_parent        = false
var _g_color_chooser_dialog:ColorPicker = null


"""
+---------+.............
|$$$$$$$$$|.............
|$$$$$$$$$|...X......... 
|$$$$$$$$$|..XX.........
|$$$$$$$$$|.XXXXXX......
|$$$$$$$$$|..XX...X.....
|$$$$$$$$$|...X....X....
|$$$$$$$$$|........X....
|$$$$$$$$$|........X....
|$$$$$$$$$|......XXXXX.. 
+---------+.......XXX... 
...................X.... 
........................ 
.............+---------+ 
+-----+......|°°°°°°°°°| 
|*****|......|°°°°°°°°°| 
|*****|......|°°°°°°°°°| 
|*****+--+...|°°°°°°°°°|
|*****|::|...|°°°°°°°°°| 
|*****|::|...|°°°°°°°°°| 
+--+--+::|...|°°°°°°°°°|
...|:::::|...|°°°°°°°°°| 
...|:::::|...|°°°°°°°°°| 
...+-----+...+---------+
"""

func _enter_tree():
    _setup_button()
    connect("pressed", self, "_clicked")
    _g_color_chooser_dialog = ColorPicker.new()
    _g_color_chooser_dialog.connect("gui_input", self, "_on_Color_select_dialog_gui_input")
    set_reset_colors(BLACK_COLOR, WHITE_COLOR)


func _on_Color_select_dialog_gui_input(event):
    if (event is InputEventMouseButton):
        #print("_on_Color_select_dialog_gui_input  InputEventMouseButton")
        var picked_color = _g_color_chooser_dialog.get_pick_color()
        _g_color_chooser_dialog.hide()
		
        if   (_g_clicked_part_code == FOREGROUND_PART_CODE):
            _g_foreground_color = picked_color
            emit_signal("foreground_color_changed", _g_foreground_color)
            update()
        elif (_g_clicked_part_code == BACKGROUND_PART_CODE):
            _g_background_color = picked_color
            emit_signal("background_color_changed", _g_background_color)
            update()


#---------- ForegroundColor getter/setter ----------
func set_foreground_color(color):
    _g_foreground_color = color
	
func get_foreground_color():
	return _g_foreground_color
#---------------------------------------------------
	

#---------- BackgroundColor getter/setter ----------
func set_background_color(color):
    _g_background_color = color
	
func get_background_color():
    return _g_background_color
#---------------------------------------------------


#-------------- Reset Colors setter ----------------
func set_reset_colors(reset_fg_color, reset_bg_color):
     _g_reset_foreground_color = reset_fg_color
     _g_reset_background_color = reset_bg_color
#---------------------------------------------------


func _clicked():
    #print("ColorSwitchButton clicked me!")
    var node_rect = get_global_rect()
	
    #print("node x: " + str(node_rect.position.x) + " y:" + str(node_rect.position.y))
    var mouseXY = self.get_viewport().get_mouse_position()
    #print("mouseXY x: " + str(mouseXY.x) + " y:" + str(mouseXY.y))
	
    var request_color_from_user = false
	
    var clicked_part_code = _detect_clicked_part(node_rect, mouseXY)
    if (clicked_part_code != NO_PART_CODE):
        if (clicked_part_code == FOREGROUND_PART_CODE):
            #print("FOREGROUND_PART clicked")
            request_color_from_user = true

        elif (clicked_part_code == BACKGROUND_PART_CODE):
            #print("BACKGROUND_PART clicked")
            request_color_from_user = true

        elif (clicked_part_code == SWITCH_PART_CODE):
            #print("SWITCH_PART clicked")
            var save_fg_color    = _g_foreground_color
            _g_foreground_color  = _g_background_color 
            _g_background_color  = save_fg_color
            _g_clicked_part_code = clicked_part_code
            emit_signal("colors_switch", self)
            update()
            return

        elif (clicked_part_code == RESET_PART_CODE):
            #print("RESET_PART clicked")
            _g_foreground_color  = _g_reset_foreground_color 
            _g_background_color  = _g_reset_background_color
            _g_clicked_part_code = clicked_part_code
            emit_signal("colors_reset", self)
            update()
            return

        #---------- If user clicked either "FOREGROUND" or "BACKGROUND" part ----------
        if (request_color_from_user == true):
            #print("request_color_from_user")
            if (not _g_added_to_parent):
                get_owner().add_child(_g_color_chooser_dialog)
                _g_added_to_parent = true
            var color_chooser_x = node_rect.position.x
            var color_chooser_y = node_rect.position.y + node_rect.size.y
            _g_color_chooser_dialog.rect_position = Vector2(color_chooser_x, color_chooser_y)
            _g_clicked_part_code = clicked_part_code
            _g_color_chooser_dialog.show()


#----- Redraw button to color the parts cinsistently with ForegroundColor and BackgroundColor -----
func _draw():
	# Note: doesnt draw at the right spot with either:
	#       get_rect(), get_global_rect(), get_transform(), get_global_transform()
    var rect = self.get_canvas_transform()
	
    #---------- Paint "FOREGROUND" part ----------
    var x = rect.origin.x + 1
    var y = rect.origin.y + 1
    var foreground_rect = Rect2(Vector2(x, y), Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE))
    self.draw_rect(foreground_rect, _g_foreground_color)
    #---------------------------------------------

    #---------- Paint "BACKGROUND" part ----------
    x = rect.origin.x + BG_PART_START
    y = rect.origin.y + BG_PART_START
    var background_rect = Rect2(Vector2(x, y), Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE))
    draw_rect(background_rect, _g_background_color)
    #---------------------------------------------


    #---------- Paint "RESET FOREGROUND" part ----------
    #x = rect.origin.x + BG_PART_START
    #y = rect.origin.y + BG_PART_START
    #var reset_foreground_rect = Rect2(Vector2(x, y), Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE))
    #draw_rect(reset_foreground_rect, _g_foreground_color)
    #---------------------------------------------


    #---------- Paint "RESET BACKGROUND" part ----------
    #x = rect.origin.x + BG_PART_START
    #y = rect.origin.y + BG_PART_START
    #var reset_background_rect = Rect2(Vector2(x, y), Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE))
    #draw_rect(reset_background_rect, _g_foreground_color)
    #---------------------------------------------
     

func _detect_clicked_part(rect, mouseXY):
    #print("rect x: " + str(rect.position.x) + " y:" + str(rect.position.y))	
    var rect_x = rect.position.x # get_transform().get_origin().x
    var rect_y = rect.position.y # get_transform().get_origin().y
    var x      = mouseXY.x - rect_x
    var y      = mouseXY.y - rect_y


	#---------- Check if mouse is inside "FOREGROUND PART" ---------
    var start_part = Vector2(0,0)
    var end_part   = Vector2(FG_BG_PART_SIZE, FG_BG_PART_SIZE)
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return FOREGROUND_PART_CODE
    #----------------------------------------------------------------


	#---------- Check if mouse is inside "BACKGROUND PART" ----------
    start_part.x = BG_PART_START
    start_part.y = BG_PART_START
    end_part.x   = start_part.x + FG_BG_PART_SIZE
    end_part.y   = start_part.y + FG_BG_PART_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return BACKGROUND_PART_CODE
    #----------------------------------------------------------------


	#---------- Check if mouse is inside "SWITCH PART" ----------
    start_part.x = SWITCH_PART_START_X
    start_part.y = SWITCH_PART_START_Y
    end_part.x   = start_part.x + SWITCH_PART_SIZE
    end_part.y   = start_part.y + SWITCH_PART_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return SWITCH_PART_CODE
    #----------------------------------------------------------------
	
	
	#---------- Check if mouse is inside "RESET PART" ----------
    start_part.x = RESET_PART_START_X
    start_part.y = RESET_PART_START_Y
    end_part.x   = start_part.x + RESET_PART_SIZE
    end_part.y   = start_part.y + RESET_PART_SIZE
    if (     (x > start_part.x  and  x < end_part.x)
         and (y > start_part.y  and  y < end_part.y)  ):
        return RESET_PART_CODE
    #----------------------------------------------------------------

    return NO_PART_CODE


# Error: "Error: Loaded resource as image file, this will not work on export"
# https://godotengine.org/qa/43318/error-loaded-resource-as-image-file-this-will-not-work-export
func _setup_button():	
    #print("<color_switch_button>.setup_button")

    # Set "Normal" Button Texture
    var normal_texture = load(_g_img_path)
    #print(str(normal_texture))
	
    #var image_normal = Image.new()
    #image_normal.load(ImgPath)
	
    #var image_texture_normal = ImageTexture.new()
    #image_texture_normal.create_from_image(image_normal)
	
    #set_normal_texture(image_texture_normal)
    set_normal_texture(normal_texture)

    #set_anchors_and_margins_preset (0,0,2)