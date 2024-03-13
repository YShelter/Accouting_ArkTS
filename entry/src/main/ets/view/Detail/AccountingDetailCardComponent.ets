
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import AccountingInfo from '../../Viewmodel/AccountingInfo';
import AccountingText from '../AccoutingTextComponent';


@Styles function allSize () {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

// 展示记账信息的组件
@Component
export struct AccountingDetailCard {
  @Prop accountingInfoStr: string;
  clickAction: Function = (isClick: Boolean) => {};
  deleteAction: Function = () => {};
  @State accountingInfo: AccountingInfo =  new AccountingInfo(-1, '', -1, '', '', '', '');
  private downX: number = 0;
  cateFontSize: number | string | Resource = $r('app.float.default_16');
  remarkFontSize: number | string | Resource = $r('app.float.default_12');
  countFontSize:number | string | Resource = $r('app.float.default_24');

  private scroller: Scroller = new Scroller();


  aboutToAppear() {
    this.accountingInfo = JSON.parse(this.accountingInfoStr);
  }

  build() {
    Scroll(this.scroller) {
      Row() {
        Row() {
          Row({ space: Const.DEFAULT_6 }) {
            Image($rawfile(this.accountingInfo.icon))
              .width($r('app.float.default_36')).height($r('app.float.default_36'))
              .objectFit(ImageFit.Contain)

            Divider()
              .vertical(true)
              .opacity(0.6)
              .margin({ left: 1, right: 3 })
              .height(Const.THOUSANDTH_600)

            Column() {
              AccountingText({ // 分类信息
                title: this.accountingInfo.category,
                fontSize: this.cateFontSize
              })
              AccountingText({ // 备注信息
                title: this.accountingInfo.remark,
                fontSize: this.cateFontSize
              })
                .opacity(Const.OPACITY_6)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .align(Alignment.TopStart)

          if (this.accountingInfo.typeName === 'expense') {
            AccountingText({
              title: '-' + this.accountingInfo.amount.toString(),
              fontSize: this.countFontSize
            })
          } else if (this.accountingInfo.typeName === 'income') {
            AccountingText({
              title: '+' + this.accountingInfo.amount.toString(),
              fontSize: this.countFontSize
            })
          }

        }
        .allSize()
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: Const.THOUSANDTH_50, right: Const.THOUSANDTH_33 })
        .onClick(() => this.clickAction(true))
        .gesture(LongPressGesture().onAction(() => this.clickAction(false)))

        Button('删除')
          .type(ButtonType.Normal)
          .width(Const.DEFAULT_100)
          .height(Const.THOUSANDTH_1000)
          .backgroundColor(Color.Red)
          .onClick(() => { this.deleteAction()})
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off) //隐藏滑动条
    .edgeEffect(EdgeEffect.Fade)
    .borderRadius($r('app.float.default_24'))
    .backgroundColor($r('app.color.white'))
    .onTouch((event: TouchEvent) => { //触摸事件
      //   动画效果
      switch (event.type) {
        case TouchType.Down:

          this.downX = event.touches[0].x;
          break;

        case TouchType.Up:

          let xOffset = event.touches[0].x - this.downX;
          if (xOffset == 0) {
            return;
          }
          var toxOffset = 0;
        // this.taskInfo = null;
          if (Math.abs(xOffset) > vp2px(Const.DEFAULT_100) / 2 && xOffset < 0) {
            toxOffset = vp2px(Const.DEFAULT_100)
          }
        // 滑动到指定位置,设置动画
          this.scroller.scrollTo({ xOffset: toxOffset, yOffset: 0,
            animation: { duration: 300, curve: Curve.Linear } })
        // 重置按下的X轴坐标
          this.downX = 0;
          break;

        default:
          break;
      }
    })
  }
}