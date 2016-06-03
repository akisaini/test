# ----------------------------------------------------- #
# FILE: logic.rb                                        #
# AUTH: Yazen Alzaghameem								#
# CONT:					                                #
# DATE: 25 May 2016                                     #
# INFO: Class that facilitates SET card matching        #
# ----------------------------------------------------- #

# Using ASCII tabs, set tab width to 2.  In Vim ":set tabstop=2"

# -- Imports -- #
require_relative './card.rb'

class Logic

	## Returns whether or not a selection is valid.
	# params
	# 	card1 - an object of class Card representing a SET card.
	# 	card2 - an object of class Card representing a SET card.
	# 	card3 - an object of class Card representing a SET card.
	# returns
	# 	TRUE iff three cards are a matching set,
	# 	FALSE otherwise.
	# requires
	# 	all parameter arrays are of length 4
	# 	all parameter arrays have elements with integer values in domain [1, 3]
	#
	def isValidSet(card1, card2, card3)
		# Using function in Card class to convert Card to Array of Int
		c1 = card1.to_a
		c2 = card2.to_a
		c3 = card3.to_a
		# A summation of individual features that is divisible by 3 is proper
    puts "Card 1: #{c1}"
    puts "Card 2: #{c2}"
    puts "Card 3: #{c3}"
		numbr = (c1[0] + c2[0] + c3[0]) % 3
    puts "Same number: #{numbr}"
		symbl = (c1[1] + c2[1] + c3[1]) % 3
    puts "Same symbol: #{symbl}"
		shade = (c1[2] + c2[2] + c3[2]) % 3
    puts "Same shade: #{shade}"
		color = (c1[3] + c2[3] + c3[3]) % 3
    puts "Same color: #{color}"
		numbr + symbl + shade + color == 0
	end

	## Searches for a single matching set within a table of Cards.
	# params
	# 	table - an array of class Card representing the face up cards
	# returns
	# 	TRUE iff a valid set exists within the array of cards, FALSE otherwise.
	# requires
	# 	- table must be an array of Card
	# 	- cards must not have any nil features
	# 
	def hasValidSet(table)
		# brute force search taking into account multiple equivalent tuples.
		len = table.length
		for i in 0..len-3 do
			card1 = table[i]
			for j in i+1..len-2
				card2 = table[j]
				for k in j+1..len-1
				card3 = table[k]
					if isValidSet(card1, card2, card3)
						return true
					end
				end
			end
		end
		false
	end

	## Searches for a single matching set within a table of Cards.
	# params
	# 	table - an array of class Card representing the face up cards
	# returns
	# 	array of matching indexes if matching set is found, empty arr otherwise.
	# requires
	# 	- table must be an array of Card
	# 	- cards must not have any nil features
	# 
	def findFirstSet(table)
		# brute force search taking into account multiple equivalent tuples.
		len = table.length
		for i in 0..len-3 do
			card1 = table[i]
			for j in i+1..len-2
				card2 = table[j]
				for k in j+1..len-1
					card3 = table[k]
					if isValidSet(card1, card2, card3)
						return [i, j, k]
					end
				end
			end
		end
		[]
	end

	## Searches for matching sets within a table of Cards.
	# params
	# 	table - an array of class Card representing the face up cards
	# returns
	# 	an array of an array of matching indexes
	# requires
	# 	- table must be an array of Card
	# 	- cards must not have any nil features
	# 
	def findSets(table)
		# brute force search taking into account multiple equivalent tuples.
		result = []
		len = table.length
		for i in 0..len-3 do
			card1 = table[i]
			for j in i+1..len-2
				card2 = table[j]
				for k in j+1..len-1
					card3 = table[k]
					if isValidSet(card1, card2, card3)
						result.push [i,j,k]
					end
				end
			end
		end
		result
	end

end
