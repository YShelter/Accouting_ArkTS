
import { CommonConstants as Const } from '../../common/constants/CommonConstants';

@Component
export default struct AddTopView {
  build() {
    Row() {
      Navigator({ target: 'pages/Index', type: NavigationType.Back }) {
        Image($rawfile('exit.png'))
          .objectFit(ImageFit.Contain)
      }
      .width(Const.THOUSANDTH_100)
      .height(Const.THOUSANDTH_1000)
    }
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_50)
    .align(Alignment.TopStart)
    .padding({left: Const.THOUSANDTH_50})
  }
}
