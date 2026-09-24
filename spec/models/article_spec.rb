require "rails_helper"

RSpec.describe Article, type: :model do
  describe "バリデーションのテスト" do
    let(:user) { create(:user) }

    context "タイトルと本文がある場合" do
      it "有効であること" do
        article = build(:article, user: user)
        expect(article).to be_valid
      end
    end

    context "タイトルがない場合" do
      it "無効であること" do
        article = build(:article, title: nil, user: user)
        expect(article).to be_invalid
      end
    end

    context "本文がない場合" do
      it "無効であること" do
        article = build(:article, body: nil, user: user)
        expect(article).to be_invalid
      end
    end
  end
end
