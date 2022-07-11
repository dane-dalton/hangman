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
    until (game_over?(self.incorrect_counter))
      board(self.incorrect_counter, self.current_word, self.guess_bank)
      self.guess_bank.push(make_guess())
      self.current_word, self.incorrect_counter = calc_guess(self.guess_bank[-1], self.current_word, self.secret_word, self.incorrect_counter)
      if winner?(self.current_word, self.secret_word)
        winner_display(self.secret_word)
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

end

game = Game.new()
puts game.play
