<template>
  <div class="simple-map demo">
    <!-- Toolbar -->
    <md-toolbar>
      <md-button
          class="md-icon-button"
          @click="toggleSideNav"
      >
        <md-icon>menu</md-icon>
      </md-button>

      <h2 class="md-title" style="flex: 1;">Bicycle map</h2>

      <md-button
          class="md-icon-button"
          :disabled="!userPosition"
          @click="centerOnUser"
      >
        <md-icon>my_location</md-icon>
      </md-button>
    </md-toolbar>

    <!-- Map -->
    <googlemaps-map
        ref="map"
        class="map"
        :center.sync="center"
        :zoom.sync="zoom"
    >
      <!-- User Position -->
      <googlemaps-user-position
          @update:position="setUserPosition"/>

      <!-- Marker -->
      <googlemaps-marker
          title="Jeju"
          :position="{ lat: 33.492143, lng: 126.527635 }"/>

      <!--<googlemaps-marker-->
          <!--v-for="marker of markers"-->
          <!--:key="marker._id"-->
          <!--:label="{-->
      <!--color: marker === currentmarker ? 'white' : 'black',-->
      <!--fontFamily: 'Material Icons',-->
      <!--fontSize: '20px',-->
      <!--text: 'star_rate',-->
    <!--}"-->
          <!--:position="marker.position"-->
          <!--@click="selectMarker(marker._id)"-->
      <!--/>-->

    </googlemaps-map>


  </div>
</template>

<script>
    import {mapActions} from 'vuex'

    export default {
        data() {
            return {
                center: {
                    lat: 33.492143,
                    lng: 126.527635,
                },
                userPosition: null,
                zoom: 12,
            }
        },

        methods: {
            ...mapActions('layout', [
                'toggleSideNav',
            ]),

            centerOnUser() {
                if (this.userPosition) {
                    this.center = this.userPosition
                }
            },

            setUserPosition(position) {
                this.userPosition = position
            },
        },
    }
</script>

<style lang="stylus" scoped>
  .demo {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .map {
    flex: 100% 1 1;
  }
</style>

