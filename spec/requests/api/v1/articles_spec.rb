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

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "指定した記事の詳細が取得できる", :aggregate_failures do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res).to include("id" => article.id, "title" => article.title, "body" => article.body)
        expect(res["user"]["id"]).to eq(article.user.id)
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 10_000_000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params) }

    let(:current_user) { create(:user) }

    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
      # rubocop:enable RSpec/AnyInstance
    end

    context "適切なパラメータを送信したとき" do
      let(:params) { { article: attributes_for(:article) } }

      it "記事が作成できる", :aggregate_failures do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq(params[:article][:title])
        expect(res["body"]).to eq(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
