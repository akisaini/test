# ----------------------------------------------------- #
# FILE: logic_test.rb                                   #
# AUTH: Yazen Alzaghameem                               #
# DATE: 25 May 2016                                     #
# INFO: Test cases for logic.rb                         #
# ----------------------------------------------------- #

# Using ASCII tabs, set tab width to 2.  In Vim ":set tabstop=2"

# From card.rb
# intializer (number, symbol, shading, color)
# number: 1 = ONE, 2 = TWO, 3 = THREE
# symbol: 1 = DIAMOND, 2 = SQUIGGLE, 3 = OVAL
# shading: 1 = SOLID, 2 = STRIPED, 3 = OPEN
# color: 1 = RED, 2 = GREEN, 3 = PURPLE

# -- Imports -- #
require_relative '../logic'
require_relative '../card'

# -- Global -- #
$FAIL = "\x1b[31m"
$PASS = "\x1b[32m"
$CLEAR = "\x1b[0m"
$HEADER = "\x1b[35;40;4m"


## Prints test case results to console.
# params
# 	str = test case name
# 	exp = expected value
# 	act = actual value
#
def printR(str, exp, act)
	printf "\t#{(exp == act) ? $PASS : $FAIL}" + "%-50s" + $CLEAR + "%-40s" "Actual = (#{act})\n", str, "Expected = (#{exp})"
end

## Returns a new card, used for shorthand and implementation independence
#	params
#		number  = number of shapes on card
#		symbol  = type of symbol on card
#		shading = shading of shapes on card
#		color   = color of shapes on card
# returns
# 	reference to new object of class Card initialzed by passed arguments.
def c(number, symbol, shading, color)
		Card.new number, symbol, shading, color
end

## Returns a new logic obj, used for shorthand and implementation independence
#	params
#		none
# returns
# 	reference to new object of class Logic.
def l
		Logic.new
end

# -- isValidSet -- #	
# all same features 1 #
def test_iVS_1111x1111x1111
	card1, card2, card3 = c(1,1,1,1), c(1,1,1,1), c(1,1,1,1)
	exp = true
	act = l.isValidSet(card1, card2, card3)
	printR("1111x1111x1111", exp, act)
end

# all same features 2 #
def test_iVS_2222x2222x2222
	card1, card2, card3 = c(2,2,2,2), c(2,2,2,2), c(2,2,2,2)
	exp = true
	act = l.isValidSet(card1, card2, card3)
	printR("2222x2222x2222", exp, act)
end

# all same features 3 #
def test_iVS_3333x3333x3333
	card1, card2, card3 = c(3,3,3,3), c(3,3,3,3), c(3,3,3,3)
	exp = true
	act = l.isValidSet(card1, card2, card3)
	printR("3333x3333x3333", exp, act)
end

# all same features 4 #
def test_iVS_3223x3223x3223
	card1, card2, card3 = c(3,2,2,3), c(3,2,2,3), c(3,2,2,3)
	exp = true
	act = l.isValidSet(card1, card2, card3)
	printR("3223x3223x3223", exp, act)
end

# all different features #
def test_iVS_1111x2222x3333
	card1, card2, card3 = c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)
	exp = true
	act = l.isValidSet(card1, card2, card3)
	printR("1111x2222x3333", exp, act)
end

# all same features for number, symbol, shading, all different for color #
def test_iVS_1231x1232x1233
	card1, card2, card3 = c(1,2,3,1), c(1,2,3,2), c(1,2,3,3)
	exp = true
	act = l.isValidSet(card1, card2, card3)
	printR("1231x1232x1233", exp, act)
end


# all same but one #
def test_iVS_1111x1111x1112
	card1, card2, card3 = c(1,1,1,1), c(1,1,1,1), c(1,1,1,2)
	exp = false
	act = l.isValidSet(card1, card2, card3)
	printR("1111x1111x1112", exp, act)
end

# all same but two #
def test_iVS_1111x1112x1112
	card1, card2, card3 = c(1,1,1,1), c(1,1,1,2), c(1,1,1,2)
	exp = false
	act = l.isValidSet(card1, card2, card3)
	printR("1111x1112x1112", exp, act)
end

# all different but one #
def test_iVS_1111x2222x3332
	card1, card2, card3 = c(1,1,1,1), c(2,2,2,2), c(3,3,3,2)
	exp = false
	act = l.isValidSet(card1, card2, card3) 
	printR("1111x2222x3332", exp, act)
end

# -- findSets() -- #
# base, three cards, no sets
def test_fS_3_0
	cards = [c(1,1,1,1), c(2,2,2,2), c(1,3,3,3)]
	exp = []
	act = l.findSets(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (1,3,3,3)]", exp, act)
end

# base, three cards, 1 possible set
def test_fS_3_1
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = [[0, 1, 2]]
	act = l.findSets(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# four cards, 0 possible sets
def test_fS_4_0
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,2), c(1,2,3,4)]
	exp = []
	act = l.findSets(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,2), (1,2,3,4)]", exp, act)
end

# four cards, 1 possible set at beginning
def test_fS_4_1
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,3), c(1,2,3,3)]
	exp = [[0, 1, 2]]
	act = l.findSets(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,3), (1,2,3,3)]", exp, act)
end

# four cards, 1 possible set at end
def test_fS_4_2
	cards = [c(1,2,3,3), c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = [[1, 2, 3]]
	act = l.findSets(cards) 
	printR("[(1,2,3,3), (1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# four cards, 2 possible sets
def test_fS_4_3
	cards = [c(1,1,1,1), c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = [[0,2,3], [1,2,3]]
	act = l.findSets(cards) 
	printR("[(1,1,1,1), (1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# -- findFirstSet() -- #
# base, three cards, no sets
def test_fFS_3_0
	cards = [c(1,1,1,1), c(2,2,2,2), c(1,3,3,3)]
	exp = []
	act = l.findFirstSet(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (1,3,3,3)]", exp, act)
end

# base, three cards, 1 possible set
def test_fFS_3_1
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = [0, 1, 2]
	act = l.findFirstSet(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# four cards, 0 possible sets
def test_fFS_4_0
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,2), c(1,2,3,4)]
	exp = []
	act = l.findFirstSet(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,2), (1,2,3,4)]", exp, act)
end

# four cards, 1 possible set at beginning
def test_fFS_4_1
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,3), c(1,2,3,3)]
	exp = [0, 1, 2]
	act = l.findFirstSet(cards)  
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,3), (1,2,3,3)]", exp, act)
end

# four cards, 1 possible set at end
def test_fFS_4_2
	cards = [c(1,2,3,3), c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = [1, 2, 3]
	act = l.findFirstSet(cards)  
	printR("[(1,2,3,3), (1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# four cards, 2 possible sets
def test_fFS_4_3
	cards = [c(1,1,1,1), c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = [0,2,3]
	act = l.findFirstSet(cards) 
	printR("[(1,1,1,1), (1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# -- hasValidSet() -- #
# base, three cards, no sets
def test_hVS_3_0
	cards = [c(1,1,1,1), c(2,2,2,2), c(1,3,3,3)]
	exp = false
	act = l.hasValidSet(cards)
	printR("[(1,1,1,1), (2,2,2,2), (1,3,3,3)]", exp, act)
end

# base, three cards, 1 possible set
def test_hVS_3_1
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = true
	act = l.hasValidSet(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# four cards, 0 possible sets
def test_hVS_4_0
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,2), c(1,2,3,4)]
	exp = false
	act = l.hasValidSet(cards) 
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,2), (1,2,3,4)]", exp, act)
end

# four cards, 1 possible set at beginning
def test_hVS_4_1
	cards = [c(1,1,1,1), c(2,2,2,2), c(3,3,3,3), c(1,2,3,3)]
	exp = true
	act = l.hasValidSet(cards)  
	printR("[(1,1,1,1), (2,2,2,2), (3,3,3,3), (1,2,3,3)]", exp, act)
end

# four cards, 1 possible set at end
def test_hVS_4_2
	cards = [c(1,2,3,3), c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = true
	act = l.hasValidSet(cards) 
	printR("[(1,2,3,3), (1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# four cards, 2 possible sets
def test_hVS_4_3
	cards = [c(1,1,1,1), c(1,1,1,1), c(2,2,2,2), c(3,3,3,3)]
	exp = true
	act = l.hasValidSet(cards) 
	printR("[(1,1,1,1), (1,1,1,1), (2,2,2,2), (3,3,3,3)]", exp, act)
end

# -- Batch -- #
puts $HEADER + "isValidSet()" + $CLEAR
test_iVS_1111x1111x1111
test_iVS_2222x2222x2222
test_iVS_3333x3333x3333
test_iVS_3223x3223x3223
test_iVS_1111x2222x3333
test_iVS_1231x1232x1233
test_iVS_1111x1111x1112
test_iVS_1111x1112x1112
test_iVS_1111x2222x3332

puts $HEADER + "findSets()" + $CLEAR
test_fS_3_0
test_fS_3_1
test_fS_4_0
test_fS_4_1
test_fS_4_2
test_fS_4_3

puts $HEADER + "findFirstSet()" + $CLEAR
test_fFS_3_0
test_fFS_3_1
test_fFS_4_0
test_fFS_4_1
test_fFS_4_2
test_fFS_4_3

puts $HEADER + "hasValidSet()" + $CLEAR
test_hVS_3_0
test_hVS_3_1
test_hVS_4_0
test_hVS_4_1
test_hVS_4_2
test_hVS_4_3
