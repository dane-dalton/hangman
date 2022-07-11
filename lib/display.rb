module Display

  def welcome
    puts "Welcome to Hangman! Guess letters to figure out the computer's word.\n"
  end

  def board(correct, word, guesses)
    puts "\nYou have #{correct} misses left...\n"
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

  def winner_display(word)
    puts "\nCongrats! You've correctly guessed the computer's word, '#{word}'!"
  end

  def loser_display(word)
    puts "\nSorry, but you were not able to figure out the word '#{word}'."
  end

  def make_guess
    invalid = true
    puts "Guess a letter: "
    while (invalid) do
      letter = gets.chomp.downcase
      if letter.match(/[a-z]/)
        invalid = false
      else
        puts "Please input a single character."
      end
    end
    return letter
  end

  def calc_guess(guess, current_word, correct_word, counter)
    keep_counter = false
    current_word = current_word.each_with_index.map do |letter, i|
      if letter == "_"
        if guess == correct_word[i]
          keep_counter = true
          letter = guess
        else
          letter = "_"
        end
      else
        letter = letter
      end
    end
    unless keep_counter
      counter -= 1
    end
    return [current_word, counter]
  end
end