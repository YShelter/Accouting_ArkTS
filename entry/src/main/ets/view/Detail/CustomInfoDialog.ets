
import CategoryInfo from '../../Viewmodel/CategoryInfo';
import { CommonConstants as Const} from '../../common/constants/CommonConstants';
import { CategoryListDialog } from '../CategoryListDialog';

@CustomDialog
export struct CustomInfoDialog {
  @Link isCustom: boolean;
  @Link minAmount: number;
  @Link maxAmount: number;
  @Consume categoryList: CategoryInfo[];
  confirm: Function = ()=>{};

  textInputController_1: TextInputController = new TextInputController();
  textInputController_2: TextInputController = new TextInputController();

  categoryListDialogController: CustomDialogController = new CustomDialogController({
    builder: CategoryListDialog({
      isCustom: $isCustom,
    }),
    cancel: ()=>{
      this.cancelCategoryListDialog();
    },
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 6,
    customStyle: true
  })

  customDialogController: CustomDialogController;

  build() {
    Column() {
      Text('请输入金额：')
        .fontSize(Const.DEFAULT_24)


      Row() {
        TextInput({
          text: this.minAmount === undefined || this.minAmount === NaN ? '' : this.minAmount.toString(),
          placeholder: '请输入最小金额',
          controller: this.textInputController_1
        })
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: Const.DEFAULT_16, weight: 400 })
          .caretColor(Color.Blue)
          .fontSize(14)
          .width(Const.THOUSANDTH_400)
          .fontColor(Color.Black)
          .borderRadius(0)
          .textAlign(TextAlign.Center)
          .type(InputType.Number)
          .style(TextInputStyle.Inline)
          .onChange((value: string) => {
            if (value.length > 0) {
              this.minAmount = parseInt(value)
            }
          })

        Text('~')
          .fontSize(Const.DEFAULT_16)

        TextInput({
          text: this.maxAmount === undefined || this.maxAmount === NaN ? '' : this.maxAmount.toString(),
          placeholder: '请输入最大金额',
          controller: this.textInputController_1
        })
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: Const.DEFAULT_16, weight: 400 })
          .caretColor(Color.Blue)
          .fontSize(14)
          .width(Const.THOUSANDTH_400)
          .fontColor(Color.Black)
          .borderRadius(0)
          .textAlign(TextAlign.Center)
          .type(InputType.Number)
          .style(TextInputStyle.Inline)
          .onChange((value: string) => {
            if (value.length > 0) {
              this.maxAmount = parseInt(value)
            }
          })
      }
      .padding(Const.DEFAULT_12)
      .margin({top: Const.DEFAULT_12})

      Divider()
        .width(Const.THOUSANDTH_900)
        .margin({top: Const.DEFAULT_12})

      Button('点击选择分类')
        .fontSize(Const.DEFAULT_24)
        .onClick(()=>{
          this.categoryListDialogController.open();
        })
        .margin({top: Const.DEFAULT_12})

      Row() {
        ForEach(this.categoryList, (item: CategoryInfo) => {
          Text(item.category+' ')
            .fontSize(14)
            .fontColor(Color.Gray)
        })
      }

      Row() {
        Button('确认')
          .width(Const.THOUSANDTH_400)
          .margin({ top: Const.DEFAULT_12 })
          .fontColor('rgb(255, 255,255)')
          .backgroundColor('rgba(255, 40, 125, 1.00)')
          .onClick(() => {
            this.checkValid();
          })

        Button('重置')
          .width(Const.THOUSANDTH_400)
          .margin({ top: Const.DEFAULT_12 })
          .fontColor('rgb(255, 255,255)')
          .backgroundColor('rgba(255, 40, 125, 1.00)')
          .onClick(() => {
            this.minAmount = undefined as number;
            this.maxAmount = undefined as number;
            this.categoryList = [];
            this.isCustom = false;
            this.customDialogController.close();
          })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .padding(Const.DEFAULT_12)

    }
    .backgroundColor(Color.White)
    .padding(Const.DEFAULT_12)
  }

  cancelCategoryListDialog() {
    this.categoryList = [];
    this.categoryListDialogController.close();
  }

  checkValid() {
    if (this.minAmount === undefined && this.maxAmount === undefined && this.categoryList.length <= 0) { // 若没有进行查询
      AlertDialog.show({
        title: '出错啦！',
        message: '请至少选择一项进行查询~',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        confirm: {
          value: '确认',
          action: ()=>{
            return;
          }
        },
        cancel: ()=>{return;}
      })
      return;
    }

    if (this?.minAmount > this?.maxAmount) { // 若输入的最小金额大于最大金额
      AlertDialog.show({
        title: '出错啦！',
        message: '第一个数需要小于第二个数哦~',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        confirm: {
          value: '确认',
          action: ()=>{
            return;
          }
        },
        cancel: ()=>{return;}
      })
      return;
    }

    this.isCustom = true;
    this.confirm()
    this.customDialogController.close();
    return;

  }
}