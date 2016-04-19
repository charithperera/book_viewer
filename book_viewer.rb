require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "sinatra/reloader" if development?

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  chapter = params[:number].to_i
  @title = "Chapter #{chapter} : #{@contents[chapter - 1]}"
  @chapter = File.read("data/chp#{chapter}.txt")

  erb :chapter
end

get"/show/:name" do
  params[:name]
end

get "/search" do
  @results = []
  if params[:query]    
    @contents.each_with_index do |title, ch_index|
      chapter = File.read("data/chp#{ch_index + 1}.txt")
      paragraphs = chapter.split("\n\n")
      paragraphs.each_with_index do |text, p_index |
        if text.downcase.include?(params[:query].downcase)
          found = {}
          found[:title] = title
          found[:ch_index] = ch_index
          found[:text] = text
          found[:p_index] = p_index
          @results << found
        end         
      end
    end
  end
  # binding.pry
  erb :search
end

helpers do
  def in_paragraphs(text)
    split = text.split("\n\n")
    split.each_with_index do |line, index|
      line.prepend("<p id=paragraph#{index}>")
      line << "</p>"
    end
    split.join
  end  

  def boldify(query, para)
    # binding.pry
    para.gsub!(query, "<strong>#{query}</strong>")
  end
end


not_found do
  redirect "/"
end

  