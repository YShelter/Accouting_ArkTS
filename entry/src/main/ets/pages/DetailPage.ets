
import { CommonConstants as Const, DetailType } from '../common/constants/CommonConstants';
import { HomeStore } from '../Viewmodel/HomeViewModel';
import { DetailTypeDialog } from  '../view/Detail/DetailTypeDialog'
import DetailTopView from '../view/Detail/DetailTopComponent';
import CategoryInfo from '../Viewmodel/CategoryInfo';
import { CustomInfoDialog } from '../view/Detail/CustomInfoDialog';
import { AccountingList } from '../view/Detail/AccountingListComponent';
import AccountingInfo from '../Viewmodel/AccountingInfo';

// match parent
@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

@Component
@Preview
export struct DetailIndex {
  @State naviAlpha: number = 0;
  // @Link homeStore: HomeStore;
  @StorageLink('homeStore') homeStore: HomeStore = new HomeStore(new Date());
  @State @Watch('confirm') detailType: string = 'mouth'; // 判断用户选择的分类类型
  @State @Watch('confirm') selectedYear: string = new Date().getFullYear().toString(); // 记录用户选择的年份
  @State @Watch('confirm') selectedMouth: string = (new Date().getMonth() + 1).toString(); // 记录用户选择的月份

  @Link @Watch('confirm') editAccountingID: string;
  @State customAccountingListStr: string = ''; // 记录用户要查询的结果
  @State customDateList: Array<number> = []; // 记录用户要查询的结果
  @State @Watch('confirm') isCustom: boolean = false;
  @State @Watch('confirm') startTime: number = undefined; // 记录用户查询的数据的开始日期
  @State @Watch('confirm') endTime: number = undefined; // 记录用户查询的数据的结束日期
  @State @Watch('confirm') minAmount: number = undefined; // 记录用户查询的数据的最小金额
  @State @Watch('confirm') maxAmount: number = undefined; // 记录用户查询的数据的最大金额
  @Provide @Watch('confirm') categoryList: Array<CategoryInfo> = []; // 记录用户要查询的分类
  private yOffset: number = 0;

  detailTypeDialogController: CustomDialogController = new CustomDialogController({
    builder: DetailTypeDialog({
      detailType: $detailType,
      selectedYear: $selectedYear,
      selectedMouth: $selectedMouth,
      startTime: $startTime,
      endTime: $endTime,
      confirm: this.confirm,
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    gridCount: 5,
    customStyle: true
  })

  customInfoDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomInfoDialog({
      isCustom: $isCustom,
      minAmount: $minAmount,
      maxAmount: $maxAmount,
      confirm: this.confirm,
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: true
  })

  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    this.confirm();
  }

  // 点击确认按钮
  confirm() {
    var homeStore: HomeStore = AppStorage.Get('homeStore');
    if (this.isCustom) {
      if (this.minAmount == undefined || this.minAmount === NaN) {
        let categoryListStr = JSON.stringify(this.categoryList);
        this.customAccountingListStr = homeStore.getAccountingListOfCustom(categoryListStr)
      }
      else if (this.minAmount !== undefined && this.minAmount !== NaN && this.categoryList.length == 0) {
        this.customAccountingListStr = homeStore.getAccountingListOfCustom(this.minAmount, this.maxAmount);
      }
      else {
        let categoryListStr = JSON.stringify(this.categoryList);
        this.customAccountingListStr = homeStore.getAccountingListOfCustom(this.minAmount, this.maxAmount, categoryListStr);
      }
      this.customDateList = homeStore.getCustomDateList();
      return 0;
    }

    switch (this.detailType) {
      case DetailType[0]:
        this.customAccountingListStr = homeStore.getAccountingListOfMouth(this.selectedYear, this.selectedMouth);
        break;
      case DetailType[1]:
        this.customAccountingListStr = homeStore.getAccountingListOfYear(this.selectedYear);
        break;
      case DetailType[2]:
        this.customAccountingListStr = homeStore.getAccountingListOfAll();
        break;
      case DetailType[3]:
        this.customAccountingListStr = homeStore.getAccountingListOfCustomDate(this.startTime, this.endTime);
        break;
      default:
        this.customAccountingListStr = '';
    }

    this.customDateList = homeStore.getCustomDateList();
  }

  // // 当用户的筛选条件发生改变时调用该函数
  // changeType() {
  //   if (this.isCustom) {
  //     this.customAccountingListStr = (this.homeStore.getAccountingListOfCustom(this.minAmount, this.maxAmount, this.categoryList.length === 0 ? undefined : this.categoryList));
  //   }
  //   else {
  //     switch (this.detailType) {
  //       case DetailType[0]:
  //         this.customAccountingListStr = this.homeStore.getAccountingListOfMouth(this.selectedYear, this.selectedMouth);
  //         break;
  //       case DetailType[1]:
  //         this.customAccountingListStr = this.homeStore.getAccountingListOfYear(this.selectedYear);
  //         break;
  //       case DetailType[2]:
  //         this.customAccountingListStr = this.homeStore.getAccountingListOfAll();
  //         break;
  //       case DetailType[3]:
  //         this.customAccountingListStr =  this.homeStore.getAccountingListOfCustomDate(this.startTime, this.endTime);
  //         break;
  //       default:
  //         this.customAccountingListStr = '';
  //     }
  //   }
  //   this.customDateList = this.homeStore.getCustomDateList();
  // }

  build() {
    Stack() {
      Scroll(this.scroller) {
        Column() {
          DetailTopView({
            homeStore: $homeStore,
            detailType: $detailType
          })

          Row() {
            Image($rawfile('search.png'))
              .objectFit(ImageFit.Contain)
              .height(Const.THOUSANDTH_1000)
              .width(Const.THOUSANDTH_100)

              Text(this.isCustom ? '点击查看（修改）筛选条件  ' : '筛选')
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
          }
          .height(Const.THOUSANDTH_50)
          .width(Const.THOUSANDTH_1000)
          .justifyContent(FlexAlign.Start)
          .backgroundColor('#ffffff')
          .padding({ left: Const.THOUSANDTH_66 })
          .onClick(()=>{
            this.customInfoDialogController.open();
          })

          AccountingList({
            customAccountingListStr: $customAccountingListStr,
            customDateList: $customDateList,
          })
        }
      }
      .allSize()
      .align(Alignment.TopStart)
      .backgroundColor('#F1F3F5')
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .onScroll(() => {
        this.onScrollAction()
      })

      Row() {
        Image($rawfile('bill.png'))
          .objectFit(ImageFit.Contain)
          .alignSelf(ItemAlign.Start)
          .width(Const.THOUSANDTH_100)

        Text(this.getTitle() + '账目明细')
          .fontSize(Const.DEFAULT_24)
          .fontFamily($r('app.string.HarmonyHeiTi_Bold'))
          .width(Const.THOUSANDTH_900)
          .height(Const.THOUSANDTH_1000)
          .textAlign(TextAlign.Start)
      }
      .justifyContent(FlexAlign.Start)
      .width(Const.THOUSANDTH_1000)
      .height(Const.DEFAULT_56)
      .position({ x: 0, y: 0 })
      .backgroundColor(`rgba(75, 255, 212, ${this.naviAlpha})`) //
      .align(Alignment.TopStart)
      .padding({ left: Const.THOUSANDTH_66 })
      .onClick(() => {
        this.detailTypeDialogController.open();
      })

    }
    .allSize()
  }

  // 获取查询的标题
  public getTitle(): string {
    if(this.isCustom === true) {
      return '';
    }

    switch (this.detailType) {
      case DetailType[0]:
        return this.selectedYear + '年' + this.selectedMouth + '月';
        break;
      case DetailType[1]:
        return this.selectedYear + '年';
        break;
      case DetailType[2]:
        return '总';
        break;
      case DetailType[3]:
        let res: string;
        let startDate: Date = new Date(this.startTime);
        let endDate: Date = new Date(this.endTime);
        res = startDate.getFullYear()
          .toString() + '.' + (startDate.getMonth() + 1).toString() + '.' + startDate.getDate()
        + '-' + endDate.getFullYear().toString() + '.' + (endDate.getMonth() + 1).toString() + '.' + endDate.getDate()
          .toString();
        return res;
        break;
      case DetailType[4]:
        return '总';
        break;
      default:
        return '?'
        break;
    }
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

}
