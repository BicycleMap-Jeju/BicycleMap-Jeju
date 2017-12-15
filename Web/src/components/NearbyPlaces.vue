<template>
  <div class="nearby-places demo">
    <md-toolbar>
      <md-button
          class="md-icon-button"
          @click="toggleSideNav"
      >
        <md-icon>menu</md-icon>
      </md-button>

      <h2 class="md-title" style="flex: 1;">
        주변 장소들
        <img src="https://i.imgur.com/856DVp3.png">  무료
        <img src="https://i.imgur.com/DChDv4A.png">  유료
        <img src="https://i.imgur.com/AnvH3JY.png">  인증센터
      </h2>

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
          :zoom="12"
          @idle="onIdle"
      >
        <!-- User Position -->
        <googlemaps-user-position
            @update:position="setUserPosition"/>


        <googlemaps-marker
            v-for="m in freeMarkers"
            :position="{ lat: m.lat, lng: m.lng}"
            :icon="'https://i.imgur.com/856DVp3.png'"
            @click="showModal = true"
        />

        <googlemaps-marker
            v-for="m in paidMarkers"
            :position="{ lat: m.lat, lng: m.lng}"
            :icon="'https://i.imgur.com/DChDv4A.png'"
            @click="showModal = true"
        />

        <googlemaps-marker
            v-for="m in centerMarkers"
            :position="{ lat: m.lat, lng: m.lng}"
            :icon="'https://i.imgur.com/AnvH3JY.png'"
            @click="showModal = true"
        />
      </googlemaps-map>

      <!-- Places list -->
      <googlemaps-nearby-places
          class="results-pane"
          ref="results"
          :request="nearbyRequest"
          :filter="result => !result.types.includes('locality')"
      >
        <template scope="props">
          <md-list class="md-double-line">
            <md-subheader class="md-inset">Nearby places</md-subheader>

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
                <span>{{ result.name }}</span>
                <span>{{ result.vicinity }}</span>
              </div>
            </md-list-item>
          </md-list>

          <LoadingOverlay v-if="props.loading"/>
        </template>
      </googlemaps-nearby-places>
    </div>
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
        searchBounds: null,
        userPosition: null,
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
        ],
        paidMarkers: [
          {
            "name": "용두암하이킹",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 삼도2동 1115",
            "lat": 33.5156722,
            "lng": 126.5215176,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "2000원",
            "numberOfBicycle": 8,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-757-7777",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150901_253/1441035132808jmo8r_JPEG/12892839_0.jpg"
          },
          {
            "name": "수월봉전기자전거",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 한경면 고산리 3674-9",
            "lat": 33.2988265,
            "lng": 126.1680307,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "3000원",
            "numberOfBicycle": 19,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-7591-7388",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20170824_253/1503550440247hR96K_JPEG/q1ZyVQAiNbyuclp5vTHOaSdc.JPG.jpg"
          },
          {
            "name": "제주도자전거대여보물섬하이킹",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 용담2동 2706-1",
            "lat": 33.5059902,
            "lng": 126.5100313,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "2000원",
            "numberOfBicycle": 9,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-4582-8240",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20160406_77/14599239321764RvSj_PNG/176353566569296_0.png"
          },
          {
            "name": "타발로하이킹",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 이도2동 387-5",
            "lat": 33.4982629,
            "lng": 126.5387661,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "4000원",
            "numberOfBicycle": 18,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-7304-4996",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20151113_160/1447396794530zmVpG_JPEG/167154463577713_6.jpg"
          },
          {
            "name": "바이크트립",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 용담2동 1543-3",
            "lat": 33.5046308,
            "lng": 126.4987662,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "7000원",
            "numberOfBicycle": 11,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-744-5990",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20160112_45/1452555032442kWbsS_JPEG/176062486050878_0.jpeg"
          },
          {
            "name": "제주하이킹",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 용담3동 1029-3",
            "lat": 33.5168360,
            "lng": 126.5023520,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "3000원",
            "numberOfBicycle": 6,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-711-2200",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150831_286/1440994256762GxWxF_JPEG/126680414849369_0.jpg"
          },
          {
            "name": "우도하이킹레저",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 우도면 연평리 2395-3",
            "lat": 33.5092667,
            "lng": 126.9433500,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "3000원",
            "numberOfBicycle": 18,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-782-5931",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "자전거빌리지",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 일도2동 141",
            "lat": 33.5131885,
            "lng": 126.5421219,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "6000원",
            "numberOfBicycle": 10,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-3100-1414",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "제주자전거대여점",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 건입동 1043-2 1층",
            "lat": 33.5157137,
            "lng": 126.5368666,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "7000원",
            "numberOfBicycle": 14,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-4932-5949",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "환타지제주",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 서귀포시 색달동 2864-36",
            "lat": 33.2501938,
            "lng": 126.4128508,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 16,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-6693-7189",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150901_96/14410597489094uLMz_GIF/SUBMIT_1382491275326_33461072.gif"
          },
          {
            "name": "로얄쇼핑자전거대여소",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 연동",
            "lat": 33.4891944,
            "lng": 126.4909367,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "4000원",
            "numberOfBicycle": 11,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "아이러브바이크",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 삼도2동 14-4",
            "lat": 33.5158840,
            "lng": 126.5226770,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "6000원",
            "numberOfBicycle": 13,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-723-7775",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150901_217/1441041448164Db3Gm_JPEG/126662557272657_0.jpg"
          },
          {
            "name": "아트센터(한라도서관)자전거대여소",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 오라2동",
            "lat": 33.4756553,
            "lng": 126.5145154,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "6000원",
            "numberOfBicycle": 16,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "탐라도서관자전거대여소",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 노형동",
            "lat": 33.4778949,
            "lng": 126.4775358,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 12,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "(구)제주일보사자전거대여소",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 연동",
            "lat": 33.4908578,
            "lng": 126.4859025,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "4000원",
            "numberOfBicycle": 19,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "제이바이시클",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 용담1동 220-14 1층",
            "lat": 33.5092130,
            "lng": 126.5160238,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "6000원",
            "numberOfBicycle": 14,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-4626-5815",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20170110_198/1484035134609abIro_PNG/186055578533709_0.png"
          },
          {
            "name": "중문하이킹",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 서귀포시 색달동 2502-1",
            "lat": 33.2552878,
            "lng": 126.4146759,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "2000원",
            "numberOfBicycle": 7,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-739-3500",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "국기로(대림A)자전거대여소",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 연동",
            "lat": 33.4785140,
            "lng": 126.4906762,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "2000원",
            "numberOfBicycle": 7,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "설문대여성문화센터자전거대여소",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 연동",
            "lat": 33.4840719,
            "lng": 126.5000440,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "7000원",
            "numberOfBicycle": 10,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "성산라이딩",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 서귀포시 성산읍 성산리 230-4",
            "lat": 33.4646036,
            "lng": 126.9333719,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 6,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-5236-9000",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net//20170704_127/1499132933756dQ7T2_JPEG/%BC%BA%BB%EA_%B6%F3%C0%CC%B5%F9.jpg"
          },
          {
            "name": "푸른바이크쉐어링",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 삼도2동 967",
            "lat": 33.5123941,
            "lng": 126.5213416,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 17,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-721-0333",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "에코트립",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 삼도2동 1158-44",
            "lat": 33.5148228,
            "lng": 126.5178852,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 12,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "1800-5816",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "에코트립",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 서귀포시 강정동 2637-1",
            "lat": 33.2344160,
            "lng": 126.4882685,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "3000원",
            "numberOfBicycle": 7,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "070-7124-0938",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20170216_12/1487235233664IWKed_JPEG/186164547334306_0.jpeg"
          },
          {
            "name": "아일랜드하이킹",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 용담1동 308-4",
            "lat": 33.5108896,
            "lng": 126.5129566,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "7000원",
            "numberOfBicycle": 12,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-900-6111",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "헬로우제주 전동킥보드",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 서귀포시 안덕면 덕수리 2772-1",
            "lat": 33.2662181,
            "lng": 126.3006345,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "2000원",
            "numberOfBicycle": 8,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-7329-9069",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20170714_192/1499999670053GErkq_JPEG/186662547454458_0.jpeg"
          },
          {
            "name": "하우마을레저",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 우도면 연평리 2384-5",
            "lat": 33.5097363,
            "lng": 126.9434747,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "6000원",
            "numberOfBicycle": 9,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-783-0354",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "자전거빌리지",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 일도2동 141",
            "lat": 33.5131970,
            "lng": 126.5420954,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "7000원",
            "numberOfBicycle": 18,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "070-8790-7100",
            "manager": "",
            "thumbUrl": null
          },
          {
            "name": "제주라이더",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 일도1동 1100-10",
            "lat": 33.5127614,
            "lng": 126.5282562,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "6000원",
            "numberOfBicycle": 13,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-8459-2848",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150901_199/1441101112111mfcCh_JPEG/156265605969357_0.jpeg"
          },
          {
            "name": "우도팔경레져",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 우도면 연평리 1737-3",
            "lat": 33.4926222,
            "lng": 126.9519664,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "4000원",
            "numberOfBicycle": 15,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "010-2604-3096",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20160517_35/1463458899379uXdc2_JPEG/176457536265051_2.jpeg"
          },
          {
            "name": "한라싸이클",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 오라2동 3160",
            "lat": 33.4814673,
            "lng": 126.5012949,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "2000원",
            "numberOfBicycle": 19,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-749-8510",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150831_43/1441018036161M8WPf_JPEG/166579548678955_0.jpeg"
          },
          {
            "name": "바이크스토리",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 삼양2동 2129-7",
            "lat": 33.5213974,
            "lng": 126.5818624,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 20,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-723-7757",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20150901_15/1441060951460h0v20_JPEG/166656588345924_0.jpeg"
          },
          {
            "name": "그린스퀘어",
            "rentalType": "유료대여소",
            "address": "제주특별자치도 제주시 건입동 1451-5",
            "lat": 33.5275000,
            "lng": 126.5450000,
            "startTime": "9:00",
            "endTime": "18:00",
            "closedDays": "없음",
            "payType": "유료",
            "charge": "5000원",
            "numberOfBicycle": 15,
            "airInjection": false,
            "airInjectionType": "",
            "repairstand": false,
            "managerNumber": "064-757-5679",
            "manager": "",
            "thumbUrl": "http://ldb.phinf.naver.net/20170306_108/1488764451166dA2Ve_JPEG/186175584851040_0.jpeg"
          }
        ],
        centerMarkers: [
          {
            "name": "송악산인증센터",
            "tel": "",
            "address": "제주특별자치도 서귀포시 대정읍 상모리 157-2",
            "lng": 126.2895389,
            "lat": 33.2068775,
          },
          {
            "name": "용두암인증센터",
            "tel": "",
            "address": "제주특별자치도 제주시 용담2동",
            "lng": 126.5112267,
            "lat": 33.5150994,
          },
          {
            "name": "함덕해수욕장인증센터",
            "tel": "",
            "address": "제주특별자치도 제주시 조천읍 함덕리",
            "lng": 126.6723826,
            "lat": 33.5441846,
          },
          {
            "name": "성산일출봉인증센터",
            "tel": "",
            "address": "제주특별자치도 서귀포시 성산읍 오조리",
            "lng": 126.9242820,
            "lat": 33.4686629,
          },
          {
            "name": "쇠소깍인증센터",
            "tel": "",
            "address": "제주특별자치도 서귀포시 하효동",
            "lng": 126.6232339,
            "lat": 33.2523116,
          },
          {
            "name": "김녕해수욕장인증센터",
            "tel": "",
            "address": "제주특별자치도 제주시 구좌읍 김녕리",
            "lng": 126.7599194,
            "lat": 33.5568675,
          },
          {
            "name": "해거름마을공원인증센터",
            "tel": "",
            "address": "제주특별자치도 제주시 한경면 판포리",
            "lng": 126.2064745,
            "lat": 33.3699757,
          },
          {
            "name": "법환바당인증센터",
            "tel": "",
            "address": "제주특별자치도 서귀포시 법환동",
            "lng": 126.5150614,
            "lat": 33.2358681,
          },
          {
            "name": "표선해변인증센터",
            "tel": "",
            "address": "제주특별자치도 서귀포시 표선면 표선리",
            "lng": 126.8407390,
            "lat": 33.3255846,
          },
          {
            "name": "다락쉼터인증센터",
            "tel": "",
            "address": "제주특별자치도 제주시 애월읍 고내리",
            "lng": 126.3408170,
            "lat": 33.4701520,

          }
        ]
      }
    },

    computed: {
      nearbyRequest() {
        if (this.searchBounds) {
          return {
            bounds: this.searchBounds,
          }
        }
      },
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

      onIdle(map) {
        this.searchBounds = map.getBounds()
        this.$refs.results.$el.scrollTop = 0
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
    overflow-x: auto;
    overflow-y: auto;
    width: 400px;
    height: calc(100vh - 64px);
    position: relative;

    .photo {
      background: #eee;
    }
  }
</style>
