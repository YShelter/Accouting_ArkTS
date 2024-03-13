

import { NavList, TabId } from '../model/NavItemModel';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { HomeStore } from '../Viewmodel/HomeViewModel';
import router from '@ohos.router';
import AccountingInfo from '../Viewmodel/AccountingInfo';
import HomeIndex from '../view/HomeComponent';
import { DetailIndex } from './DetailPage';

@Styles function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

AppStorage.SetOrCreate('homeStore', new HomeStore(new Date()));

@Entry
@Component
struct Index {
  @State currentPage: number = 0;
  @State addAccountingInfo: AccountingInfo = router.getParams() ? (router.getParams() as Record<string, Object>).editTask as AccountingInfo : {} as AccountingInfo;
  // @State homeStore: HomeStore = new HomeStore(new Date());
  @StorageLink('homeStore') homeStore: HomeStore = new HomeStore(new Date());
  @State editAccountingID: string = '';
  private tabController: TabsController = new TabsController();

  aboutToAppear() {
    this.homeStore.queryAllData()
  }

  onPageShow() {
    let params = (router.getParams() ? router.getParams() : {}) as Record<string, Object>;
    let result = params.addAccounting ? params.addAccounting as string : '{}';
    this.addAccountingInfo = JSON.parse(result);
    this.editAccountingID = JSON.stringify(this.addAccountingInfo);

    this.homeStore.initData();
  }

  @Builder TabBuilder(index: number) {
    Column() {
      Image(index === this.currentPage ? NavList[index].icon_selected : NavList[index].icon)
        .width($r('app.float.default_24'))
        .height($r('app.float.default_24'))
        .objectFit(ImageFit.Contain)
        .borderRadius(Const.BORDER_RADIUS_PERCENT_50);
      Text(NavList[index].text)
        .fontSize($r('app.float.default_10'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .fontColor(this.currentPage === index ? $r('app.color.blueColor') : $r('app.color.tabTitleColor'))
        .margin({ top: $r('app.float.default_4') })
    }.justifyContent(FlexAlign.Center).allSize()
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
      TabContent() {
        HomeIndex({
          // homeStore: $homeStore,
          addAccountingInfo: $addAccountingInfo,
          editAccountingID: $editAccountingID
        })
          .borderWidth({ bottom: 1 })
          .borderColor($r('app.color.primaryBgColor'))
      }
      .tabBar(this.TabBuilder(TabId.HOME))
      .align(Alignment.Start)

      TabContent() {
        DetailIndex({
          // homeStore: $homeStore,
          editAccountingID: $editAccountingID
        })
      }
      .tabBar(this.TabBuilder(TabId.DETAIL))

    }
    .scrollable(false)
    .allSize()
    .barWidth(Const.THOUSANDTH_940)
    .barMode(BarMode.Fixed)
    .vertical(false)
    .onChange((index) => {
      this.currentPage = index;
    })
  }

}