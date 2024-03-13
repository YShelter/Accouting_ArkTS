
import { AccountingType } from '../common/constants/CommonConstants';
export interface CategoryItem {
  category: string;
  icon: string;
  ordinal: number;
  typeName: string;
}

export const expenseList: Array<CategoryItem> = [
  {
    category: '购物',
    icon: 'add2shop.png',
    ordinal: 1,
    typeName: AccountingType[0]
  },
  {
    category: '旅行',
    icon: 'airplane.png',
    ordinal: 2,
    typeName: AccountingType[0]
  },
  {
    category: '玩具',
    icon: 'baby-mobile.png',
    ordinal: 3,
    typeName: AccountingType[0]
  },
  {
    category: '转账',
    icon: 'bankcard.png',
    ordinal: 4,
    typeName: AccountingType[0]
  },
  {
    category: '运动',
    icon: 'bike.png',
    ordinal: 5,
    typeName: AccountingType[0]
  },
  {
    category: '零食',
    icon: 'cake.png',
    ordinal: 6,
    typeName: AccountingType[0]
  },
  {
    category: '蔬菜',
    icon: 'bok-choy.png',
    ordinal: 7,
    typeName: AccountingType[0]
  },
  {
    category: '书籍',
    icon: 'books.png',
    ordinal: 8,
    typeName: AccountingType[0]
  },
  {
    category: '装饰',
    icon: 'bookshelf.png',
    ordinal: 9,
    typeName: AccountingType[0]
  },
  {
    category: '面包',
    icon: 'bread.png',
    ordinal: 10,
    typeName: AccountingType[0]
  },
  {
    category: '通勤',
    icon: 'bus.png',
    ordinal: 11,
    typeName: AccountingType[0]
  },
  {
    category: '汽车',
    icon: 'car.png',
    ordinal: 12,
    typeName: AccountingType[0]
  },
  {
    category: '娱乐',
    icon: 'card.png',
    ordinal: 13,
    typeName: AccountingType[0]
  },
  {
    category: '聚会',
    icon: 'cheers.png',
    ordinal: 14,
    typeName: AccountingType[0]
  },
  {
    category: '水果',
    icon: 'cherry.png',
    ordinal: 15,
    typeName: AccountingType[0]
  },
  {
    category: '餐饮',
    icon: 'cooking.png',
    ordinal: 16,
    typeName: AccountingType[0]
  },
  {
    category: '电脑',
    icon: 'cpu.png',
    ordinal: 17,
    typeName: AccountingType[0]
  },
  {
    category: '约会',
    icon: 'dating.png',
    ordinal: 18,
    typeName: AccountingType[0]
  },
  {
    category: '首饰',
    icon: 'dimon.png',
    ordinal: 19,
    typeName: AccountingType[0]
  },
  {
    category: '宠物',
    icon: 'fish.png',
    ordinal: 20,
    typeName: AccountingType[0]
  },
  {
    category: '鲜花',
    icon: 'flower.png',
    ordinal: 21,
    typeName: AccountingType[0]
  },
  {
    category: '游戏',
    icon: 'game.png',
    ordinal: 22,
    typeName: AccountingType[0]
  },
  {
    category: '礼物',
    icon: 'gift.png',
    ordinal: 23,
    typeName: AccountingType[0]
  },
  {
    category: '理发',
    icon: 'haircut.png',
    ordinal: 24,
    typeName: AccountingType[0]
  },
  {
    category: '外卖',
    icon: 'hamburger.png',
    ordinal: 25,
    typeName: AccountingType[0]
  },
  {
    category: '医疗',
    icon: 'hospital.png',
    ordinal: 26,
    typeName: AccountingType[0]
  },
  {
    category: '酒店',
    icon: 'hotel.png',
    ordinal: 27,
    typeName: AccountingType[0]
  },
  {
    category: '家政',
    icon: 'housekeeping.png',
    ordinal: 28,
    typeName: AccountingType[0]
  },
  {
    category: '化妆品',
    icon: 'lipstick.png',
    ordinal: 29,
    typeName: AccountingType[0]
  },
  {
    category: '学习',
    icon: 'literature.png',
    ordinal: 30,
    typeName: AccountingType[0]
  },
  {
    category: '文具',
    icon: 'pen.png',
    ordinal: 31,
    typeName: AccountingType[0]
  },
  {
    category: '通讯',
    icon: 'phonecall.png',
    ordinal: 32,
    typeName: AccountingType[0]
  },
  {
    category: '办公',
    icon: 'workstation.png',
    ordinal: 33,
    typeName: AccountingType[0]
  },
  {
    category: '还款',
    icon: 'cash.png',
    ordinal: 34,
    typeName: AccountingType[0]
  },
];


export const IncomeList: Array<CategoryItem> = [
  {
    category: '生活费',
    icon: 'calendar.png',
    ordinal: 1,
    typeName: AccountingType[1]
  },
  {
    category: '奖学金',
    icon: 'checked.png',
    ordinal: 2,
    typeName: AccountingType[1]
  },
  {
    category: '理财',
    icon: 'investment.png',
    ordinal: 3,
    typeName: AccountingType[1]
  },
  {
    category: '工资',
    icon: 'money.png',
    ordinal: 4,
    typeName: AccountingType[1]
  }
// Add more IncomeItem objects here if needed
];
