/**
 * ViewModel 模板
 *
 * 职责：
 * - 管理页面状态
 * - 协调 Service 层调用
 * - 处理交互流程
 *
 * 禁止：
 * - 直接操作 UI 组件
 * - 直接调用网络/数据库 API（通过 Repository）
 */

import { Logger } from '../utils/Logger';
import { XxxService } from '../services/XxxService';
import { XxxItem } from '../models/XxxItem';

const TAG: string = 'XxxViewModel';

export class XxxViewModel {
  // --- 依赖 ---
  private xxxService: XxxService = new XxxService();

  // --- 公共方法（必须声明参数和返回值类型）---

  /**
   * 初始化 ViewModel，加载必要数据
   */
  async initialize(): Promise<void> {
    Logger.info(TAG, 'initialize');
    // 初始化逻辑
  }

  /**
   * 获取列表数据
   * @returns 数据列表
   */
  async fetchItems(): Promise<XxxItem[]> {
    try {
      Logger.info(TAG, 'fetchItems start');
      const items: XxxItem[] = await this.xxxService.getItems();
      Logger.info(TAG, `fetchItems success, count: ${items.length}`);
      return items;
    } catch (error) {
      Logger.error(TAG, `fetchItems failed: ${error}`);
      throw error; // 不吞异常，向上传递
    }
  }

  /**
   * 处理用户操作
   * @param itemId - 操作目标 ID
   */
  async handleAction(itemId: string): Promise<void> {
    try {
      Logger.info(TAG, `handleAction: ${itemId}`);
      await this.xxxService.performAction(itemId);
    } catch (error) {
      Logger.error(TAG, `handleAction failed: ${error}`);
      throw error;
    }
  }

  /**
   * 清理资源
   */
  destroy(): void {
    Logger.info(TAG, 'destroy');
    // 清理定时器、监听器等
  }
}
