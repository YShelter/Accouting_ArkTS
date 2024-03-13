
import { CommonConstants as Const, DetailType, DetailTypeCN } from '../../common/constants/CommonConstants';
import BalanceText from '../BalanceTextComponent';

// 自定义弹窗组件，用户选择筛选模式
@CustomDialog
export  struct DetailTypeDialog {
  @Link detailType: string;
  @Link selectedMouth: string;
  @Link selectedYear: string;

  @Link startTime: number;
  @Link endTime: number;

  confirm: Function = () => {};

  @State thisDetailType: string = '';

  tabController: TabsController = new TabsController();
  private curMouth: string = (new Date().getMonth() + 1).toString();
  private curYear: string = new Date().getFullYear().toString();
  detailTypeDialogController: CustomDialogController;

  aboutToAppear() {
    // 如果不这样做，会导致每次弹窗关闭 this.detailType 被 Tabs 的 onChange 属性重置为 DetailType[0] 也就是 ‘mouth’
    this.thisDetailType = this.detailType;
  }

  @Builder
  ArrowIcon(isNext: boolean) {
    Row() {
      Image($r('app.media.ic_right_grey'))
        .width($r('app.float.default_6'))
        .height($r('app.float.default_12'))
    }
    .width($r('app.float.default_20'))
    .height($r('app.float.default_20'))
    .rotate({ z: 1, angle: isNext ? 0 : Const.DEFAULT_180 }) // 控制箭头方向
    .justifyContent(FlexAlign.Center)
    .onClick(()=>{this.goToNextYear(isNext)})
  }

  @Builder
  TabBuilder(index: number) {
    Row() {
      Text(DetailTypeCN[index])
        .fontSize($r('app.float.default_16'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .fontColor(this.thisDetailType === DetailType[index] ? $r('app.color.blueColor') : $r('app.color.tabTitleColor'))
        .margin({ top: $r('app.float.default_4') })

    }
  }

  @Builder Mouth() {
    Column(){
      Row() {
        this.ArrowIcon(false) // 左箭头
        BalanceText({
          title: this.selectedYear + '年',
          fontSize: $r('app.float.default_24')
        })
        this.ArrowIcon(true) // 右箭头
      }
      .width(Const.THOUSANDTH_800)
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)

      Grid() {
        ForEach(Const.MOUTH_LIST, (item: string) => {
          GridItem() {
            Text(item)
              .fontSize($r('app.float.default_24'))
              .fontWeight(Const.FONT_WEIGHT_500)
              .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
              .fontColor(this.getFontColor(item))
              .textAlign(TextAlign.Center)
          }
          .backgroundColor(item === this.selectedMouth ? 'rgba(255, 40, 125, 1.00)' : 'rgb(255, 255,255)')
          .onClick(() => {
            this.detailType = DetailType[0];
            this.selectedMouth = item;
            this.detailTypeDialogController.close();
            this.confirm();
          })
        })
      }
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr 1fr')
      .padding(Const.DEFAULT_12)
      .layoutWeight(4)
    }
  }

  @Builder Year() {
    Column() {
      Row() {
        this.ArrowIcon(false) // 左箭头
        BalanceText({
          title: this.selectedYear + '年',
          fontSize: $r('app.float.default_24')
        })
        this.ArrowIcon(true) // 右箭头
      }
      .width(Const.THOUSANDTH_800)
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)

      Grid() {
        ForEach(Const.YEAR_LIST, (item: string) => {
          GridItem() {
            Text(item)
              .fontSize($r('app.float.default_24'))
              .fontWeight(Const.FONT_WEIGHT_500)
              .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
              .fontColor(this.getFontColor(item))
              .textAlign(TextAlign.Center)
          }
          .backgroundColor(item === this.selectedYear ? 'rgba(255, 40, 125, 1.00)' : 'rgb(255, 255,255)')
          .onClick(() => {
            this.detailType = DetailType[1];
            this.selectedYear = item;
            this.selectedMouth = '';
            this.detailTypeDialogController.close();
            this.confirm();
          })
        })
      }
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr 1fr')
      .padding(Const.DEFAULT_12)
    }
  }

  build() {
    Column() {
      Tabs({barPosition: BarPosition.Start, controller: this.tabController, index: DetailType[this.detailType]}) {
        TabContent(){
          this.Mouth();
        }
        .tabBar(this.TabBuilder(DetailType.mouth))


        TabContent(){
          this.Year();
        }
        .tabBar(this.TabBuilder(DetailType.year))

        TabContent(){
          Button('确认')
            .width(Const.THOUSANDTH_400)
            .fontColor('rgb(255, 255,255)')
            .backgroundColor('rgba(255, 40, 125, 1.00)' )
            .onClick(() => {
              this.detailType = DetailType[2];
              this.detailTypeDialogController.close();
              this.confirm();
            })
        }
        .tabBar(this.TabBuilder(DetailType.all))

        TabContent(){
          Column() {
            Text('请选择日期: ')
              .fontSize(Const.DEFAULT_24)

            Row() {
              Button(this.getTimeStr(this.startTime))
                .fontColor(Color.Gray)
                .border({
                  color: Color.Gray,
                })
                .backgroundColor(Color.White)
                .width(Const.THOUSANDTH_400)
                .onClick(()=>{
                  DatePickerDialog.show({
                    start: new Date('2020-1-1'),
                    end: new Date('2031-1-1'),
                    selected: this.startTime ? new Date(this.startTime) : new Date(new Date().setDate(1)),
                    onAccept: (value: DatePickerResult) => {
                      this.startTime = new Date().setFullYear(value.year, value.month, value.day);
                    }
                  })
                })

              Text('-')
                .width(Const.THOUSANDTH_100)

              Button(this.getTimeStr(this.endTime))
                .width(Const.THOUSANDTH_400)
                .fontColor(Color.Gray)
                .border({
                  color: Color.Gray,
                })
                .backgroundColor(Color.White)
                .onClick(()=>{
                  DatePickerDialog.show({
                    start: new Date('2020-1-1'),
                    end: new Date('2031-1-1'),
                    selected: this.endTime ? new Date(this.endTime) : new Date(new Date().setDate(1)),
                    onAccept: (value: DatePickerResult) => {
                      this.endTime = new Date().setFullYear(value.year, value.month, value.day);
                    }
                  })
                })

            }
            .align(Alignment.Center)
            .margin(Const.THOUSANDTH_100)
            .width(Const.THOUSANDTH_900)

            Button('确认')
              .width(Const.THOUSANDTH_400)
              .fontColor('rgb(255, 255,255)')
              .backgroundColor('rgba(255, 40, 125, 1.00)' )
              .onClick(() => {
                this.detailType = DetailType[3];
                if (this.checkValid()) {
                  this.detailTypeDialogController.close();
                  this.confirm();
                }
              })
          }
        }
        .tabBar(this.TabBuilder(DetailType.customDate))

      }
      .scrollable(false)
      .width(Const.THOUSANDTH_1000)
      .barMode(BarMode.Fixed)
      .animationDuration(400)
      .onChange((index: number) => {
        this.thisDetailType = DetailType[index];
      })
    }
    .padding(Const.DEFAULT_24)
    .height(Const.THOUSANDTH_500)
    .width(Const.THOUSANDTH_1000)
    .backgroundColor('rgba(255, 255, 255, 0.80)')

  }

  private goToNextYear(isNext: boolean) {
    let year: number = parseInt(this.selectedYear);
    year = isNext ? year+1 : year-1;
    if (year > 2031) {
      year = 2031;
    }
    else if (year < 2020) {
      year = 2020;
    }
    this.selectedYear = year.toString();
  }

  private getFontColor(item: string): string {
    if (this.selectedMouth === item || this.selectedYear === item) {
      return 'rgb(255, 255, 255)'
    }
    else if (this.curMouth === item || this.curYear === item) {
      return 'rgba(255, 40, 125, 1.00)'
    }
    else {
      return 'rgb(0, 0, 0)'
    }
  }

  private getTimeStr(time: number): string {
    let curDate = new Date()
    if(!time || time === 0 ) {
      time= curDate.setDate(1);
    }

    let resDate = new Date(time);
    let res: string = resDate.getFullYear().toString() + '.' + (resDate.getMonth() + 1).toString() + '.' + resDate.getDate().toString();
    return res;
  }

  // 检查返回数据的合规性
  private checkValid(): Boolean {
    if (this.startTime && this.endTime) {
      if (this.startTime < this.endTime) {
        return true;
      }

    }
    else if (this.endTime) {
      this.startTime = new Date().setDate(1);
      if (this.startTime < this.endTime) {
        return true;
      }
    }
    else {
      AlertDialog.show({
        title: "出错啦！",
        message: "请选择你要查询的日期信息",
        confirm: {
          value: "确认",
          action: () => {
            return false;
          },
        },
        cancel: () => {return false},
        gridCount: 3,
        alignment: DialogAlignment.Center,
      })
    }

    AlertDialog.show({
      title: "出错啦！",
      message: "请选择结束日期大于开始日期~",
      confirm: {
        value: "确认",
        action: () => {
          return false;
        },
      },
      cancel: () => {return false},
      gridCount: 3,
      alignment: DialogAlignment.Center,
    })
    return false;
  }


}