require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "バリデーションのテスト" do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }

    context "コメント本文がある場合" do
      it "有効であること" do
        comment = build(:comment, user: user, article: article)
        expect(comment).to be_valid
      end
    end

    context "コメント本文がない場合" do
      it "無効であること" do
        comment = build(:comment, body: nil, user: user, article: article)
        expect(comment).to be_invalid
      end
    end
  end
end
