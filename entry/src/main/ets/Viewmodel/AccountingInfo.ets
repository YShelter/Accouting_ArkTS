


// 储存记账信息的数据结构
export default class AccountingInfo {
  id: number;
  date: string;
  amount: number;
  category: string;
  typeName: string;
  icon: string;
  remark: string;

   constructor(id: number, date: string, amount: number, category: string, typeName: string, icon: string, remark: string,) {
    this.id = id;
    this.date = date;
    this.amount = amount;
    this.category = category;
    this.typeName = typeName;
    this.icon = icon;
    this.remark = remark;
  }

}