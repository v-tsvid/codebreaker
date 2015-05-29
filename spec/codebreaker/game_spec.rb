require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    it "stores empty secret code" do
      expect(game.instance_variable_get(:@secret_code)).to eq "" 
    end

    it "stores empty guess" do
      expect(game.instance_variable_get(:@guess)).to eq "" 
    end

    it "stores guess count" do
      expect(game).to respond_to(:guess_count)
    end

    it "stores default attempt count 10" do
      expect(game.instance_variable_get(:@attempt_count)).to eq 10 
    end

    it "stores player's score" do
      expect(game).to respond_to(:score)
    end

    it "stores scores array" do
      expect(game).to respond_to(:scores)
    end

    it "stores hint availability flag" do
      expect(game).to respond_to(:hint)
    end

    it "stores win flag" do
      expect(game).to respond_to(:won)
    end

    it "stores lose flag" do
      expect(game).to respond_to(:lost)
    end

    describe "#new_game" do
      subject { game.send(:new_game) }

      it_behaves_like "new_game"
    end

    describe "#start" do
      subject { game.start("name", 5) }

      it "sets player's name" do
        expect{ subject }.to change{ game.instance_variable_get(:@name) }.to "name"
      end

      it "sets attempt_count" do
        expect{ subject }.to change{ game.instance_variable_get(:@attempt_count) }.to 5
      end

      context "raises exception when" do
        it "trying to set player's name with no string" do
          expect(game.start(123, 5)).to eq "Name must be a string"
        end

        it "trying to set player's name with string less than 3 chars" do
          expect(game.start("na", 5)).to eq "Name must contain 3 to 10 chars"
        end

        it "trying to set player's name with string more than 10 chars" do
          expect(game.start("my famous name", 5)).to eq "Name must contain 3 to 10 chars"
        end

        it "trying to set attempt_count with no integer" do
          expect(game.start("name", "str")).to eq "Count must be an integer"
        end

        it "trying to set attempt_count with number 0 or less" do
          expect(game.start("name", 0)).to eq "Count must be a number greater than 0"
        end
      end

      it_behaves_like "new_game"
    end

    describe "#play_again" do
      subject { game.play_again }
      
      context "when game has already started" do
        before do 
          game.start("name", 5) 
          game.instance_variable_set(:@guess_count, 9)
          game.instance_variable_set(:@hint, false)
          game.instance_variable_set(:@won, true)
          game.instance_variable_set(:@secret_code, "")
          game.instance_variable_set(:@score, 100)
        end
        it_behaves_like "new_game"
      end

      context "when game has not been started yet" do
        it "returns message says start game first" do
          expect(subject).to eq "Start new game first"
        end
      end
    end

    describe "#submit_guess" do
      before do
        game.start("name", 5)
      end

      it "submits guess" do
        expect{ game.submit_guess("1234") }.to change{ game.instance_variable_get(:@guess) }.to("1234")
      end

      it "submits 4 char guess" do
        expect{ game.submit_guess("1234") }.to change{ game.instance_variable_get(:@guess).size }.to eq(4)
      end

      it "submits guess with number from 1 to 6" do
        expect{ game.submit_guess("1234") }.to change{ game.instance_variable_get(:@guess) }.to match(/[1-6]{4}/)
      end

      it "increases guess count by 1" do
        expect{ game.submit_guess("1235") }.to change{ game.instance_variable_get(:@guess_count) }.by(1)
      end

      it "calls the answer giving method" do
        expect(game).to receive(:answer)
        game.submit_guess("1234")
      end

      it "returns player's score if answer is \"++++\"" do
        allow(game).to receive(:answer).and_return("++++")
        expect(game.submit_guess("1234")).to eq game.instance_variable_get(:@score)
      end

      it "loses if max guess count reached" do
        game.instance_variable_set(:@guess_count, 4)
        expect(game.submit_guess("1234")).to eq "lose"
      end

      it "it decrements player's score by 50 points" do
        expect { game.submit_guess("1235") }.to change { game.instance_variable_get(:@score) }.by(-50)
      end

      context "raises exception when" do
        it "trying to submit guess when game is over (win)" do
          game.instance_variable_set(:@won, true)
          expect(game.submit_guess("1234")).to eq "Start new game first"
        end

        it "trying to submit guess when game is over (lose)" do
          game.instance_variable_set(:@lost, true)
          expect(game.submit_guess("1234")).to eq "Start new game first"
        end

        it "trying to put something not a string" do
          expect(game.submit_guess(1234)).to eq "Please, put string of numbers"
        end

        it "trying to put  string size not 4" do
          expect(game.submit_guess("12345")).to eq "String must contain 4 numbers"
        end

        it "trying to put string not match numbers from 1 to 6" do
          expect(game.submit_guess("1237")).to eq "String must contain only numbers from 1 to 6"
        end
      end
    end

    describe "#answer" do
      before do
        game.start("name", 5)
        game.instance_variable_set(:@secret_code, "1234")
      end

      it "adds + if number on its place" do
        game.instance_variable_set(:@guess, "4256")
        expect(game.send(:answer)).to include "+" 
      end

      it "adds - if number is not on its place" do
        game.instance_variable_set(:@guess, "4156")
        expect(game.send(:answer)).to include "-"  
      end
      
      it "takes each number one time only (when + first)" do
        game.instance_variable_set(:@guess, "1156")
        expect(game.send(:answer)).to eq "+"
      end

      it "takes each number one time only (when - first)" do
        game.instance_variable_set(:@guess, "2244")
        expect(game.send(:answer)).to eq "++"
      end

      it "returns right answer when secret_code has same numbers" do
        game.instance_variable_set(:@secret_code, "1214")
        game.instance_variable_set(:@guess, "1214")
        expect(game.send(:answer)).to eq "++++"
      end

      it "returns #### if no one number is guessed" do
        game.instance_variable_set(:@guess, "5656")
        expect(game.send(:answer)).to eq "####"
      end

      it "returns sorted answer with + are forwarding -" do
        game.instance_variable_set(:@guess, "3214")
        expect(game.send(:answer)).to eq "++--"
      end

      it "returns the right answer according to last guess" do
        game.instance_variable_set(:@guess, "1325")
        expect(game.send(:answer)).to eq "+--"
      end
    end

    describe "#use_hint" do
      before do
        game.start("name", 5)
        game.instance_variable_set(:@secret_code, "1234")
      end

      it "reveals one of the numbers in the secret code" do
        expect(["1***", "*2**", "**3*", "***4"]).to include(game.use_hint)
      end

      it "makes possible to use hint one time per game only" do
        game.use_hint
        expect(["1***", "*2**", "**3*", "***4"]).not_to include(game.use_hint)
      end

      it "it decrements player's score by 100 points" do
        expect { game.use_hint }.to change { game.instance_variable_get(:@score) }.by(-100)
      end
    end  

    describe "#save_score" do
      before do
        game.start("name", 5)
        game.instance_variable_set(:@won, true)
        game.instance_variable_set(:@score, 250)
        scores = [ { :name => "sharikov", :score => 400 }, { :name => "bormentahl", :score => 350 } ]
      end

      it "loads scores from file" do
        file = YAML.dump(:scores)
        allow(File).to receive(:open).and_return(file)
        expect(YAML).to receive(:load).and_return(file)
        game.save_score("file")
      end

      # it "adds current player's score to scores" do
      #   file = YAML.dump(:scores)
      #   scores = [ { :name => "sharikov", :score => 400 }, { :name => "bormentahl", :score => 350 }, { :name => game.instance_variable_get(:@name), :score => game.instance_variable_get(:@score) } ]
      #   allow(File).to receive(:open).and_return(file)
      #   expect { game.save_score("file") }.to change { game.instance_variable_get(:@scores) }.to eq :scores
      # end

      it "opens file" do
        expect(File).to receive(:open)
        game.save_score("file")
      end

      it "saves scores to file" do
        file = YAML.dump(:scores)
        allow(File).to receive(:open).and_return(file)
        #expect { game.save_score("file") }.to change { YAML.dump }.to eq :file
        expect(File).to receive(:open) { |file| file.write(YAML.dump(@scores)) }.and_return(file)
        game.save_score("file")
      end

      it "returns score" do
        file = YAML.dump(:scores)
        allow(File).to receive(:open).and_return(file)
        expect(game.save_score("file")).to eq game.instance_variable_get(:@score)
      end

      context "raises exception when" do
        it "trying to save score when no win" do
          game.instance_variable_set(:@won, false)
          expect(game.save_score("file")).to eq "You can save your score only if you win"
        end

        it "trying to load missing file" do
          game.instance_variable_set(:@won, true)
          expect(game.save_score("")).to match "No such file or directory"
        end
      end
    end
  end
end
