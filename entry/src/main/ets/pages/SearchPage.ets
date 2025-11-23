import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, router } from "@kit.ArkUI";

@Entry
@Component
export struct SearchPage {
  @State value: string = '';

  build() {
    Column() {
      TextInput({ text: this.value, placeholder: 'Search place...' })
        .onChange((val: string) => this.value = val)
        .width('100%')
        .height('25%')
        .padding({ left: '2%', right: '2%' })

      Blank().height('25%')


      ArcButton({
        options: new ArcButtonOptions({
          label: 'Search',
          position: ArcButtonPosition.BOTTOM_EDGE,
          styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
          onClick: () => {
            if (this.value.trim() !== '') {
              router.pushUrl({
                url: 'pages/SearchResultsPage',
                params: { keyword: this.value }
              })
            }
          }
        })
      })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
  }
}
