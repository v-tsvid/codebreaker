module Codebreaker
  class Game
    attr_accessor :secret_code, :guess, :guess_count, :max_guess_count, :score, :hint
    
    def initialize
      @max_guess_count = 10
    end

    # def attempt_count(count)
    #   begin
    #     raise "Please, put the integer" unless count.class == Fixnum
    #     if count > 0
    #       @max_guess_count = count
    #     else
    #       raise "Please, put the number greater than 0"
    #     end
    #   rescue Exception => e
    #     e.message
    #   end
    # end

    def start
      @hint = true
      @guess_count = 0
      @secret_code = ""
      puts "Put the number of attempts"
      # count = gets
      # attempt_count(count)
      @score = (@max_guess_count + 1) * 50 + 100
      4.times { |t| @secret_code += rand(1..6).to_s }
    end

    alias_method :play_again, :start

    def submit_guess(guess)
      @guess_count += 1
      @score -= 50
      @guess = guess.to_s
      ans = answer

      if ans == "++++"
        win
      elsif @guess_count >= @max_guess_count
        lose
      else
        ans
      end
    end

    def answer
      ans = ""

      @guess.each_char do |char|
        if @guess.index(char) == @secret_code.index(char)
          ans += "+"  
        elsif @secret_code.include? char
          ans += "-"
        end
      end
      return ans
    end

    def use_hint
      if hint
        @score -= 100
        a = @secret_code.split(//)
        r = rand(0..3)
        a.each_index do |i|
          a[i] = "*" unless i == r
        end
        h = ""
        a.each do |x|
          h += x
        end
        @hint = false
        h
      else
        puts "Hint already used"
      end
    end

    def win
      puts "CONGRATS! YOU WIN!"
      save_score
      play_again 
    end

    def lose
      puts "LOL, YOU LOSE!"
      play_again
    end

    def save_score
      puts "Your score is #{@score}"
      puts "Do you want to save it? Y/N"
      choice = gets
      if choice.capitalize == "Y"
        puts "Put your name"
        name = gets

      elsif choice.capitalize == "N"
      else
      end
          
    end
  end
end
