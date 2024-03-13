import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import AccountingInfo from '../Viewmodel/AccountingInfo';
import { HomeStore } from '../Viewmodel/HomeViewModel';
import AccountingText from './AccoutingTextComponent';
import AddBtn from './Home/AddBtnComponent';
import HomeTopView from './Home/HomeTopComponent';
import { AccountingCard } from './Home/TaskCardComponent';
import { dateToStr } from '../common/utils/Utils';


// match parent
@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

const WHITE_COLOR_0X = 255;

// 标题样式
@Extend(Text)
function titleTextStyle() {
  .fontSize($r('app.float.default_16'))
  .fontWeight(Const.FONT_WEIGHT_500)
  .width(Const.THOUSANDTH_1000)
  .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
  .fontColor($r(`app.element.color.titleColor`))
  .padding({
    top: Const.THOUSANDTH_15,
    bottom: Const.THOUSANDTH_15,
    left: Const.THOUSANDTH_33
  })
}

// 主页界面设置
@Component
export default struct HomeIndex {
  @State naviAlpha: number = 0;
  // @Link homeStore: HomeStore;
  @StorageLink('homeStore') homeStore: HomeStore = new HomeStore(new Date());
  @Link addAccountingInfo: AccountingInfo;
  @Link @Watch('accountingAdded') editAccountingID: string;
  private scroller: Scroller = new Scroller();
  private yOffset: number = 0;

  accountingAdded() {
    let addAccountingStr = JSON.stringify(this.addAccountingInfo);
    this.homeStore.updateAccountingInfoList(addAccountingStr);
  }

  build() {
    Stack() {
      Scroll (this.scroller) {
        Column() {
          HomeTopView({ homeStore: $homeStore })
          Text($r("app.string.accounting_list")).titleTextStyle()
          if (this.homeStore.getAccountingListOfDay().length > 0) {
            Column({ space: Const.DEFAULT_8}) {
              ForEach(this.homeStore.getAccountingListOfDay(), (item: AccountingInfo) => {
                AccountingCard({
                  accountingInfoStr: JSON.stringify(item),
                  clickAction: (isClick: boolean) => this.accountingItemClickAction(item, isClick), // 处理点击或者长按事件
                  deleteAction: () => this.deleteAccountingItemClickAction(item) // 处理删除事件
                })
                  .margin({ bottom: Const.DEFAULT_12 })
                  .height($r('app.float.default_72'))
              }, (item: AccountingInfo) => JSON.stringify(item))
            }
            .onAppear(() => {
              this.scroller.scrollTo({xOffset:0, yOffset: this.yOffset})
            })
            .padding({
              top: Const.THOUSANDTH_15,
              left: Const.THOUSANDTH_33,
              right: Const.THOUSANDTH_33
            })
            .width(Const.THOUSANDTH_1000)
          } else {
            Column({space: Const.THOUSANDTH_1000}) {
              Image($r('app.media.ic_no_data'))
                .width($r('app.float.default_132'))
                .height($r('app.float.default_100'));
              AccountingText({title: "没有记录，快开始记账吧！"})
                .opacity(Const.OPACITY_4)
            }
            .margin({ top: Const.DEFAULT_48 })
          }
        }
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .allSize()
      .onScroll(() => {
        this.onScrollAction()
      })
      .align(Alignment.TopStart)

      AddBtn({clickAction: () => {
        this.editAccountingAction()
      } })

      Row() {
        Text($r('app.string.EntryAbility_label'))
          .titleTextStyle()
          .fontSize($r('app.float.default_24'))
          .padding({ left: Const.THOUSANDTH_66 })
      }
      .width(Const.THOUSANDTH_1000)
      .height(Const.DEFAULT_56)
      .position({ x: 0, y: 0 })
      .backgroundColor(`rgba(${WHITE_COLOR_0X},${WHITE_COLOR_0X},${WHITE_COLOR_0X},${this.naviAlpha})`)

    }
    .allSize()
    .backgroundColor($r('app.color.primaryBgColor'))

  }

  // 触发点击或者长按记账记录事件
  accountingItemClickAction(item: AccountingInfo, isClick: boolean): void {
    // 触发点击或者长按记账记录事件
    if (isClick) {
      // 编辑记账信息
      router.pushUrl({
        url: 'pages/AddAccountingPage',
        params: {params: JSON.stringify(item)}
      });
    }
    else {

    }
  }

  // 点击删除按钮事件
  deleteAccountingItemClickAction(item: AccountingInfo) {
    let accountingInfoStr = JSON.stringify(item);
    this.homeStore.deleteAccountingItem(accountingInfoStr);
  }

  // 向上滑动时，改变顶部组件的透明度
  onScrollAction() {
    this.yOffset = this.scroller.currentOffset().yOffset;
    if (this.yOffset > Const.DEFAULT_56) {
      this.naviAlpha = 1;
    } else {
      this.naviAlpha = this.yOffset / Const.DEFAULT_56;
    }
  }

  // 添加收支记录
  editAccountingAction() {
    let item: AccountingInfo = new AccountingInfo(-1, dateToStr(new Date()), 0, '', '', '', '');
    // 跳转添加记录界面
    router.pushUrl({
      url: 'pages/AddAccountingPage',
      params: {params: JSON.stringify(item)}
    });

  }

}

