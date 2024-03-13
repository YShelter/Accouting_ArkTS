
import AccountingInfo from '../Viewmodel/AccountingInfo';
import DayInfo from '../Viewmodel/DayInfo';

export  class WeekDateModel {
  weekTitle: string; // 日期信息 年月日星期
  dateStr: string;  // 字符串格式日期
  date: Date;
  accountingList: Array<AccountingInfo> = [] as Array<AccountingInfo>; // 记账信息
  dayInfo: DayInfo = new DayInfo('', 0, 0) as DayInfo; // 每日结余

  constructor(weekTitle: string, dateStr: string, date: Date) {
    this.weekTitle = weekTitle;
    this.dateStr = dateStr;
    this.date = date;
    this.accountingList = [];
    this.dayInfo = new DayInfo(dateStr, 0 , 0);
  }

}





