require 'yaml'
require_relative 'display.rb'

class Game
  include Display

  attr_accessor :secret_word, :incorrect_counter, :guess_bank, :current_word

  def initialize(
    secret_word = MODIFIED_BANK[rand(MODIFIED_BANK.length)]. split(''),
    incorrect_counter = 6,
    guess_bank = [],
    current_word = secret_word.dup.map { |letter| "_" }
  )
    @secret_word = secret_word
    @incorrect_counter = incorrect_counter
    @guess_bank = guess_bank
    @current_word = current_word
  end

  def play
    welcome()
    load_game?()
    until (game_over?(self.incorrect_counter))
      board(self.incorrect_counter, self.current_word, self.guess_bank)
      # save_display() if save_game?()
      self.guess_bank.push(make_guess())
      self.current_word, self.incorrect_counter = calc_guess(self.guess_bank[-1], self.current_word, self.secret_word, self.incorrect_counter)
      if winner?(self.current_word, self.secret_word)
        winner_display(self.secret_word.join(''))
        break
      end
    end
    unless winner?(self.current_word, self.secret_word)
      loser_display(self.secret_word.join(''))
    end
  end

  def winner?(current, correct)
    current == correct
  end
  
  def game_over?(counter)
    if counter <= 0
      true
    else
      false
    end
  end

  def save_game?
    invalid = true
    puts "Would you like to save your game? (y/n)"
    while invalid
      y_or_n = gets.chomp.downcase
      invalid = false if y_or_n.match(/^[yn]$/)
    end
    if y_or_n == "y"
      to_yaml()
      return true
    else
      return false
    end
  end

  def load_game?
    invalid = true
    puts "Would you like to load your last saved game? (y/n)"
    while invalid
      y_or_n = gets.chomp.downcase
      invalid = false if y_or_n.match(/^[yn]$/)
    end
    if y_or_n == "y"
      Game.from_yaml()
      return true
    else
      return false
    end
  end

  def to_yaml
    save_file = "hangman_save/save_data"
    File.open(save_file, "w") do |file|
      file.puts YAML.dump({
        secret_word: self.secret_word,
        incorrect_counter: self.incorrect_counter,
        guess_bank: self.guess_bank,
        current_word: self.current_word
      })
    end
  end

  def self.from_yaml
    data = YAML.load(File.read("hangman_save/save_data"))
    p data
    self.new(data[:secret_word], data[:incorrect_counter], data[:guess_bank], data[:current_word])
  end
end

game = Game.new()
puts game.play
