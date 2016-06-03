# ----------------------------------------------------- #
# FILE: animator.rb                                     #
# AUTH: Yazen Alzaghameem                               #
# DATE: 25 May 2016                                     #
# INFO: Engine that manages the drawing of animation    #
# ----------------------------------------------------- #

# Using ASCII tabs, set tab width to 2.  In Vim ":set tabstop=2"

# -- Imports -- #
require 'gosu'

# Class that encapsulates sprite information.  Sprite index should never be modified!
class Sprite
	attr_reader   :images	# An array containing gosu images
	attr_accessor :index	# Index of the array that is currently drawn
	attr_accessor :speed	# How frequently image is updated
	attr_accessor :xscale	# X scale of the image
	attr_accessor :yscale	# Y scale of the image
	attr_accessor :alpha	# Transparency of the image
	attr_accessor :blend	# Blend parameters of the image (Hex format)
#TODO	attr_accessor :angle	# Rotation of the sprite
	
	def initialize(images)
		@images = images
		@index  = 0
		@speed  = 0
		@xscale = 1
		@yscale = 1
		@alpha  = 0
		@blend  = 0xFFFFFFFF
#TODO:		@angle  = 1
	end
end

# Class that controls the step and draw events of GameObjects.  
# Note #ofsteps/second = 60
class GameCanvas
	attr_accessor :enabled
	attr_reader :queue

	def initialize(window)
		@window = window
		@enabled = true
		@queue = {}
	end
	
	def add(name, object)
		@queue[name] = object
	end

	def remove(name)
		@queue.delete name	
	end

	def clear()
		@queue = {}
	end

	def step()
		@queue.each {|x,obj| puts obj; obj.step(@window)}
	end

	def draw()
		@queue.each {|x,obj| obj.draw()}
	end
end

class GameObject
	attr_reader :sprite
	attr_reader :x
	attr_reader :y
	attr_reader :depth
	
	def initialize(x, y, depth, sprite)
		@sprite = sprite
		@x = x
		@y = y
		@depth = depth
		@timer = 0
	end

	def draw()
		@sprite.images[@sprite.index].draw @x, @y, @depth, @sprite.xscale, @sprite.yscale, @sprite.blend        # default behavior is to draw the sprite with given image index using modifiers
	end

	def step(window)
		#TODO @timer = ?
		#TODO @sprite.index = @sprite.index + 1 % @sprite.images.length if counter == @sprite.speed             # default step behavior updates the image index (for animation)
	end

	def mouse_event?(mouse_x, mouse_y, code)
		code && mouse_x >= @x && mouse_x <= @sprite.images[@sprite.index].width &&
						mouse_y >= @y && mouse_y <= @sprite.images[@sprite.index].height
	end
end


# Draws a mouse cursor on the screen #
class GameCursorTest < GameObject
		def initialize(x, y, depth, sprite)
			super(x, y, depth, sprite)
		end
		
		def step(window)
			@x = window.mouse_x - 10
			@y = window.mouse_y - 10
			window.button_down?(Gosu::MsLeft) ? @sprite.index = 1 : @sprite.index = 0
		end
end

# Scrolling box test#
class ScrollingBoxTest < GameObject
	
	def initialize(x, y, depth, string)
			@x = x
			@y = 400
			@depth = depth
			@text = string
			@image = Gosu::Image.from_text(@text, 42)
			#@scroll = true #@image.height > 611 ? true : false
			@counter = 200
			@state = true
	end

	def step(window)
		@counter -= 1; return if @counter > 0
		(@y + @image.height < 0 ? @y = window.height : @y -= 2); return if @counter == 0
		@counter = 200 if @y == 400
	end

	def draw()
		@image.draw @x, @y, @depth+1, 1, 1, 0xFF_000000
		Gosu::draw_rect(456, 114, 906, 725, 0xF0_FBF5DD, @depth)
	end
end


