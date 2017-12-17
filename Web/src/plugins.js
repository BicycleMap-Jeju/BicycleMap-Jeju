import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'
import VueMaterial from 'vue-material'
import VueGoogleMaps from 'vue-googlemaps'

Vue.use(VueRouter)

Vue.use(Vuex)

Vue.use(VueMaterial)

Vue.use(VueGoogleMaps, {
	load: {
		apiKey: process.env.GOOGLE_API_KEY,
		libraries: ['places'],
	},
})
