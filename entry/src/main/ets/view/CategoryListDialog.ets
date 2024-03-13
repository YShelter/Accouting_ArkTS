
import { AccountingType, AccountingTypeCN, CommonConstants as Const} from '../common/constants/CommonConstants';
import { CategoryItem, expenseList, IncomeList } from '../model/CategoryInitList';
import CategoryInfo from '../Viewmodel/CategoryInfo';

@Preview
@CustomDialog
export struct CategoryListDialog {

  @Consume categoryList: CategoryInfo[];
  @Link isCustom: boolean;
  @State accountingType: string = 'expense';

  categoryListDialogController: CustomDialogController;

  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Tabs() {
        TabContent()
          .tabBar(this.TabBuilder(AccountingType.expense))

        TabContent()
          .tabBar(this.TabBuilder(AccountingType.income))
      }
      .scrollable(false)
      .width(Const.THOUSANDTH_1000)
      .height(Const.THOUSANDTH_50)
      .barMode(BarMode.Fixed)
      .onChange((index) => {
        this.accountingType = AccountingType[index];
      })

      Grid(this.scroller) {
        ForEach(this.accountingType === 'expense' ? expenseList : IncomeList, (item: CategoryItem) => {
          GridItem() {
            this.gridItemBuilder(item)
          }
          .width(Const.THOUSANDTH_230)

        })
      }
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .height(Const.THOUSANDTH_400)
      .width(Const.THOUSANDTH_900)

      Row() {
        Button('确认')
          .fontColor('rgb(255, 255,255)')
          .backgroundColor('rgba(255, 34, 136, 1.00)')
          .width(Const.THOUSANDTH_400)
          .height(Const.THOUSANDTH_50)
          .onClick(() => {
            if (this.categoryList.length > 0) {
              this.isCustom = true;
            }
            this.categoryListDialogController.close();
          })
          .margin({right: Const.DEFAULT_6})

        Button('取消')
          .fontColor('rgb(255, 255,255)')
          .backgroundColor('rgba(255, 34, 136, 1.00)')
          .height(Const.THOUSANDTH_50)
          .width(Const.THOUSANDTH_400)
          .onClick(() => {
            this.cancel();
            this.categoryListDialogController.close();
          })
          .margin({left: Const.DEFAULT_6})

      }

    }
    .backgroundColor(Color.White)
    .margin({
      left: Const.THOUSANDTH_100,
      right: Const.THOUSANDTH_100,
    })
    .border({
      radius: Const.DEFAULT_12
    })


  }

  @Builder
  TabBuilder(index: number) {
    Row() {
      Text(AccountingTypeCN[index])
        .fontSize($r('app.float.default_24'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .fontColor(this.accountingType === AccountingType[index] ? $r('app.color.blueColor') : $r('app.color.tabTitleColor'))
        .margin({ top: $r('app.float.default_4') })

    }
  }

  @Builder
  gridItemBuilder(categoryInfo: CategoryInfo) {
    Column() {
      Image($rawfile(categoryInfo.icon))
        .objectFit(ImageFit.Contain)
        .width(Const.THOUSANDTH_700)
        .layoutWeight(3)

      Text(categoryInfo.category)
        .fontSize($r('app.float.default_16'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .width(Const.THOUSANDTH_800)
        .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
        .fontColor($r(`app.element.color.titleColor`))
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
    }
    .aspectRatio(Const.DEFAULT_1)
    .border({
      radius: Const.DEFAULT_48,
      width: Const.DEFAULT_2,
      color: this?.categoryList.includes(categoryInfo) ? $r('app.color.blueColor') : $r('app.color.black')
    })
    .margin({
      top: Const.DEFAULT_2,
      left: Const.DEFAULT_2,
      right: Const.DEFAULT_2
    })
    .onClick(() => {
      if (!this.categoryList.includes(categoryInfo)) {
        this.categoryList.push(categoryInfo)
      } else {
        this.categoryList = this.categoryList.filter((item) => {
          return item !== categoryInfo;
        })
      }
    })
  }

  private cancel() {
    this.categoryList = [];
  }

}