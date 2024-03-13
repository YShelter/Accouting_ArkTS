
import router from '@ohos.router';
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import AccountingInfoApi from '../../common/database/Tables/AccountingInfoApi';
import { dateToStr } from '../../common/utils/Utils';
import AccountingInfo from '../../Viewmodel/AccountingInfo';

@Styles function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

@Component
export default struct KeyboardView {
  @Link accountingInfo: AccountingInfo;
  @Link isEdit: boolean;
  @State amount: string = '0';
  @State selectedDate: number = new Date().setHours(0,0,0,0);
  private textInputController: TextInputController = new TextInputController();
  private firstRow: string[] = ['7', '8', '9'];
  private secondRow: string[] = ['4', '5', '6', '+'];
  private thirdRow: string[] = ['1', '2', '3', '-'];
  private firstNum: number = 0;
  private operate: Boolean = false;
  private secondNum: number = 0;

  aboutToAppear() {
    this.amount = this.accountingInfo.amount.toString();
    let date:Date = new Date(this.accountingInfo.date);
    this.selectedDate = date.getTime();
  }

  build() {
    Column() {

      Row() {
        TextInput({
          text: this.accountingInfo.remark,
          placeholder: '点击输入备注...',
          controller: this.textInputController
        })
          .placeholderColor(Color.Gray)
          .placeholderFont({ size: 14, weight: 400 })
          .caretColor(Color.Red)
          .width(Const.THOUSANDTH_600)
          .onChange((value: string) => {
            this.accountingInfo.remark = value;
          })

        Text('￥ ' + this.amount)
          .maxLines(3)
          .backgroundColor(Color.White)
          .width(Const.THOUSANDTH_400)


      }
      .layoutWeight(1)
      .backgroundColor('rgba(255, 255, 255, 1.00)')
      .border({
        radius: Const.DEFAULT_20,
        color: Color.Black,
        width: Const.DEFAULT_4
      })
      .margin({
        top: Const.DEFAULT_4,
        left: Const.DEFAULT_10,
        right: Const.DEFAULT_10
      })


      Grid() {
        ForEach(this.firstRow, (item: string) => { // 展示第一行
          GridItem() {
            this.gridItemBuilder(item);
          }
          .margin(Const.DEFAULT_6)
        })

        GridItem() { // 展示日期
          this.dateGridItem(new Date())
        }
        .margin(Const.DEFAULT_6)


        ForEach(this.secondRow, (item: string) => { // 展示第二行
          GridItem() {
            this.
            gridItemBuilder(item);
          }
          .margin(Const.DEFAULT_6)
        })

        ForEach(this.thirdRow, (item: string) => { // 展示第三行
          GridItem() {
            this.gridItemBuilder(item);
          }
          .margin(Const.DEFAULT_6)
        })

        GridItem() {
          this.gridItemBuilder('0');
        }
        .margin(Const.DEFAULT_6)

        GridItem() {
          Image($rawfile('backup.png'))
            .objectFit(ImageFit.Contain)
            .allSize()
            .backgroundColor(Color.White)
            .border({
              radius: Const.DEFAULT_20,
              color: Color.Black,
              width: Const.DEFAULT_4
            })
            .onClick(() => {
              this.backupClick();
            })
        }
        .margin(Const.DEFAULT_6)

        GridItem() {
          this.gridItemBuilder('完成')
        }
        .margin(Const.DEFAULT_6)
        .columnStart(3)
        .columnEnd(4)

      }
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .layoutWeight(4)
      .margin({
        bottom: Const.DEFAULT_10,
        right: Const.DEFAULT_10
      })
    }
    .height(Const.THOUSANDTH_400)
    .width(Const.THOUSANDTH_1000)
    .backgroundColor('rgba(255, 255, 50, 1.00)')


  }

  // 数字及符号
  @Builder
  gridItemBuilder(item: string) {
    Text(item)
      .allSize()
      .textAlign(TextAlign.Center)
      .backgroundColor(item === '完成' ? Color.Pink : Color.White)
      .fontColor(item === '完成' ? Color.White : Color.Black)
      .border({
        radius: Const.DEFAULT_20,
        color: Color.Black,
        width: Const.DEFAULT_4
      })
      .onClick(() => {
        if (item === '完成') {
          this.clickComplete();
        }
        else {
          this.clickItem(item)
        }
      })
  }

  // 展示日期
  @Builder
  dateGridItem(date: Date) {
    Text(dateToStr(date) === dateToStr(new Date(this.selectedDate)) ? '今日' : '' + (new Date(this.selectedDate).getMonth() + 1).toString() + '.' + new Date(this.selectedDate).getDate().toString())
      .allSize()
      .textAlign(TextAlign.Center)
      .backgroundColor(Color.White)
      .border({
        radius: Const.DEFAULT_24,
        color: Color.Black,
        width: Const.DEFAULT_4
      })
      .onClick(() => {
        DatePickerDialog.show({
          start: new Date('2020-1-1'),
          end: new Date('2031-12-31'),
          selected: new Date(this.selectedDate),
          onAccept: (value: DatePickerResult) => {
            this.selectedDate = new Date().setFullYear(value.year, value.month, value.day);
          }
        })
      })
  }

  // 计算表达式
  checkOperator (operator: string) {
    if(this.operate === false) {
      this.firstNum = parseInt(this.amount);
      this.amount += operator;
      this.operate = true;
    }
    else {
      for (let i = 1; i < this.amount.length; i++) {
        if (this.amount[i] === '+') {
          this.amount = (this.firstNum + this.secondNum).toString();
          this.firstNum = parseInt(this.amount);
          this.secondNum = 0;
          this.amount += operator;
          break;
        }
        else if(this.amount[i] === '-') {
          this.amount = (this.firstNum - this.secondNum).toString();
          this.firstNum = parseInt(this.amount);
          this.secondNum = 0;
          this.amount += operator;
          break;
        }
      }
    }
  }

  // 回退键逻辑处理
  backupClick() {
    if (this.operate === false) {
      this.amount = this.amount.slice(0, -1);
      this.firstNum = Math.floor(this.firstNum / 10);
    }
    else {
      let char = this.amount.charAt(this.amount.length - 1);
      if (char === '+' || char === '-') {
        this.operate = false;
        this.secondNum = 0;
        this.amount = this.amount.slice(0, -1);
      } else {
        this.amount = this.amount.slice(0, -1);
        this.secondNum = Math.floor(this.secondNum / 10);
      }
    }

    if (this.amount === '') {
      this.amount = '0';
    }
  }

  // 数字与运算符按键逻辑
  clickItem(item: string) {
    if (this.amount.length > 12) {
        AlertDialog.show({
          title: '呜呜',
          message: '您当前输入的数值过长。',
          autoCancel: true,
          alignment: DialogAlignment.Center,
          gridCount: 3,
          confirm: {
            value: '确认',
            action: () => {
              return;
            }
          },
          cancel: () => {
            return;
          }
        })
      return;
    }

    switch (item) {
      case '+':
        this.checkOperator(item);
        break;
      case '-':
        this.checkOperator(item);
        break;
      default:
        this.amount = this.amount === '0' ? '' : this.amount;
        if (this.operate === false) {
          this.amount += item;
        }
        else {
          this.secondNum = this.secondNum * 10 + parseInt(item);
          this.amount += item;
        }
        break;
    }
  }

  // 完成数据输入
  async clickComplete() {

    console.info(`clickComplete`)

    if (this.operate === true) { // 如果结果包含计算式，则先计算出结果
      for (let i = 0; i < this.amount.length; i++) {
        if (this.amount[i] === '+') {
          this.amount = (this.firstNum + this.secondNum).toString();
        }
        else if(this.amount[i] === '-') {
          this.amount = (this.firstNum - this.secondNum).toString();
        }
      }
    }

    // 检查结果的有效性
    if (parseInt(this.amount) <= 0) {
      AlertDialog.show({
        title: '出错啦',
        message: '金额必须为大于零的数哦~',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        confirm: {
          value: '确认',
          action: () => {
            return;
          }
        },
        cancel: () => {
          return;
        }
      })
    }
    else if (this.accountingInfo.category == '' || this.accountingInfo.icon == '') {
      AlertDialog.show({
        title: '出错啦',
        message: '请至少选中一项分类哦~',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        confirm: {
          value: '确认',
          action: () => {
            return;
          }
        },
        cancel: () => {
          return;
        }
      })
    }
    else {
      this.accountingInfo.amount = parseInt(this.amount);
      this.accountingInfo.date = dateToStr(new Date(this.selectedDate))

      if (this.isEdit) {
        AccountingInfoApi.updateData(this.accountingInfo, () => {});
      } else {
        AccountingInfoApi.insertData(this.accountingInfo, (res) => {})
      }


      AlertDialog.show({
        title: '记录成功！',
        message: '完成一笔新的记账啦~',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        confirm: {
          value: '确认',
          action: () => {
            router.back({
              url: 'pages/Index',
              params: {
                addAccounting: JSON.stringify(this.accountingInfo)
              }
            });
          }
        },
        cancel: () => {
          router.back({
            url: 'pages/Index',
            params: {
              addAccounting: JSON.stringify(this.accountingInfo)
            } });
        }
      })
    }

  }

}