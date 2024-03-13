import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import { HomeStore } from '../../Viewmodel/HomeViewModel';
import BalanceText from '../BalanceTextComponent';


export const WEEK_DAY_WIDTH: number = 100 / Const.WEEK_DAY_NUM;

const DEFAULT_SCROLL_WIDTH = 336; // 默认宽度
const DEFAULT_SCROLL_PERCENT = 0.934; // 默认宽度占屏幕百分比

@Component
export struct WeekCalendar {
  @Link homeStore: HomeStore;
  scrollWidth: number = DEFAULT_SCROLL_WIDTH; // 默认滑动宽度后切换页面


  build() {
    Row() {
      Column() {
        Row() {
          this.ArrowIcon(false) // 左箭头
          BalanceText({
            title: this.homeStore.dateTitle,
            fontSize: $r('app.float.default_16')
          })
          this.ArrowIcon(true) // 右箭头
        }
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date('2020-1-1'),
            end: new Date('2031-12-31'),
            selected: this.homeStore.currentDate,
            onAccept: (value: DatePickerResult) => {
              let selectedDate = new Date() as Date;
              selectedDate.setFullYear(value.year, value.month, value.day);
              this.homeStore.setSelectedShowDate(selectedDate.getTime());
            }
          })
        })
      }
      .borderRadius($r('app.float.default_24'))
      .backgroundColor($r('app.color.white'))
      .width(Const.THOUSANDTH_1000)
      .height(Const.THOUSANDTH_1000)
      .justifyContent(FlexAlign.Center)
    }
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_300)
    .padding(Const.THOUSANDTH_33)
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
    .rotate({ z: 1, angle: isNext ? 0 : Const.DEFAULT_180 })
    .justifyContent(FlexAlign.Center)
  }

}