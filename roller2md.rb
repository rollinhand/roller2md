#!/usr/bin/env ruby
require 'mysql2'
require 'upmark'

class Roller2Md
  # instance variables
  # username        - MySQL username
  # password        - MySQL password
  # host            - MySQL host
  # database		- MySQL database
  # outputDirectory - directory to write Markdown files
  attr_writer :username, :password, :host, :database, :outputDirectory

  def initialize
    @host = 'localhost'
    @username = 'admin'
    @password = 'be2382be'
    @database = 'rollerdb'
    @outputDirectory = '.'
  end

  # Creates Jekyll compatible filename YEAR-MONTH-DAY-TITLE.md
  def createFilename(publishDate, anchor)
    filename = publishDate.strftime("%Y-%m-%d") + "-" + anchor + ".md"
  end
  
  # Write header for each post
  def writeFrontMatter(publishDate, title, category, creator, file) 
  	frontMatter = "---\n" \
  	"layout: post\n" \
  	"title: \"#{title}\"\n" \
  	"creator: #{creator}\n" \
  	"date: #{publishDate.strftime("%Y-%m-%d")}\n" \
  	"category: #{category}\n" \
  	"---\n"
  	file.puts frontMatter
  end
  
  # Write post to output file
  def writePost(anchor, summaryHtml, textHtml, file)
    begin
      print "Post '#{anchor}': "
      if ( !summaryHtml.nil? && !summaryHtml.empty?)
        file.puts Upmark.convert(summaryHtml)      
        file.puts "<!--more-->"
      end  
      file.puts Upmark.convert(textHtml)
      puts "done"
    rescue NoMethodError => e  
  	  puts "failed => #{e.message}"
  	  file.puts summaryHtml
  	  file.puts "<!--more-->"
  	  file.puts textHtml
  	rescue Upmark::ParseFailed => e
  	  puts "failed => #{e.message}"
  	  file.puts summaryHtml
  	  file.puts "<!--more-->"
  	  file.puts textHtml
  	end
  end
    
  def export
    begin
      connection = Mysql2::Client.new(:host => @host, :username => @username, :password => @password, :database => @database)
  	  
  	  results = connection.query("select id, name from weblogcategory")
      puts "Fetched #{results.count} results from 'weblogcategory'"
      
      @categories = Hash.new
      results.each do |row|
        @categories[ row["id"] ] = row["name"]
      end
  	  
  	  results = connection.query("select id, anchor, creator, title, summary, text, pubtime, categoryid from weblogentry where status = 'PUBLISHED' order by pubtime asc")
  	  puts "Fetched #{results.count} results from 'weblogentry'"
  	  
  	  results.each do |row|
  	    filename = createFilename(row["pubtime"], row["anchor"])
  	    category = @categories[ row["categoryid"] ]
  	    
  	    File.open("#{@outputDirectory}/#{filename}", "w") do |file|
  	    	writeFrontMatter row["pubtime"], row["title"], category, row["creator"], file
  	    	writePost row["anchor"], row["summary"], row["text"], file
  	    end
  	  end
    rescue Mysql2::Error => e
      puts e.errno
  	  puts e.error
    ensure
      connection.close if connection
    end
  end
end  
  
# main program
roller2md = Roller2Md.new
roller2md.outputDirectory="../rollinhand.github.io/_posts"
roller2md.export

