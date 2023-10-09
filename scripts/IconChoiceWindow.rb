module UNITATEM module SmallChoiceList
    #==============================================================================
    # Small Choice List
    # -----------------------------------------------------------------------------
    # 9.10.2023
    # -----------------------------------------------------------------------------
    #==============================================================================
    # # Introduction
    #
    # Adds a smaller version of the Choice List Window, mostly used for confirmation
    # buttons with a single option with a single icon (as a confirmation button)
    # 
    #==============================================================================
    # # Usage
    #
    # Script call:
    # params = []
    # choices = []
    # choices.push("choice 1")
    # choices.push("choice 2")
    # params.push(choices)
    # params.push(0/1/2 this part is where you press cancel and which choice to default)
    # setup_small_choices(params)
    # 
    #==============================================================================
    # # SETTINGS
    # -----------------------------------------------------------------------------
    end end
    #==============================================================================
    # Importing the script
    #------------------------------------------------------------------------------
    $imported = {} if $imported.nil? ; $imported[:UNITATEM_SMALLCHOICELIST] = true
    
    #==============================================================================
    # ** Window_SmallChoiceList
    #------------------------------------------------------------------------------
    #==============================================================================
    
    class Window_SmallChoiceList < Window_Command
      #--------------------------------------------------------------------------
      # * Object Initialization
      #--------------------------------------------------------------------------
      def initialize(message_window)
        @message_window = message_window
        super(0, 0)
        self.openness = 0
        deactivate
      end
      #--------------------------------------------------------------------------
      # * Start Input Processing
      #--------------------------------------------------------------------------
      def start
        update_placement
        refresh
        select(0)
        open
        activate
      end
      #--------------------------------------------------------------------------
      # * Update Window Position
      #--------------------------------------------------------------------------
      def update_placement
        # This is the crucial part
        self.width = 24 + 9 + padding * 2
        self.width = [width, Graphics.width].min
        self.height = fitting_height($game_message.small_choices.size)
        self.x = Graphics.width - width
        if @message_window.y >= Graphics.height / 2
          self.y = @message_window.y - height
        else
          self.y = @message_window.y + @message_window.height
        end
      end
      #--------------------------------------------------------------------------
      # * Get Maximum Width of Choices
      #--------------------------------------------------------------------------
      def max_choice_width
        $game_message.small_choices.collect {|s| text_size(s).width }.max
      end
      #--------------------------------------------------------------------------
      # * Calculate Height of Window Contents
      #--------------------------------------------------------------------------
      def contents_height
        item_max * item_height
      end
      #--------------------------------------------------------------------------
      # * Create Command List
      #--------------------------------------------------------------------------
      def make_command_list
        $game_message.small_choices.each do |choice|
          add_command(choice, :choice)
        end
      end
      #--------------------------------------------------------------------------
      # * Draw Item
      #--------------------------------------------------------------------------
      def draw_item(index)
        rect = item_rect_for_text(index)
        draw_text_ex(rect.x, rect.y, command_name(index))
      end
      #--------------------------------------------------------------------------
      # * Get Activation State of Cancel Processing
      #--------------------------------------------------------------------------
      def cancel_enabled?
        $game_message.small_choice_cancel_type > 0
      end
      #--------------------------------------------------------------------------
      # * Call OK Handler
      #--------------------------------------------------------------------------
      def call_ok_handler
        $game_message.small_choice_proc.call(index)
        close
      end
      #--------------------------------------------------------------------------
      # * Call Cancel Handler
      #--------------------------------------------------------------------------
      def call_cancel_handler
        $game_message.small_choice_proc.call($game_message.small_choice_cancel_type - 1)
        close
      end
    end
    
    #==============================================================================
    # ** Game_Message
    #------------------------------------------------------------------------------
    #==============================================================================
    class Game_Message
      #--------------------------------------------------------------------------
      # * accessors and readers
      #--------------------------------------------------------------------------
      attr_reader   :small_choices
      attr_accessor :small_choice_proc
      attr_accessor :small_choice_cancel_type
      #--------------------------------------------------------------------------
      # * alias method: Clear
      #--------------------------------------------------------------------------
      alias clear_scl clear
      def clear
        clear_scl
        @small_choices = []
        @small_choice_cancel_type = 0
        @small_choice_proc = nil
      end
      #--------------------------------------------------------------------------
      # * new method: small_choice?
      #--------------------------------------------------------------------------
      def small_choice?
        @small_choices.size > 0
      end
      #--------------------------------------------------------------------------
      # * alias method: busy?
      #--------------------------------------------------------------------------
      alias busy_scl busy?
      def busy?
        return true if small_choice?
        busy_scl
      end
    end
    
    #==============================================================================
    # ** Game_Interpreter
    #------------------------------------------------------------------------------
    #==============================================================================
    class Game_Interpreter
      #--------------------------------------------------------------------------
      # * new method: setup_small_choices
      #--------------------------------------------------------------------------
      def setup_small_choices(params)
        params[0].each {|s| $game_message.small_choices.push(s) }
        $game_message.small_choice_cancel_type = params[1]
        $game_message.small_choice_proc = Proc.new {|n| @branch[@indent] = n }
      end
      
    end
    
    #==============================================================================
    # ** Window_Message
    #------------------------------------------------------------------------------
    #==============================================================================
    class Window_Message < Window_Base
      #--------------------------------------------------------------------------
      # * alias method: create_all_windows
      #--------------------------------------------------------------------------
      alias create_all_windows_scl create_all_windows
      def create_all_windows
        create_all_windows_scl
        @small_choice_window = Window_SmallChoiceList.new(self)
      end
      #--------------------------------------------------------------------------
      # * alias method: dispose_all_windows
      #--------------------------------------------------------------------------
      alias dispose_all_windows_scl dispose_all_windows
      def dispose_all_windows
        dispose_all_windows_scl
        @small_choice_window.dispose
      end
      #--------------------------------------------------------------------------
      # * alias method: update_all_windows
      #--------------------------------------------------------------------------
      alias update_all_windows_scl update_all_windows
      def update_all_windows
        update_all_windows_scl
        @small_choice_window.update
      end
      #--------------------------------------------------------------------------
      # * alias method: process_input
      #--------------------------------------------------------------------------
      alias process_input_scl process_input
      def process_input
        if $game_message.small_choice?
          input_small_choice
        else
          process_input_scl
        end
      end
      #--------------------------------------------------------------------------
      # * alias method: all_close?
      #--------------------------------------------------------------------------
      alias all_close_scl all_close?
      def all_close?
        return false if (!@small_choice_window.close?)
        all_close_scl
      end
      #--------------------------------------------------------------------------
      # * new method: input_small_choice
      #--------------------------------------------------------------------------
      def input_small_choice
        @small_choice_window.start
        Fiber.yield while @small_choice_window.active
      end
    end