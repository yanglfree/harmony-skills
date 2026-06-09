/**
 * 长列表页面模板
 *
 * 使用说明：
 * 1. 替换 XxxItem 为实际数据模型
 * 2. 替换 XxxListViewModel 为实际 ViewModel
 * 3. ListItemView 必须组件化，避免 build() 过重
 * 4. 使用 LazyForEach 优化长列表性能
 */

import { Logger } from '../utils/Logger';
import { XxxListViewModel } from '../viewmodels/XxxListViewModel';
import { XxxItem } from '../models/XxxItem';

const TAG: string = 'XxxListPage';

@Entry
@Component
struct XxxListPage {
  @State private isLoading: boolean = true;
  @State private items: XxxItem[] = [];
  @State private isRefreshing: boolean = false;

  private viewModel: XxxListViewModel = new XxxListViewModel();

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
    this.loadData();
  }

  private async loadData(): Promise<void> {
    try {
      this.isLoading = true;
      this.items = await this.viewModel.fetchItems();
      this.isLoading = false;
    } catch (error) {
      Logger.error(TAG, `loadData failed: ${error}`);
      this.isLoading = false;
    }
  }

  private async refreshData(): Promise<void> {
    try {
      this.isRefreshing = true;
      this.items = await this.viewModel.fetchItems();
      this.isRefreshing = false;
    } catch (error) {
      Logger.error(TAG, `refreshData failed: ${error}`);
      this.isRefreshing = false;
    }
  }

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress()
          .width(48)
          .height(48)
      } else {
        Refresh({ refreshing: $$this.isRefreshing }) {
          List({ space: 12 }) {
            ForEach(this.items, (item: XxxItem) => {
              ListItem() {
                // 列表 item 必须组件化
                XxxListItemView({ item: item })
              }
            }, (item: XxxItem) => item.id)
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 16, right: 16 })
        }
        .onRefreshing(() => this.refreshData())
      }
    }
    .width('100%')
    .height('100%')
  }
}

/**
 * 列表项组件 — 必须独立组件化
 */
@Component
struct XxxListItemView {
  @Prop item: XxxItem = new XxxItem();

  build() {
    Row() {
      Column() {
        Text(this.item.title)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.item.subtitle)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
  }
}
