
import AccountingInfo from '../../../Viewmodel/AccountingInfo';
import dataRdb from '@ohos.data.relationalStore';
import { CommonConstants as Const } from '../../constants/CommonConstants';
import RdbUtils from '../Rdb/RdbUtils';
import hilog from '@ohos.hilog';

class AccountingInfoApi {
  // 插入数据
  insertData(accountingInfo: AccountingInfo, callback: Function): void {
    const valueBucket =generateBucket(accountingInfo);
    RdbUtils.insert(Const.ACCOUNTING_INFO.tableName, valueBucket).then(result => {
      callback(result);
    })
  }

  // 删除数据
  deleteData(accountingInfo: AccountingInfo, callback: Function): void {
    let predicates = new dataRdb.RdbPredicates(Const.ACCOUNTING_INFO?.tableName);
    predicates.equalTo('date', accountingInfo.date).and().equalTo('id',accountingInfo.id);
    RdbUtils.del(predicates).then(result => {
      callback(result);
    })
  }

  // 更新数据
  updateData(accountingInfo: AccountingInfo, callback: Function): void {
    const valueBucket = generateBucket(accountingInfo);
    let predicates = new dataRdb.RdbPredicates(Const.ACCOUNTING_INFO.tableName);
    predicates.equalTo('id', accountingInfo.id);
    RdbUtils.update(valueBucket, predicates).then(result => {
      callback(result);
    })
  }

  // 查询所有记账记录
  queryAllDate(callback): void {
    RdbUtils.queryAll(Const.ACCOUNTING_INFO.tableName).then(resultSet => {
      let count = resultSet.rowCount;
      if (count <= 0) {
        const result: AccountingInfo[] = [];
        callback(result);
      }
      else {
        resultSet.goToFirstRow();
        const result: AccountingInfo[] = [];
        for (let i = 0; i < count; i++) {
          let tem = new AccountingInfo(0, '', 0, '', '', '', '');
          tem.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tem.date = resultSet.getString(resultSet.getColumnIndex('date'));
          tem.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          tem.category = resultSet.getString(resultSet.getColumnIndex('category'));
          tem.icon = resultSet.getString(resultSet.getColumnIndex('icon'));
          tem.remark = resultSet.getString(resultSet.getColumnIndex('remark'));
          tem.typeName = resultSet.getString(resultSet.getColumnIndex('typeName'));
          result[i] = tem;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    })
  }

  // 查询某天的记账记录
  query(date: string, callback: Function): void {
    let predicates = new dataRdb.RdbPredicates(Const.ACCOUNTING_INFO.tableName);
    predicates.equalTo('date', date);
    RdbUtils.query(predicates).then(resultSet => {
      let count = resultSet.rowCount;
      if (count <= 0) {
        const result: AccountingInfo[] = [];
        callback(result);
      }
      else {
        resultSet.goToFirstRow();
        const result: AccountingInfo[] = [];
        for (let i = 0; i < count; i++) {
          let tem = new AccountingInfo(0, '', 0, '', '', '', '');
          tem.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tem.date = resultSet.getString(resultSet.getColumnIndex('date'));
          tem.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'));
          tem.category = resultSet.getString(resultSet.getColumnIndex('category'));
          tem.icon = resultSet.getString(resultSet.getColumnIndex('icon'));
          tem.remark = resultSet.getString(resultSet.getColumnIndex('remark'));
          tem.typeName = resultSet.getString(resultSet.getColumnIndex('typeName'));
          result[i] = tem;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    })
  }

}

function generateBucket(accountingInfo: AccountingInfo): dataRdb.ValuesBucket {
  let valueBucket = {} as dataRdb.ValuesBucket;
  Const.ACCOUNTING_INFO.columns?.forEach((item: string) => {
    if (item !== 'id') {
      switch (item) {
        case 'date':
          valueBucket[item] = accountingInfo.date;
          break;
        case 'category':
          valueBucket[item] = accountingInfo.category;
          break;
        case 'amount':
          valueBucket[item] = accountingInfo.amount;
          break;
        case 'typeName':
          valueBucket[item] = accountingInfo.typeName;
          break;
        case 'icon':
          valueBucket[item] = accountingInfo.icon;
          break;
        case 'remark':
          valueBucket[item] = accountingInfo.remark;
          break;
        default:
          break;
      }
    }
  });
  return valueBucket;
}

let accountingInfoApi = new AccountingInfoApi();

export default accountingInfoApi as AccountingInfoApi;