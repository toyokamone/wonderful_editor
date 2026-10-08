require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import Vue from 'vue'
import App from '../app.vue'
import router from '../router/router.js'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'

Vue.use(Vuetify)
const vuetify = new Vuetify()

document.addEventListener('turbolinks:load', () => {
  const el = document.getElementById('app')
  if (el) {
    new Vue({
      router,
      vuetify,
      render: h => h(App)
    }).$mount(el)
  }
})
