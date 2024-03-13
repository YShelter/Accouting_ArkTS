
import AccountingInfo from '../../Viewmodel/AccountingInfo';
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import { AccountingDetailCard } from './AccountingDetailCardComponent';
import AccountingText from '../AccoutingTextComponent';
import { dateToStr } from '../../common/utils/Utils';

@Component
export struct AccountingList {
  @Link customDateList: Array<number>;
  @Link @Watch('addAccounting') customAccountingListStr: string;

  @State accountingList: Array<AccountingInfo> = [];

  addAccounting() {
    if (this.customAccountingListStr.length > 0) {
      this.accountingList = JSON.parse(this.customAccountingListStr)
    }
    else {
      this.accountingList = [];
    }
  }

  build() {
    Column() {
      if (this.customDateList.length > 0) {
        Column({ space: Const.DEFAULT_4}) {
          ForEach(this.customDateList, (date: number) => {
            Text(this.getDateTitle(date))
              .alignSelf(ItemAlign.Start)
            ForEach(this.accountingList, (item: AccountingInfo) => { // 展示每天的记账记录
              if (this.isSameDate(date, item)) {
                AccountingDetailCard({
                  accountingInfoStr: JSON.stringify(item),
                  // clickAction: (isClick: boolean) => this.accountingItemClickAction(item, isClick), // 处理点击或者长按事件
                  // deleteAction: () => this.deleteAccountingItemClickAction(item) // 处理删除事件
                })
                  .margin({ bottom: Const.DEFAULT_4 })
                  .height($r('app.float.default_64'))
              }
            }, (item: AccountingInfo) => JSON.stringify(item))
            Divider()
              .width(Const.THOUSANDTH_900)
              .vertical(false)
              .margin({ top: 4, bottom: 12 })
          })
        }
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
    .backgroundColor('#F1F3F5')
    .width(Const.THOUSANDTH_1000)
  }

  private getDateTitle(date: number): string {
    let newDate = new Date(date);
    let res = newDate.getFullYear().toString() + '.' + (newDate.getMonth()+1).toString() + '.' + newDate.getDate().toString() + ' ';

    switch (newDate.getDay()) {
      case 0:
        res += '星期日';
        break;
      case 1:
        res += '星期一';
        break;
      case 2:
        res += '星期二';
        break;
      case 3:
        res += '星期三';
        break;
      case 4:
        res += '星期四';
        break;
      case 5:
        res += '星期五';
        break;
      case 6:
        res += '星期六';
        break;
      default:
        break;
    }
    return res;
  }

  private isSameDate(date: number, item: AccountingInfo): Boolean {
    let date_1 = new Date(date);
    let date_2 = new Date(item.date)
    return dateToStr(date_1) === dateToStr(date_2);
  }
}