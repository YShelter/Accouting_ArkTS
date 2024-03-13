import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { columnAccountingInfoList, columnCategoryInfoList, columnDayInfoList } from '../common/database/ColumnModel';
import RdbUtils from '../common/database/Rdb/RdbUtils';
import { GlobalContext } from '../common/utils/GlobalContext';

export default class extends UIAbility {
  async onCreate(want, launchParam) {
    GlobalContext.getContext().setObject('want', want);
    GlobalContext.getContext().setObject('launchParam', launchParam);

    // 创建数据库
    RdbUtils.initDb(this.context, Const.RDB_NAME.dbName ? Const.RDB_NAME.dbName : '');
    await RdbUtils.getDb();

    // 创建每日收支表
    RdbUtils.createTable(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '', columnDayInfoList).then(() => {
    }).catch((err: Error) => {
      hilog.error(0xFF00, `RdbHelper dayInfo err : ${JSON.stringify(err)}`, '');
    });
    // // 创建分类目录表
    // RdbUtils.createTable(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '', columnCategoryInfoList).then(() => {
    // }).catch((err: Error) => {
    //   hilog.error(0xFF00, `RdbHelper dayInfo err : ${JSON.stringify(err)}`, '');
    // });
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
