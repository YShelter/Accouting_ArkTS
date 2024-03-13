
import { CommonConstants as Const } from '../../common/constants/CommonConstants';

@Styles function allSize () {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

// 添加记录按钮组件
@Component
export default struct AddBtn {
  clickAction: Function = () => {};


  build() {
    Button({type: ButtonType.Circle}) {
      Image($rawfile('add.png'))
        .allSize()
        .borderRadius(Const.BORDER_RADIUS_PERCENT_50)
    }
    .onClick(() => this.clickAction())
    .zIndex(Const.HOME_BTN_Z)
    .position({ x: Const.THOUSANDTH_800, y: Const.THOUSANDTH_880 })
    .width($r('app.float.default_64'))
    .height($r('app.float.default_64'))
    .backgroundColor('rgba(255,255,255,0)')
  }
}
