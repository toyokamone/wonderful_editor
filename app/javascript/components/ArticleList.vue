<template>
  <v-container class="py-8">
    <!-- データがある場合はカード一覧を表示 -->
    <template v-if="articles && articles.length > 0">
      <v-card
        v-for="article in articles"
        :key="article.id"
        class="mb-5 mx-auto"
        max-width="600"
      >
        <v-card-title>{{ article.title }}</v-card-title>
        <v-divider class="mx-4"></v-divider>
        <v-card-text>{{ article.body }}</v-card-text>
      </v-card>
    </template>

    <!-- データ取得中または0件の場合の表示 -->
    <template v-else>
      <v-alert type="info" class="mx-auto" max-width="600">
        記事データが見つかりません（または読み込み中）
      </v-alert>
    </template>
  </v-container>
</template>

<script>
import axios from "axios";

export default {
  name: "ArticleList",
  data() {
    return {
      articles: []
    };
  },
  mounted() {
    this.fetchArticles();
  },
  methods: {
    async fetchArticles() {
      try {
        const response = await axios.get("/api/v1/articles");
        // APIのレスポンス形式に合わせてデータをセット
        this.articles = response.data;
      } catch (error) {
        console.error("記事一覧の取得エラー:", error);
      }
    }
  }
};
</script>
