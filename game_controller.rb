# utility class that executes window logic
require 'gosu'

class GameController

  attr_accessor :game_state
  attr_accessor :play_computer_button_state
  attr_accessor :play_solo_button_state
  attr_accessor :restart_game_button_state
  attr_accessor :end_game_state
  attr_accessor :new_game_button_state
  attr_accessor :end_game_button_state
  attr_accessor :exit_game_button_state
  attr_accessor :deal_three_button_state
  attr_accessor :hint_button_state

  attr_accessor :button_color
  attr_accessor :button_color_pressed
  attr_accessor :outline_color
  attr_accessor :text_window_color
  attr_accessor :text_color
  attr_accessor :intro_message_image
  attr_accessor :play_computer_button_image
  attr_accessor :play_solo_button_image
  attr_accessor :score_button_image
  attr_accessor :end_game_button_image
  attr_accessor :new_game_button_image
  attr_accessor :end_game_button_state
  attr_accessor :exit_game_button_image
  attr_accessor :deal_three_button_image
  attr_accessor :hint_button_image
  attr_accessor :b_offset
  attr_accessor :hint_counter
  attr_accessor :hint_set

  def initialize
    @game_state = 0                # 0 = game intro; 1 = game in play; 2 = end of game
    @b_offset = 10                 # button border offset width
    @hint_counter = 0
    @hint_set = Array.new
    @play_computer_button_state = false
    @play_solo_button_state = false
    @deal_three_button_state = false
    @hint_button_state = false
    @new_game_button_state = false
    @end_game_button_state = false
    @exit_game_button_state = false

    @button_color = Gosu::Color.new(255, 152, 214, 255)           # color (alpha, red, green, blue) modulation
    @button_color_pressed = Gosu::Color.new(255, 152, 214, 100)
    @outline_color = Gosu::Color.new(255, 150, 0, 0)
    #@text_window_color = Gosu::Color.new(255, 251, 245, 221)
    @text_window_color = Gosu::Color.new(0xFF_F2E6B1)
    @text_color = Gosu::Color.new(0xff_000000)

    @intro_message_image = Gosu::Image.from_text("Welcome to Team GitGud Game of Set!", 60, :align => :center)
    @play_computer_button_image = Gosu::Image.from_text("Play Computer", 40, :width => 230, :align => :center)
    @play_solo_button_image = Gosu::Image.from_text("Play Solo", 40, :width => 230, :align => :center)
    @score_button_image = Gosu::Image.from_text("High Scores", 40, :width => 230, :align => :center)
    @deal_three_button_image = Gosu::Image.from_text("Deal 3 Cards", 40, :width => 180, :align => :center)
    @hint_button_image = Gosu::Image.from_text("Need Hint", 40, :width => 180, :align => :center)
    @end_game_button_image = Gosu::Image.from_text("End Game", 40, :width => 180, :align => :center)
    @new_game_button_image = Gosu::Image.from_text("New Game", 40, :width => 180, :align => :center)
    @exit_game_button_image = Gosu::Image.from_text("Exit Game", 40, :width => 180, :align => :center)
  end

  def check_intro_buttons(x_pos, y_pos, win_x_dim, win_y_dim)

    button_width = play_solo_button_image.width + b_offset
    button_height = play_solo_button_image.height + b_offset

    if x_pos >= win_x_dim/3 - button_width/2 && x_pos <= win_x_dim/3 + button_width/2 && y_pos >= win_y_dim*2/3 - button_height/2 && y_pos <= win_y_dim*2/3 + button_height/2
      @play_solo_button_state = true
      puts "solo play #{@play_solo_button_state}"
    elsif x_pos >= win_x_dim*2/3 - button_width/2 && x_pos <= win_x_dim*2/3 + button_width/2 && y_pos >= win_y_dim*2/3 - button_height/2 && y_pos <= win_y_dim*2/3 + button_height/2
      @play_computer_button_state = true
      puts "computer play #{@play_computer_button_state}"
    elsif x_pos >= win_x_dim/2-button_width/2 && x_pos <= (win_x_dim/2 + button_width/2) && y_pos >= win_y_dim*3/4 - button_height/2 && y_pos <= (win_y_dim*3/4 + button_height/2)
      @end_game_state = true
      puts "show splash screen #{@end_game_state}"
    end
  end

  def check_play_buttons(x_pos, y_pos, win_x_dim, win_y_dim)

    button_width = deal_three_button_image.width + b_offset
    button_height = deal_three_button_image.height + b_offset

    if x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + button_width && y_pos >= win_y_dim - 500 && y_pos <= win_y_dim - 500 + button_height
      @deal_three_button_state = true
      puts "deal-3 #{@deal_three_button_state}"
    elsif x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + button_width && y_pos >= win_y_dim - 400 && y_pos <= win_y_dim - 400 + button_height
      @hint_button_state = true
      puts "hint #{@hint_button_state}"
    elsif x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + button_width && y_pos >= win_y_dim - 300 && y_pos <= win_y_dim - 300 + button_height
      @end_game_button_state = true
      puts "end game #{@end_game_button_state}"
    elsif x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + button_width && y_pos >= win_y_dim - 200 && y_pos <= win_y_dim - 200 + button_height
      @new_game_button_state = true
      puts "new game #{@new_game_button_state}"
    end
  end

  def check_end_game_buttons(x_pos, y_pos, win_x_dim, win_y_dim)

    width = new_game_button_image.width + b_offset
    height = new_game_button_image.height + b_offset

    if x_pos >= win_x_dim/3-width/2 && x_pos <= win_x_dim/3 + width/2 && y_pos >= win_y_dim-100 && y_pos <= win_y_dim-100 + height
      @new_game_button_state = true
      puts "new game #{@new_game_button_state}"
    elsif x_pos >= win_x_dim*2/3-width/2 && x_pos <= win_x_dim*2/3 + width/2 && y_pos >= win_y_dim-100 && y_pos <= win_y_dim-100 + height
      @exit_game_button_state = true
      puts "exit game #{@exit_game_button_state}"
    end
  end

  # check if mouse cursor position is at valid card location after mouse button push; if mouse button was pushed and
  #   cursor position was over valid card location, the card's 'selected' attribute is flipped
  #   maximum 3 cards may be selected at one time; if user selects more than 3 cards, action is ignored
  # param x: x-coordinate of mouse cursor in window when left button pushed
  # param y: y-coordinate of mouse cursor in window when left button pushed
  # requires: maximum 21 cards dealt on the table (i.e. 21 cards in the cards_on_table array)
  # updates: card at game_data.cards_on_table[index]
  def check_card_selected(x, y, game_data)

    # check for valid x, y mouse coordinates if the point(x,y) is within a valid card region in the game window,
    #   then update the card index corresponding to the selected card; limit of 21 cards maximum in the window
    card_index = -1                                       # card_index initialized to invalid index
    if x >= 10 && x <= 160 && y >= 10 && y <= 255
      card_index = 0
    elsif x >= 10 && x <= 160 && y >= 265 && y <= 510
      card_index = 1
    elsif x >= 10 && x <= 160 && y >= 520 && y <= 765
      card_index = 2
    elsif x >= 170 && x <= 320 && y >= 10 && y <= 255
      card_index = 3
    elsif x >= 170 && x <= 320 && y >= 265 && y <= 510
      card_index = 4
    elsif x >= 170 && x <= 320 && y >= 520 && y <= 765
      card_index = 5
    elsif x >= 330 && x <= 480 && y >= 10 && y <= 255
      card_index = 6
    elsif x >= 330 && x <= 480 && y >= 265 && y <= 510
      card_index = 7
    elsif x >= 330 && x <= 480 && y >= 520 && y <= 765
      card_index = 8
    elsif x >= 490 && x <= 640 && y >= 10 && y <= 255
      card_index = 9
    elsif x >= 490 && x <= 640 && y >= 265 && y <= 510
      card_index = 10
    elsif x >= 490 && x <= 640 && y >= 520 && y <= 765
      card_index = 11
    elsif x >= 650 && x <= 800 && y >= 10 && y <= 255
      card_index = 12
    elsif x >= 650 && x <= 800 && y >= 265 && y <= 510
      card_index = 13
    elsif x >= 650 && x <= 800 && y >= 520 && y <= 765
      card_index = 14
    elsif x >= 810 && x <= 960 && y >= 10 && y <= 255
      card_index = 15
    elsif x >= 810 && x <= 960 && y >= 265 && y <= 510
      card_index = 16
    elsif x >= 810 && x <= 960 && y >= 520 && y <= 765
      card_index = 17
    elsif x >= 970 && x <= 1120 && y >= 10 && y <= 255
      card_index = 18
    elsif x >= 970 && x <= 1120 && y >= 265 && y <= 510
      card_index = 19
    elsif x >= 970 && x <= 1120 && y >= 520 && y <= 765
      card_index = 20
    end

    # check if selected card index is in valid range of number of cards_on_table array
    if card_index < game_data.cards_on_table.length && card_index > -1
      # if selected, change card selected status to unselected
      if game_data.cards_on_table[card_index].selected
        game_data.cards_on_table[card_index].selected = !game_data.cards_on_table[card_index].selected
      elsif game_data.num_cards_selected(game_data.cards_on_table) < 3  # if unselected, check if 3 cards already selected; if not, change card to selected
        game_data.cards_on_table[card_index].selected = !game_data.cards_on_table[card_index].selected
      end
      # TODO: test prints to console; this can be removed as needed from final version
      puts game_data.cards_on_table[card_index].selected
    end
  end

  # draw intro screen with welcome message, solo-play, and play-computer buttons
  def draw_intro(win_x_dim, win_y_dim, x_pos, y_pos)

    width = intro_message_image.width + b_offset
    height = intro_message_image.height + b_offset
    outline_width = width + b_offset
    outline_height = height + b_offset
    # print welcome message
    Gosu::draw_rect(win_x_dim/2-outline_width/2, win_y_dim/3-outline_height/2, outline_width, outline_height, text_color, 1)
    Gosu::draw_rect(win_x_dim/2-width/2, win_y_dim/3-height/2, width, height, text_window_color, 1)
    @intro_message_image.draw(win_x_dim/2-width/2+b_offset/2, win_y_dim/3-height/2+b_offset/2, 2, 1, 1, text_color)

    width = play_solo_button_image.width + b_offset
    height = play_solo_button_image.height + b_offset
    outline_width = width + b_offset
    outline_height = height + b_offset

    Gosu::draw_rect(win_x_dim/3-outline_width/2, win_y_dim*2/3-outline_height/2, outline_width, outline_height, outline_color, 1)
    # update button color if mouse positioned over button rect
    if x_pos >= win_x_dim/3-width/2 && x_pos <= win_x_dim/3 + width/2 && y_pos >= win_y_dim*2/3-height/2 && y_pos <= win_y_dim*2/3 + height/2
      Gosu::draw_rect(win_x_dim/3-width/2, win_y_dim*2/3-height/2, width, height, button_color_pressed, 2)
    else
      Gosu::draw_rect(win_x_dim/3-width/2, win_y_dim*2/3-height/2, width, height, button_color, 2)
    end
    @play_solo_button_image.draw(win_x_dim/3-width/2+b_offset/2, win_y_dim*2/3-height/2+b_offset, 3, 1, 1, text_color)

    Gosu::draw_rect(win_x_dim*2/3-outline_width/2, win_y_dim*2/3-outline_height/2, outline_width, outline_height, outline_color, 1)
    if x_pos >= win_x_dim*2/3-width/2 && x_pos <= win_x_dim*2/3 + width/2 && y_pos >= win_y_dim*2/3-height/2 && y_pos <= win_y_dim*2/3 + height/2
      Gosu::draw_rect(win_x_dim*2/3-width/2, win_y_dim*2/3-height/2, width, height, button_color_pressed, 2)
    else
      Gosu::draw_rect(win_x_dim*2/3-width/2, win_y_dim*2/3-height/2, width, height, button_color, 2)
    end
    @play_computer_button_image.draw(win_x_dim*2/3-width/2+b_offset/2, win_y_dim*2/3-height/2+b_offset, 3, 1, 1, text_color)

    Gosu::draw_rect(win_x_dim/2-outline_width/2, win_y_dim*3/4-outline_height/2, outline_width, outline_height, outline_color, 1)
    if x_pos >= win_x_dim/2-width/2 && x_pos <= (win_x_dim/2 + width/2) && y_pos >= win_y_dim*3/4-height/2 && y_pos <= (win_y_dim*3/4 + height/2)
      Gosu::draw_rect(win_x_dim/2-width/2, win_y_dim*3/4-height/2, width, height, button_color_pressed, 2)
    else
      Gosu::draw_rect(win_x_dim/2-width/2, win_y_dim*3/4-height/2, width, height, button_color, 2)
    end
    @score_button_image.draw(win_x_dim/2-width/2+b_offset, win_y_dim*3/4-height/2+b_offset, 3, 1, 1, text_color)

  end

  # draw play screen buttons; deal-3, hint, and new-game
  def draw_play_buttons(win_x_dim, win_y_dim, x_pos, y_pos)

    width = deal_three_button_image.width + b_offset
    height = deal_three_button_image.height + b_offset
    outline_width = width + b_offset
    outline_height = height + b_offset

    Gosu::draw_rect(win_x_dim - 200 - b_offset/2, win_y_dim - 500 - b_offset/2, outline_width, outline_height, outline_color, 1)
    # update button color if mouse positioned over button rect
    if x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + width && y_pos >= win_y_dim - 500  && y_pos <= win_y_dim - 500 + height
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 500, width, height, button_color_pressed, 2)
    else
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 500, width, height, button_color, 2)
    end
    @deal_three_button_image.draw(win_x_dim - 200 + b_offset/2, win_y_dim - 500 + b_offset, 3, 1, 1, text_color)

    Gosu::draw_rect(win_x_dim - 200 - b_offset/2, win_y_dim - 400 - b_offset/2, outline_width, outline_height, outline_color, 1)
    if x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + width && y_pos >= win_y_dim - 400  && y_pos <= win_y_dim - 400 + height
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 400, width, height, button_color_pressed, 1)
    else
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 400, width, height, button_color, 1)
    end
    @hint_button_image.draw(win_x_dim - 200 + b_offset/2, win_y_dim - 400 + b_offset, 3, 1, 1, text_color)

    Gosu::draw_rect(win_x_dim - 200 - b_offset/2, win_y_dim - 300 - b_offset/2, outline_width, outline_height, outline_color, 1)
    if x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + width && y_pos >= win_y_dim - 300  && y_pos <= win_y_dim - 300 + height
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 300, width, height, button_color_pressed, 1)
    else
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 300, width, height, button_color, 1)
    end
    @end_game_button_image.draw(win_x_dim - 200 + b_offset/2, win_y_dim - 300 + b_offset, 3, 1, 1, text_color)

    Gosu::draw_rect(win_x_dim - 200 - b_offset/2, win_y_dim - 200 - b_offset/2, outline_width, outline_height, outline_color, 1)
    if x_pos >= win_x_dim - 200 && x_pos <= win_x_dim - 200 + width && y_pos >= win_y_dim - 200  && y_pos <= win_y_dim - 200 + height
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 200, width, height, button_color_pressed, 1)
    else
      Gosu::draw_rect(win_x_dim - 200, win_y_dim - 200, width, height, button_color, 1)
    end
    @new_game_button_image.draw(win_x_dim - 200 + b_offset/2, win_y_dim - 200 + b_offset, 3, 1, 1, text_color)
  end

  # draw cards in cards_on_table array to game window (range from 0 - 20)
  def draw_table(game_data)

      (0..game_data.cards_on_table.length - 1).each do |i|
        c = game_data.cards_on_table[i]
        select = c.selected ? 'T' : 'F'
        # interpolates the five attributes of the card to concatenate the appropriate bmp filename
        card_file_name = "#{c.number}#{c.symbol}#{c.shading}#{c.color}#{select}.bmp"
        # relative pathing here to prevent problems opening image files from test files in /testing directory
        card_config_path = File.expand_path("../media/#{card_file_name}", __FILE__)
        card_image = Gosu::Image.new(card_config_path)
        x_offset = 10 + (i / 3) * 160                     # calculate x-coord offset for card in grid of cards
        y_offset = 10 + (i % 3) * 255                     # calculate y-coord offset for card in grid of cards
        card_image.draw(x_offset, y_offset, 1)            # draw card image to window
        if @hint_set != nil
          if @hint_counter > 0 && (@hint_set.include? i)
            color = @hint_counter % 2 == 0 ? 0x55_aa0000 : 0x55_88ffff
            card_image.draw(x_offset, y_offset, 1, 1, 1, color)
          end
        end
        #game_data.cards_on_table[i].print_card                      # prints card info to console; can be removed as needed
      end
      sleep(0.12) if @hint_counter > 0
      @hint_counter -= 1 if @hint_counter > 0
  end

  # draw end game splash screen with statistics data, new-game button, and exit-game button
  def draw_end_game(win_x_dim, win_y_dim, x_pos, y_pos)

    width = new_game_button_image.width + b_offset
    height = new_game_button_image.height + b_offset
    outline_width = width + b_offset
    outline_height = height + b_offset

    Gosu::draw_rect(win_x_dim/3-outline_width/2, win_y_dim-100-b_offset/2, outline_width, outline_height, outline_color, 1)
    # update button color if mouse positioned over button rect
    if x_pos >= win_x_dim/3-width/2 && x_pos <= win_x_dim/3 + width/2 && y_pos >= win_y_dim-100 && y_pos <= win_y_dim-100 + height
      Gosu::draw_rect(win_x_dim/3-width/2, win_y_dim-100, width, height, button_color_pressed, 2)
    else
      Gosu::draw_rect(win_x_dim/3-width/2, win_y_dim-100, width, height, button_color, 2)
    end
    @new_game_button_image.draw(win_x_dim/3-width/2+b_offset/2, win_y_dim-100+b_offset, 3, 1, 1, text_color)

    Gosu::draw_rect(win_x_dim*2/3-outline_width/2, win_y_dim-100-b_offset/2, outline_width, outline_height, outline_color, 1)
    if x_pos >= win_x_dim*2/3-width/2 && x_pos <= win_x_dim*2/3 + width/2 && y_pos >= win_y_dim-100 && y_pos <= win_y_dim-100 + height
      Gosu::draw_rect(win_x_dim*2/3-width/2, win_y_dim-100, width, height, button_color_pressed, 2)
    else
      Gosu::draw_rect(win_x_dim*2/3-width/2, win_y_dim-100, width, height, button_color, 2)
    end
    @exit_game_button_image.draw(win_x_dim*2/3-width/2+b_offset/2, win_y_dim-100+b_offset, 3, 1, 1, text_color)
  end
end
