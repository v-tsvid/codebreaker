require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    # describe "#attempt_count" do
    #   it "sets max_guess_count" do
    #     expect { game.attempt_count(5) }.to change { game.instance_variable_get(:@max_guess_count) }
    #   end

    #   context "raises exception when" do
    #     it "trying to set max_guess_count with no integer" do
    #       expect(game.attempt_count("str")).to eq "Please, put the integer"
    #     end

    #     it "trying to set max_guess_count with number 0 or less" do
    #       expect(game.attempt_count(0)).to eq "Please, put the number greater than 0"
    #     end
    #   end
    # end

    describe "#start" do
      before { game.start }
      it_behaves_like "new_game"
    end

    describe "#submit_guess" do
      before do
        game.start 
        game.submit_guess(1234) 
      end

      it "submits guess" do
        expect(game.instance_variable_get(:@guess)).not_to be_empty
      end

      it "submits 4 char guess" do
        expect(game.instance_variable_get(:@guess).size).to eq(4)
      end

      it "submits guess with number from 1 to 6" do
        expect(game.instance_variable_get(:@guess)).to match(/[1-6]+/)
      end

      it "increases guess count by 1" do
        expect { game.submit_guess(1235) }.to change { game.instance_variable_get(:@guess_count) }.by(1)
      end

      it "calls the answer giving method" do
        expect(game).to receive(:answer)
        game.submit_guess(1234)
      end

      it "wins if all numbers are guessed" do
        game.secret_code = "1234"
        expect(game).to receive(:win)
        game.submit_guess(1234)
      end

      it "loses if max guess count reached" do
        game.guess_count = 9
        expect(game).to receive(:lose)
        game.submit_guess(1235)
      end

      it "it decrements player's score by 50 points" do
        expect { game.submit_guess(1235) }.to change { game.instance_variable_get(:@score) }.by(-50)
      end
    end

    describe "#answer" do
      before do
        game.start
        game.secret_code = "1234"
      end

      it "contains + if number on its place" do
        game.guess = "4256"
        expect(game.answer).to include "+" 
      end

      it "contains - if number is not on its place" do
        game.guess = "4156"
        expect(game.answer).to include "-" 
      end

      it "gives the right answer according to last guess" do
        game.guess = "1325"
        expect(game.answer).to eq "+--"
      end
    end

    describe "#use_hint" do
      before do
        game.start
        game.secret_code = "1234"
      end

      it "reveals one of the numbers in the secret code" do
        expect(["1***", "*2**", "**3*", "***4"]).to include(game.use_hint)
      end

      it "possible to use hint one time per game only" do
        game.use_hint
        expect(["1***", "*2**", "**3*", "***4"]).not_to include(game.use_hint)
      end

      it "it decrements player's score by 100 points" do
        expect { game.use_hint }.to change { game.instance_variable_get(:@score) }.by(-100)
      end
    end

    describe "#win" do
      it "shows message say player wins" do
        #expect{ game.win }.to output("CONGRATS! YOU WIN!").to_stdout
      end

      it "proposes to save score" do
        expect(game).to receive(:save_score)
        game.win
      end

      it "proposes to play again" do
        expect(game).to receive(:play_again)
        game.win
      end
    end

    describe "#lose" do
      it "shows message say player loses" do
        # puts = double("puts")
        # expect(game).to receive(:puts).with("LOL, YOU LOSE!")
        # game.lose
      end

      it "proposes to play again" do
        expect(game).to receive(:play_again)
        game.lose
      end
    end

    describe "#save_score" do
      before { game.save_score }

      it "shows player's score" do
      end

      it "proposes to save player's score"
      it "gets player's name"
      it "loads saved records list"
      it "add player's score to list on due position"
      it "shows records list"
      it "saves new record list"

    end

    describe "#play_again" do
      before { game.play_again }
      it_behaves_like "new_game"
    end
  end
end
