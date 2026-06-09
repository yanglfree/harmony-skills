/**
 * Repository 模板
 *
 * 职责：
 * - 数据获取（网络 / 本地存储）
 * - 数据聚合与转换
 * - 底层异常转译为业务异常
 *
 * 禁止：
 * - 包含业务规则
 * - 依赖 UI 框架
 */

import { Logger } from '../utils/Logger';
import { XxxItem } from '../models/XxxItem';
import { StorageKeys } from '../constants/StorageKeys';
import http from '@ohos.net.http';

const TAG: string = 'XxxRepository';

/**
 * 业务异常类 — Repository 层统一转译
 */
export class BusinessError extends Error {
  code: string;

  constructor(code: string, message: string) {
    super(message);
    this.code = code;
  }
}

export class XxxRepository {
  /**
   * 从远端获取数据
   * @param params - 请求参数
   * @returns 数据列表
   * @throws BusinessError 业务异常
   */
  async fetchFromRemote(params: Record<string, string>): Promise<XxxItem[]> {
    try {
      Logger.info(TAG, 'fetchFromRemote start');
      const httpRequest = http.createHttp();
      // 网络请求逻辑...
      const items: XxxItem[] = []; // 解析响应
      Logger.info(TAG, `fetchFromRemote success, count: ${items.length}`);
      return items;
    } catch (error) {
      Logger.error(TAG, `fetchFromRemote failed: ${error}`);
      // 底层异常转译为业务异常
      throw new BusinessError('FETCH_FAILED', '数据获取失败');
    }
  }

  /**
   * 从本地缓存读取数据
   * @returns 缓存数据，不存在返回空数组
   */
  async fetchFromLocal(): Promise<XxxItem[]> {
    try {
      Logger.debug(TAG, 'fetchFromLocal');
      // 本地存储读取逻辑（使用集中管理的 StorageKeys）
      return [];
    } catch (error) {
      Logger.warn(TAG, `fetchFromLocal failed: ${error}`);
      return []; // 缓存失败不阻断流程，返回空
    }
  }

  /**
   * 保存数据到本地缓存
   * @param items - 要缓存的数据
   */
  async saveToLocal(items: XxxItem[]): Promise<void> {
    try {
      Logger.debug(TAG, `saveToLocal, count: ${items.length}`);
      // 本地存储写入逻辑
    } catch (error) {
      Logger.warn(TAG, `saveToLocal failed: ${error}`);
      // 缓存失败不阻断流程
    }
  }
}
