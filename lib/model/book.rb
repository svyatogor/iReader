#
#  Book.rb
#  iRead
#
#  Created by Sergey Kuleshov on 6/5/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

require "base64"
require "#{SOURCE_DIR}/model/section"

class Book
  attr_accessor :toc, :document, :html  
  
  def Book.cssUrl
    "file://#{NSBundle.mainBundle.pathForResource("fb2", ofType:"css")}"
  end
  
  def Book.xslUrl
    NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource("FB2_2_html", ofType:"xsl"))    
  end

  def Book.loadStructure(root)
    err = Pointer.new_with_type '@'
    root.nodesForXPath("./div[@class = 'section']", error:err).map { |node| Section.create node }
  end
  
	def Book.load(url)
	  book = Book.new
		err = Pointer.new_with_type '@'
		loadOptions = (NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA) 
		
		book.document = NSXMLDocument.alloc.initWithContentsOfURL url,
																													    options:loadOptions,
																													    error:err
																												
		raise err[0].localizedDescription if err[0]

		book.html = book.document.objectByApplyingXSLTAtURL	xslUrl, 
																												arguments:{"cssfile" => "'#{Book.cssUrl}'"}, 
																												error:err
		raise err[0].localizedDescription if err[0]

		bodyNodes = book.html.rootElement.nodesForXPath("//div[@class = 'chapter']", error:err)
		raise "Cannot load TOC (#{err[0].localizedDescription})" if err[0]
		book.toc = bodyNodes.map {|node| Section.create(node)}
    return book
	end
	
	def id
		@id ||= document.rootElement.valueForXPath "/FictionBook/description/document-info/id"
	end
	
	def cover_image
	  raise "Not implmented"
    # coverImageHref = @document.rootElement.valueForXPath "/FictionBook/description/title-info/coverpage/image[0][@xlink:href]"
    # puts "C = #{coverImageHref}"
    # raise "No cover images found" if coverImages.length == 0
    # imageHref = coverImages[0].attributeForName("xlink:href").stringValue
    # raise "Invalid cover image" unless imageHref[0] == '#'
    # imageXPath = "//binary[@id = '#{imageHref.sub(/#/, '')}']"
    # potentialImages = @document.rootElement.nodesForXPath(imageXPath, error:nil)
    # raise "Invalid cover image" if potentialImages.length  == 0
    # 
    # imageData = Base64.decode64 potentialImages[0].stringValue
    # imageRep = NSBitmapImageRep.imageRepWithData imageData
  end
end
