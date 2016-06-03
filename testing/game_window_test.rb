# TODO: testing is a bit wonky when running the GameWindow during a test
# TODO: so far the tests complete successfully after closing the game window...
# TODO: we should also be able to create additional test files that don't use
# TODO: the game window and only use other classes/methods
require 'test/unit'
# using relative file path to avoid issues running test files from the /testing directory
require "#{File.expand_path("../../graphics_window.rb", __FILE__)}"

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    # Do nothing
  end

  def test_card
    card1 = Card.new(1,1,1,1)
    assert_equal(1, card1.number)
  end

  # test GameData constructor
  def test_game_data
    game_data = GameData.new
    assert_equal([], game_data.cards_on_table)
    assert_equal(false, game_data.is_player_two)
    assert_equal([], game_data.player_one_cards)
    assert_equal([], game_data.player_two_cards)
    assert_equal(0, game_data.player_one_score)
    assert_equal(0, game_data.player_two_score)
    assert_equal(0, game_data.start_time)
    assert_equal({}, game_data.stats_hash)
  end
end