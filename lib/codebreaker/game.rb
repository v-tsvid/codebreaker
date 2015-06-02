require 'yaml'

module Codebreaker
  CODE_LENGTH = 4
  ATTEMPT_COUNT_MAX = 12
  GUESS_SCORE_DECR = 50
  HINT_SCORE_DECR = 100
  NAME_MIN_LENGTH = 3
  NAME_MAX_LENGTH = 10
  CODE_FROM = 1
  CODE_TO = 6
  FILE_PATH = "../data/scores.txt"
  
  class Game
    
    attr_reader :name, :guess, :guess_count
    attr_reader :attempt_count, :score, :scores, :hint, :won, :lost

    def initialize
      @name = ""
      @secret_code = ""
      @guess = ""
      @attempt_count = 10
      @scores = Array.new
    end
    
    def start(name, count)
      begin
        raise "Count must be an integer" unless count.class == Fixnum
        raise "Count must be a number from 1 to 12" unless count > 0 && count < ATTEMPT_COUNT_MAX + 1 
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
        raise "Start new game first" unless @won == false && @lost == false
        raise "Please, put string of numbers" unless guess.class == String
        raise "String must contain 4 numbers" unless guess.size == CODE_LENGTH
        raise "String must contain only numbers from #{CODE_FROM} to #{CODE_TO}" unless 
          guess == guess.match(/[#{CODE_FROM}-#{CODE_TO}]{#{CODE_LENGTH}}/).to_s
        @guess_count += 1
        @score -= GUESS_SCORE_DECR
        @guess = guess
        ans = answer

        if ans == "++++"
          @won = true
          @score
        elsif @guess_count == @attempt_count
          @lost = true
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
        h = @secret_code.chars.map.with_index { |x, i| i == r ? x : x = "*" }.join
      end
    end

    # def save_score(path)
    #   begin
    #     raise "You can save your score only if you win" unless @won == true
    #     #return File.open(path)
    #     @scores = YAML.load(File.open("../data/scores.txt"))
    #     #@scores.push( { :name => @name, :score => @score } )
    #     File.open("../data/scores.txt", 'w') { |file| file.write(YAML.dump(@scores)) } 
    #     @scores
    #   rescue Exception => e
    #     e.message
    #   end
    # end

   
    private 

      def new_game
        @secret_code = ""
        CODE_LENGTH.times { |t| @secret_code += rand(CODE_FROM..CODE_TO).to_s }
        @guess_count = 0
        @score = (ATTEMPT_COUNT_MAX + 1) * GUESS_SCORE_DECR + HINT_SCORE_DECR
        @hint = true
        @won = false
        @lost = false
      end
    
      def answer
        ans = ""
        g = @guess.dup
        s = @secret_code.dup

        g.chars.each.with_index do |char, i|
          if char == s[i]
            ans += "+";  s[i] = '*';  g[i] = '*'
          end
        end

        g.chars.each.with_index do |char, i|
          if s.include?(char) && char != '*'
            ans += "-";  s[s.index(char)] = '*'
          end
        end

        ans == "" ? ans = "####" : ans
      end
  end
end
