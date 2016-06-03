require 'sqlite3'

# master GameData class to store all data/states needed during game loop
# GameData object is created in GameWindow initialize block
class GameData

  attr_accessor :set_deck
  attr_accessor :cards_on_table
  attr_accessor :player_one_cards
  attr_accessor :player_two_cards
  attr_accessor :player_one_score
  attr_accessor :player_two_score
  attr_accessor :start_time
  attr_accessor :is_player_two
  attr_accessor :stats_hash
  attr_accessor :cards_selected
  attr_accessor :db

  def initialize
    # instance variables
    @set_deck = Deck.new              # Deck array contains master deck of Card objects; 81 cards are added during object initialize
    set_deck.cards.shuffle!           # shuffle deck so ready for dealing (standard array shuffle! method)
    @cards_on_table = Array.new       # Card array contains cards dealt from set_deck and are currently in play on the table
    @player_one_cards = Array.new     # Card array of card sets collected by Player 1; moved from cards_on_table array when set of 3 found
    @player_two_cards = Array.new     # Card array of card sets collected by Player 2; moved from cards_on_table array when set of 3 found
    @player_one_score = 0
    @player_two_score = 0
    @start_time = 0                   # time game started (game timer calculated as Time.now - start_time)
    @is_player_two = false            # true if second player/computer player; false if solo play
    @stats_hash = Hash.new(0)         # TODO: statistics variables: track time of sets, # sets won...
    @cards_selected = Array.new       # TODO: may not need this; indices of selected cards from cards_on_table to form a set
    @db = init_db
  end



  def init_db
    db_name = "./high_scores.db"
    if !File.exists?db_name
      db = SQLite3::Database.new db_name
      db.execute("CREATE TABLE scores(name, score)")
    else
      db = SQLite3::Database.new db_name
    end
    db
  end

  def store_score(name, score)
    db.execute('INSERT INTO scores(name, score) VALUES(?, ?)', name, score)
  end

  def get_top_10
    output = ["HIGH SCORES"]
    result = db.execute("SELECT * FROM scores ORDER BY score DESC LIMIT 10")
    for i in result
      output.push i[0] + ": %.2f" % i[1] #" + i[1].to_s
    end
    output
  end

  # Iterates through an array of Card objects to identify the number of cards that have been selected by the player
  # returns: number of cards currently selected by the player
  def num_cards_selected(cards_on_table)
    num_select = 0
    cards_on_table.each do |card|
      #puts card.to_s
      num_select += 1 if card.selected
      #cards_selected.push(cards_on_table[i]) if card.selected
    end
    num_select
  end
end
