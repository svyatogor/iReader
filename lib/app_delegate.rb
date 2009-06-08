#
#  AppDelegate.rb
#  iRead
#
#  Created by Sergey Kuleshov on 6/4/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

framework 'cocoa'
require "#{SOURCE_DIR}/preferences"

class AppDelegate
	attr_reader :defaults

  def initialize
    
  end

	def applicationDidFinishLaunching(notification)
		NSLog "iReader started"
		Preferences.instance
	end
	
	def applicationWillTerminate(notification)
		Preferences.instance.save
	end
end
