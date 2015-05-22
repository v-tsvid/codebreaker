module Codebreaker
  class Game
    FILE = ''
    CODE_LENGTH = 4
    GUESS_SCORE_DECR = 50
    HINT_SCORE_DECR = 100
    NAME_MIN_LENGTH = 3
    NAME_MAX_LENGTH = 10

    attr_reader :name, :secret_code, :guess, :guess_count, :attempt_count, :score, :scores_hash, :hint, :wins

    def initialize
      @name = ""
      @secret_code = ""
      @guess = ""
      @attempt_count = 10
      @scores_hash = Hash.new
    end
    
    def new_game
      @secret_code = ""
      CODE_LENGTH.times { |t| @secret_code += rand(1..6).to_s }
      @guess_count = 0
      @score = (@attempt_count + 1) * GUESS_SCORE_DECR + HINT_SCORE_DECR
      @hint = true
      @wins = false
    end

    def start(name, count)
      begin
        raise "Count must be an integer" unless count.class == Fixnum
        raise "Count must be a number greater than 0" unless count > 0
        raise "Name must be a string" unless name.class == String
        unless name.size > NAME_MIN_LENGTH - 1 && name.size < NAME_MAX_LENGTH + 1
          raise "Name must contain #{NAME_MIN_LENGTH} to #{NAME_MAX_LENGTH} chars" 
        end
        @name = name
        @attempt_count = count
        new_game
      rescue Exception => e
        e.message
      end
    end

    def play_again
      @name == "" ? "Start new game first" : new_game
    end

    def submit_guess(guess)
      begin
        raise "Please, put string of numbers" unless guess.class == String
        raise "String must contain 4 numbers" unless guess.size == CODE_LENGTH
        raise "String must contain only numbers from 1 to 6" unless guess == guess.match(/[1-6]+/).to_s
        @guess_count += 1
        @score -= GUESS_SCORE_DECR
        @guess = guess
        ans = answer

        if ans == "++++"
          @wins = true
          "win"
        elsif @guess_count == @attempt_count
          "lose"
        else
          ans
        end
      rescue Exception => e
        e.message
      end
    end

    def use_hint
      if hint
        @score -= HINT_SCORE_DECR
        @hint = false
        r = rand(0..CODE_LENGTH-1)
        h = @secret_code.split(//).map.with_index { |x, i| i == r ? x : x = "*" }.join
      end
    end

   
    private 
    
      def answer
        ans = ""
        excl = ""
        @guess.each_char do |char|
          if !excl.include? char
            if @guess.index(char) == @secret_code.index(char) 
              ans += "+"  
              excl += char
            elsif @secret_code.include? char
              ans += "-"
              excl += char
            end
          end
        end

        if ans == ""
          ans = "####"
        else
          ans.chars.sort.join
        end
      end
  end
end
