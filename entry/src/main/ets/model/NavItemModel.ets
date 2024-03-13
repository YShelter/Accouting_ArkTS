// 底部导航栏信息模块
export interface NavItem {
  icon: Resource;
  icon_selected: Resource;
  text: Resource;
  id: number;
}

// tabId
export enum TabId {
  HOME,
  DETAIL,
  STATISTICS,
  MINE
}

export const NavList: NavItem[] = [
  {
    icon: $r('app.media.ic_tabs_home_normal'),
    icon_selected: $r('app.media.ic_tabs_home_sel'),
    text: $r('app.string.tab_home'),
    id: TabId.HOME
  },
  {
    icon: $rawfile('receipt.png'),
    icon_selected: $rawfile('receipt_sel.png'),
    text: $r('app.string.tab_detail'),
    id: TabId.DETAIL
  },
  {
    icon: $rawfile('chart.png'),
    icon_selected: $rawfile('chart_sel.png'),
    text: $r('app.string.tab_statistics'),
    id: TabId.STATISTICS
  },
  {
    icon: $rawfile('account.png'),
    icon_selected: $rawfile('account_sel.png'),
    text: $r('app.string.tab_mine'),
    id: TabId.MINE
  },
]