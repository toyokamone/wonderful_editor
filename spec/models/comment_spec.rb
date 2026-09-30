# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
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
