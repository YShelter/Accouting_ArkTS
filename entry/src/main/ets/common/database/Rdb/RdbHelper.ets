
import dataRdb from '@ohos.data.relationalStore';
import ColumnInfo from '../ColunmInfo';

// 数据库操作工具类
export interface RdbHelper {
  /**
   * 获取数据库的名称。
   * 返回数据库名称
   */
  getDbName(): string;

  /**
   * 获取RDB。
   * @param context - 表示应用程序或功能的上下文。
   * @返回RDB。
   */
  getRdb(context: Context): Promise<RdbHelper>;

  /**
   * 在数据库中执行SQL语句。
   * @param sql - 表示要执行的SQL语句。
   */
  executeSql(sql: string): Promise<void>;

  /**
   * 在数据库中创建表。
   * @param tableName - 表示目标表名。
   * @param columns - 要修改的列。
   * @returns
   */
  createTable(tableName: string, columns: Array<ColumnInfo>): Promise<void>;

  /**
   * 基于表名在数据库中删除表。
   * @param tableName - 表示目标表。
   * @returns
   */
  deleteTable(tableName: string): Promise<void>;

  /**
   * 基于表名在数据库中修改表。
   * @param tableName - 表示目标表。
   * @param column - 要修改的列。
   * @returns
   */
  addTableColumn(tableName: string, column: ColumnInfo): Promise<void>;

  /**
   * 将一行数据或一批数据插入目标表中。
   * @param tableName - 表示目标表。
   * @param values - 表示要插入到表中的数据行{@link ValuesBucket}。
   * @returns 受影响的行数。
   */
  insert(tableName: string, values: dataRdb.ValuesBucket | Array<dataRdb.ValuesBucket>): Promise<number>;

  /**
   * 根据指定的RdbPredicates实例对象更新数据库中的数据。
   * @param values - 表示要插入到表中的数据行ValuesBucket。
   * @param rdbPredicates - 由RdbPredicates实例对象指定的更新条件。
   * @returns 受影响的行数。
   */
  update(values: dataRdb.ValuesBucket, rdbPredicates: dataRdb.RdbPredicates): Promise<number>;

  /**
   * 基于指定条件在数据库中查询数据。
   * @param rdbPredicates - 由{@link RdbPredicates}实例对象指定的查询条件。
   * @param columns - 要查询的列。如果值为空数组，则查询适用于所有列。
   * @returns 如果操作成功，将返回{@link ResultSet}对象。
   */
  query(rdbPredicates: dataRdb.RdbPredicates, columns?: Array<string>): Promise<dataRdb.ResultSet>;

  /**
   * 基于表名在数据库中查询数据。
   * @param tableName - 表示目标表。
   * @returns 如果操作成功，将返回ResultSet对象。
   */
  queryAll(tableName: string): Promise<dataRdb.ResultSet>;

  /**
   * 基于SQL语句在数据库中查询数据。
   * @param sql - 表示要执行的SQL语句。
   * @param bindArgs - 表示SQL语句中参数的值。这些值为字符串。
   * @returns 如果操作成功，将返回{@link ResultSet}对象。
   */
  queryBySql(sql: string, bindArgs?: Array<dataRdb.ValueType>): Promise<dataRdb.ResultSet>;

  /**
   * 基于指定条件在数据库中删除数据。
   * @param rdbPredicates - 由RdbPredicates实例对象指定的删除条件。
   * @returns 受影响的行数。
   */
  delete(rdbPredicates: dataRdb.RdbPredicates): Promise<number>;
}