
import dataRdb from '@ohos.data.relationalStore';
import tableHelper from './TableHelper';
import { RdbHelper } from './RdbHelper';
import ColumnInfo from '../ColunmInfo';

export class RdbHelperImp implements RdbHelper {
  private mDatabaseName: string;
  private rdbStore: dataRdb.RdbStore = {} as dataRdb.RdbStore;
  private storeConfig: dataRdb.StoreConfig = {  name: '', securityLevel: dataRdb.SecurityLevel.S1 } as dataRdb.StoreConfig;

  constructor(databaseName: string) {
    this.mDatabaseName = databaseName;
  }

  getDbName(): string {
    return this.mDatabaseName;
  }

  // 获取一个RdbStore来操作关系型数据库
  getRdb(context: Context): Promise<RdbHelper> {
    this.storeConfig = {
      // 配置数据库文件名、安全级别
      name: this.mDatabaseName, securityLevel: dataRdb.SecurityLevel.S1
    };
    return new Promise<RdbHelper>((success, error) => {
      dataRdb.getRdbStore(context, this.storeConfig).then(dbStore => {
        this.rdbStore = dbStore;
        success(this);
      }).catch((err: Error) => {
        error(err);
      })
    })
  }

  // 执行SQL语句
  executeSql(sql: string): Promise<void> {
    return this.rdbStore.executeSql(sql);
  }

  // 上层接口
  // 调用 createTableSql 生成 sql 语句， executeSql 执行
  createTable(tableName: string, columns: Array<ColumnInfo>): Promise<void> {
    let createTableSql = tableHelper.createTableSql(tableName, columns);
    return this.executeSql(createTableSql);
  }

  // 上层接口
  // 调用 deleteTableSql 生成 sql 语句， executeSql 执行
  deleteTable(tableName: string): Promise<void> {
    let deleteTableSql = tableHelper.deleteTableSql(tableName);
    return this.executeSql(deleteTableSql);
  }

  // 上层接口 向表格中添加一行属性
  // 调用 addTableColumnSql 生成 sql 语句， executeSql 执行
  addTableColumn(tableName: string, column: ColumnInfo): Promise<void> {
    let addTableColumnSql = tableHelper.addTableColumnSql(tableName, column);
    return this.executeSql(addTableColumnSql);
  }

  // 插入数据
  // 若为多组数据则调用 batchSaveDate ，否则直接插入
  insert(tableName: string, values: dataRdb.ValuesBucket | Array<dataRdb.ValuesBucket>): Promise<number> {
    return new Promise<number>((success, error) => {
      if (!values) { // 检查插入数据是否为空
        error(0);
        return;
      }
      if (values instanceof Array) { // 检查values是否为多个数据// 开始数据库事务
        this.rdbStore.beginTransaction();
        this.batchSaveDate(tableName, values).then(data => {
          console.info(`insert success, data : ${JSON.stringify(data)}`);
          success(data);
          this.rdbStore.commit();
        }).catch((err: Error) => {
          console.error('错误', err.name, err.message)
          error(err);
          this.rdbStore.commit();
        })
      } else { // 为一组数据则直接插入
        this.rdbStore.insert(tableName, values).then(data => {
          console.info(`insert success, data : ${JSON.stringify(data)}`);
          success(data);
          this.rdbStore.commit();
        }).catch((err: Error) => {
          console.error(`insert failed, err : ${JSON.stringify(err)}`);
          error(err);
          this.rdbStore.commit();

        })
      }
    })
  }

  // private saveArray(tableName: string, values: Array<dataRdb.ValuesBucket>): Promise<number> {
  //   return new Promise<number>((success, error) => {
  //     if (!values || values.length === 0) { // 若数据为空则返回错误，0
  //       error(0);
  //       return;
  //     }
  //     let index = 0
  //     let callback = (data: number, err: Error) => {
  //       if (err) {
  //         Logger.info(`saveArray failed, err : ${err}`);
  //         error(err);
  //         return;
  //       }
  //       if (data) {
  //         if (index < values.length - 1) {
  //           this.saveData(tableName, values, ++index, callback);
  //         } else {
  //           success(data);
  //         }
  //       }
  //     }
  //     this.saveData(tableName, values, index, callback);
  //   })
  // }
  //
  // // 将一组数据插入表中
  // private saveData(tableName: string, values: Array<dataRdb.ValuesBucket>, index: number, callback: Function): void   {
  //   Logger.info(`saveData tableName : ${tableName}, index : ${JSON.stringify(index)}`);
  //   this.rdbStore.insert(tableName, values[index]).then((data: number) => {
  //     Logger.info(`saveData success id : ${data}`);
  //     callback(data);
  //   }).catch((err: Error) => {
  //     Logger.error(`saveData failed, err : ${err}`);
  //     callback(err);
  //   })
  // }

  // 将多组数据插入到表中
  private batchSaveDate(tableName: string, values: Array<dataRdb.ValuesBucket>): Promise<number> {
    return new Promise<number> ((success, error) => {
      if (!values || values.length === 0) { // 若数据为空则返回错误，0
        error(0);
        return;
      }
      // 调用batchInsert接口插入多组数据
      this.rdbStore.batchInsert(tableName, values, function(err, data) {
        if (err) {
          error(err)
        }
        success(data)
      })
    })
  }

  // 修改表格中的数据
  update(values: dataRdb.ValuesBucket, rdbPredicates: dataRdb.RdbPredicates): Promise<number> {
    return this.rdbStore.update(values, rdbPredicates);
  }

  // 查询表格中某一列或者几列的数据的数据
  query(rdbPredicates: dataRdb.RdbPredicates, columns?: Array<string>): Promise<dataRdb.ResultSet> {
    return this.rdbStore.query(rdbPredicates, columns);
  }

  // 查询表格中的所有数据
  queryAll(tableName: string): Promise<dataRdb.ResultSet> {
    return this.rdbStore.querySql(`select * from ${tableName}`);
  }

  // 通过sql语句查询数据
  queryBySql(sql: string, bindArgs?: Array<dataRdb.ValueType>): Promise<dataRdb.ResultSet> {
    return this.rdbStore.querySql(sql, bindArgs);
  }

  // 删除表格中的数据
  delete(rdbPredicates: dataRdb.RdbPredicates): Promise<number> {
    return this.rdbStore.delete(rdbPredicates);
  }
}
