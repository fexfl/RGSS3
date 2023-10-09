module UNITATEM module PartyMessage
    #==============================================================================
    # Party Message
    # -----------------------------------------------------------------------------
    # 9.10.2023
    # -----------------------------------------------------------------------------
    #==============================================================================
    # # Introduction
    #
    # Displays a message when an actor joins or leaves a party.
    # Has an option to display the icon set in the ClassIcons script, as well as
    # the \I[xxx] icon in the actors nickname
    # 
    #==============================================================================
    # # Usage
    # 
    # plug and play
    #
    # You can enable the ClassIcons icon using the boolean below, make sure you have
    # ClassIcons imported for it to work
    #
    # Additionally, an icon can be extracted from the nickname actor property. It
    # should look like this: \I[xxx] Nickname
    #
    #==============================================================================
    # # Dependencies
    #
    # For some features:
    # UNITATEM - Class Icons
    # 
    #==============================================================================
    # # SETTINGS
    # -----------------------------------------------------------------------------
    DISPLAY_CLASS_ICON = true
    DISPLAY_NICKNAME_ICON = true
    SOUND_EFFECT = "Heal7"
    VOLUME = 75
    PITCH = 100
    end end
    #==============================================================================
    # Importing the script
    #------------------------------------------------------------------------------
    $imported = {} if $imported.nil?
    $imported[:UNITATEM_PARTYMESSAGE] = true
    #==============================================================================
    # ** Game_Party
    #------------------------------------------------------------------------------
    #  This class handles parties. Information such as gold and items is included.
    # Instances of this class are referenced by $game_party.
    #==============================================================================
    class Game_Party < Game_Unit
      #--------------------------------------------------------------------------
      # * new method: party_message_string
      #--------------------------------------------------------------------------
      def party_message_string(actor_id)
        rel_actor = $data_actors[actor_id]
        prefix_a = ""
        prefix_b = ""
        if UNITATEM::PartyMessage::DISPLAY_NICKNAME_ICON
          path = rel_actor.nickname[0,7]
          prefix_a = path + " "
        end
        if $imported[:UNITATEM_CLASSICONS]
          if UNITATEM::PartyMessage::DISPLAY_CLASS_ICON
            element_id = UNITATEM::ClassIcons::DICT_ICONINDICES[UNITATEM::ClassIcons::DICT_CLASSES.find_index(rel_actor.class_id)]
            prefix_b = "\\I[" + element_id.to_s + "]"
          end
        else
        end
        name_for_msg = prefix_b + prefix_a + rel_actor.name
        return name_for_msg
      end
      #--------------------------------------------------------------------------
      # * alias method: add_actor
      #--------------------------------------------------------------------------
      alias add_actor_pm add_actor
      def add_actor(actor_id)
        add_actor_pm(actor_id)
        name_for_msg = party_message_string(actor_id)
        RPG::SE.new(UNITATEM::PartyMessage::SOUND_EFFECT, UNITATEM::PartyMessage::VOLUME, UNITATEM::PartyMessage::PITCH).play
        $game_message.add(name_for_msg + " has joined the party!")
      end
      #--------------------------------------------------------------------------
      # * alias method: remove_actor
      #--------------------------------------------------------------------------
      alias remove_actor_pm remove_actor
      def remove_actor(actor_id)
        remove_actor_pm(actor_id)
        name_for_msg = party_message_string(actor_id)
        RPG::SE.new(UNITATEM::PartyMessage::SOUND_EFFECT, UNITATEM::PartyMessage::VOLUME, UNITATEM::PartyMessage::PITCH).play
        $game_message.add(name_for_msg + " has left the party!")
      end
    end