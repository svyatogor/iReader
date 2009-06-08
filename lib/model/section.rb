#
#  Section.rb
#  iRead
#
#  Created by Sergey Kuleshov on 6/4/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class Section
  attr_accessor :name
  attr_accessor :id
  attr_accessor :subsections      
  
	def initialize
		@subsections = []
	end
	
  def leaf
    subsections.length == 0
  end

  def length
    subsections.length
  end

  def editable
    false
  end

  def Section.create(node)
    section = Section.new
    section.id = node.attributeForName("id").stringValue
    section.name = (node.valueForXPath("./div[starts-with(@class, 'title')]") || "-").gsub(/<.*>/, '')
    section.subsections = Book.loadStructure node
		return section
  end
end
