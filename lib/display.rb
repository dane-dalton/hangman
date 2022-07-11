module Display

  def welcome
    puts "Welcome to Hangman! Guess letters to figure out the computer's word.\n"
  end

  def board(correct, word, guesses)
    puts "You have #{correct} misses left...\n"
    word.each do |letter|
      print "#{letter} "
    end
    puts "\n\n"
    puts "Your current guesses are: "
    guesses.each do |guess|
      print "#{guess} "
    end
    puts "\n\n"
  end

  def make_guess
    invalid = true
    puts "Guess a letter: "
    while (invalid) do
      letter = gets.chomp.downcase
      if letter == /[a-z]/
        invalid = false
      else
        puts "Please input a single character."
      end
    end
    return letter
  end
end