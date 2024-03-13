

// 统计每日记账信息

export default class DayInfo {
  date: string;
  expense: number = 0;
  income: number = 0;

  constructor(date: string, expense: number, income: number) {
    this.date = date;
    this.expense = expense;
    this.income = income;
  }
}