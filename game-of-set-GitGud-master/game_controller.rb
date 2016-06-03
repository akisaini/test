# ----------------------------------------------------- #
# FILE: game_controller.rb                              #
# AUTH: Eric Lewantowicz                                #
# CONT: Andrew Lee                                      #
# DATE: 26 May 2016                                     #
# INFO: class that deals with various game states       #
# ----------------------------------------------------- #

# utility class that executes window logic
require 'gosu'
require_relative 'game_input'

class GameController

  attr_accessor :game_state
  attr_accessor :play_computer_button_state
  attr_accessor :ai_level
  attr_accessor :player
  attr_accessor :play_solo_button_state
  attr_accessor :play_multiplayer_button_state
  attr_accessor :restart_game_button_state
  attr_accessor :end_game_state
  attr_accessor :new_game_button_state
  attr_accessor :end_game_button_state
  attr_accessor :exit_game_button_state
  attr_accessor :deal_three_button_state
  attr_accessor :hint_button_state
  attr_accessor :end_game_button_state
  attr_accessor :hint_counter
  attr_accessor :hint_set
  attr_accessor :comp_set

  def initialize
    @game_state = 0                                               # 0 = game intro; 1 = game in play; 2 = end of game
    @hint_counter = 0                                             # counter to flash hint cards in draw cycle
    @hint_set = Array.new                                         # set of three cards shown when hint requested
    @comp_set = Array.new
    @ai_level = 4                                                 # vs. computer (level 0 easiest to 5 hardest)
    @player = 1                                                   # track active player 1 or 2 (3 for neither)
    @play_computer_button_state = false                           # multiple button states used in all stages of game play
    @play_solo_button_state = false                               # multiplayer active or not
    @play_multiplayer_button_state = false
    @deal_three_button_state = false
    @hint_button_state = false
    @new_game_button_state = false
    @end_game_button_state = false
    @exit_game_button_state = false
  end

  # after mouse press detected on play screen, calculate if cursor positioned over valid card
  #   maximum 3 cards may be selected at one time; if user selects more than 3 cards, action is ignored
  # x: x-coordinate of mouse cursor in window when left button pushed
  # y: y-coordinate of mouse cursor in window when left button pushed
  # requires: game state 1
  # requires: maximum 21 cards in cards_on_table
  # updates: card.selected status
  def check_card_selected(x, y, game_data)

    # check if cursor position in a valid card region in the game window, update index of corresponding card
    card_index = -1                                                     # initialize to invalid index
    (0..20).each do |i|
      x1 = 10 + 160 * (i / 3)
      x2 = 160 * ((i / 3) + 1)
      y1 = 10 + (255 * (i % 3))
      y2 = 255 + (255 * (i % 3))
      (card_index = i; break) if (x >= x1 && x <= x2 && y >= y1 && y <= y2)
    end
    # check if selected card index is in valid range of number of cards_on_table array
    if card_index < game_data.cards_on_table.length && card_index > -1
      if game_data.cards_on_table[card_index].selected                  # update card status from selected to unselected
        game_data.cards_on_table[card_index].selected = !game_data.cards_on_table[card_index].selected
      elsif game_data.num_cards_selected(game_data.cards_on_table) < 3  # if 3 not already selected, update card to selected
        game_data.cards_on_table[card_index].selected = !game_data.cards_on_table[card_index].selected
      end
    end
  end

  # draw play screen cards currently in play
  # draw white background for unselected cards, yellow for selected cards, and flashing red/blue for hint card set
  # requires: game state 2
  # requires: maximum 21 cards
  # updates: hint_counter
  def draw_table(game_data)

      (0..game_data.cards_on_table.length - 1).each do |i|
        c = game_data.cards_on_table[i]
        select = c.selected ? 'T' : 'F'
        # interpolates five card attributes to concatenate corresponding .bmp filename
        card_file_name = "#{c.number}#{c.symbol}#{c.shading}#{c.color}#{select}.bmp"
        card_image = $RESOURCES[card_file_name]
        x_offset = 10 + (i / 3) * 160                                   # calculate x-coord offset for card position
        y_offset = 10 + (i % 3) * 255                                   # calculate y-coord offset for card position
        card_image.draw(x_offset, y_offset, 1)                          # draw card image to window
        if @hint_set != nil                                             # check for empty hint set array
          if @hint_counter > 0 && (@hint_set.include? i)                # update card color if active hint counter
            color = 0x55_aa0000 if @hint_counter > 0 && @hint_counter < 20  # alternate hint card color each count cycle
	    color = 0x55_88ffff if @hint_counter > 20 && @hint_counter < 40
	    color = 0x55_aa0000 if @hint_counter > 40 && @hint_counter < 60 
	    color = 0x55_88ffff if @hint_counter > 60 && @hint_counter < 80
	    color = 0x55_aa0000 if @hint_counter > 80 && @hint_counter < 120
	    color = 0x55_aa0000 if color == nil
            card_image.draw(x_offset, y_offset, 1, 1, 1, color)
          end
        end
      end
      #sleep(0.12) if @hint_counter > 0                                  # pause screen draw for hint color flash effect
      @hint_counter -= 1 if @hint_counter > 0                           # update hint counter
  end
end
