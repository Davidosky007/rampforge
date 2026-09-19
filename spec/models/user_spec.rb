require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "requires an email" do
      user = build(:user, email: nil)

      expect(user).not_to be_valid
    end

    it "does not allow duplicate emails ignoring case" do
      create(:user, email: "david@example.com")

      duplicate = build(:user, email: "DAVID@example.com")

      expect(duplicate).not_to be_valid
    end

    it "rejects unsupported roles" do
      user = build(:user, role: "superhero")

      expect(user).not_to be_valid
    end
  end

  describe "public id" do
    it "assigns a public id on creation" do
      user = create(:user)

      expect(user.public_id).to be_present
    end
  end
end
