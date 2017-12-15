<template>

  <div class="locationGeocoder demo">
    <md-toolbar>
      <md-button
          class="md-icon-button"
          @click="toggleSideNav"
      >
        <md-icon>menu</md-icon>
      </md-button>

      <h2 class="md-title" style="flex: 1;">Geocoder</h2>

      <md-button
          class="md-icon-button"
          :disabled="!userPosition"
          @click="centerOnUser"
      >
        <md-icon>my_location</md-icon>
      </md-button>
    </md-toolbar>

    <div class="panes">
      <!-- Map -->
      <googlemaps-map
          class="map"
          :center.sync="center"
          :options="mapOptions"
          :zoom="12"
          @click="onClick"
      >
        <!-- User Position -->
        <googlemaps-user-position
            @update:position="setUserPosition"/>

        <googlemaps-marker
            v-if="searchLocation"
            title="Searched location"
            :position="searchLocation"/>

        <googlemaps-marker
            v-for="m in freeMarkers"
            :position="{ lat: m.lat, lng: m.lng}"
            :icon="'https://i.imgur.com/856DVp3.png'"
            @click="showModal = true"
        />

        <foo-modal
            v-if="showModal"
            @close="showModal = false"
            name="dialog"
            height="auto"
            :classes="['v--modal', 'vue-dialog', this.params.class]"
            :width="width"
            :pivot-y="0.3"
            :adaptive="true"
            :clickToClose="clickToClose"
            :transition="transition"
            @before-open="beforeOpened"
            @before-close="beforeClosed"
            @opened="$emit('opened', $event)"
            @closed="$emit('closed', $event)">
          <div class="dialog-content">
            <div
                class="dialog-c-title"
                v-if="params.title"
                v-html="params.title || ''"></div>
            <div
                class="dialog-c-text"
                v-html="params.text || ''"></div>
          </div>
          <div
              class="vue-dialog-buttons"
              v-if="buttons">
            <button
                v-for="(button, i) in buttons"
                :class="button.class || 'vue-dialog-button'"
                :style="buttonStyle"
                :key="i"
                v-html="button.title"
                @click.stop="click(i, $event)">
              {{button.title}}
            </button>
          </div>
          <div v-else class="vue-dialog-buttons-none"></div>
        </foo-modal>



      </googlemaps-map>

      <!-- Places list -->
      <googlemaps-geocoder
          class="results-pane"
          ref="results"
          :request="geocoderRequest"
      >
        <template scope="props">
          <div v-if="!searchLocation" class="tip overlay">
            <md-icon class="md-size-2x">assistant</md-icon>
            <div>Click on the map</div>
          </div>

          <md-list v-else class="md-double-line">
            <md-subheader class="md-inset">Geocoder</md-subheader>

            <md-list-item
                v-for="result of props.results"
                :key="result.id"
            >
              <!-- Photo -->
              <md-avatar class="photo">
                <img
                    v-if="result.photos"
                    :src="result.photos[0].getUrl({ maxWidth: 80, maxHeight: 80 })"
                />
                <md-icon v-else class="md-primary">place</md-icon>
              </md-avatar>

              <!-- Infos -->
              <div class="md-list-text-container">
                <template v-if="result.placeDetails">
                  <span>{{ result.placeDetails.name }}</span>
                  <span>{{ result.placeDetails.vicinity }}</span>
                </template>
                <span v-else>{{ result.formatted_address }}</span>
              </div>
            </md-list-item>
          </md-list>

          <LoadingOverlay v-if="props.loading"/>
        </template>
      </googlemaps-geocoder>
    </div>
  </div>
</template>

<script>
  import {mapActions} from 'vuex'
  import VModal from 'vue-js-modal'

  export default {
    name: 'Dialog',
    props: {
      width: {
        type: [Number, String],
        default: 400
      },
      clickToClose: {
        type: Boolean,
        default: true
      },
      transition: {
        type: String,
        default: 'fade'
      }
    },
    data() {
      return {
        center: {
          lat: 33.492143,
          lng: 126.527635,
        },
        showModal: false,
        searchLocation: null,
        userPosition: null,
        params: {},
        defaultButtons: [{ title: 'CLOSE' }],
        freeMarkers: [
          {
            "name": "서귀포시청2청사 앞",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 서귀포시 신중로 55",
            "lat": 33.2556297,
            "lng": 126.5084008,
            "startTime": "6:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 10,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-760-3093",
            "manager": "서귀포시청"
          },
          {
            "name": "월드컵경기장 광장",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 서귀포시 월드컵로 33",
            "lat": 33.2461897,
            "lng": 126.5071304,
            "startTime": "6:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 20,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-760-3626",
            "manager": "서귀포시청"
          },
          {
            "name": "성산읍 한도교",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 서귀포시 성산읍 오조리 2-3",
            "lat": 33.4690137,
            "lng": 126.9234661,
            "startTime": "6:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 5,
            "airInjection": true,
            "airInjectionType": "태양광식",
            "repairstand": false,
            "managerNumber": "064-760-3093",
            "manager": "서귀포시청"
          },
          {
            "name": "쇠소깍",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 서귀포시 쇠소깍로 128",
            "lat": 33.2522101,
            "lng": 126.6209248,
            "startTime": "6:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 5,
            "airInjection": true,
            "airInjectionType": "태양광식",
            "repairstand": false,
            "managerNumber": "064-760-3093",
            "manager": "서귀포시청"
          },
          {
            "name": "법환포구",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 서귀포시 막숙포로 61",
            "lat": 33.2357794,
            "lng": 126.5129644,
            "startTime": "6:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 5,
            "airInjection": true,
            "airInjectionType": "태양광식",
            "repairstand": false,
            "managerNumber": "064-760-3093",
            "manager": "서귀포시청"
          },
          {
            "name": "송악산",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 서귀포시 대정읍 상모리 157-2",
            "lat": 33.2067231,
            "lng": 126.2874012,
            "startTime": "6:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 5,
            "airInjection": true,
            "airInjectionType": "태양광식",
            "repairstand": false,
            "managerNumber": "064-760-3093",
            "manager": "서귀포시청"
          },
          {
            "name": "삼도1동 오라지구대 뒤",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 삼도1동 560-2",
            "lat": 33.499845,
            "lng": 126.516376,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": false,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "노형동 탐라도서관 주차장 내",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 노형동 3812-2",
            "lat": 33.477823,
            "lng": 126.477638,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "연동 대림아파트 동측 주차장내",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 연동 1499",
            "lat": 33.478731,
            "lng": 126.490505,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "오라2동 제주아트센터 주차장 내",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 오라2동 898-8",
            "lat": 33.475501,
            "lng": 126.514446,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "연동 설문대여성문화센터 주차장내",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 연동 324-10",
            "lat": 33.484193,
            "lng": 126.500447,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "연동 로얄쇼핑센터 앞 주차장내",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 연동 272-56",
            "lat": 33.489191,
            "lng": 126.490911,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "연동 롯데시티호텔 뒤 주차장내",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 연동 2322-7",
            "lat": 33.490923,
            "lng": 126.486967,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": true,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "이도2동 벤처마루 앞",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 이도2동 1176-126",
            "lat": 33.500109,
            "lng": 126.529585,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": false,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          },
          {
            "name": "일도2동 영락교회 앞",
            "rentalType": "무인대여소",
            "address": "제주특별자치도 제주시 일도2동 488-9",
            "lat": 33.510488,
            "lng": 126.543503,
            "startTime": "06:00",
            "endTime": "21:00",
            "closedDays": "없음",
            "payType": "무료",
            "charge": "",
            "numberOfBicycle": 90,
            "airInjection": false,
            "airInjectionType": "수동식",
            "repairstand": false,
            "managerNumber": "064-728-3553",
            "manager": "제주특별자치도 제주시청"
          }
        ]
      }
    },

    computed: {
      geocoderRequest() {
        if (this.searchLocation) {
          return {
            location: this.searchLocation,
          }
        }
      },

      mapOptions() {
        return {
          clickableIcons: false,
        }
      },

      buttons () {
        return this.params.buttons || this.defaultButtons
      },
      /**
       * Returns FLEX style with correct width for arbitrary number of
       * buttons.
       */
      buttonStyle () {
        return {
          flex: `1 1 ${100 / this.buttons.length}%`
        }
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

      onClick({latLng}) {
        this.searchLocation = latLng
        this.$refs.results.$el.scrollTop = 0
      },

      setUserPosition(position) {
        this.userPosition = position
      },

      beforeOpened (event) {
        window.addEventListener('keyup', this.onKeyUp)
        this.params = event.params || {}
        this.$emit('before-opened', event)
      },
      beforeClosed (event) {
        window.removeEventListener('keyup', this.onKeyUp)
        this.params = {}
        this.$emit('before-closed', event)
      },
      click (i, event, source = 'click') {
        const button = this.buttons[i]
        if (button && typeof button.handler === 'function') {
          button.handler(i, event, { source })
        } else {
          this.$modal.hide('dialog')
        }
      },
      onKeyUp (event) {
        if (event.which === 13 && this.buttons.length > 0) {
          const buttonIndex = this.buttons.length === 1
            ? 0
            : this.buttons.findIndex(button => button.default)
          if (buttonIndex !== -1) {
            this.click(buttonIndex, event, 'keypress')
          }
        }
      }
    },
  }
</script>

<style lang="stylus" scoped>
  .demo {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .panes {
    flex: 1;
    display: flex;
    flex-direction: row;
    align-items: stretch;
  }

  .map {
    flex: 1;
  }

  .results-pane {
    overflow: auto;
    width: 400px;
    position: relative;

    .photo {
      background: #eee;
    }
  }

  .vue-dialog div {
    box-sizing: border-box;
  }
  .vue-dialog .dialog-flex {
    width: 100%;
    height: 100%;
  }
  .vue-dialog .dialog-content {
    flex: 1 0 auto;
    width: 100%;
    padding: 15px;
    font-size: 14px;
  }
  .vue-dialog .dialog-c-title {
    font-weight: 600;
    padding-bottom: 15px;
  }
  .vue-dialog .dialog-c-text {
  }
  .vue-dialog .vue-dialog-buttons {
    display: flex;
    flex: 0 1 auto;
    width: 100%;
    border-top: 1px solid #eee;
  }
  .vue-dialog .vue-dialog-buttons-none {
    width: 100%;
    padding-bottom: 15px;
  }
  .vue-dialog-button {
    font-size: 12px !important;
    background: transparent;
    padding: 0;
    margin: 0;
    border: 0;
    cursor: pointer;
    box-sizing: border-box;
    line-height: 40px;
    height: 40px;
    color: inherit;
    font: inherit;
    outline: none;
  }
  .vue-dialog-button:hover {
    background: rgba(0, 0, 0, 0.01);
  }
  .vue-dialog-button:active {
    background: rgba(0, 0, 0, 0.025);
  }
  .vue-dialog-button:not(:first-of-type) {
    border-left: 1px solid #eee;
  }
</style>
