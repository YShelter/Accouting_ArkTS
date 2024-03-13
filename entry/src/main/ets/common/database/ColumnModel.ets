
import ColumnInfo from './ColunmInfo'

export const columnDayInfoList: Array<ColumnInfo> = [
  new ColumnInfo('date', 'text', -1, false, true, false),
  new ColumnInfo('expense', 'integer', -1, false, false, false),
  new ColumnInfo('income', 'integer', -1, false, false, false)
]

export const columnAccountingInfoList: Array<ColumnInfo> = [
  new ColumnInfo('id', 'integer', -1, false, true, true),
  new ColumnInfo('category', 'text', -1, false, false, false),
  new ColumnInfo('amount', 'integer', -1, false, false, false),
  new ColumnInfo('date', 'text', -1, false, false, false),
  new ColumnInfo('typeName', 'text', -1, false, false, false),
  new ColumnInfo('icon', 'text', -1, false, false, false),
  new ColumnInfo('remark', 'text', -1, true, false, false),

]

export const columnCategoryInfoList: Array<ColumnInfo> = [
  new ColumnInfo('category', 'text', -1, false, true, false),
  new ColumnInfo('icon', 'text', -1, false, false, false),
  new ColumnInfo('ordinal', 'integer', -1, false, false, false),
  new ColumnInfo('typeName', 'text', -1, false, false, false),
]