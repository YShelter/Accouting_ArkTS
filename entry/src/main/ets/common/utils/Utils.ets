const CHINESE_OF_WEEK: string[] = ['一', '二', '三', '四', '五', '六', '日'];
const YEAR: string = '年';
const MONTH: string = '月';
const DAY: string = '日';
const WEEK: string = '星期';
const DAYS_OF_WEEK: number = 7;
const SUNDAY_FIRST_SHIFT: number = 6;

// 函数用于生成星期标题的数组，星期天是第一天
export const weekTitleFunc = () => {
  const weekTitleArr: Array<string> = [];
  for (let index = 0; index < CHINESE_OF_WEEK.length; index++) {
    weekTitleArr.push(CHINESE_OF_WEEK[(index + SUNDAY_FIRST_SHIFT) % DAYS_OF_WEEK]); // 星期天作为一周的第一天
  }
  return weekTitleArr;
}

// 常量数组，包含星期的标题，按照星期天到星期六的顺序排列
export const WEEK_TITLES: string[] = weekTitleFunc();

// 用于将数字转换为两位数格式的函数
export function padTo2Digits(num: number) {
  return num.toString().padStart(2, '0');
}

// 格式化日期的函数
export function dateFormat(date: Date) {
  return date.getFullYear() + YEAR + padTo2Digits(date.getMonth() + 1) + MONTH + padTo2Digits(date.getDate()) + DAY;
}

// 格式化日期和星期的函数
export function weekDateFormat(timestamp: number) {
  let tempDate = new Date(timestamp);
  return dateFormat(tempDate) + WEEK + WEEK_TITLES[tempDate.getDay()];
}

// 将日期格式转化为字符串格式 'Fri Aug 26 2022'
export function dateToStr(date: Date) {
  return date.toDateString();
}

// 比较点击的日期和当期日期是否为同一天
export function sameDate(firstDate: Date, timestamp: number) {

  let secondDate = new Date(timestamp);
  if (firstDate.getFullYear() != secondDate.getFullYear()) {
    return false;
  }

  if (firstDate.getMonth() != secondDate.getMonth()) {
    return false;
  }

  if (firstDate.getDate() != secondDate.getDate()) {
    return false;
  }

  return true;
}

