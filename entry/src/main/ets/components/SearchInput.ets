@Component
export struct SearchInput {
  @State value: string = '';
  private onSearch?: (value: string) => void;

  build() {
    Row() {
      TextInput({ text: this.value, placeholder: 'Search place...' })
        .onChange((val: string) => this.value = val)
        .width('60%')
        .height(36)

      Image($r('app.media.search'))
        .width(24)
        .height(24)
        .onClick(() => {
          if (this.onSearch) {
            this.onSearch(this.value);
          }
        })
    }
    .alignItems(VerticalAlign.Center)
  }

  setOnSearchCallback(callback: (value: string) => void): SearchInput {
    this.onSearch = callback;
    return this;
  }
}