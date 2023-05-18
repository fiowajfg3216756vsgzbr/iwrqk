import 'package:get/get.dart';

import 'app/data/services/account_service.dart';
import 'app/data/services/auto_lock_service.dart';
import 'app/data/services/config_service.dart';
import 'app/data/services/download_service.dart';
import 'app/data/services/user_service.dart';
import 'app/global_widgets/comments/comments_list/controller.dart';
import 'app/global_widgets/comments/send_comment_bottom_sheet/controller.dart';
import 'app/global_widgets/dialogs/loading_dialog/controller.dart';
import 'app/modules/media_detail/widgets/create_video_download_task_dialog/controller.dart';
import 'app/modules/tabs/media_grid_tab/widgets/filter_dialog/controller.dart';

void initGetx() {
  Get.put(ConfigService());
  Get.put(AutoLockService());
  Get.put(AccountService());
  Get.put(UserService());
  Get.put(DownloadService());

  Get.create(() => LoadingDialogController());
  Get.create(() => FilterDialogController());

  Get.create(() => CommentsListController());
  Get.create(() => SendCommentBottomSheetController());
  Get.create(() => CreateVideoDownloadDialogController());
}
