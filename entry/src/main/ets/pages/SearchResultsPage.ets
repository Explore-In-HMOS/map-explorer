import { SiteService } from "../services/SiteService";
import { LocationService } from "../services/LocationService";
import type { Place } from "../common/types";
import { ArcList, ArcListItem, router } from "@kit.ArkUI";

interface RouterParams {
  keyword?: string;
}

@Entry
@Component
export struct SearchResultsPage {
  @State results: Place[] = [];
  @State loading: boolean = true;
  @State keyword: string = '';

  async aboutToAppear() {
    const params: RouterParams = router.getParams() as RouterParams;
    this.keyword = params.keyword ?? '';

    if (this.keyword.trim() === '') {
      this.loading = false;
      return;
    }

    try {
      const location = await LocationService.getCurrentLocationSafe();
      const center = location ?? { latitude: 0.447967, longitude: 0.179380 };
      this.results = await SiteService.searchPlaces(this.keyword, center);
    } catch (err) {
      console.error("Search failed:", err);
    } finally {
      this.loading = false;
    }
  }

  build() {
    Column() {
        Text("Searching...")
          .fontSize(14)
          .fontColor(Color.Gray)
          .visibility(this.loading ? Visibility.Visible : Visibility.Hidden)


      ArcList() {
        ForEach(this.results, (p: Place) => {
          ArcListItem() {
            Column() {
              Text(p.name ?? 'Unknown')
                .fontSize(16)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
              Text(p.address ?? '')
                .fontSize(12)
                .opacity(0.6)
                .fontColor(Color.Black)
            }
            .padding(12)
            .backgroundColor('#F5F5F5')
            .borderRadius(12)
            .margin({ bottom: 8 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/PlaceDetailPage',
                params: { siteId: p.siteId, name: p.name }
              })
            })
          }
        })
      }

    }
    .padding(12)
    .width('100%')
    .height('100%')
  }
}