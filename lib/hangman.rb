require 'yaml'
require_relative 'display.rb'

class Game
  include Display

  attr_accessor :secret_word, :incorrect_counter, :guess_bank, :current_word

  def initialize()
    @word_bank = File.open('dictionary.txt').readlines.map { |line| line.chomp }
    @modified_bank = @word_bank.select { |word| word.length >= 5 && word.length <= 12 }
    @secret_word = @modified_bank[rand(@modified_bank.length)].split('')
    @incorrect_counter = 6
    @guess_bank = []
    @current_word = @secret_word.dup.map { |letter| "_" }
  end

  def play
    welcome()
    load_game?()
    until (game_over?(self.incorrect_counter))
      board(self.incorrect_counter, self.current_word, self.guess_bank)
      save_game?()
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
    puts "Would you like to save your game? (y/n) "
    while invalid
      y_or_n = gets.chomp.downcase
      invalid = false if y_or_n.match(/^[yn]$/)
    end
    if y_or_n == "y"
      Game.to_yaml
      return true
    else
      return false
    end
  end

  def self.to_yaml
    save_file = "hangman_save/save_data"
    File.open(save_file, "w") do |file|
      file.puts YAML.dump(self)
    end
  end

  def self.from_yaml
    data = YAML.load File.read("hangman_save/save_data")
    self.new(data[:secret_word], data[:incorrect_counter], data[:guess_bank], data[:current_word])
  end
end

game = Game.new()
puts game.play
