// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '发票上传器';

  @override
  String signedInMessage(Object email) {
    return '✅ 已登录为 $email';
  }

  @override
  String get signInCancelled => '❌ 登录已取消';

  @override
  String get signedOut => '🔒 已登出';

  @override
  String signInError(Object error) {
    return '❌ 登录出错：$error';
  }

  @override
  String get welcomeHeader => '欢迎！';

  @override
  String welcomeUser(Object user) {
    return '欢迎，$user';
  }

  @override
  String get pleaseSignIn => '请登录以开始。';

  @override
  String get signInButton => '登录';

  @override
  String get signOutButton => '登出';

  @override
  String get receiptUpload => '上传收据';

  @override
  String get spreadsheet => '电子表格';

  @override
  String get noCategory => '⚠️ 尚未选择类别。请先上传至少一张收据。';

  @override
  String spreadsheetOpenFail(Object error) {
    return '❌ 无法打开表格：$error';
  }

  @override
  String get uploadSuccess => '✅ 上传成功！';

  @override
  String uploadFailed(Object statusCode, Object error) {
    return '❌ 上传失败：$statusCode $error';
  }

  @override
  String failedToLoadData(Object error) {
    return '❌ 加载数据失败：$error';
  }

  @override
  String get noImageSelected => '未选择图片';

  @override
  String get cameraButton => '相机';

  @override
  String get galleryButton => '图库';

  @override
  String get categoryLabel => '类别';

  @override
  String get addCategoryOption => '➕ 添加类别';

  @override
  String get newCategoryLabel => '新类别名称';

  @override
  String deleteCategoryTitle(Object category) {
    return '删除“$category”？';
  }

  @override
  String get deleteCategoryConfirm => '确定要删除该类别吗？';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get amountLabel => '发票金额（例如：34.50）';

  @override
  String get filenameLabel => '文件名（可选：自动生成）';

  @override
  String get pickDate => '选择日期';

  @override
  String get noDateSelected => '未选择日期';

  @override
  String get uploadButton => '上传！';

  @override
  String get uploadProgress => '正在上传并更新表格...';

  @override
  String get uploadSuccessSnackbar => '✅ 上传并记录到表格！';

  @override
  String get uploadFailedSnackbar => '❌ 上传失败';

  @override
  String get uploadErrorTitle => '上传错误';

  @override
  String get ok => '好的';
}
