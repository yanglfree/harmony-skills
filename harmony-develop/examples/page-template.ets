/**
 * 标准页面模板
 *
 * 使用说明：
 * 1. 将 XxxPage 替换为实际页面名
 * 2. 将 XxxViewModel 替换为实际 ViewModel
 * 3. 在 aboutToAppear() 中初始化数据
 * 4. build() 中只做 UI 编排，不做业务逻辑
 */

import { Logger } from '../utils/Logger';
import { XxxViewModel } from '../viewmodels/XxxViewModel';
import { RouterService } from '../router/RouterService';

const TAG: string = 'XxxPage';

@Entry
@Component
struct XxxPage {
  // --- 状态声明（必须显式类型 + 本地初始化）---
  @State private isLoading: boolean = true;
  @State private errorMessage: string = '';

  // --- ViewModel ---
  private viewModel: XxxViewModel = new XxxViewModel();

  // --- 生命周期 ---
  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
    this.loadData();
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'aboutToDisappear');
  }

  // --- 私有方法 ---
  private async loadData(): Promise<void> {
    try {
      this.isLoading = true;
      await this.viewModel.initialize();
      this.isLoading = false;
    } catch (error) {
      Logger.error(TAG, `loadData failed: ${error}`);
      this.errorMessage = $r('app.string.load_failed');
      this.isLoading = false;
    }
  }

  // --- UI ---
  build() {
    Column() {
      if (this.isLoading) {
        this.LoadingView();
      } else if (this.errorMessage) {
        this.ErrorView();
      } else {
        this.ContentView();
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private LoadingView() {
    Column() {
      LoadingProgress()
        .width(48)
        .height(48)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  private ErrorView() {
    Column() {
      Text(this.errorMessage)
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
      Button($r('app.string.retry'))
        .margin({ top: 16 })
        .onClick(() => this.loadData())
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  private ContentView() {
    Column() {
      // TODO: 实际内容
    }
    .width('100%')
    .height('100%')
  }
}
