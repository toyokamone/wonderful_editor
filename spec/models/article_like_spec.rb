require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  describe "バリデーションのテスト" do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }

    context "同じユーザーが同じ記事に初めていいねする場合" do
      it "有効であること" do
        article_like = build(:article_like, user: user, article: article)
        expect(article_like).to be_valid
      end
    end

    context "同じユーザーが同じ記事に2回以上いいねする場合" do
      it "無効であること" do
        create(:article_like, user: user, article: article)
        duplicate_like = build(:article_like, user: user, article: article)
        expect(duplicate_like).to be_invalid
      end
    end
  end
end
