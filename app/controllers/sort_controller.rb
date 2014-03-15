
class SortController < ApplicationController 
	class Post
		attr_accessor :title, :link, :comments, :page
	end

  def comments
  	# url = "http://www.news.ycombinator.com/"
  	# agent = Mechanize.new
  	# agent.get(url)
    # doc = agent.page.parser.css('td')[0]
    @array = Array.new
    @homepage = Nokogiri::HTML(open("https://news.ycombinator.com/rss"))
  	@individualLinksArray = @homepage.css('comments')
  	@individualLinksArray.each { |x|

  		@onePost = Post.new
  		@onePost.page = x
  		@individualPage = Nokogiri::HTML(open(x))

  		@numComments = @individualPage.css('tr')[3].css('tr')[1].css('a')[1]
  		if @numComments != nil
  			if @numComments.text == "discuss"
  				@numComments = 0
  			else
  				@onePost.comments = @numComments.text.gsub("comments","").gsub("comment","")
  				#need to convert the above string to integer that way I can sort by it below
  				puts @onePost.comments
  			end
  		else
  			@onePost.comments = 0
  		end

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

  		@postTitle = @individualPage.css('tr')[3].css('tr')[0].css('a[href]').text
  		@onePost.title = @postTitle

  		@array.push(@onePost)
  	}
  	puts @array.each{ |x| puts x.comments }
  	#@array.sort! { |x,y| Integer (x.comments) <=> Integer(y.comments) }
  end

  def domain
  end

  def headline_length
  end
end
