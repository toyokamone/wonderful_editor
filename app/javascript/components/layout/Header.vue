<template>
  <v-app-bar app color="#3085DE" dark>
    <v-toolbar-title @click="moveToHome" style="cursor: pointer;">
      WonderfulEditor
    </v-toolbar-title>

    <v-spacer></v-spacer>

    <!-- ログイン時 -->
    <template v-if="isLoggedIn">
      <v-btn text @click="moveToNewArticle">
        投稿する
      </v-btn>

      <!-- 右端の 3点リーダーメニュー -->
      <v-menu offset-y>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <span style="font-size: 22px; font-weight: bold;">⋮</span>
          </v-btn>
        </template>

        <v-list>
          <v-list-item @click="moveToMyPage">
            <v-list-item-title>マイページ</v-list-item-title>
          </v-list-item>
          <v-list-item @click="moveToDrafts">
            <v-list-item-title>下書き一覧</v-list-item-title>
          </v-list-item>
          <v-list-item @click="logout">
            <v-list-item-title>ログアウト</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </template>

    <!-- 未ログイン時 -->
    <template v-else>
      <v-btn text @click="moveToLogin">
        ログイン
      </v-btn>
      <v-btn text @click="moveToRegister">
        会員登録
      </v-btn>
    </template>
  </v-app-bar>
</template>

<script>
import axios from "axios";
import Router from "../../router/router";

const headers = {
  headers: {
    Authorization: "Bearer",
    "Access-Control-Allow-Origin": "*",
    "access-token": localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid")
  }
};

export default {
  data() {
    return {
      isLoggedIn: !!localStorage.getItem("access-token"),

      menus: [
        {
          title: "マイページ",
          click: () => {
            this.moveToMyPage();
          }
        },
        {
          title: "下書き一覧",
          click: () => {
            this.moveToDrafts();
          }
        },
        {
          title: "ログアウト",
          click: () => {
            this.logout();
          }
        }
      ]
    };
  },

    methods: {
    moveToHome() {
      if (this.$route.path !== "/") Router.push("/");
    },

    moveToNewArticle() {
      if (this.$route.path !== "/articles/new") Router.push("/articles/new");
    },

    moveToLogin() {
      if (this.$route.path !== "/login") Router.push("/login");
    },

    moveToRegister() {
      if (this.$route.path !== "/registration") Router.push("/registration");
    },

    async logout() {
      await axios
        .delete("/api/v1/auth/sign_out", headers)
        .then(_response => {
          this.refresh();
        })
        .catch(e => {
          alert(e.response.data.errors);
          this.refresh();
        });
    },

    refresh() {
      localStorage.clear();
      if (this.$route.path !== "/") {
        Router.push("/");
      }
      window.location.reload();
    },

    moveToMyPage() {
      if (this.$route.path !== "/mypage") Router.push("/mypage");
    },

    moveToDrafts() {
      if (this.$route.path !== "/articles/drafts") Router.push("/articles/drafts");
    }
  }
};
</script>

<style lang="scss" scoped>
.header-link {
  text-decoration: none;
}
.register {
  border: 2px solid #fff;
  border-radius: 5px;
  font-weight: bold;
}
.login {
  font-weight: bold;
}
</style>
