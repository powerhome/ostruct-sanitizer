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
end
