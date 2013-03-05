module ApplicationHelper
	#returns full title if needed
	def full_title(page_title)
		base_title = "Smells Like Fail"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
