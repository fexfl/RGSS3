module UNITATEM module AtkTimesWithAllSkills
    #==============================================================================
    # # Atk Times with all or selected Skills
    # -----------------------------------------------------------------------------
    # 26.8.2023
    # -----------------------------------------------------------------------------
    #==============================================================================
    # # Introduction
    #
    # Allows the AtkTimes+ effect to be used with any skill instead of just normal
    # skills.
    # Has an option for counting all skills as normal attacks.
    #
    # Partly copied and modified from Rinobi
    # 
    #==============================================================================
    # # SETTINGS
    # -----------------------------------------------------------------------------
    # The skill IDs within the array below will be treated as normal attacks.
    Use_all_skills = true
    Normal_attacks = [1]
     
    end end
    #==============================================================================
    # Importing the script
    #------------------------------------------------------------------------------
    $imported = {} if $imported.nil? ; $imported[:UNITATEM_ATKTIMES] = true
    #==============================================================================
    # ** Game_Action
    #------------------------------------------------------------------------------
    #  This class handles battle actions. This class is used within the
    # Game_Battler class.
    #==============================================================================
    class Game_Action
      #--------------------------------------------------------------------------
      # Overwrite Method: Normal Attack Determination
      #--------------------------------------------------------------------------
      def attack?
        if UNITATEM::AtkTimesWithAllSkills::Use_all_skills
          return true
        else
          skill_array = UNITATEM::AtkTimesWithAllSkills::Normal_attacks
          skill_array.push(subject.attack_skill_id)
          skill_array.any? {|skill_id| item == $data_skills[skill_id]}
        end
      end
    end