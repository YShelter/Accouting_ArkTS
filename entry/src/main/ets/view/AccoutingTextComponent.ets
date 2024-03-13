
import { CommonConstants as Const } from '../common/constants/CommonConstants'

@Component
export default struct AccountingText {
  @Prop title: string;
  fontSize: number | string | Resource;
  fontWeight: number | FontWeight | string = Const.FONT_WEIGHT_500;
  fontColor: ResourceColor = $r('app.color.titleColor');
  fontFamily: string | Resource = $r('app.string.HarmonyHeiTi_Medium');

  build() {
    Column() {
      Text (this.title)
        .fontSize(this.fontSize)
        .fontWeight(this.fontWeight)
        .fontColor(this.fontColor)
        .fontFamily(this.fontFamily)
        .textAlign(TextAlign.Start)
    }
    .align(Alignment.TopStart)

  }
}
