#
#  Book.rb
#  iRead
#
#  Created by Sergey Kuleshov on 6/4/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

framework 'cocoa'
require 'base64'
require "#{SOURCE_DIR}/model/book"
require "#{SOURCE_DIR}/preferences"

class BookDocument < NSDocument
  attr_accessor :parent
  attr_accessor :webView
  attr_accessor :tocView
  attr_accessor :tocController
	attr_accessor :book
  
  def readFromURL(url, ofType:type, error:outError)
		@book = Book.load url
  end
  
  def zoomIn(sender)
    webView.makeTextLarger(self)
  end
  
  def zoomOut(sender)
    webView.makeTextSmaller(self)
  end

  def canZoomIn(sender)
    false
  end

  def outlineViewSelectionDidChange(nofitication)
    section = @tocController.selectedObjects[0]
    dom = webView.mainFrame.DOMDocument
    el = dom.getElementById(section.id)
    el.scrollIntoView(true) if el
  end

  def windowNibName
    "Book"
  end

  def windowControllerDidLoadNib(controller)
    super(controller)
    webView.mainFrame.loadData(@book.html.XMLData, MIMEType:"text/html", textEncodingName:"utf-8", baseURL:nil)
		tocView.reloadData
		
		@bookDefaults = Preferences.instance.find_book book.id
  end

  def webView(sender, didFinishLoadForFrame:frame)
		webView.mainFrame.DOMDocument.body.scrollTop = @bookDefaults.position.to_i		
  end
	
	def windowWillClose(notification)
		position = webView.mainFrame.DOMDocument.body.scrollTop
		@bookDefaults.position = position
		Preferences.instance.save
	end
	
end
