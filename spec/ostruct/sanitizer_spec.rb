require "spec_helper"

describe OStruct::Sanitizer do
  it "has a version number" do
    expect(OStruct::Sanitizer::VERSION).not_to be nil
  end

  describe "#truncate" do
    let(:user) do
      User.new(
        first_name: "first name longer than 10 characters",
        last_name: "last name longer than 10 characters",
      )
    end

    it "truncates user's first name to 10 characters" do
      expect(user.first_name.length).to be 10
      expect(user.first_name).to eq "first name"
    end

    it "truncates user's last name to 10 characters" do
      expect(user.last_name.length).to be 10
      expect(user.last_name).to eq "last name "
    end
  end

  describe "#drop_punctuation" do
    let(:user) do
      User.new(
        city: "Porto, Alegre!",
        country: "B.r!a,z#i%l^",
      )
    end

    it "drops punctuation from user's city name" do
      expect(user.city).to eq "Porto Alegre"
    end

    it "drops punctuation from user's country name" do
      expect(user.country).to eq "Brazil"
    end
  end
end
