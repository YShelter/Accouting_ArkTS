
import { HomeStore } from '../../Viewmodel/HomeViewModel';
import { CommonConstants as Const, DetailType } from '../../common/constants/CommonConstants';
import DayInfo from '../../Viewmodel/DayInfo';
import { IncomeList } from '../../model/CategoryInitList';

// 明细页展示结余信息
@Component
@Preview
export default struct DetailTopView {
  @Link homeStore: HomeStore;
  @Link detailType: string;


  build() {
    Row() {
      Column() {
        Row() {
          Text(this.getTitle() + '结余')
            .fontSize(Const.DEFAULT_24)
          Text('￥ ' + this.homeStore.getCustomBalance())
            .fontSize(Const.DEFAULT_24)
            .fontColor('rgba(255, 0, 159, 1.00)')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Const.THOUSANDTH_900)
        .layoutWeight(2)

        Row() {
          Text(this.getTitle() + '支出')
            .width(Const.THOUSANDTH_200)
            .fontSize(Const.DEFAULT_16)
            .fontColor(Color.Gray)
          Row() {
            Row()
              .width(this.getExpense('expense'))
              .height(Const.DEFAULT_6)
              .backgroundColor('rgba(255, 195, 0, 1.00)')
              .borderRadius(Const.BORDER_RADIUS_PERCENT_50)
          }
          .backgroundColor('#F1F3F5')
          .width(Const.THOUSANDTH_50)

          Text(this.homeStore.getExpense())
            .width(Const.THOUSANDTH_200)
            .fontSize(Const.DEFAULT_16)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Const.THOUSANDTH_900)
        .layoutWeight(1)

        Row() {
          Text(this.getTitle() + '收入')
            .width(Const.THOUSANDTH_200)
            .height(Const.DEFAULT_16)
            .fontSize(Const.DEFAULT_16)
            .fontColor(Color.Gray)
          Row() {
            Row()
              .width(this.getExpense('income'))
              .height(Const.DEFAULT_6)
              .backgroundColor('rgba(255, 62, 62, 1.00)')
              .borderRadius(Const.BORDER_RADIUS_PERCENT_50)
          }
          .backgroundColor('#F1F3F5')
          .width(Const.THOUSANDTH_500)

          Text(this.homeStore.getIncome())
            .width(Const.THOUSANDTH_200)
            .fontSize(Const.DEFAULT_16)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.End)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Const.THOUSANDTH_900)
        .layoutWeight(1)

      }
      .height(Const.THOUSANDTH_1000)
      .borderRadius($r('app.float.default_24'))
      .backgroundColor($r('app.color.white'))
      .margin({top: Const.DEFAULT_56})
      .width(Const.THOUSANDTH_1000)
      .border({
        radius: Const.DEFAULT_24,
        color: Color.Black,
        width: Const.DEFAULT_2
      })
    }
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_300)
    .padding(Const.THOUSANDTH_50)
    .justifyContent(FlexAlign.End)
    .backgroundImagePosition({x: 0, y: 0})
    .backgroundImage($r('app.media.home_background'))
    .backgroundImageSize({ width: Const.THOUSANDTH_1000, height: Const.THOUSANDTH_1000 })
  }

  getTitle() {
    switch (this.detailType) {
      case DetailType[0]:
        return '本月'
        break;
      case DetailType[1]:
        return '本年'
        break;
      case DetailType[2]:
        return '总'
        break;
      case DetailType[3]:
        return ''
        break;
      default:
        return ''
        break;
    }
  }

  getExpense(type: string): string {
    let expense:number = parseInt(this.homeStore.getExpense());
    let income:number = parseInt(this.homeStore.getIncome());
    let sum:number = expense + income;

    if (type === 'expense') {
      let length = (expense / sum) * 100;
      return length.toFixed(0)+'%';
    }
    else if (type === 'income') {
      let length = (income / sum) * 100;
      return length.toFixed(0)+'%';
    }

  }

}