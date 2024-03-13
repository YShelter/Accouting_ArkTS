
// 储存记录的类别
export default class CategoryInfo {
  category: string;
  icon: string;
  ordinal: number;
  typeName: string;

  constructor(category: string, icon: string, ordinal: number, type: string) {
    this.category = category;
    this.icon = icon;
    this.ordinal = ordinal;
    this.typeName = type;
  }
}