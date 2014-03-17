
class SortController < ApplicationController 
	class Post
		attr_accessor :title, :link, :comments, :page
	end

  # method to pull and parse from news.ycombinator.com/rss because
  # news.ycombinator.com/ cannot be scrapped
  def scrape
    @array = Array.new
    @homepage = Nokogiri::HTML(open("https://news.ycombinator.com/rss"))
  	@individualLinksArray = @homepage.css('comments')
  	@individualLinksArray.each { |x|

  		# create new post object to store the data necessary
  		@onePost = Post.new
  		@onePost.page = x
  		@individualPage = Nokogiri::HTML(open(x))

  		# parse out the number of comments for each page
  		@numComments = @individualPage.css('tr')[3].css('tr')[1].css('a')[1]
  		if @numComments != nil
  			if @numComments.text == "discuss"
  				@numComments = Integer(0)
  			else
  				@hold = @numComments.text
  				if @hold != nil
  					@onePost.comments = Integer(@hold.gsub("comments","").gsub("comment",""))
  				else 
  					@onePost.comments = Integer(0)
  				end
  			end
  		else
  			@onePost.comments = Integer(0)
  		end

  		# parse out the link domain
  		@postLink = @individualPage.css('tr')[3].css('tr').css('td')[1].css('span').text
  		if @postLink != nil
  			@postLink.gsub!("(","")
  			if @postLink != nil 
  				@postLink.gsub!(")","")
  				@onePost.link = @postLink
  			else
  			end
  		else
  		end

  		# parse out the post headline
  		@postTitle = @individualPage.css('tr')[3].css('tr')[0].css('a[href]').text
  		@onePost.title = @postTitle

  		@array.push(@onePost)
  	}
  	return @array
  end

  def comments
  	@arr = scrape
  	# logging:
  	# @arr.each {|x| 
  	# 	if x.comments == nil 
  	# 		puts "found nil comments"
  	# 		x.comments = Integer(0)
  	# 	else 
  	# 		puts x.comments
  	# 	end}
  	# puts "------------"
  	@arr.sort!{|x,y| y.comments <=> x.comments}
  	# logging: @arr.each {|x| puts x.comments}
  end

  def domain
  	@arr = scrape
  	# logging: @arr.each {|x| puts x.link}
  	# puts "------------"
  	@arr.sort! {|x,y| x.link <=> y.link }
  	# loggging: @arr.each {|x| puts x.link}
  end

  def headline_length
  	@arr = scrape
  	# loggging: @arr.each {|x| puts x.title}
  	# puts "------------"
  	@arr.sort! {|x,y| x.title.length <=> y.title.length }
  	# logging: @arr.each {|x| puts x.title}
  end
end
