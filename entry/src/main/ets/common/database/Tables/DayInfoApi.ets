
import dataRdb from '@ohos.data.relationalStore';
import DayInfo from '../../../Viewmodel/DayInfo';
import { CommonConstants as Const } from '../../constants/CommonConstants'
import RdbUtils from '../Rdb/RdbUtils';


// 与每日结余相关的数据库操作
class DayInfoApi {

  // 插入数据
  insertData(dayInfo: DayInfo, callback: Function): void {
    const valueBucket = generateBuket(dayInfo);
    RdbUtils.insert('dayInfo', valueBucket).then(result => {
      callback(result);
    })
  }

  // 更新数据
  updateData(dayInfo: DayInfo, callback: Function): void {
    const valueBucket = generateBuket(dayInfo);
    let predicates: dataRdb.RdbPredicates = new dataRdb.RdbPredicates('dayInfo');
    predicates.equalTo('date', dayInfo.date);
    RdbUtils.update(valueBucket, predicates).then((result: number) => {
      callback(result);
    })
  }

  // 根据日期查询单个数据
  // 若不存在则初始化一个数据
  query(date: string, callback: Function): void {
    let predicates: dataRdb.RdbPredicates = new dataRdb.RdbPredicates(Const.DAY_INFO.tableName);
    predicates.equalTo('date', date);
    RdbUtils.query(predicates).then((resultSet) => {
      let count: Number = resultSet.rowCount;
      if (count === -1) {
        let result = new DayInfo(date, 0, 0);
        this.insertData(result,()=>{}); // 查询数据不存在则插入一个新的数据
        callback(result);
      }
      else {
        let result = new DayInfo('', 0, 0);
        resultSet.goToFirstRow();
        result.date = resultSet.getString(resultSet.getColumnIndex('date'));
        result.expense = resultSet.getDouble(resultSet.getColumnIndex('expense'));
        result.income = resultSet.getDouble(resultSet.getColumnIndex('income'));
        callback(result);
      }
      return;
    })
  }

  // 查询多组数据
  queryList(dates: string[], callback: Function): void {
    let predicates: dataRdb.RdbPredicates = new dataRdb.RdbPredicates('dayInfo');
    predicates.in('date', dates);
    RdbUtils.query(predicates).then((resultSet) => {
      let count: Number = resultSet.rowCount;
      if (count <= 0) {
        let result: DayInfo[] = [];
        callback(result);
      }
      else {
        let result: DayInfo[] = [];
        resultSet.goToFirstRow();
        for (let i = 0; i < count; i++) {
          let tmp = new DayInfo('', 0, 0);
          tmp.date = resultSet.getString(resultSet.getColumnIndex('date'));
          tmp.expense = resultSet.getDouble(resultSet.getColumnIndex('expense'));
          tmp.income = resultSet.getDouble(resultSet.getColumnIndex('income'));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
      return;
    })
  }
}

// 生成储存要插入数据的桶
function generateBuket(dayInfo: DayInfo): dataRdb.ValuesBucket {
  let valueBucket = {} as dataRdb.ValuesBucket;
  Const.DAY_INFO.columns?.forEach((item: string) =>{
    switch (item) {
      case 'date':
        valueBucket.date = dayInfo.date;
        break;
      case 'expense':
        valueBucket.expense = dayInfo.expense;
        break;
      case 'income':
        valueBucket.income = dayInfo.income;
        break;
      default:
        break;
    }
  });
  return valueBucket;
}

let dayInfoApi = new DayInfoApi();

export default dayInfoApi as DayInfoApi;