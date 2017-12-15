import '../dist/topseo.css'
import 'vue-material/dist/vue-material.css'

import './plugins'
import Vue from 'vue'
import router from './router'
import store from './store'
import App from './components/App.vue'
import LoadingOverlay from './components/LoadingOverlay.vue'
import VModal from 'vue-js-modal'

Vue.component('LoadingOverlay', LoadingOverlay)
Vue.component('modal', {
  template: '#modal-template'
})
Vue.use(VModal, { componentName: "foo-modal" })


new Vue({
	el: '#app',
	router,
	store,
	...App,
})
