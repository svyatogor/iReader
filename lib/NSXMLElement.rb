#
#  NSXMLElement.rb
#  iRead
#
#  Created by Sergey Kuleshov on 6/8/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class NSXMLElement
	def valueForXPath(xpath)
		err = Pointer.new_with_type '@'
		a = self.nodesForXPath xpath, error:err
		a.length > 0 ? a[0].stringValue : nil
	end
end
