
import { AccountingType, AccountingTypeCN, CommonConstants as Const } from '../common/constants/CommonConstants';
import AddTopView from '../view/Add/AddTopComponent';
import AccountingInfo from '../Viewmodel/AccountingInfo';
import CategoryGridView from '../view/Add/CategoryGridComponent';
import KeyboardView from '../view/Add/KeyBoardComponent';
import router from '@ohos.router';

@Styles function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

PersistentStorage.PersistProp('a_id', 1);

@Entry
@Component
struct AddAccounting {
  @State accountingType: string = AccountingType[0];
  @State accountingInfo: AccountingInfo = this.parseRouterParams();
  @State isEdit: boolean = false;
  @StorageLink('a_id') a_id: number = 1;

  parseRouterParams() {
    let params = router.getParams() as Record<string, Object>;
    const routerParams: AccountingInfo = JSON.parse(params.params as string);
    return routerParams;
  }

  onPageShow() {
    if (this.accountingInfo.id != -1) {
      this.isEdit = true;
    }
    else {
      this.accountingInfo.id = this.a_id;
      this.a_id += 1;
    }
  }


  build() {
    Column() {

      AddTopView()

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
        this.accountingInfo.typeName = this.accountingType;
      })

      CategoryGridView({
        accountingType: $accountingType,
        accountingInfo: $accountingInfo
      })

      KeyboardView({
        accountingInfo: $accountingInfo,
        isEdit: $isEdit
      })
        .margin({top: Const.DEFAULT_4})
    }
    .allSize()
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

}