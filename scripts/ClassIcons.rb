module UNITATEM module ClassIcons
    #==============================================================================
    # Class Icons
    # -----------------------------------------------------------------------------
    # 9.10.2023
    # -----------------------------------------------------------------------------
    #==============================================================================
    # # Introduction
    #
    # Draws an Icon corresponding to the Actors class in front of the actor name, as
    # well as the class name
    # 
    #==============================================================================
    # # Usage
    # Store Classes and corresponding icon indices in the arrays below
    # 
    #==============================================================================
    # # SETTINGS
    # -----------------------------------------------------------------------------
    DICT_CLASSES = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 30, 33, 34, 31, 32, 101, 102, 103, 104, 105, 106, 107, 108, 109]
    DICT_ICONINDICES = [609, 610, 612, 613, 611, 614, 608, 615, 616, 617, 609, 610, 610, 613, 609, 609, 612, 609, 611, 616, 610, 613, 610, 608]
    end end
    #==============================================================================
    # Importing the script
    #------------------------------------------------------------------------------
    $imported = {} if $imported.nil?
    $imported[:UNITATEM_CLASSICONS] = true
    #==============================================================================
    # ** Window_Base
    #------------------------------------------------------------------------------
    #==============================================================================
    class Window_Base < Window
      #--------------------------------------------------------------------------
      # * new method: draw_actor_name_withicon
      #--------------------------------------------------------------------------
      def draw_actor_name_withicon(actor, x, y, width = 112)
        if UNITATEM::ClassIcons::DICT_CLASSES.find_index(actor.class_id).nil?
          draw_actor_name(actor, x, y, width)
        else
          icon_id = UNITATEM::ClassIcons::DICT_ICONINDICES[UNITATEM::ClassIcons::DICT_CLASSES.find_index(actor.class_id)]
          draw_icon(icon_id, x, y, true)
          change_color(hp_color(actor))
          draw_text(x + 26, y, width, line_height, actor.name)
        end
      end
      #--------------------------------------------------------------------------
      # * new method: draw_actor_class_withicon
      #--------------------------------------------------------------------------
      def draw_actor_class_withicon(actor, x, y, width = 112)
        if UNITATEM::ClassIcons::DICT_CLASSES.find_index(actor.class_id).nil?
          draw_actor_class(actor, x, y, width)
        else
          icon_id = UNITATEM::ClassIcons::DICT_ICONINDICES[UNITATEM::ClassIcons::DICT_CLASSES.find_index(actor.class_id)]
          draw_icon(icon_id, x, y, true)
          change_color(normal_color)
          draw_text(x + 24, y, width, line_height, actor.class.name)
        end
      end
      #--------------------------------------------------------------------------
      # * new method: draw_actor_simple_status_withicon
      #--------------------------------------------------------------------------
      def draw_actor_simple_status_withicon(actor, x, y)
        draw_actor_name(actor, x, y)
        draw_actor_level(actor, x, y + line_height * 1)
        draw_actor_icons(actor, x, y + line_height * 2)
        draw_actor_class_withicon(actor, x + 120, y)
        draw_actor_hp(actor, x + 120, y + line_height * 1)
        draw_actor_mp(actor, x + 120, y + line_height * 2)
      end
    end
    
    #==============================================================================
    # ** Window_MenuStatus
    #------------------------------------------------------------------------------
    #  This window displays party member status on the menu screen.
    #==============================================================================
    
    class Window_MenuStatus < Window_Selectable
      #--------------------------------------------------------------------------
      # * overwrite method: Draw Item
      #--------------------------------------------------------------------------
      def draw_item(index)
        actor = $game_party.members[index]
        enabled = $game_party.battle_members.include?(actor)
        rect = item_rect(index)
        draw_item_background(index)
        draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
        draw_actor_simple_status_withicon(actor, rect.x + 108, rect.y + line_height / 2) # edited
      end
    end
    
    #==============================================================================
    # ** Window_Status
    #------------------------------------------------------------------------------
    #  This window displays full status specs on the status screen.
    #==============================================================================
    
    class Window_Status < Window_Selectable
      #--------------------------------------------------------------------------
      # * overwrite method: Draw Block 1
      #--------------------------------------------------------------------------
      def draw_block1(y)
        draw_actor_name(@actor, 4, y)
        draw_actor_class_withicon(@actor, 128, y) # edited
        draw_actor_nickname(@actor, 288, y)
      end
    end
    
    #==============================================================================
    # ** Window_BattleStatus
    #------------------------------------------------------------------------------
    #  This window is for displaying the status of party members on the battle
    # screen.
    #==============================================================================
    
    class Window_BattleStatus < Window_Selectable
      #--------------------------------------------------------------------------
      # * overwrite method: Draw Basic Area
      #--------------------------------------------------------------------------
      def draw_basic_area(rect, actor)
        draw_actor_name_withicon(actor, rect.x + 0, rect.y, 100) # edited
        draw_actor_icons(actor, rect.x + 104, rect.y, rect.width - 104)
      end
    end