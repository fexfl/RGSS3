module UNITATEM module TitleScreenVariation
#==============================================================================
# Title Screen Variation
# -----------------------------------------------------------------------------
# 19.9.2023
# -----------------------------------------------------------------------------
#==============================================================================
# # Introduction
#
# Allows to set multiple title screens that are iterated each time the game
# starts
# 
#==============================================================================
# # SETTINGS
# -----------------------------------------------------------------------------
Title_variations = ["TITLE_Ex1", "TITLE_Ex2"]
Txtfile_location = "Data/TitleScreenVariation.txt"
end end
#==============================================================================
# Importing the script
#------------------------------------------------------------------------------
$imported = {} if $imported.nil? ; $imported[:UNITATEM_TITLESCREENVARIATION] = true
#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#==============================================================================
module SceneManager
  #--------------------------------------------------------------------------
  # Overwrite Method: self.run
  #--------------------------------------------------------------------------
  def self.run
    DataManager.init
    ###############
    # edited part #
    ###############
    # reading
    txtfile = File.open(UNITATEM::TitleScreenVariation::Txtfile_location)
    title_int = txtfile.read.to_i
    title_newint = (title_int + 1) % UNITATEM::TitleScreenVariation::Title_variations.length()
    txtfile.close
    # writing
    txtfile_write = File.open(UNITATEM::TitleScreenVariation::Txtfile_location, "w")
    txtfile_write.write(title_newint)
    txtfile_write.close
    # setting the title image
    $data_system.title1_name = UNITATEM::TitleScreenVariation::Title_variations[title_int]
    #self.run_unitatem
    ###################
    # edited part end #
    ###################
    Audio.setup_midi if use_midi?
    @scene = first_scene_class.new
    @scene.main while @scene
  end
end