shared_examples_for "new_game" do

  it "stores guess count" do
    expect(game).to respond_to(:guess_count)
  end

  it "stores max guess count" do
    expect(game).to respond_to(:guess_count)
  end

  it "stores max guess count greater than 0" do
    expect(game.instance_variable_get(:@max_guess_count)).to be > 0
  end

  it "stores default max guess count 10" do
    expect(game.instance_variable_get(:@max_guess_count)).to eq 10 
  end

  it "stores secret code" do
    expect(game).to respond_to(:secret_code)
  end

  it "stores 4 char secret code" do
    expect(game.instance_variable_get(:@secret_code).size).to eq(4)
  end

  it "stores secret code with number from 1 to 6" do
    expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
  end

  it "stores different codes each game" do
    expect { game.start }.to change { game.instance_variable_get(:@secret_code) }
  end

  it "stores player's score" do
    expect(game).to respond_to(:score)
  end

  it "stores player's score at the start due to max_guess_count" do
    expect(game.instance_variable_get(:@score)).to eq((game.instance_variable_get(:@max_guess_count) + 1) * 50 + 100)
  end
end 