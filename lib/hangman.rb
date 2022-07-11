class Game

  attr_accessor :word_bank

  def initialize()
    @word_bank = File.open('dictionary.txt').readlines.map { |line| line.chomp }
    self.word_bank = self.word_bank.select { |word| word.length >= 5 && word.length <= 12 }
  end

  
end

game = Game.new()
p game.word_bank