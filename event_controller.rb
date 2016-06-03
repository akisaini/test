# yazen:  event handling. #
# Events are caused by actions within the game.  Events alter the game state and game data.
# TODO documentation, test case file
require_relative 'logic'

class Event
	
	#TODO documentation
	def plays_exist?(game_data)
		game_data.set_deck.cards.length != 0 || Logic.new.hasValidSet(game_data.cards_on_table)
	end

	#TODO documentation
	def action_selected_three(game_controller, game_data)
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
			# TODO:  Case where game mode 2 player.
			game_data.player_one_score += 1
		end
		# end game if no remaining moves
		game_controller.game_state = 2 unless plays_exist? game_data
	end

	#TODO:  Actual implementation, this is just a placeholder
	def action_hint(game_controller, game_data)
		game_data.cards_on_table.each {|c| c.hinted = false}
		x = Logic.new.findFirstSet(game_data.cards_on_table)
		x.each {|i| game_data.cards_on_table[i].hinted = true}
	end
	
	#TODO:  Actual implementation, this is just a placeholder
	def action_hint_old(game_controller, game_data)
		x = Logic.new.findFirstSet(game_data.cards_on_table)
		x.each {|i| game_data.cards_on_table[i] = nil}
		game_data.cards_on_table.delete(nil)

		# end game if no remaining moves
		game_controller.game_state = 2 unless plays_exist? game_data
	end

end
