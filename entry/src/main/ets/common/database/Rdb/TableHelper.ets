
import ColumnInfo from '../ColunmInfo';

class TableHelper {

  // 生成创建数据表的SQL语句
  createTableSql(tableName: string, columns: Array<ColumnInfo>): string {
    let sql = `create table if not exists ${tableName}(`;
    for (let column of columns) {
      sql = sql.concat(`${column.name} ${column.type}`);
      sql = sql.concat(`${column.length && column.length > 0 ? `(${column.length})` : ''}`);
      sql = sql.concat(`${column.primary ? ' primary key' : ''}`);
      sql = sql.concat(`${column.autoincrement ? ' autoincrement' : ''}`);
      sql = sql.concat(`${column.nullable ? '' : ' not null'}`);
      sql = sql.concat(', ');
    }
    sql = `${sql.substring(0, sql.length - 2)})`;
    return sql;
  }

  // 生成添加新的一列的sql语句
  addTableColumnSql(tableName: string, column: ColumnInfo): string {
    let sql = `alter table ${tableName} add `;
    sql = sql.concat(`${column.name} ${column.type}`);
    sql = sql.concat(`${column.length && column.length > 0 ? `(${column.length})` : ''}`);
    return sql;
  }

  // 生成删除表格的sql语句
  deleteTableSql(tableName: string): string {
    return `drop table if exists ${tableName}`;
  }
}

const tableHelper = new TableHelper();

export default tableHelper;