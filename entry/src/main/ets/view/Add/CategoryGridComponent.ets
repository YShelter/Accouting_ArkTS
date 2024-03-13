
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import { CategoryItem, expenseList, IncomeList } from '../../model/CategoryInitList';
import AccountingInfo from '../../Viewmodel/AccountingInfo';
import CategoryInfo from '../../Viewmodel/CategoryInfo';

@Component
export default struct CategoryGridView {
  @Link accountingType: string;
  @Link accountingInfo: AccountingInfo;
  scroller: Scroller = new Scroller()

  build() {
    Grid(this.scroller) {

      ForEach(this.accountingType === 'expense' ? expenseList: IncomeList, (item: CategoryItem) => {
        GridItem() {
          this.gridItemBuilder(item)
        }
        .width(Const.THOUSANDTH_230)
        .height(Const.THOUSANDTH_230)

      })
    }
    .rowsTemplate('1fr 1fr 1fr 1fr')
    .width(Const.THOUSANDTH_900)
    .height(Const.THOUSANDTH_500)
  }

  @Builder
  gridItemBuilder(categoryInfo: CategoryInfo) {
    Column() {
      Image($rawfile(categoryInfo.icon))
        .objectFit(ImageFit.Contain)
        .width(Const.THOUSANDTH_900)
        .layoutWeight(3)

      Text(categoryInfo.category)
        .fontSize($r('app.float.default_16'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .width(Const.THOUSANDTH_900)
        .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
        .fontColor($r(`app.element.color.titleColor`))
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
    }
    .aspectRatio(Const.DEFAULT_1)
    .border({
      radius: Const.DEFAULT_48,
      width: Const.DEFAULT_2,
      color: this.accountingInfo.category === categoryInfo.category ? $r('app.color.blueColor') : $r('app.color.black')
    })
    .margin({
      top: Const.DEFAULT_2,
      left: Const.DEFAULT_2,
      right: Const.DEFAULT_2
    })
    .padding(Const.DEFAULT_8)
    .onClick(() => {
      this.accountingInfo.category = categoryInfo.category;
      this.accountingInfo.icon = categoryInfo.icon;
      this.accountingInfo.typeName = this.accountingType;
    })
  }

}

