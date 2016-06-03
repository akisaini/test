# ----------------------------------------------------- #
# FILE: event_controller.rb                             #
# AUTH: Yazen Alzaghameem																#
# CONT: Eric Lewantowicz, Andrew Lee, Aki saini         #
# DATE: 26 May 2016                                     #
# INFO: controller class that handles Events            #
# ----------------------------------------------------- #

# Events are caused by actions within the game.  Events alter the game state and game data.
# TODO documentation, test case file
require_relative 'logic'

MAX_SET_SCORE = 10

class Event
	
	#TODO documentation
	def plays_exist?(game_data)
		game_data.set_deck.cards.length != 0 || Logic.new.hasValidSet(game_data.cards_on_table)
	end

	#TODO documentation
	def action_selected_three(game_controller, game_data, game_canvas)
		# parse data #
		r, x = Array.new, Array.new
		game_data.cards_on_table.each_with_index do |c, i| 
			r.push c if c.selected
			x.push i if c.selected
			c.selected = false
		end
		# handle valid set #
		if Logic.new.isValidSet(r[0], r[1], r[2])
			x.each {|i| game_data.cards_on_table[i] = nil}
			game_data.cards_on_table.delete(nil)
			game_data.player_set_timer = 0
			time = Time.now.to_i - game_data.set_time			  # time taken to find set
      penalty = time / 5
			set_score = MAX_SET_SCORE - penalty					    # weighted score with time penalty
			set_score = (set_score < 1)? 1 : set_score
      puts "set score: #{set_score}"
			if game_controller.player == 1
				game_data.player_one_score += set_score
        setSong = Gosu::Sample.new('set.wav')
        setSong.play(1, 1, true)
			elsif game_controller.player == 2
				game_data.player_two_score += set_score
			end
		end
		# end game if no remaining moves, add scrolling highscore to screen TODO refactor
		game_controller.game_state = 2 unless plays_exist? game_data
	end

	#TODO:  Actual implementation, this is just a placeholder
	def action_hint(game_controller, game_data)
		game_data.cards_on_table.each {|c| c.hinted = false}
		x = Logic.new.findFirstSet(game_data.cards_on_table)
		x.each {|i| game_data.cards_on_table[i].hinted = true}
	end
	
	#TODO:  Actual implementation, this is just a placeholder
	def action_hint_old(game_controller, game_data, game_canvas)
		x = Logic.new.findFirstSet(game_data.cards_on_table)
		x.each {|i| game_data.cards_on_table[i] = nil}
		game_data.cards_on_table.delete(nil)

		# end game if no remaining moves TODO refactor code
		game_controller.game_state = 2 unless plays_exist? game_data
	end

	# clear all select states in cards in play
	# game_data: contains cards_on_table array of cards in play
	# updates: game_data.cards_on_table
	def action_clear_selected(game_data)
		game_data.cards_on_table.each do |c|            # reset all cards on table to non-selected
			c.selected = false
		end
	end

	# set three cards to selected state
	# game_data: contains cards_on_table array of cards in play
	# set: array of three cards to select
	# updates: game_data.cards_on_table
	def action_set_three_selected(game_data, set)
		(0..2).each do |i|
      ind = set[i]
			game_data.cards_on_table[ind].selected = true
		end
  end

  # subtract penalty points from player game score
  # game_data: contains scores
  # game_controller: contains player state
  # penalty: number of points to subtract from player score
  # updates: game_data.player_one_score or player_two_score
  def action_score_penalty(game_data, game_controller, penalty)
    game_data.player_one_score -= penalty if game_controller.player == 1
    game_data.player_two_score -= penalty if game_controller.player == 2
    puts "player #{game_controller.player}: #{penalty} point penalty"
  end

	def action_load_highscore(game_canvas, game_data)
		str = game_data.get_top_10.reduce {|str1, str2| str1 = str1 + "\n" + str2}
		game_canvas.add("highscore", ScrollingBoxTest.new(456,114,-5, str)) unless game_canvas.queue.key? "highscore"
	end

  # Prompts player timer for multiplayer games
  # game_controller: contains player state (current player)
  # updates: game_data
  def action_player_timer(game_data, time)
    game_data.player_set_startTime = time + 5
    game_data.player_set_timer = 5
  end

end
