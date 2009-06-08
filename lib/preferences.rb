#
#  Preferences.rb
#  iRead
#
#  Created by Sergey Kuleshov on 6/8/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

require 'singleton'

class Preferences
	include Singleton
	
	class Book
		def initialize(hash)
			@hash = hash
		end
		
		def position
			@hash[:position] || "DefaultPosition"
		end
		
		def position=(new_position)
			@hash[:position] = new_position
		end
	end
	
	def initialize
		@defaults = NSUserDefaults.standardUserDefaults
	end
	
	def books
		@books ||= (@defaults.dictionaryForKey("Books") || {})
	end
	
	def find_book(id)
		bookSettings = books.fetch(id) {|k| books[k] = {}}
		Preferences::Book.new bookSettings
	end
	
	def save
		NSLog("Saving preferences")
		@defaults.setObject(@books, forKey:"Books")
		@defaults.synchronize
	end
end
