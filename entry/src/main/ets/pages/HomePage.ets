import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { SiteService } from '../services/SiteService';
import { LocationService } from '../services/LocationService';
import type { Place } from '../common/types';
import {
  ArcButton,
  ArcButtonOptions,
  ArcButtonPosition,
  ArcButtonStyleMode,
  ColorMetrics,
  router
} from '@kit.ArkUI';

@Entry
@Component
export struct HomePage {
  private mapController?: map.MapComponentController;
  @State mapOptions: mapCommon.MapOptions = {
    position: { target: { latitude: 0.447967, longitude: 0.179380 }, zoom: 13 }
  };
  @State results: Place[] = [];
  @State myLocationMarker: mapCommon.MarkerOptions = {
    position: { latitude: 0.447967, longitude: 0.179380 },
    icon: $r('app.media.Vector'),
    title: 'Place_1',
    clickable: true,
    anchorU: 0.5,
    anchorV: 1,
    alpha: 1
  };

  async onSearch(keyword: string) {
    const center = this.mapOptions.position.target;
    this.results = await SiteService.searchPlaces(keyword, center);
  }

  async aboutToAppear() {
    const location = await LocationService.getCurrentLocationSafe();
    if (location) {
      this.mapOptions = {
        position: { target: location, zoom: 18 }
      };
      this.myLocationMarker.position = location;
    }
  }

  build() {
    Stack() {
      Row() {
        ArcButton({
          options: new ArcButtonOptions({
            label: 'Search',
            position: ArcButtonPosition.TOP_EDGE,
            styleMode: ArcButtonStyleMode.CUSTOM,
            backgroundColor: ColorMetrics.resourceColor('#50707070'),
            onClick: () => {
              router.pushUrl({
                url: 'pages/SearchPage',
              })

            }
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.Transparent)
      .position({ top: 0 })
      .zIndex(1)

      MapComponent({
        mapOptions: this.mapOptions,
        mapCallback: async (err, ctrl) => {
          if (!err) {
            this.mapController = ctrl;
            await ctrl?.addMarker(this.myLocationMarker);
          }
        }
      })
        .width('130%')
        .height('110%')
        .margin({ top: 2 })
    }
  }
}
