module UNITATEM module MapBattleBGM
    #==============================================================================
    # Map Battle Background Music
    # -----------------------------------------------------------------------------
    # 6.10.2023
    # -----------------------------------------------------------------------------
    #==============================================================================
    # # Introduction
    #
    # Allows for setting the Battle Background Music for each map without executing
    # it through an event
    # 
    #==============================================================================
    # # Usage
    #
    # Map notetags:
    # <battle bgm: name>
    # 
    #==============================================================================
    # # SETTINGS
    # -----------------------------------------------------------------------------
    MAP_BATTLE_BGM_STR = /<(?:BATTLE BGM|battle bgm):[ ](.*)>/i
    VOLUME = 75
    PITCH = 100
    end end
    #==============================================================================
    # Importing the script
    #------------------------------------------------------------------------------
    $imported = {} if $imported.nil? ; $imported[:UNITATEM_MAPBATTLEBGM] = true
    #==============================================================================
    # ** RPG::Map
    #------------------------------------------------------------------------------
    #==============================================================================
    
    class RPG::Map
      #--------------------------------------------------------------------------
      # accessors
      #--------------------------------------------------------------------------
      attr_accessor :battle_bgm_name
    
      #--------------------------------------------------------------------------
      # common cache: load_notetags_mbbgm
      #--------------------------------------------------------------------------
      def load_notetags_mbbgm
        @battle_bgm_name = ""
        #---
        self.note.split(/[\r\n]+/).each { |line|
          case line
          when UNITATEM::MapBattleBGM::MAP_BATTLE_BGM_STR
            @battle_bgm_name = $1.to_s
          end
        }
      end
    end
    #==============================================================================
    # ** GameMap
    #------------------------------------------------------------------------------
    #==============================================================================
    class Game_Map
      
      #--------------------------------------------------------------------------
      # alias method: setup
      #--------------------------------------------------------------------------
      alias setup_mbbgm setup;
      def setup(map_id)
        setup_mbbgm(map_id)
        @map.load_notetags_mbbgm
      end
      
      #--------------------------------------------------------------------------
      # new method: get_battle_bgm
      #--------------------------------------------------------------------------
      def get_battle_bgm
        return @map.battle_bgm_name
      end
    end
    #==============================================================================
    # ** GamePlayer
    #------------------------------------------------------------------------------
    #==============================================================================
    class Game_Player
      #--------------------------------------------------------------------------
      # alias method: perform_transfer
      #--------------------------------------------------------------------------
      alias perform_transfer_mbbgm perform_transfer
      def perform_transfer
        perform_transfer_mbbgm
        str = $game_map.get_battle_bgm
        if !(str == "")
          bgm = RPG::BGM.new(str, UNITATEM::MapBattleBGM::VOLUME, UNITATEM::MapBattleBGM::PITCH)
          $game_system.battle_bgm=bgm
        end
      end
    end