require 'rubygems'
require 'mechanize'
require 'debugger'


class AAInfo

  def initialize
    @searcher = ARGV[0].to_sym
    @lecture_time = ''
    @desk = ''
    @partner = ''
    @reviewers = []
    make_student_email_hash
    fetch_pairings
    parse_search_line
    display_results  
  end

  def fetch_pairings
    agent = Mechanize.new
    agent.get('https://github.com/login')
    form = agent.page.forms.first
    form.login = ARGV[1]
    form.password = ARGV[2]
    form.submit
    agent.page.link_with(:text => "appacademy").click
    agent.page.link_with(:text => "appacademy/meta").click

    @todays_pairings = agent.page.parser.css('code')[0].text.split('{')
  end




  def make_student_email_hash
    @student_email_hash = {}
    File.foreach('aaemails.csv') do |line|
      next if line[0..3] == 'Name'
      line_array = line.split(',')
      name = line_array[0].downcase.split
      formatted_name = name[0][0] + name[1]
      @student_email_hash[formatted_name.to_sym] = line_array[1]
    end
  end

  def find_searcher_line
    found_line = ''
    @todays_pairings.each do |line|
      if /:students=>\[.+, :#{@searcher}/ =~ line || /:students=>\[:#{@searcher}/ =~ line # looks for name in either position
        found_line = line
        break
      end
    end
    raise "student not found" if found_line == ''
    found_line
  end

  def parse_search_line
    line_to_parse = find_searcher_line.strip.split(' ')

    partner_find = line_to_parse[0..1].join.split('[')[1].delete(']').split(',')
    partner_find.each do |person|
      if person !="#{@searcher}"
        @partner = person.delete(':').to_sym
      end
    end

    @reviewers = line_to_parse[2..3].join.split('[')[1].delete(']').split(',')
    @reviewers.map! { |reviewer| reviewer.delete(':').to_sym }


    if line_to_parse[4].include?("early")
      @lecture_time = "early"
    else
      @lecture_time = 'late' 
    end

    
    line_to_parse[5].each_char do |char| 
      @desk << char if char.to_i > 0
    end
  end

  def get_email_addresses
    email_addresses = 'code-reviews@appacademy.io, ' + @student_email_hash[@partner]
    email_addresses += ", #{@student_email_hash[@reviewers[0]]}, #{@student_email_hash[@reviewers[1]]}"
  end

  def display_results
    puts "Hello #{@searcher}!"
    puts "Your partner is: #{@partner}"
    puts "Your desk number is: #{@desk}"
    puts "Your lecture time is: #{@lecture_time}"
    puts "Your reviewers are: #{@reviewers[0]} and #{@reviewers[1]}"
    puts "At 6PM, send your code to: #{get_email_addresses}"
  end

end


new_search = AAInfo.new


  #crawls github for latest pairing / reviewers / table # / early or late



  #sends email with this information when run



