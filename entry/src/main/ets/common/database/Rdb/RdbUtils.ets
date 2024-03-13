
import dataRdb from '@ohos.data.relationalStore';
import { RdbHelper } from './RdbHelper';
import { RdbHelperImp } from './RdbHelperImp';
import ColumnInfo from '../ColunmInfo';

let dbContext: Context;
let mDatabaseName: string = '';

export class RdbUtils {
  private rdbHelpers = new Map<string, RdbHelper>();

  initDb(context: Context, databaseName: string) {
    dbContext = context;
    mDatabaseName = databaseName;
  }

  // 创建或获取一个数据库连接工具
  getDb(): Promise<RdbHelper> {
    return new Promise<RdbHelper>((success, error) => {
      let dbName = mDatabaseName;
      if (!dbContext || !dbName || dbName.length === 0) { // 检查上下文和数据库名是否为空
        error("init err");
        return;
      }
      let dbHelper = this.rdbHelpers.get(dbName); // 获取一个操作数据库的工具类
      if (!dbHelper) { // 不存在则重新创建一个
        let rdbHelper: RdbHelper = new RdbHelperImp(dbName);
        rdbHelper.getRdb(dbContext).then(data => {
          this.rdbHelpers.set(dbName, data);
          success(data);
        }).catch((err: Error) => {
          error(err);
        })
      } else { // 存在则直接返回以存在的工具类
        success(dbHelper);
      }
    })
  }

  // 删除数据库
  deleteDb(context: Context, dbName: string): Promise<void> {
    this.rdbHelpers.delete(dbName); // 将存在的数据库连接工具从内存中删除
    return dataRdb.deleteRdbStore(context, dbName);
  }

  // 创建表格
  createTable(tableName: string, columns: Array<ColumnInfo>): Promise<void> {
    return this.getDb().then(dbHelper => {
      return dbHelper.createTable(tableName, columns);
    });
  }

  // 确认创建
  isCreateTable(tableName: string, columns: Array<ColumnInfo>): Promise<boolean> {
    return this.createTable(tableName, columns).then(() => {
      return true;
    }).catch((error: Error) => {
      return false;
    });
  }

  // 删除表格
  deleteTable(tableName: string): Promise<void> {
    return this.getDb().then(dbHelper => {
      return dbHelper.deleteTable(tableName);
    })
  }

  // 执行 sql 语句
  executeSql(sql: string): Promise<void> {
    return this.getDb().then(dbHelper => {
      return dbHelper.executeSql(sql);
    })
  }

  // 向表格中添加一行属性
  addTableColumn(tableName: string, column: ColumnInfo): Promise<void> {
    return this.getDb().then(dbHelper => {
      return dbHelper.addTableColumn(tableName, column);
    })
  }

  // 插入数据
  insert(tableName: string, values: dataRdb.ValuesBucket | Array<dataRdb.ValuesBucket>): Promise<number> {
    return this.getDb().then(dbHelper => {
      return dbHelper.insert(tableName, values);
    })
  }

  // 更新数据
  update(values: dataRdb.ValuesBucket, rdbPredicates: dataRdb.RdbPredicates): Promise<number> {
    return this.getDb().then(dbHelper => {
      return dbHelper.update(values, rdbPredicates);
    })
  }

  // 查询数据
  query(rdbPredicates: dataRdb.RdbPredicates, columns?: Array<string>): Promise<dataRdb.ResultSet> {
    return this.getDb().then(dbHelper => {
      return dbHelper.query(rdbPredicates, columns);
    })
  }

  // 查询所有数据
  queryAll(tableName: string): Promise<dataRdb.ResultSet> {
    return this.getDb().then(dbHelper => {
      return dbHelper.queryAll(tableName);
    })
  }

  // 通过 sql 语句查询数据
  queryBySql(sql: string, bindArgs?: Array<dataRdb.ValueType>): Promise<dataRdb.ResultSet> {
    return this.getDb().then(dbHelper => {
      return dbHelper.queryBySql(sql, bindArgs);
    })
  }

  // 删除数据
  del(rdbPredicates: dataRdb.RdbPredicates): Promise<number> {
    return this.getDb().then(dbHelper => {
      return dbHelper.delete(rdbPredicates);
    })
  }
}

let rdbUtils = new RdbUtils();

export default rdbUtils as RdbUtils;