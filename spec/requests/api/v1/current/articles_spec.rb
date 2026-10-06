require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let!(:old_article) { create(:article, :published, user: current_user, updated_at: 1.day.ago) }
    let!(:newest_article) { create(:article, :published, user: current_user) }

    before do
      create(:article, :draft, user: current_user)
      create(:article, :published)
    end

    it "自分が書いた公開記事の一覧のみを取得できる（更新順）" do
      subject
      res = JSON.parse(response.body)
      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(res.length).to eq(2)
        expect(res.map {|a| a["id"] }).to eq [newest_article.id, old_article.id]
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      end
    end
  end
end
