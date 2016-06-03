# ----------------------------------------------------- #
# FILE: deck.rb                                         #
# AUTH: Eric Lewantowicz                                #
# CONT: Yazen Alzaghameem, Andrew Lee                   #
# DATE: 26 May 2016                                     #
# INFO: deals with a deck of cards and its attributes   #
# ----------------------------------------------------- #

# Deck class contains a cards array of 81 Card object (81 array elements), each card with 5 attributes
class Deck

  attr_accessor :cards                    # creates setter and getter for cards array

  # cards have not been shuffled here; shuffle is called in GameData initialize block after Deck instantiation
  def initialize
    @cards = Array.new						        # create empty cards array
    (1..3).each do |number|               # assign 1-3 value for each card attribute
      (1..3).each do |symbol|
        (1..3).each do |shading|
          (1..3).each do |color|
            # instantiate Card object with 4 attributes; 81 cards in a full deck
            new_card = Card.new(number, symbol, shading, color)
            @cards << new_card					  # add card to end of @cards array
          end
        end
      end
    end
  end

  # Deck class method to remove and return first (top) card from deck
  # updates: cards array
  # returns: top card from deck
  def remove_top_card
    cards.shift;
  end

  # remove 12 cards from the deck and add to cards_on_table array
  # requires: minimum 12 cards in deck
  # cards_on_table: cards currently in play on the table
  # updates: cards_on_table array (cards in play on the table)
  # updates: (self) master deck of cards array
  def deal_twelve(cards_on_table)

    # throws runtime exception if not enough cards in deck
    raise 'Not enough cards in deck to deal 12' unless cards.length >= 12
    12.times do |i|
      print "card # #{i}: "                     # test print card to console; can be removed as needed
      removed_card = self.remove_top_card       # call Deck class method to remove first card from array
      removed_card.deal_card(cards_on_table)    # call Card class method to add removed card to cards_on_table array
    end
  end

  # remove 3 cards from the deck and add to cards_on_table array
  # requires: minimum 3 cards in deck; no action if less than 3 cards remaining in deck
  # cards_on_table: cards currently in play on the table
  # updates: cards_on_table array
  # updates: (self) master deck of cards array
  def deal_three(cards_on_table)

    # must be minimum 3 cards left in deck and maximum 18 cards on the table
    if cards.length >= 3 && cards_on_table.length <= 18
      3.times do |i|
       print "card # #{i}: "                     # TODO: test print card to console; can be removed as needed
        removed_card = self.remove_top_card       # call Deck class method to remove first card from array
        removed_card.deal_card(cards_on_table)    # call Card class method to add removed card to cards_on_table array
      end
    end
  end
end