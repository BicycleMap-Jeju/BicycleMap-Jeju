import VueRouter from 'vue-router'
import store from './store'

import SimpleMap from './components/SimpleMap.vue'
import NearbyPlaces from './components/NearbyPlaces.vue'
import LocationGeocoder from './components/LocationGeocoder.vue'
import PlaceDetails from './components/PlaceDetails.vue'

const router = new VueRouter({
	mode: 'hash',
	routes: [
		// { path: '/', name: 'simple', component: SimpleMap },
    { path: '/', name: '자전거 대여소', component: LocationGeocoder },
    { path: '/nearby', name: '주변 장소들', component: NearbyPlaces },
	],
})

router.afterEach(() => {
	store.dispatch('layout/setSideNavOpen', false)
})

export default router
