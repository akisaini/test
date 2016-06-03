=begin
Project: Project #2: Game of Set
Team: GitGud
Members: Yazen Alzaghameem, Andrew Lee, Eric Lewantowicz, Joel Pepper, Aki Saini
Course: CSE 3901
Date: 6/3/2016
Description:
Execution Instructions:   !! Graphical interface requires GOSU gem  !!
1. First install the following packages on Linux:
    sudo apt-get install build-essential libsdl2-dev libsdl2-ttf-dev libpango1.0-dev
    libgl1-mesa-dev libfreeimage-dev libopenal-dev libsndfile-dev
2. Ubuntu will likely require a system restart before installing GOSU gem
3. Finally, install GOSU gem
4. May require disabling of Linux 3D Acceleration if errors/warning received
5. For troubleshooting, refer to http://github.com/gosu/gosu/wiki/getting-started-on-linux
=end

require 'gosu'
# include class files; require_relative used because in same directory as this file
require_relative 'game_data'
require_relative 'deck'
require_relative 'card'
require_relative 'game_controller'
require_relative 'event_controller'
require_relative 'logic'

class GameWindow < Gosu::Window

  attr_accessor :game_data
  attr_accessor :game_controller
  attr_accessor :win_x_dim
  attr_accessor :win_y_dim
  attr_accessor :text_color
  attr_accessor :transparent_color

  def initialize
    @win_x_dim = 1380                                         # set game window fixed x,y dimensions
    @win_y_dim = 900
    @font_size = Gosu::Font.new(20)            # sets font size for all text drawn in game window
    @text_color = Gosu::Color.new(0xff_000000)
    @transparent_color = Gosu::Color.new(180, 255, 255, 255)  # color (alpha, red, green, blue) modulation
    @transparent_color2 = Gosu::Color.new(180, 255, 255, 255)  # color (alpha, red, green, blue) modulation
    super @win_x_dim, @win_y_dim                              # (x,y) dimensions of game window
    self.caption = "Team GitGud's Game of Set"                # game window title bar caption

    # relative file path used for background image in /media dir
    play_image_config_path = File.expand_path("../media/play_background.png", __FILE__)
    intro_end_image_config_path = File.expand_path("../media/intro_end_background.png", __FILE__)
    @play_background_image = Gosu::Image.new(play_image_config_path, :tileable => true)
    @intro_end_background_image = Gosu::Image.new(intro_end_image_config_path, :tileable => true)
    # instantiate master game_data object; this object stores all game data cards, scores, timer, stats variables
    #   this GameData object also creates and shuffles the Set card deck so that it is ready to deal
    @game_data = GameData.new                   # GameData class struct contains all variables needed for game logic
    @game_controller = GameController.new       # create utility class game_controller object

  end

  # show mouse cursor in game window
  def needs_cursor?
    true
  end

  # window callback function is checked by system prior to update() method if button_up event is detected
  # this callback should be used for single press events (i.e. interacting with UI, and not events that require
  # holding down a button; for holding down a button functionality, use the Gosu::button_down/up? class methods
  # override: default Gosu member function, which does nothing
  # callback: called by system when button_up event detected
  def button_up(id)
    x_pos = mouse_x                         # get x, y coordinates of mouse cursor after button push
    y_pos = mouse_y
    puts "x_pos #{x_pos}, y_pos #{y_pos}"   # test print x, y coords to console; can get rid of this as needed
    if id == Gosu::MsLeft && game_controller.game_state == 0        # game in intro screen state
      game_controller.check_intro_buttons(x_pos, y_pos, win_x_dim, win_y_dim)         # call GraphicsWindow method to identify which card selected
    elsif id == Gosu::MsLeft && game_controller.game_state == 1     # game in play/table screen state
      game_controller.check_card_selected(x_pos, y_pos, game_data)         # identify if card selected
      game_controller.check_play_buttons(x_pos, y_pos, win_x_dim, win_y_dim)
    elsif id == Gosu::MsLeft && game_controller.game_state == 2     # game in end screen state
      game_controller.check_end_game_buttons(x_pos, y_pos, win_x_dim, win_y_dim)
    end
  end

  # overrides Gosu::Window update method; executes 60 times per second
  # PRIMARY GAME LOGIC CAN GO IN HERE (or class method calls made in here)
  # updates: game_controller.game_state (0=intro screen, 1=play screen, 2=end screen)
  def update

    if game_controller.game_state == 0                    # game introduction; user chooses single player or versus computer
      if game_controller.play_solo_button_state || game_controller.play_computer_button_state
        game_controller.game_state = 1                    # update game state to game in play
        game_data.start_time = Time.now.to_i              # start game timer from current time
      elsif game_controller.end_game_state
        game_controller.game_state = 2
      end

    elsif game_controller.game_state == 1                 # game in play
      if game_data.set_deck.cards.length == 81            # if full deck, deal initial 12 cards to cards_on_table
        game_data.set_deck.deal_twelve(game_data.cards_on_table)
      end
      if game_data.set_deck.cards.length >= 3 && game_data.cards_on_table.length < 12
        game_data.set_deck.deal_three(game_data.cards_on_table)
      end
      # TODO: insert code to check if any sets remaining; check end game conditions
      # TODO: if end game condition, then update game_state to 2 to transition to end/statistics screen
      if game_data.num_cards_selected(game_data.cards_on_table) == 3
        #Event.new.action_selected_three(game_data)
        Event.new.action_selected_three(game_controller, game_data)
      end
      if game_controller.deal_three_button_state
        game_controller.deal_three_button_state = false   # reset button state for future use
        game_data.set_deck.deal_three(game_data.cards_on_table)
      elsif game_controller.end_game_button_state
        game_controller.end_game_button_state = false     # reset button state for future use
        game_controller.game_state = 2                    # update game state to 2 to transition to end/stats screen
      #Event.new.action_hint(game_controller, game_data)
      elsif game_controller.new_game_button_state
        @game_data = GameData.new                         # reset deck and game data variables for new game
        @game_controller = GameController.new             # reset game button states for new game; resets game state to 0
      end

      # handle hint cards drawing
      if game_controller.hint_button_state                  # check if hint button was pressed
        hint_sets = Logic.new.findSets(game_data.cards_on_table)
        if hint_sets == nil
          # TODO: logic needed for no set found?
        else  # pick random valid set
          game_controller.hint_set = hint_sets[rand(hint_sets.length)]
          p game_controller.hint_set
          game_controller.hint_counter = 5
        end
        game_controller.hint_button_state = false             # reset button state for future use
      end

    else  # game_state = 2; end of game; show results, stats, etc...
        if game_controller.new_game_button_state
          @game_data = GameData.new                       # reset deck and game data variables for new game
          @game_controller = GameController.new           # reset game button states for new game; resets game state to 0
        elsif game_controller.exit_game_button_state
          self.close                                      # close game window and end program
        end
    end
  end

  # overrides Gosu::Window method
  # called 60 timers per second (60 fps) to redraw window; also called by operating system as needed
  # contains code to redraw the game window, but does not contain game logic here unless necessary
  # game logic should be contained in 'update' method above
  def draw

    if game_controller.game_state == 0        # game intro screen; user chooses single player or versus computer
      # draws background image; args are (x-coord origin, y-coord origin, z-order, scale_x, scale_y, color)
      @intro_end_background_image.draw(0, 0, 0, 1, 1, transparent_color)
      game_controller.draw_intro(win_x_dim, win_y_dim, mouse_x, mouse_y)

    elsif game_controller.game_state == 1     # game in play
      # draws background image; args are (x-coord origin, y-coord origin, z-order, scale_x, scale_y)
      @play_background_image.draw(0, 0, 0, 1.3, 1)
      # draw the cards to the window from the cards_on_table array

      game_controller.draw_play_buttons(win_x_dim, win_y_dim, mouse_x, mouse_y)
      game_controller.draw_table(game_data)

      # draw game timer, player scores, and cards in deck to the window
      # draw args are ("text", x-coord origin, y-coord origin, layer above background, horiz scale factor, vertical scale factor, RGB color)
      current_time = Time.now.to_i - game_data.start_time
      @font_size.draw("Game Time: #{current_time}", 10, 860, 1, 2, 2, text_color)
      @font_size.draw("Player 1 Score: #{game_data.player_one_score.round}", 400, 820, 1, 2, 2, text_color)
      @font_size.draw("Player 1 seconds/set: #{(current_time/game_data.player_one_score.to_f).round(1)}", 400, 860, 1, 2, 2, text_color)
      # display player-2 score only if computer is playing
      if game_controller.play_computer_button_state
        @font_size.draw("Player 2 Score: #{game_data.player_two_score}", 900, 820, 1, 2, 2, text_color)
        @font_size.draw("Player 2 seconds/set: #{(current_time/game_data.player_two_score.to_f).round(1)}", 900, 860, 1, 2, 2, text_color)
      end
      @font_size.draw("Cards Remaining: #{game_data.set_deck.cards.length}", 10, 820, 1, 2, 2, text_color)

    else                                      # game_state = 2, end of game; show results, stats, etc...
      # draws background image; args are (x-coord origin, y-coord origin, z-order, scale_x, scale_y, color)
      @intro_end_background_image.draw(0, 0, 0, 1, 1, @transparent_color)
      game_controller.draw_end_game(win_x_dim, win_y_dim, mouse_x, mouse_y)
      scores = game_data.get_top_10
      count = 0
      for score in scores
        image = Gosu::Image.from_text(score, 40, :width => 250, :align => :center)
        Gosu::draw_rect(10, count*45, image.width, image.height, 0xFF_F2E6B1, 1)
        image.draw(10, count*45, 2, 1, 1, text_color)
        #@font_size.draw(score, 0, count*40, 1, 2, 2, text_color)
        count += 1
      end
    end
end

### Start Main Program ###
# instantiate GameWindow object; this call also creates GameData struct/object containing game variables/states (cards, scores, timers...)
window = GameWindow.new
# window.show renders game window to the screen and triggers entry into a continual game loop,
#   which executes GameWindow's 'update' and 'draw' methods 60 times per second until the window is closed
window.show
puts 'program end'                              # test print program end to console; can delete as necessary
end
