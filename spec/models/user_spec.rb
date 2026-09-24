require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    context "name, email, password が正しく入力されている場合" do
      it "有効であること" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "name が空の場合" do
      it "無効であること" do
        user = build(:user, name: nil)
        expect(user).to be_invalid
      end
    end
  end
end
