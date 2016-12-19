require "spec_helper"

describe OStruct::Sanitizer do
  it "has a version number" do
    expect(OStruct::Sanitizer::VERSION).not_to be nil
  end

  describe "invalid usage" do
    it "fails including OStruct::Sanitizer within a non OpenStruct class" do
      define_invalid_usage = -> {
        class InvalidUsage
          include OStruct::Sanitizer
        end
      }

      expect(define_invalid_usage).to raise_error
    end
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

  describe "#strip" do
    let(:user) do
      User.new(
        email: "  drborges.cic@gmail.com   ",
        phone: "  (55) 51 00000000    ",
      )
    end

    it "strips out leading and trailing spaces from user's email" do
      expect(user.email).to eq "drborges.cic@gmail.com"
    end

    it "strips out leading and trailing spaces from user's phone number" do
      expect(user.phone).to eq "(55) 51 00000000"
    end
  end
end
