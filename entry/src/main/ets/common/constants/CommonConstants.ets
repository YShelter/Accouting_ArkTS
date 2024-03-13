import CommonConstantsInfo from '../../viewmodel/CommonConstantsInfo';

export enum AccountingType {
  expense, income
}

export enum AccountingTypeCN {
  '支出区', '收入区'
}

export enum DetailType {
  mouth, year, all, customDate, custom,
}

export enum DetailTypeCN {
  '月度账单', '年度账单', '总账单', '自定义'
}

// 一般属性信息
export class CommonConstants {
  static readonly RDB_NAME = { dbName: 'recordingInfo.db' } as CommonConstantsInfo; // db name

  /** 每日记账信息统计表 */
  static readonly DAY_INFO = {
    tableName: 'dayInfo',
    columns: ['date', 'expense', 'income']
  } as CommonConstantsInfo

  static readonly ACCOUNTING_INFO = {
    tableName: 'accountingInfo',
    columns: ['id', 'date', 'amount', 'category', 'typeName', 'icon', 'remark']
  } as CommonConstantsInfo

  static readonly CATEGORY_INFO = {
    tableName: 'categoryInfo',
    columns: ['category', 'icon', 'index', 'typeName']
  } as CommonConstantsInfo

  // THOUSANDTH
  static readonly THOUSANDTH_15: string = '1.5%'; // ‘1.5%’
  static readonly THOUSANDTH_12: string = '2.2%'; // ‘2.2%’
  static readonly THOUSANDTH_33: string = '3.3%'; // ‘3.3%’
  static readonly THOUSANDTH_40: string = '4%'; // ‘4%’
  static readonly THOUSANDTH_50: string = '5%'; // ‘5%’
  static readonly THOUSANDTH_66: string = '6.6%'; // ‘6.6%’
  static readonly THOUSANDTH_80: string = '8%'; // ‘8%’
  static readonly THOUSANDTH_90: string = '9%'; // ‘9%’
  static readonly THOUSANDTH_100: string = '10%'; // ‘10%’
  static readonly THOUSANDTH_120: string = '12%'; // ‘12%’
  static readonly THOUSANDTH_160: string = '16%'; // ‘16%’
  static readonly THOUSANDTH_180: string = '18%'; // ‘18%’
  static readonly THOUSANDTH_200: string = '20%'; // ‘20%’
  static readonly THOUSANDTH_230: string = '23%'; // ‘23%’
  static readonly THOUSANDTH_250: string = '25%'; // ‘25%’
  static readonly THOUSANDTH_300: string = '30%'; // ‘30%’
  static readonly THOUSANDTH_400: string = '40%'; // ‘40%’
  static readonly THOUSANDTH_440: string = '44%'; // ‘44%’
  static readonly THOUSANDTH_450: string = '45%'; // ‘45%’
  static readonly THOUSANDTH_420: string = '42%'; // ‘42%’
  static readonly THOUSANDTH_480: string = '48%'; // ‘48%’
  static readonly THOUSANDTH_500: string = '50%'; // ‘50%’
  static readonly THOUSANDTH_560: string = '56%'; // ‘56%’
  static readonly THOUSANDTH_600: string = '60%'; // ‘60%’
  static readonly THOUSANDTH_700: string = '70%'; // ‘70%’
  static readonly THOUSANDTH_800: string = '80%'; // ‘80%’
  static readonly THOUSANDTH_830: string = '83%'; // ‘83%’
  static readonly THOUSANDTH_880: string = '88%'; // ‘88%’
  static readonly THOUSANDTH_900: string = '90%'; // ‘90%’
  static readonly THOUSANDTH_940: string = '94%'; // ‘94%’
  static readonly THOUSANDTH_950: string = '95%'; // ‘95%’
  static readonly THOUSANDTH_1000: string = '100%'; // ‘100%’

  static readonly DEFAULT_1: number = 1;

  static readonly DEFAULT_2: number = 2;

  static readonly DEFAULT_4: number = 4;

  static readonly DEFAULT_6: number = 6;

  static readonly DEFAULT_8: number = 8;

  static readonly DEFAULT_12: number = 12;

  static readonly DEFAULT_10: number = 10;

  static readonly DEFAULT_16: number = 16;

  static readonly DEFAULT_18: number = 18;

  static readonly DEFAULT_20: number = 20;

  static readonly DEFAULT_24: number = 24;

  static readonly DEFAULT_28: number = 28;

  static readonly DEFAULT_32: number = 32;

  static readonly DEFAULT_36: number = 36;

  static readonly DEFAULT_48: number = 48;

  static readonly DEFAULT_56: number = 56;

  static readonly DEFAULT_60: number = 60;

  static readonly DEFAULT_100: number = 100;

  static readonly DEFAULT_180: number = 180;

  // 字体大小
  static readonly FONT_WEIGHT_400: number = 400;

  static readonly FONT_WEIGHT_500: number = 500;

  static readonly FONT_WEIGHT_700: number = 700;

  static readonly FONT_WEIGHT_900: number = 900;


  // 透明度
  static readonly OPACITY_4: number = 0.4;

  static readonly OPACITY_6: number = 0.6;

  // 边框曲率
  static readonly BORDER_RADIUS_PERCENT_50: string = '50%';

  static readonly BORDER_RADIUS_PERCENT_5: string = '5%';

  // 间距
  static readonly LIST_ITEM_SPACE: number = 2;

  static readonly SPACE_4: number = 4;

  // 列表
  static readonly MOUTH_LIST = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10','11', '12'];

  static readonly YEAR_LIST = ["2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", '2029', '2030', '2031'];

  // navigation title
  static readonly ADD_TASK_TITLE: string = '添加任务';

  static readonly EDIT_TASK_TITLE: string = '编辑任务';

  // prompt message
  static readonly SETTING_FINISHED_MESSAGE = '设置完成！！！';

  static readonly SETTING_FINISH_FAILED_MESSAGE = '网络连接错误';

  static readonly CHOOSE_TIME_OUT_RANGE: string = '选择时间超出范围';

  static readonly NICK_NAME = 'JoIin';

  static readonly SIGNATURE = '这是一条简短地个人签';

  static readonly HOME_BTN_Z = 1;

  // unit
  static readonly PER_DAY: string = '/ 天';

  // global data key
  static readonly GLOBAL_KEY: string = 'global';

  // RemindContent
  static readonly REMINDER_AGENT_TAG: string = 'reminderAgent';

  static readonly PACKAGE_NAME: string = 'com.example.healthy_life';

  static readonly ENTRY_ABILITY: string = 'EntryAbility';

  // offset
  static readonly ZERO: number = 0;

  static readonly MINUS_20: number = -20;

  static readonly HAS_NO_INDEX: number = -1;

  static readonly OFFSET_24: number = -24;

  // letter spacing
  static readonly LETTER_1: number = 0.1;

  static readonly LETTER_34: number = 3.4;

  // achievement
  static readonly ACHIEVE_CARD_IMG_HEIGHT: number = 88;

  static readonly ACHIEVE_CARD_TOP: number = 38;

  static readonly ACHIEVE_CARD_BOTTOM: number = 10;

  static readonly ACHIEVE_SPLIT_RATIO: number = 1 / 3;

  static readonly ACHIEVE_TITLE_BAR_LEFT: number = 20;

  static readonly ACHIEVE_TITLE_BAR_TOP: number = 15;

  static readonly FULL_WIDTH: string = '100%';

  static readonly FULL_HEIGHT: string = '100%';

  static readonly WEEK_DAY_NUM: number = 7; // number days of one week

  static readonly WEEK_DAY_TIME: number = 7 * 24 * 60 * 60 * 1000;

}




