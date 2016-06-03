# ----------------------------------------------------- #
# FILE: game_data.rb                                    #
# AUTH: Eric Lewantowicz                                #
# CONT: Andrew Lee                                      #
# DATE: 26 May 2016                                     #
# INFO: holds various gamestates/game related values    #
# ----------------------------------------------------- #

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
  attr_accessor :player_one_name
  attr_accessor :player_two_name
  attr_accessor :player_one_name_input
  attr_accessor :player_two_name_input
  attr_accessor :start_time
  attr_accessor :player_set_startTime
  attr_accessor :player_set_timer
  attr_accessor :stats_hash
  attr_accessor :db
  attr_accessor :set_time
  attr_accessor :window

  def initialize(window)
    @window = window
    @set_deck = Deck.new              # Deck array contains master deck of Card objects; 81 cards are added during object initialize
    set_deck.cards.shuffle!           # shuffle deck makes ready for dealing (standard array .shuffle! method)
    @cards_on_table = Array.new       # Card array contains cards dealt from set_deck and are currently in play on the table
    @player_one_cards = Array.new     # Card array of card sets collected by Player 1; moved from cards_on_table array when set of 3 found
    @player_two_cards = Array.new     # Card array of card sets collected by Player 2; moved from cards_on_table array when set of 3 found
    @player_one_score = 0
    @player_two_score = 0
    @start_time = 0                   # time game started (game timer calculated as Time.now - start_time)
    @set_time = 0                     # time last valid set found by player
    @player_set_startTime = 0         # Multiplayer functionality - time when player presses their "key"
    @player_set_timer = 0             # Multiplayer functionality - time player has to complete a set
    @stats_hash = Hash.new(0)         # TODO: statistics variables: track time of sets, # sets won...
    @db = init_db
    @player_one_name_input = Gosu::TextInput.new
    player_one_name_input.text = "Player 1"
    @player_two_name_input = Gosu::TextInput.new
    player_two_name_input.text = "Player 2"
  end

  # Use this instead of making a new GameData
  def clear!
    @set_deck = Deck.new
    set_deck.cards.shuffle!
    @cards_on_table = Array.new
    @player_one_cards = Array.new
    @player_two_cards = Array.new
    @player_one_score = 0
    @player_two_score = 0
    @start_time = 0
    @set_time = 0
    @player_set_startTime = 0
    @player_set_timer = 0
    @stats_hash = Hash.new(0)
  end

  # Not currently used
  def @player_one_name_input.filter(text_in)
    text_in.upcase.gsub(/[^A-Z0-9]/, '')
  end

  def player_one_name
    player_one_name_input.text
  end

  # Not currently used
  def @player_two_name_input.filter(text_in)
    text_in[0..9]
  end

  def player_two_name
    player_two_name_input.text
  end

  # Multiplayer startTime getter and setter
  def player_set_startTime; @player_set_startTime; end
  def player_set_startTime= (time) 
    @player_set_startTime = time
  end

  # Multiplayer timer getter and setter
  def player_set_timer; @player_set_timer; end
  def player_set_timer= (time) 
    @player_set_timer = time
  end

  # Run once to get the database squared away
  def init_db
    db_name = "#{ENV['HOME']}/.config/set_game/high_scores.db"
    Dir.mkdir("#{ENV['HOME']}/.config") unless File.exists?("#{ENV['HOME']}/.config")
    Dir.mkdir("#{ENV['HOME']}/.config/set_game") unless File.exists?("#{ENV['HOME']}/.config/set_game")
    if !File.exists?db_name
      db = SQLite3::Database.new db_name
      db.execute("CREATE TABLE scores(name, score)")
    else
      db = SQLite3::Database.new db_name
    end
    db
  end

  # Stores player 1's score, unless its 0
  def store_score
    if player_one_score != 0
      db.execute('INSERT INTO scores(name, score) VALUES(?, ?)', @player_one_name_input.text, @player_one_score)
    end
    # Stores player 2's score, unless its 0
    if player_two_score != 0
      db.execute('INSERT INTO scores(name, score) VALUES(?, ?)', @player_two_name_input.text, @player_two_score)
    end
  end

  # Returns the 10 best scores, in order
  def get_top_10
    output = []
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
      num_select += 1 if card.selected
    end
    num_select
  end
end
