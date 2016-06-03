# Created by: Eric Lewantowicz
# Modified by : Yazen, 
# Card attributes
# number: 1 = ONE, 2 = TWO, 3 = THREE
# symbol: 1 = DIAMOND, 2 = SQUIGGLE, 3 = OVAL
# shading: 1 = SOLID, 2 = STRIPED, 3 = OPEN
# color: 1 = RED, 2 = GREEN, 3 = PURPLE
# selected: false = card not selected by player; true = card has been selected by player as candidate for a set
class Card

  attr_accessor :number       # create setters and getters for class instance variables
  attr_accessor :symbol
  attr_accessor :shading
  attr_accessor :color
  attr_accessor :selected
  attr_accessor :hinted

  def initialize(number, symbol, shading, color)  # automatically initializes card attributes when Card object created
    @number = number
    @symbol = symbol
    @shading = shading
    @color = color
    @selected = false
    @hinted = false
  end

  # Card class method to add single card to the end of cards_on_table array (cards currently in play on the table)
  # updates: add one card to cards_on_table array
  def deal_card(cards_on_table)
    cards_on_table.push(self)                     # add dealt card to end of cards_on_table array
    self.print_card                               # print card attributes to console; can be removed as needed
  end

  # outputs card attributes to console
  def print_card
    # TODO: function currently commented out
    #print "number #{number}, symbol #{symbol}, shading #{shading}, color #{color}, selected #{selected}\n"
  end

  # Returns an array representation of Card.
  # params
  # 	none
  # returns
  # 	array[number, symbol, shading, color]
  # requires
  # 	none
  def to_a
    [number, symbol, shading, color]
  end

  ## Returns color settings of the card.
  # params
  #	none
  # returns
  # 	Gosu.Image.Color()
  # requires
  #	hinted is not nil
  #
  def mask
    (hinted) ? 0x80FF00FF : 0xFFFFFFFF
  end

end
