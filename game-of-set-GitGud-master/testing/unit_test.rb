require 'test/unit'
#require "#{File.expand_path("../../graphics_window.rb", __FILE__)}"
require_relative '../logic'
require_relative '../card'
require_relative '../deck'
require_relative '../game_data'
require_relative '../graphics_window'
class MyTest < Test::Unit::TestCase

  def window
   GameWindow.new
  end

  def game_data
    GameData.new window
  end

  # test card constructor
  def test_card_constructor
    card1 = Card.new(1,1,1,1)
    assert_equal(1, card1.number)
    assert_equal(1, card1.symbol)
    assert_equal(1, card1.shading)
    assert_equal(1, card1.color)
    assert_equal(false, card1.selected)
    assert_equal(nil, card1.hinted)
  end

  # test deck constructor
  def test_deck_constructor
    deck1 = Deck.new
    assert_equal(81, deck1.cards.length)
  end

  # test deal_twelve
  def test_deal_twelve
    deck = Deck.new
    card_array = Array.new
    deck.deal_twelve(card_array)
    assert_equal(12, card_array.length)
  end

  # test remove_top_card
  def test_remove_top_card
    deck = Deck.new
    ccard = deck.cards[0]
    rcard = deck.remove_top_card
    assert_equal(ccard, rcard)
    assert_equal(80, deck.cards.length)
  end

  # test deal_three
  def test_deal_three
    deck = Deck.new
    card_array = Array.new
    deck.deal_three(card_array)
    assert_equal(3, card_array.length)
  end

  # test deal_card
  def test_deal_card
    deck = Deck.new
    card_array = Array.new
    deck.cards[0].deal_card(card_array)
    assert_equal(1, card_array.length)
  end

  # test GameData constructor
  def test_game_data
    assert_equal([], game_data.cards_on_table)
    assert_equal([], game_data.player_one_cards)
    assert_equal([], game_data.player_two_cards)
    assert_equal(0, game_data.player_one_score)
    assert_equal(0, game_data.player_two_score)
    assert_equal(0, game_data.start_time)
    assert_equal(0, game_data.set_time)
    assert_equal({}, game_data.stats_hash)
  end

end