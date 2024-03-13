
import { WeekDateModel} from '../model/WeekCalendarModel';
import { dateToStr, weekDateFormat } from '../common/utils/Utils';
import AccountingInfo from './AccountingInfo';
import DayInfoApi from '../common/database/Tables/DayInfoApi';
import DayInfo from './DayInfo';
import AccountingInfoApi from '../common/database/Tables/AccountingInfoApi';
import CategoryInfo from './CategoryInfo';

@Observed
export class HomeStore {
  public currentDate: Date;
  public showDate: number;
  public dateTitle: string;
  public dateArr: Array<WeekDateModel> = []; // 记录每周天信息
  public accountingList: Array<AccountingInfo> = [];
  public dayInfo: DayInfo = new DayInfo('', 0, 0);
  public selectedDayInfo: WeekDateModel = new WeekDateModel('', '', new Date()) as WeekDateModel; // 被选中的日期的结余情况
  // public mouthAccountingList: Array<AccountingInfo> = [];
  // public yearAccountingList: Array<AccountingInfo> = [];
  // public allAccountingList: Array<AccountingInfo> = [];
  // public customAccountingListOfDate: Array<AccountingInfo> = [];
  public customAccountingList: Array<AccountingInfo> = [];
  public customDateList: Array<number> = [];
  public customDayInfo: DayInfo = new DayInfo('', 0, 0);

  constructor(currentDate: Date) {
    this.currentDate = currentDate;
    this.showDate = currentDate.getTime();
    this.dateTitle = weekDateFormat(currentDate.getTime());
  }

  // 启动应用时初始化数据
  public queryAllData() {
    AccountingInfoApi.queryAllDate((resultSet: AccountingInfo[]) => {
      for (let i = 0; i < resultSet.length; i++) {
        let addAccountingInfo: AccountingInfo = resultSet[i] as AccountingInfo;
        let filteredItems = this.dateArr.filter(item => item.dateStr === addAccountingInfo.date);
        let weekDateInfo = filteredItems.length > 0 ? filteredItems[0] : undefined;

        let dateInfo: number = new Date(addAccountingInfo.date).getTime();
        let weekTitle:string = weekDateFormat(dateInfo);

        if (!weekDateInfo || weekDateInfo.dateStr === '') { // 判断当天是否已经存在数据
          weekDateInfo = new WeekDateModel(weekTitle, addAccountingInfo.date, new Date(dateInfo));
          let accountingList: Array<AccountingInfo> = [];
          accountingList.push(addAccountingInfo);
          let dayInfo = new DayInfo(addAccountingInfo.date, 0, 0);
          if (addAccountingInfo.typeName === 'expense') {
            dayInfo.expense += addAccountingInfo.amount;
          }
          else if (addAccountingInfo.typeName === 'income') {
            dayInfo.income += addAccountingInfo.amount;
          }
          DayInfoApi.updateData(dayInfo, (result: number) => {
            if (result <= 0) {
              DayInfoApi.insertData(dayInfo, () => {
              })
            }
          });
          weekDateInfo.dayInfo = dayInfo;
          weekDateInfo.accountingList = accountingList;
          this.dateArr.push(weekDateInfo);
        }
        else {
          this.dateArr = this.dateArr.map((item: WeekDateModel) => { // 存在则修改其中的数据
            if (item.dateStr === addAccountingInfo.date) {
              item.accountingList.push(addAccountingInfo); // 插入记账信息

              if (addAccountingInfo.typeName === 'expense') { // 更新每日结余信息
                item.dayInfo.expense += addAccountingInfo.amount;
              }
              else if (addAccountingInfo.typeName === 'income') {
                item.dayInfo.income += addAccountingInfo.amount;
              }

              DayInfoApi.updateData(item.dayInfo, (result: number) => { // 更新DayInfo数据
                if (result <= 0) { // 若不存在则新插入一个DayInfo
                  DayInfoApi.insertData(item.dayInfo, () => {
                  })
                }
              });
              return item;
            }
            return item;
          })
        }
      }

      //将DateArr按日期排序
      this.dateArr.sort((a, b) => a.date.getTime() - b.date.getTime());



    })
  }

  public initData() {
    this.setSelectedShowDate(this.showDate);
  }

  // 初始化数据
  // public initData() {
  //   let dateStr:string = dateToStr(new Date(this.showDate));
  //
  //   let filteredItems = this.dateArr.filter(item => item.dateStr === dateStr);
  //   let selectedDayInfo = filteredItems.length > 0 ? filteredItems[0] : undefined;
  //
  //   if (!selectedDayInfo) {
  //       AccountingInfoApi.query(dateStr, (resultSet: AccountingInfo[]) => {
  //         if (resultSet && resultSet?.length > 0) {
  //           this.selectedDayInfo.accountingList = resultSet;
  //           this.dayInfo = this.setSelectedDayBalance(resultSet, this.dayInfo);
  //           this.selectedDayInfo.dayInfo = this.dayInfo;
  //           this.dateArr.push(this.selectedDayInfo);
  //           DayInfoApi.updateData(this.dayInfo, () => {});
  //           this.dateArr.push(this.selectedDayInfo);
  //         }
  //       });
  //   }
  //   else {
  //     if (selectedDayInfo.accountingList.length > 0 && (selectedDayInfo.dayInfo.expense == 0 && selectedDayInfo.dayInfo.income == 0)) {
  //       selectedDayInfo.dayInfo = this.setSelectedDayBalance(selectedDayInfo.accountingList, selectedDayInfo.dayInfo);
  //     }
  //     else if (selectedDayInfo.accountingList.length == 0 && (selectedDayInfo.dayInfo.expense != 0 || selectedDayInfo.dayInfo.income != 0)) {
  //       selectedDayInfo.dayInfo = this.setSelectedDayBalance(selectedDayInfo.accountingList, selectedDayInfo.dayInfo);
  //     }
  //     this.selectedDayInfo = selectedDayInfo;
  //   }
  // }

  // 设置选中的日期
  public setSelectedShowDate(ShowDateTime: number) {
    this.showDate = ShowDateTime;
    this.dateTitle = weekDateFormat(this.showDate);
    // let selectedDayInfo = this.dateArr.find((item: WeekDateModel) => item.dateStr == dateToStr(new Date(ShowDateTime))) as WeekDateModel;
    let filteredItems = this.dateArr.filter(item => item.dateStr === dateToStr(new Date(ShowDateTime)));
    let selectedDayInfo = filteredItems.length > 0 ? filteredItems[0] : undefined;
    if (selectedDayInfo) {
      if (selectedDayInfo?.weekTitle === '') {
        selectedDayInfo.weekTitle = this.dateTitle;
        selectedDayInfo.date = new Date(ShowDateTime);
      }
      this.updateSelectedDayInfo(selectedDayInfo);
    }
    else {
      selectedDayInfo = new WeekDateModel(this.dateTitle, dateToStr(new Date(ShowDateTime)), new Date(ShowDateTime));
      selectedDayInfo.accountingList = [];
      selectedDayInfo.dayInfo = new DayInfo(dateToStr(new Date(ShowDateTime)), 0, 0);
      this.dateArr.push(selectedDayInfo);

      // 将DateArr按日期排序
      this.dateArr.sort((a, b) => a.date.getTime() - b.date.getTime());

      this.updateSelectedDayInfo(selectedDayInfo);
    }
  }

  // 将页面数据更新为被选中的天数的数据
  public  updateSelectedDayInfo(selectedDayInfo: WeekDateModel) {
    // 从数据库中查找数据
    if (selectedDayInfo.accountingList.length === 0) {
      AccountingInfoApi.query(selectedDayInfo.dateStr, (resultSet: AccountingInfo[]) => {
        let accountingListStr = JSON.stringify(resultSet);
        this.accountingList = JSON.parse(accountingListStr);
        selectedDayInfo.accountingList = this.accountingList;
        this.dayInfo.date = selectedDayInfo.dateStr;

        this.dayInfo = this.setSelectedDayBalance(resultSet, this.dayInfo);

        selectedDayInfo.dayInfo = this.dayInfo;
        DayInfoApi.updateData(this.dayInfo, (res: number) => {
          if (res <= 0) {
            DayInfoApi.insertData(this.dayInfo, ()=>{});
          }
        });

        this.selectedDayInfo = selectedDayInfo;
      });


      this.dateArr = this.dateArr.map((item: WeekDateModel) => {
        if (item.dateStr == selectedDayInfo.dateStr) {
          item.accountingList = selectedDayInfo.accountingList;
          item.dayInfo = selectedDayInfo.dayInfo;
          return item;
        }
        else {
          return item;
        }
      })

      return;
    }
    else {
      if (selectedDayInfo.accountingList.length > 0) {
        selectedDayInfo.dayInfo = this.setSelectedDayBalance(selectedDayInfo.accountingList, selectedDayInfo.dayInfo);
      }
      this.selectedDayInfo = selectedDayInfo;
    }
  }

  // 当用户添加或修改记录时，更新内存中的数据
  public updateAccountingInfoList(addAccountingStr: string) {
    let addAccountingInfo:AccountingInfo = JSON.parse(addAccountingStr);
    let filterAccountingList = this.selectedDayInfo.accountingList.filter((item: AccountingInfo) => item.id === addAccountingInfo.id);

    if (filterAccountingList.length > 0) { // 确认是否是修改记账记录
      if (addAccountingInfo.date === this.selectedDayInfo.dateStr) { // 确认有没有修改记账日期
        this.selectedDayInfo.accountingList = this.selectedDayInfo.accountingList.map((item: AccountingInfo) => {
          if (addAccountingInfo.id === item.id) {
            item = addAccountingInfo;
            return item;
          }
          return item;
        });
        this.accountingList = this.selectedDayInfo.accountingList;
        AccountingInfoApi.updateData(addAccountingInfo, () => {
        });
        this.dayInfo.date = addAccountingInfo.date;
        this.dayInfo = this.setSelectedDayBalance(this.selectedDayInfo.accountingList, this.dayInfo);
        this.selectedDayInfo.dayInfo = this.dayInfo;
        DayInfoApi.updateData(this.dayInfo, () => {});

        return;
      }
      else { // 修改了记账日期则删除
        this.selectedDayInfo.accountingList = this.selectedDayInfo.accountingList.filter(item => item.id !== addAccountingInfo.id);
        this.selectedDayInfo.dayInfo = this.setSelectedDayBalance(this.selectedDayInfo.accountingList, this.selectedDayInfo.dayInfo);
        this.accountingList = this.selectedDayInfo.accountingList;
        this.dayInfo = this.selectedDayInfo.dayInfo;
      }
    }


    let filteredItems = this.dateArr.filter(item => item.dateStr === addAccountingInfo.date);
    let weekDateInfo = filteredItems.length > 0 ? filteredItems[0] : undefined;

    if (!weekDateInfo || weekDateInfo.dateStr === '') { // 判断插入数据的当天是否已经存在数据
      weekDateInfo = new WeekDateModel(weekDateFormat(new Date(addAccountingInfo.date).getTime()), addAccountingInfo.date, new Date(addAccountingInfo.date));
      let accountingList: Array<AccountingInfo> = [];
      accountingList.push(addAccountingInfo);
      let dayInfo = new DayInfo(addAccountingInfo.date, 0, 0);
      if (addAccountingInfo.typeName === 'expense') {
        dayInfo.expense += addAccountingInfo.amount;
      }
      else if (addAccountingInfo.typeName === 'income') {
        dayInfo.income += addAccountingInfo.amount;
      }
      DayInfoApi.updateData(dayInfo, (result: number) => {
        if (result <= 0) {
          DayInfoApi.insertData(dayInfo, () => {
          })
        }
      });

      weekDateInfo.dayInfo = dayInfo;
      weekDateInfo.accountingList = accountingList;
      this.dateArr.push(weekDateInfo);

      // 将DateArr按日期排序
      this.dateArr.sort((a, b) => a.date.getTime() - b.date.getTime());

      if (addAccountingInfo.date === dateToStr(new Date(this.showDate))) {
        this.selectedDayInfo.accountingList = accountingList;
        this.selectedDayInfo.dayInfo = dayInfo;
      }

    }
    else {
      this.dateArr = this.dateArr.map((item: WeekDateModel) => { // 存在则修改其中的数据
        if (item.dateStr === addAccountingInfo.date) {
          item.accountingList.push(addAccountingInfo); // 插入记账信息

          if (addAccountingInfo.typeName === 'expense') { // 更新每日结余信息
            item.dayInfo.expense += addAccountingInfo.amount;
          }
          else if (addAccountingInfo.typeName === 'income') {
            item.dayInfo.income += addAccountingInfo.amount;
          }

          DayInfoApi.updateData(item.dayInfo, (result: number) => { // 更新DayInfo数据
            if (result <= 0) { // 若不存在则新插入一个DayInfo
              DayInfoApi.insertData(item.dayInfo, () => {
              })
            }
          });

          if (addAccountingInfo.date === dateToStr(new Date(this.showDate))) {
            this.selectedDayInfo.accountingList = item.accountingList;
            this.selectedDayInfo.dayInfo = item.dayInfo;
          }

          return item;
        }
        return item;
      })
    }
  }

  // 侧滑删除单个记账信息
  public deleteAccountingItem (accountingInfoStr: string) {
    let accountingInfo: AccountingInfo = JSON.parse(accountingInfoStr);
    this.selectedDayInfo.accountingList = this.selectedDayInfo.accountingList.filter((item: AccountingInfo) => accountingInfo.id !== item.id);
    this.selectedDayInfo.dayInfo = this.setSelectedDayBalance(this.selectedDayInfo.accountingList, this.selectedDayInfo.dayInfo);
    this.accountingList = this.selectedDayInfo.accountingList;
    this.dayInfo = this.selectedDayInfo.dayInfo;

    AccountingInfoApi.deleteData(accountingInfo, ()=>{});
    DayInfoApi.updateData(this.dayInfo, ()=>{});

    this.dateArr.map((selectedDate: WeekDateModel) => {
      if (selectedDate.dateStr === this.selectedDayInfo.dateStr) {
        selectedDate.accountingList = this.selectedDayInfo.accountingList;
        selectedDate.dayInfo = this.selectedDayInfo.dayInfo;
        return selectedDate;
      }
      return selectedDate;
    })


  }

  // 获取本日结余
  public getBalance(): string {
    let dayInfo = this.selectedDayInfo?.dayInfo;

    if (dayInfo) { // 如果选中的天存在，即没有选中未来的天数
      let res: number = dayInfo.income - dayInfo.expense;
      return res.toString();
    }

    return '0';
  }

  // 记录结余
  public setSelectedDayBalance(accountingList: AccountingInfo[], dayInfo: DayInfo): DayInfo {
    let expense: number = 0;
    let income: number = 0;
    for (let i = 0; i < accountingList.length; i++) {
      if (accountingList[i].typeName === 'expense') {
        expense += accountingList[i].amount;
      }
      else if (accountingList[i].typeName === 'income') {
        income += accountingList[i].amount;
      }
    }

    dayInfo.income = income;
    dayInfo.expense = expense;
    return dayInfo;
  }

  // 获取本日记账详情
  public getAccountingListOfDay(): AccountingInfo[] {
    if (this.selectedDayInfo && this.selectedDayInfo.accountingList.length > 0) { // 若信息存在且长度不为0
      return this.selectedDayInfo.accountingList;
    }
    return [];
  }

  // 获取某月记账列表
  public getAccountingListOfMouth(year: string, mouth: string): string {
    this.customAccountingList = this.dateArr.reduce((accumulator, item) => {
      if ((item.date.getMonth() + 1).toString() === mouth && (item.date.getFullYear()).toString() === year) {
        accumulator = accumulator.concat(item.accountingList);
      }
      return accumulator;
    }, []);

    // 计算结余信息
    this.customDayInfo = this.setSelectedDayBalance(this.customAccountingList, this.customDayInfo)

    return JSON.stringify(this.customAccountingList);
  }

  // 获取某年记账列表
  public getAccountingListOfYear(year: string): string {
    this.customAccountingList = this.dateArr.reduce((accumulator, item) => {
      if (item.date.getFullYear().toString() === year) {
        accumulator = accumulator.concat(item.accountingList);
      }
      return accumulator;
    }, []);

    // 计算结余信息
    this.customDayInfo = this.setSelectedDayBalance(this.customAccountingList, this.customDayInfo)

    return JSON.stringify(this.customAccountingList);
  }

  // 获取所有的记账列表
  public getAccountingListOfAll(): string {
    // 使用 reduce 将所有 accountingList 拼接成一个数组
    this.customAccountingList = this.dateArr.reduce((accumulator, item) => {
      // 将 item.accountingList 拼接到累积器中
      return accumulator.concat(item.accountingList);
    }, []);

    // 计算结余信息
    this.customDayInfo = this.setSelectedDayBalance(this.customAccountingList, this.customDayInfo)

    return JSON.stringify(this.customAccountingList);

  }

  // 获取用户自定义日期的记账记录
  public getAccountingListOfCustomDate(startDate: number, endDate: number): string {
    this.customAccountingList = this.dateArr.reduce((accumulator: AccountingInfo[], item: WeekDateModel) => {
      let dateTime = item.date.getTime();
      if (dateTime >= startDate && dateTime <= endDate) {
        accumulator = accumulator.concat(item.accountingList);
      }
      return accumulator;
    }, []);

    // 计算结余信息
    this.customDayInfo = this.setSelectedDayBalance(this.customAccountingList, this.customDayInfo)

    return JSON.stringify(this.customAccountingList);

  }

  // 获取用户自定义的记账记录
  public getAccountingListOfCustom(min: number, max: number, categoryListStr: string);
  public getAccountingListOfCustom(min: number, max: number);
  public getAccountingListOfCustom(categoryListStr: string);
  public getAccountingListOfCustom(...args: any[]){
    let selectedList: AccountingInfo[] = this.customAccountingList;
    // if (detailType === 'mouth') {
    //   selectedList = this.mouthAccountingList;
    // }
    // else if (detailType === 'year') {
    //   selectedList = this.yearAccountingList;
    // }
    // else if (detailType === 'all') {
    //   selectedList = this.allAccountingList;
    // }
    // else if (detailType === 'custom') {
    //   selectedList = this.customAccountingList;
    // }
    if (args.length === 1 && typeof args[0] === 'string') {
      // 只传递了一个参数，并且是数组，表示传递了分类列表字符串
      const categoryListStr = args[0];
      let categoryList: CategoryInfo[] = JSON.parse(categoryListStr)
      let categoryStrList: string[] = categoryList.map(( item: CategoryInfo) => {
        return item.category;
      })
      this.customAccountingList = selectedList.filter((accountingInfo) => {
        return categoryList.length === 0 || categoryStrList.includes(accountingInfo.category);
      });
    } else if (args.length === 2 && typeof args[0] === 'number' && typeof args[1] === 'number') {
      // 传递了两个参数，都是数字，表示传递了金额范围
      const min = args[0];
      const max = args[1];
      this.customAccountingList = selectedList.filter((accountingInfo) => {
        return accountingInfo.amount >= min && accountingInfo.amount <= max;
      });
    } else if (args.length === 3 && typeof args[0] === 'number' && typeof args[1] === 'number' && typeof args[2] === 'string') {
      // 传递了三个参数，前两个是数字，第三个是数组，表示同时传递了金额范围和分类列表字符串
      let min: number = args[0];
      let max = args[1];
      let categoryListStr: string = args[2];
      let categoryList: CategoryInfo[] = JSON.parse(categoryListStr)
      let categoryStrList: string[] = categoryList.map(( item: CategoryInfo) => {
        return item.category;
      })
      this.customAccountingList = selectedList.filter((accountingInfo) => {
        const amountInRange = accountingInfo.amount >= min && accountingInfo.amount <= max;
        const categoryMatched = categoryList.length === 0 || categoryStrList.includes(accountingInfo.category);
        return amountInRange && categoryMatched;
      });
    } else {
      this.customAccountingList = [];
    }

    // 计算结余信息
    this.customDayInfo = this.setSelectedDayBalance(this.customAccountingList, this.customDayInfo)
    return JSON.stringify(this.customAccountingList);
  }

  // 获取账单的日期信息
  public getCustomDateList(): number[] {
    // 先清空 customDateList 数组，以便重新填充
    this.customDateList = [];

    // 遍历 customAccountingList
    this.customAccountingList.forEach((accountingInfo: AccountingInfo) => {
      // 提取账单的日期
      const date = new Date(accountingInfo.date);
      // 将日期的时间戳添加到 customDateList
      this.customDateList.push(date.getTime());
    });

    // 使用 Set 数据结构去重
    this.customDateList = Array.from(new Set(this.customDateList));

    return this.customDateList;
  }

  // 获取结余
  public getCustomBalance(): string {
    let dayInfo = this.customDayInfo;

    if (dayInfo) {
      let res: number = dayInfo.income - dayInfo.expense;
      return res.toString();
    }

    return '0';
  }

  // 获取支出
  public getExpense(): string {
    return this.customDayInfo.expense.toString();
  }

  // 获取收入
  public getIncome(): string {
    return this.customDayInfo.income.toString();
  }

}

