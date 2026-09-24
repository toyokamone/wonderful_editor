require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    let!(:article_yesterday) { create(:article, updated_at: 1.day.ago) }
    let!(:article_two_days_ago) { create(:article, updated_at: 2.days.ago) }
    let!(:article_now) { create(:article, updated_at: Time.current) }

    it "記事の一覧が取得できる", :aggregate_failures do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq(3)
      expect(res.map {|d| d["id"] }).to eq([article_now.id, article_yesterday.id, article_two_days_ago.id])
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end
