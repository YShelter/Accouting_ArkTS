
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import { HomeStore } from '../../Viewmodel/HomeViewModel';
import BalanceText from '../BalanceTextComponent';
import { WeekCalendar } from './WeekCalendarComponent';

@Extend(Text) function titleTextStyle () {
  .fontSize($r('app.float.default_16'))
  .fontWeight(Const.FONT_WEIGHT_500)
  .width(Const.THOUSANDTH_1000)
  .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
  .fontColor($r(`app.element.color.titleColor`))
}


@Component
export default struct HomeTopView {
  @Link homeStore: HomeStore;

  build() {
    Column() {
      Text ($r('app.string.today_balance'))
        .titleTextStyle()
        .opacity(Const.OPACITY_6)
        .padding({left: $r('app.float.default_24')})
      Row() {
        BalanceText({
          title: this.homeStore.getBalance(),
          fontSize: $r('app.float.default_72'),
          fontFamily: $r('app.string.HarmonyHeiTi_Bold'),
          fontWeight: Const.FONT_WEIGHT_700
        })
        Text('元')
          .titleTextStyle()
          .fontSize($r('app.float.default_40'))
          .margin({ top: $r('app.float.default_12'), left: $r('app.float.default_8') })
      }
      .width(Const.THOUSANDTH_1000)
      .padding({ left: $r('app.float.default_24') })

      WeekCalendar({homeStore: $homeStore})
    }
    .height(Const.THOUSANDTH_400)
    .backgroundImagePosition({x: 0, y: 0})
    .backgroundImage($r('app.media.home_background'))
    .backgroundImageSize({ width: Const.THOUSANDTH_1000, height: Const.THOUSANDTH_900 })
    .justifyContent(FlexAlign.End)
  }
}