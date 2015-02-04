class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Constructor
  def initialize(new_word)
    @word = new_word
    @guesses = ""
    @wrong_guesses = ""
  end

  # Change Correct guess list
  def guess(letter)
    raise ArgumentError, 'input nil' if letter == nil
    raise ArgumentError, 'empty input' unless letter.empty? == false
    raise ArgumentError, 'input not a letter' unless /[[:alpha:]]/ =~ letter
    letter.downcase!
    if @guesses.include? letter or @wrong_guesses.include? letter
      return false
    elsif @word.include? letter
      @guesses += letter
    else
      @wrong_guesses += letter
    end
  end

  # Display word with guesses
  def word_with_guesses
    @word.chars.map{|x| (guesses.include? x) ? x:"-"}.join
  end

  # Return game status
  def check_win_or_lose
    if word_with_guesses.eql? @word
      :win
    elsif @wrong_guesses.length == 7
      :lose
    else
      :play
    end
  end

  # Get a word from remote "random word" service
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
