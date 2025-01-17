import 'package:get/get.dart';

import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/download_task.dart';
import '../../../../../data/providers/storage_provider.dart';
import '../../../../../data/services/download_service.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class DownloadsMediaPreviewListController
    extends SliverRefreshController<MediaDownloadTask> {
  final DownloadMediaPreviewListRepository repository = DownloadMediaPreviewListRepository();

  final DownloadService _downloadService = Get.find();

  late MediaType _filterType;

  void initConfig(MediaType filterType) {
    _filterType = filterType;
  }

  @override
  Future<GroupResult<MediaDownloadTask>> getNewData(int currentPage) async {
    return repository.getDownloadRecords(currentPage, _filterType);
  }

  Future<void> deleteTaskRecord(String taskId) async {
    await _downloadService.deleteTaskRecord(taskId);
  }

  Future<void> deleteVideoTask(int index, String taskId) async {
    await StorageProvider.deleteDownloadVideoRecord(index);
    await deleteTaskRecord(taskId);
  }
}
