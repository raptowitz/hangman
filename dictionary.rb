# frozen_string_literal: true

# dictionary
module Dictionary
  def secret_word
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    @secret_word = words.sample.chomp.downcase
    # p @secret_word
  end
end
