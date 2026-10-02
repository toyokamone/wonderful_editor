# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default(0), not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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

  describe "ステータスのテスト" do
    let(:user) { create(:user) }

    context "status が draft のとき" do
      let(:article) { build(:article, status: :draft, user: user) }

      it "下書き記事として保存できる" do
        expect(article.status).to eq "draft"
      end
    end

    context "status が published のとき" do
      let(:article) { build(:article, status: :published, user: user) }

      it "公開記事として保存できる" do
        expect(article.status).to eq "published"
      end
    end
  end
end
