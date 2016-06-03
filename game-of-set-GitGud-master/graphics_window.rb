=begin
Project: Project #2: Game of Set
Team: GitGud
Creation Date: 23 May 16
Authors: Yazen Alzaghameem, Andrew Lee, Eric Lewantowicz, Joel Pepper, Aki Saini
Course: CSE 3901
Submission Date: 6/3/2016
Description: Set card game
Execution Instructions:   !! Graphical interface requires GOSU gem  !!
1. First install the following packages on Linux:
    sudo apt-get install build-essential libsdl2-dev libsdl2-ttf-dev libpango1.0-dev
    libgl1-mesa-dev libfreeimage-dev libopenal-dev libsndfile-dev
2. Ubuntu will likely require a system restart before installing GOSU gem
3. Finally, install GOSU gem
4. May require disabling of Linux 3D Acceleration if errors/warning received
5. For troubleshooting, refer to http://github.com/gosu/gosu/wiki/getting-started-on-linux
=end

# ----------------------------------------------------------- #
# FILE: graphics_window .rb                                   #
# AUTH: Eric Lewantowicz                                      #
# CONT: Andrew Lee, Yazen Alzaghameem, Joel Pepper, Aki Saini #
# DATE: 26 May 2016                                           #
# INFO: Main Class                                            #
# ----------------------------------------------------------- #

require 'gosu'
# include class files; require_relative used because in same directory as this file
require_relative 'game_data'
require_relative 'deck'
require_relative 'card'
require_relative 'game_controller'
require_relative 'event_controller'
require_relative 'logic'
require_relative 'game_input'
require_relative 'animator'

# IMPORTANT!:  Please store any external files in this hash #
# Format:  key = filename (string), key = object
$RESOURCES = {}
HINT_PENALTY = 5
DEAL_PENALTY = 5


class GameWindow < Gosu::Window

  attr_accessor :game_data
  attr_accessor :game_controller
  attr_accessor :win_x_dim
  attr_accessor :win_y_dim
  attr_accessor :input_cont

  def initialize
    @win_x_dim = 1380                                         # set window fixed x, y dimensions
    @win_y_dim = 900
    @font_size = Gosu::Font.new(20)                           # font size for window text
    @text_color = Gosu::Color.new(0xff_000000)
    @transparent_color = Gosu::Color.new(180, 255, 255, 255)  # color (alpha, red, green, blue) modulation
    @transparent_color2 = Gosu::Color.new(180, 255, 255, 255)
    super @win_x_dim, @win_y_dim                              # x, y dimensions of game window
    self.caption = "Team GitGud's Game of Set"                # window title bar caption
    play_image_config_path = File.expand_path("../media/play_background.png", __FILE__)
    intro_end_image_config_path = File.expand_path("../media/intro_end_background.png", __FILE__)
    intro_highscore_image_config_path = File.expand_path("../media/intro_highscore.png", __FILE__)
    @play_background_image = Gosu::Image.new(play_image_config_path, :tileable => true)
    @intro_end_background_image = Gosu::Image.new(intro_end_image_config_path, :tileable => true)
    @ai_flag = false                                       # monitor computer card set display progress
    @intro_highscore_image = Gosu::Image.new(intro_highscore_image_config_path, :tileable => true)
    @game_data = GameData.new(self)                           # object contains game play variables
    @game_controller = GameController.new                     # object contains button states, update/draw handling
    @input_cont = InputController.new(@game_data)
    # Intro
    @input_cont.make_text(0.5, 0.25, 0, :text => "Welcome to Team GitGud Game of Set!", :font_height => 60, :title => true)
    @input_cont.make_button(0.2, 0.5, 0, :text => "Play Computer") { game_controller.play_computer_button_state = true }
    @input_cont.make_button(0.5, 0.5, 0, :text => "Play Solo") { game_controller.play_solo_button_state = true }
    @input_cont.make_button(0.8, 0.5, 0, :text => "Play 2 Player") { game_controller.play_multiplayer_button_state = true, game_controller.player = 3 }
    @input_cont.make_button(0.3, 0.7, 0, :text => "High Scores") { game_controller.end_game_state = true }
    @input_cont.make_button(0.7, 0.7, 0, :text => "Exit Game") { game_controller.exit_game_button_state = true }
    @input_cont.make_text_input(0.1, 0.9, 0, @game_data.player_one_name_input, :text => "Player 1")
    @input_cont.make_text_input(0.6, 0.9, 0, @game_data.player_two_name_input, :text => "Player 2")
    # Game
    @input_cont.make_button(0.91, 0.1, 1, :text => "Deal 3 Cards", :x_buffer => 10) { game_controller.deal_three_button_state = true }
    @input_cont.make_button(0.91, 0.3, 1, :text => "Need Hint", :x_buffer => 10) { game_controller.hint_button_state = true } 
    @input_cont.make_button(0.91, 0.5, 1, :text => "End Game", :x_buffer => 10) { game_controller.new_game_button_state = true } 
    @input_cont.make_button(0.91, 0.7, 1, :text => "Exit Game", :x_buffer => 10) { game_controller.exit_game_button_state = true }
    # End Screen
    @input_cont.make_text(0.5, 0.05, 2, :text => "High Scores", :title => true)
    @input_cont.make_button(0.3, 0.9, 2, :text => "New Game") { game_controller.new_game_button_state = true }
    @input_cont.make_button(0.7, 0.9, 2, :text => "Exit Game") { game_controller.exit_game_button_state = true }

    load_images                                               # load image resources to $RESOURCES
    ##TODO can safely delete these demos
    @animator = GameCanvas.new self                               # controller that records animating objects
    @animator.add("cursor", GameCursorTest.new(0,0,1000, Sprite.new([$RESOURCES["img_cursor0.png"], $RESOURCES["img_cursor1.png"]])))
  end

  # Load persistent external image resources into the $RESOURCES hash.
  def load_images
    # This code was moved from draw_table() in order to reduce draw overhead.
    @game_data.set_deck.cards.each do |c|
      # interpolates five card attributes to concatenate corresponding .bmp filename
      card_file_name_true = "#{c.number}#{c.symbol}#{c.shading}#{c.color}T.bmp"
      card_file_name_false = "#{c.number}#{c.symbol}#{c.shading}#{c.color}F.bmp"
      # relative path to avoid problems opening image files from /testing directory
      card_config_path_true = File.expand_path("../media/#{card_file_name_true}", __FILE__)
      card_config_path_false = File.expand_path("../media/#{card_file_name_false}", __FILE__)
      card_image_true = Gosu::Image.new(card_config_path_true)
      card_image_false = Gosu::Image.new(card_config_path_false)
      $RESOURCES[card_file_name_true] = card_image_true
      $RESOURCES[card_file_name_false] = card_image_false
    end

    # Mouse cursor Demo #
    $RESOURCES["img_cursor0.png"] = Gosu::Image.new(File.expand_path("../media/img_cursor0.png", __FILE__))
    $RESOURCES["img_cursor1.png"] = Gosu::Image.new(File.expand_path("../media/img_cursor1.png", __FILE__))
  end

  def needs_cursor?                                           # show mouse cursor in game window
	  false
  end

  # window callback function is checked by system prior to update() method if button_up event is detected
  # this callback should be used for single press events (i.e. interacting with UI, and not events that require
  # holding down a button; for holding down a button functionality, use the Gosu::button_down/up? class methods
  # override: default Gosu member function, which does nothing
  # callback: called by system when button_up event detected
  def button_up(id)
    x_pos = mouse_x                                                               # get x, y coords of mouse cursor after button release
    y_pos = mouse_y
    puts "x_pos #{x_pos}, y_pos #{y_pos}"                                         # TODO: test print x, y coords to console; can delete
    if id == Gosu::MsLeft
      @input_cont.check_input(x_pos, y_pos, game_controller.game_state)
      if game_controller.play_multiplayer_button_state
        if game_controller.game_state == 1 && game_data.player_set_timer > 0
          game_controller.check_card_selected(x_pos, y_pos, game_data)              # check for mouse press on cards only when timer is counting for multiplayer games
        end
      elsif game_controller.game_state == 1
        game_controller.check_card_selected(x_pos, y_pos, game_data)                # check for mouse press in play screen buttons or cards
      end
    end
    @input_cont.update_text
  end

  def button_down(id)
    @input_cont.update_text
  end

  # overrides Gosu::Window update method; executes 60 times per second default
  # contains primary game loop logic
  # updates: game_controller.game_state (0=intro screen, 1=play screen, 2=end screen)
  # updates: game_controller button states (multiple)
  # updates: game_controller.hint_counter
  def update
    @animator.step()
    if game_controller.game_state == 0                    # game state 0--intro; choose single play or vs. computer
      if game_controller.play_solo_button_state || game_controller.play_computer_button_state || game_controller.play_multiplayer_button_state
        game_controller.game_state = 1                    # update game state to game in play
        game_data.start_time = Time.now.to_i              # start game timer from current time
        game_data.set_time = game_data.start_time         # initialize to start of game for first set timer
      elsif game_controller.end_game_state
        @input_cont.update_high_scores
        game_controller.game_state = 2
      elsif game_controller.exit_game_button_state
        self.close
      end

    elsif game_controller.game_state == 1                 # game state 1--game in play
      @input_cont.change_state
      if game_controller.exit_game_button_state
        self.close
      end
      if game_data.set_deck.cards.length == 81            # if full deck, deal initial 12 cards to cards_on_table
        game_data.set_deck.deal_twelve(game_data.cards_on_table)
      end
      if game_data.set_deck.cards.length >= 3 && game_data.cards_on_table.length < 12 # if less than 12 cards on table, deal 3
        game_data.set_deck.deal_three(game_data.cards_on_table)
      end
      # if vs. computer, and player exceeds find set time limit (scaled for difficulty), computer finds set and gets points
      if game_controller.play_computer_button_state &&
          ((Time.now.to_i - game_data.set_time) > (30 - 5 * game_controller.ai_level)) &&
          Logic.new.hasValidSet(game_data.cards_on_table)
        if !@ai_flag                                                 # only run this block once per hint_counter cycle
          @ai_flag = true
          game_controller.player = 2                                    # transfer control to player 2 (computer)
          comp_sets = Logic.new.findSets(game_data.cards_on_table)
          game_controller.comp_set = comp_sets[rand(comp_sets.length)]  # computer identifies random set to take
          Event.new.action_clear_selected(game_data)                    # set all cards on table to non-selected
          game_controller.hint_counter = 3                              # set counter for computer card set display
          game_controller.hint_set = game_controller.comp_set                           # set computer card set to display
        end
        if game_controller.hint_counter == 0                          # wait until hint cycles complete
          Event.new.action_set_three_selected(game_data, game_controller.comp_set)      # set valid set of three cards to selected
          Event.new.action_selected_three(game_controller, game_data, @animator)   # remove set from table and update score and play music
          game_data.set_time = Time.now.to_i                            # reset set timer
          game_controller.player = 1                                    # return control to player 1
          game_controller.comp_set = []                                 # reset for next computer take
          @ai_flag = false                                           # reset flag for next computer set take
        end
      end
      # Multiplayer - Player 1 Attempt (Presses "1")
      if game_controller.play_multiplayer_button_state && (button_down?(Gosu::Kb1) || button_down?(Gosu::KbNumpad1)) && game_data.player_set_timer == 0
        game_controller.player = 1
        Event.new.action_player_timer(game_data, Time.now.to_i)
      # Multiplayer - Player 2 Attempt (Presses "0")
      elsif game_controller.play_multiplayer_button_state && (button_down?(Gosu::Kb0) || button_down?(Gosu::KbNumpad0)) && game_data.player_set_timer == 0
        game_controller.player = 2
        Event.new.action_player_timer(game_data, Time.now.to_i)
      end

      # Multiplayer - Timer
      if game_data.player_set_timer > 0
        game_data.player_set_timer = game_data.player_set_startTime - Time.now.to_i
      else
        Event.new.action_score_penalty(game_data, game_controller, 5)
        game_data.player_set_startTime = 0;
        game_data.player_set_timer = 0
        game_controller.player = 3
      end

      # check if player selected three cards and not running hint or computer draw cycles -Non Multiplayer Scoring
      if !game_controller.play_multiplayer_button_state
        if game_controller.hint_counter == 0 && game_data.num_cards_selected(game_data.cards_on_table) == 3
          num_on_table = game_data.cards_on_table.length                # check if Event.action removes valid set
          Event.new.action_selected_three(game_controller, game_data, @animator)   # handle valid and invalid sets
          # reset set timer if set was removed from table
          (game_data.set_time = Time.now.to_i) if (num_on_table > game_data.cards_on_table.length)
        end
      else # Mutliplayer Scoring (Can only score during timer countdown)
        if game_controller.hint_counter == 0 && game_data.num_cards_selected(game_data.cards_on_table) == 3 && game_data.player_set_timer > 0
          num_on_table = game_data.cards_on_table.length                # check if Event.action removes valid set
          Event.new.action_selected_three(game_controller, game_data, @animator)   # handle valid and invalid sets
          # reset set timer if set was removed from table
          (game_data.set_time = Time.now.to_i) if (num_on_table > game_data.cards_on_table.length)
        end
      end
      if game_controller.deal_three_button_state && !@ai_flag   # handle if player pushed Deal-3-Cards button and ai player not active
        game_controller.deal_three_button_state = false   # reset button state for future use
        game_data.set_time = Time.now.to_i                # reset set timer so computer doesn't steal set immediately
        if Logic.new.hasValidSet(game_data.cards_on_table)
          Event.new.action_score_penalty(game_data, game_controller, DEAL_PENALTY)
        end
        game_data.set_deck.deal_three(game_data.cards_on_table)
=begin
      elsif game_controller.hint_button_state
        game_controller.hint_button_state = false         # reset button state for future use
        # TODO: replace implementation to give hint to player
        # TODO: possibly missing implementation to facilitate cues to player.
        #       i.e how can cards be highlighted without also being selected?
        #       i.e flashing effect?  different color besides yellow?
        #           player needs to see the hint and also know if he/she has selected the card(s)
        Event.new.action_hint(game_controller, game_data)
=end
      elsif game_controller.end_game_button_state
        game_controller.end_game_button_state = false     # reset button state for future use
        game_controller.game_state = 2                    # update game state to 2 to transition to end/stats screen
        #@input_cont.update_high_scores
	@input_cont.change_state
      elsif game_controller.new_game_button_state
        game_data.store_score
        @input_cont.update_high_scores
        game_data.clear!                         # reset deck and game data variables for new game
        @game_controller = GameController.new             # reset game button states for new game; resets game state to 0
      end
      if game_controller.hint_button_state && !@ai_flag   # check if hint button was pressed and ai player not active
        hint_sets = Logic.new.findSets(game_data.cards_on_table)
        p hint_sets
        if hint_sets.to_a.empty?
          # TODO: logic needed for no set found?
        else                                              # pick random valid set to use for hint
          # penalize player score if valid hint set exists
          Event.new.action_score_penalty(game_data, game_controller, HINT_PENALTY)
          game_controller.hint_set = hint_sets[rand(hint_sets.length)]
          p game_controller.hint_set                      # TODO: test print hint set; can delete
          game_controller.hint_counter = 60                # set counter for flashing hint card draw in draw_table
        end
        game_controller.hint_button_state = false         # reset button state for future use
      end
    else                                                  # game_state = 2--end of game: show scores, stats
      #; $CURRENT_INPUT.selected = false unless $CURRENT_INPUT == nil
      if game_controller.new_game_button_state
        game_data.store_score
        @input_cont.update_high_scores
        game_data.clear!                       # reset deck and game data variables for new game
        @game_controller = GameController.new           # reset game button states for new game; resets game state to 0
      elsif game_controller.exit_game_button_state      # handle exit_game button pushed
        self.close                                      # close game window and end program
      end
    end
  end

  # draw window intro, game play, and end screens; called 60 times per second and by operating system as needed
  # override: Gosu::Window method
  # game logic contained in 'update' method above
  def draw
    @input_cont.draw_all(mouse_x, mouse_y, game_controller.game_state)
    @animator.draw()
    if game_controller.game_state == 0                          # game intro screen; draw intro screen and intro buttons
      # args (x-coord origin, y-coord origin, z-order, scale_x, scale_y, color)
      @animator.remove("highscore") #TODO can refactor this somewhere else
      @intro_end_background_image.draw(0, 0, 0, 1, 1, @transparent_color)
      #game_controller.draw_intro(win_x_dim, win_y_dim, mouse_x, mouse_y, game_data)
    elsif game_controller.game_state == 1                       # game in play screen; draw play screen table, cards, and play butons
      @animator.remove("highscore") #TODO can refactor this somewhere else
      @play_background_image.draw(0, 0, 0, 1.3, 1)
      game_controller.draw_table(game_data)
      # draw game timer, player scores, and cards in deck to the window
      # draw args are ("text", x-coord origin, y-coord origin, layer above background, horiz scale factor, vertical scale factor, RGB color)
      current_time = Time.now.to_i - game_data.start_time
      @font_size.draw("Game Time: #{current_time}", 10, 860, 1, 2, 2, @text_color)
      @font_size.draw("#{game_data.player_one_name} Score: #{game_data.player_one_score}", 400, 820, 1, 2, 2, @text_color)
      # display player-2 score if facing computer or player 2
      if game_controller.play_computer_button_state || game_controller.play_multiplayer_button_state
        @font_size.draw("#{game_data.player_two_name} Score: #{game_data.player_two_score}", 400, 860, 1, 2, 2, @text_color)
      end
      # display current player and timer countdown for multiplayer
      if game_controller.play_multiplayer_button_state
        if game_controller.player == 1
          @font_size.draw("Active Player: #{game_data.player_one_name}", 760, 820, 1, 2, 2, @text_color)
        elsif game_controller.player == 2
          @font_size.draw("Active Player: #{game_data.player_two_name}", 760, 820, 1, 2, 2, @text_color)
        else
          @font_size.draw("Active Player: ", 760, 820, 1, 2, 2, @text_color)
        end
        @font_size.draw("Set Timer: #{game_data.player_set_timer}", 760, 860, 1, 2, 2, @text_color)
      end
      @font_size.draw("Cards Remaining: #{game_data.set_deck.cards.length}", 10, 820, 1, 2, 2, @text_color)
    elsif game_controller.game_state == 2                                                        # end game screen; draw results, stats
      Event.new.action_load_highscore @animator, @game_data     #TODO can refactor this outside loop to optimize further
      @intro_highscore_image.draw(0, 0, 0, 1, 1, 0xFF_FFFFFF) #TODO was @transparent_color
      @intro_end_background_image.draw(0, 0, -10, 1, 1, 0xFF_FFFFFF) #TODO was @transparent_color
    end
  end
end

### Start Main Program ###

song = Gosu::Sample.new('song.wav')
# Plays the song without panning.
#
# volume:: is fixed for song class
# speed:: is fixed for song class
song.play(0.1, 1, true)



window = GameWindow.new  # create GameWindow object; initializes GameData and GameController objects
window.show              # render window to screen and enter game loop--update, draw methods executed 60 times per second
puts 'program end'       # test print program end to console
