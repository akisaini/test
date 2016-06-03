# ----------------------------------------------------- #
# FILE: game_input.rb                                   #
# AUTH:                                                 #
# CONT:                                                 #
# DATE: 26 May 2016                                     #
# INFO:                                                 #
# ----------------------------------------------------- #

require 'gosu'

# Don't instantiate this, use the constructors in InputController
private
class GameInput

  attr_accessor :text
  attr_accessor :native_state

  # x: top left corner x dim (actual box, not outline)
  # y: top left corner y dim (actual box, not outline)
  # native_state: the game state it shows up in (0, 1 or 2)
  # width: Set a manual width
  # text: text to put on the thing
  # font_height: How big the font is in pixels
  # x_buffer: how many extra pixels to add on the right and left
  # y_buffer: " top and bottom
  def initialize(x, y, native_state, game_data, relative, width, text, font_height, x_buffer, y_buffer)
    @button_color = Gosu::Color.new(255, 152, 214, 255)           # color (alpha, red, green, blue) modulation
    @button_color_pressed = Gosu::Color.new(255, 152, 214, 100)
    @outline_color = Gosu::Color.new(255, 150, 0, 0)
    @splash_color = Gosu::Color.new(0xFF_F2E6B1)
    @black = Gosu::Color.new(0xff_000000)
    @border_offset = 10
    @native_state = native_state
    @x_buffer = x_buffer
    @y_buffer = y_buffer
    @text_color = Gosu::Color.new(0xff_000000)
    @font_height = font_height
    @text = text
    @width = width
    if width != 0
      @text_image = Gosu::Image.from_text(text, @font_height, :width => width, :align => :center)
    else
      @text_image = Gosu::Image.from_text(text, @font_height)
      @text_image = Gosu::Image.from_text(text, @font_height, :width => @text_image.width + x_buffer * 2, :align => :center)
    end
    if relative
      @x_min = x * game_data.window.width - @text_image.width / 2
      @y_min = y * game_data.window.height - @text_image.height / 2
    else
      @x_min = x
      @y_min = y
    end
    @x_max = @x_min + @text_image.width
    @y_max = @y_min + @text_image.height
  end

  def isSelected(x, y)
    x <= @x_max and x >= @x_min and y <= @y_max + @y_buffer * 2 and y >= @y_min
  end

  def draw(x, y, title: false, no_outline: false, force_highlight: false)
    if title
      outline = @black
    else
      outline = @outline_color
    end
    if !no_outline
      width = @text_image.width + @border_offset * 2
      height = @text_image.height + @y_buffer * 2 + @border_offset * 2
      Gosu::draw_rect(@x_min - @border_offset, @y_min - @border_offset, width, height, outline, 1)
    end
    if (isSelected(x, y) and !title and !no_outline) or force_highlight
      box_color = @button_color_pressed
    else
      box_color = @button_color
    end
    Gosu::draw_rect(@x_min, @y_min, @text_image.width, @text_image.height + @y_buffer * 2, box_color, 1)
    @text_image.draw(@x_min, @y_min + @y_buffer, 2, 1, 1, @black)
  end
end

public
class InputController

  def initialize(game_data)
    @game_data = game_data
    @buttons = []
    @texts = []
    @text_inputs = []
    @hs_store = []
  end

  # USE THESE, DON'T DIRECTLY CALL THE CONSTRUCTORS
  def make_button(x, y, native_state, relative: true, width: 0, text: "", font_height: 40, x_buffer: 40, y_buffer: 10, &block)
    @buttons.push(Button.new(x, y, native_state, @game_data, relative, width, text, font_height, x_buffer, y_buffer, &block))
  end

  def make_text(x, y, native_state, relative: true, width: 0, text: "", font_height: 40, x_buffer: 40, y_buffer: 10, title: false)
    @texts.push(StaticText.new(x, y, native_state, @game_data, relative, width, text, font_height, x_buffer, y_buffer, title))
  end

  def make_text_input(x, y, native_state, text_input, relative: true, width: 0, text: "", font_height: 40, x_buffer: 40, y_buffer: 10)
    @text_inputs.push(InputBox.new(x, y, native_state, text_input, @game_data, relative, width, text, font_height, x_buffer, y_buffer))
  end

  # Run on mouse click
  def check_input(x, y, game_state)
    @buttons.each do |button|
      if button.isSelected(x, y) and button.native_state == game_state
        clickSong = Gosu::Sample.new('click.wav')
        clickSong.play(1, 1, false)
        button.run_process
        return
      end
    end
    @text_inputs.each do |text_input|
      if text_input.isSelected(x, y) and text_input.native_state == game_state
        @text_inputs.each { |t| t.selected = false }
        text_input.switchTo(@game_data.window)
        return
      end
    end
  end

  def update_text
    @text_inputs.each { |text_input| text_input.updateText }
  end
  
  def change_state
    @text_inputs.each {|t| t.selected = false}
    @game_data.window.text_input = nil
  end

  # Draws everything
  def draw_all(x, y, game_state)
    @buttons.each { |button| if button.native_state == game_state then button.draw(x, y) end }
    @texts.each { |text| if text.native_state == game_state then text.draw(x, y, :title => text.title) end }
    @text_inputs.each do |text_input|
      if text_input.native_state == game_state
        #text_input.updateText
        text_input.draw(x, y, :force_highlight => text_input.selected)
      end
    end
    @hs_store.each { |text| if text.native_state == game_state then text.draw(x, y, :no_outline => true) end }
  end

  # Recreates the high score images
  def update_high_scores
    scores = @game_data.get_top_10
    @hs_store = []
    for i in (0...scores.length)
      @hs_store.push(StaticText.new(0.5, i*0.066+0.14, 2, @game_data, true, 1000, "#{i+1}. #{scores[i]}", 40, 40, 10, false))
    end
  end

  # A button, also requires a code block to be passed with what it's supposed to do
  private
  class Button < GameInput
    def initialize(x, y, native_state, game_data, relative, width, text, font_height, x_buffer, y_buffer, &block)
      super(x, y, native_state, game_data, relative, width, text, font_height, x_buffer, y_buffer)
      @process = block
    end

    # Run the block
    def run_process
      @process.call
    end
  end

  # Just text, also takes whether it is the title or not
  private
  class StaticText < GameInput
    
    attr_accessor :title

    def initialize(x, y, native_state, game_data, relative, width, text, font_height, x_buffer, y_buffer, title)
      super(x, y, native_state, game_data, relative, width, text, font_height, x_buffer, y_buffer)
      @title = title
    end
  end

  # Text input, also takes a TextInput object
  private
  class InputBox < GameInput

    attr_accessor :text_input
    attr_accessor :selected

    def initialize(x, y, native_state, text_input, game_data, relative, width, text, font_height, x_buffer, y_buffer)
      super(x, y, native_state, game_data, relative, width, text, font_height, x_buffer, y_buffer)
      @text_input = text_input
      @text_input.text = @text
      @selected = false
    end

    # Run this to change the primary input
    def switchTo(window)
      @selected = true
      window.text_input = @text_input
    end

    # Run this to keep the text boxes accurate
    def updateText
      $CURRENT_INPUT = self
      @text = @text_input.text
      @text_image = Gosu::Image.from_text(@text, @font_height)
      @text_image = Gosu::Image.from_text(@text, @font_height, :width => @text_image.width + @x_buffer * 2, :align => :center)
    end
  end
end
