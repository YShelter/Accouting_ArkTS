import { CommonConstants as Const } from '../common/constants/CommonConstants'
import { HomeStore } from '../Viewmodel/HomeViewModel';

// 设置字体样式
@Component
export default struct BalanceText {
  @Prop title: string;
  titleResource: Resource = $r('app.string.empty');
  fontSize: number | string | Resource = $r('app.float.default_16');
  fontWeight: number | FontWeight | string = Const.FONT_WEIGHT_500;
  fontColor: ResourceColor = $r('app.color.titleColor');
  fontFamily: string | Resource = $r('app.string.HarmonyHeiTi_Medium');

  build() {
    Text(this.title || this.titleResource)
      .fontSize(this.fontSize)
      .fontWeight(this.fontWeight)
      .fontColor(this.fontColor)
      .fontFamily(this.fontFamily)
  }

}