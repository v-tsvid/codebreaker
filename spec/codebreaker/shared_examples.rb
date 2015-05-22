shared_examples_for "new_game" do
  it "sets 4 char secret code" do
    expect{ subject }.to change{ game.instance_variable_get(:@secret_code).size }.to 4
  end

  it "sets secret code with number from 1 to 6" do
    expect{ subject }.to change{ game.instance_variable_get(:@secret_code) }.to match(/[1-6]+/)
  end

  it "sets random secret codes each game" do
    allow(game).to receive(:rand).and_return(1)
    expect{ subject }.to change{ game.instance_variable_get(:@secret_code) }.to eq("1111")
  end
  
  it "sets guess count to 0" do
    expect{ subject }.to change{ game.instance_variable_get(:@guess_count) }.to 0
  end

  it "sets player's score at the start due to attempt_count" do
    game.instance_variable_set(:@attempt_count, 5)
    expect{ subject }.to change{ game.instance_variable_get(:@score) }.to((game.instance_variable_get(:@attempt_count) + 1) * 50 + 100)
  end
  
  it "sets hint availability flag to true" do
    expect{ subject }.to change{ game.instance_variable_get(:@hint) }.to true
  end

  it "sets win flag to false" do
    expect{ subject }.to change{ game.instance_variable_get(:@wins) }.to false
  end
end