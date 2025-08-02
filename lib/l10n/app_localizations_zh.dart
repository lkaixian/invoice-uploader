// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get selectLanguage => '选择语言';

  @override
  String get language => '语言';

  @override
  String get appTitle => '财务与发票管理应用';

  @override
  String get theme => '主题';

  @override
  String get switchTheme => '切换主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '系统默认';

  @override
  String get settings => '设置';

  @override
  String signedInMessage(String email) {
    return '✅ 已登录：$email';
  }

  @override
  String get signInCancelled => '❌ 登录已取消';

  @override
  String get signedOut => '🔒 已登出';

  @override
  String signInError(String error) {
    return '❌ 登录出错：$error';
  }

  @override
  String get welcomeHeader => '欢迎！';

  @override
  String welcomeUser(String user) {
    return '欢迎，$user';
  }

  @override
  String get pleaseSignIn => '请先登录以开始使用。';

  @override
  String get signInButton => '登录';

  @override
  String get signOutButton => '登出';

  @override
  String get receiptUpload => '单个上传';

  @override
  String get spreadsheet => '电子表格';

  @override
  String get noCategory => '⚠️ 尚未选择类别，请先上传至少一个发票。';

  @override
  String spreadsheetOpenFail(String error) {
    return '❌ 打开表格失败：$error';
  }

  @override
  String get uploadSuccess => '✅ 上传成功！';

  @override
  String uploadFailed(int statusCode, String error) {
    return '❌ 上传失败：$statusCode $error';
  }

  @override
  String get incompleteData => '❌ 信息不完整，请检查输入内容。';

  @override
  String get noImageSelected => '未选择图片';

  @override
  String get cameraButton => '相机';

  @override
  String get galleryButton => '图库';

  @override
  String get categoryLabel => '类别';

  @override
  String get selectCategory => '选择类别';

  @override
  String get addCategoryOption => '➕ 添加类别';

  @override
  String get newCategoryLabel => '新类别名称';

  @override
  String deleteCategoryTitle(String category) {
    return '删除“$category”？';
  }

  @override
  String get deleteCategoryTitlePlaceholder => '删除所选类别';

  @override
  String get deleteCategoryConfirm => '是否确定要删除此类别？';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get amountLabel => '发票金额（例如 34.50）';

  @override
  String get enterAmount => '输入金额';

  @override
  String get filenameLabel => '文件名（可选：自动生成）';

  @override
  String get selectFiles => '选择文件';

  @override
  String get date => '日期';

  @override
  String get file => '文件';

  @override
  String get previous => '上一页';

  @override
  String get next => '下一页';

  @override
  String get pickDate => '选择日期';

  @override
  String get noDateSelected => '未选择日期';

  @override
  String get uploadButton => '上传！';

  @override
  String get uploadingPleaseWait => '正在上传，请稍候……';

  @override
  String get uploadProgress => '正在上传并更新表格……';

  @override
  String get uploadSuccessSnackbar => '✅ 上传并记录成功！';

  @override
  String get uploadFailedSnackbar => '❌ 上传失败';

  @override
  String get uploadErrorTitle => '上传错误';

  @override
  String get ok => '确定';

  @override
  String get viewExpenses => '查看支出';

  @override
  String get viewAll => '查看全部';

  @override
  String get bulkUpload => '批量上传';

  @override
  String uploadedCount(int uploaded, int total) {
    return '已上传 $uploaded / $total';
  }

  @override
  String get addMoreFiles => '添加更多文件';

  @override
  String get originalName => '原始名称';

  @override
  String get autoGenerateFilename => '自动生成文件名';

  @override
  String get topCategories => '前三类别';

  @override
  String get topSpends => '前三支出';

  @override
  String get monthJanuary => '一月';

  @override
  String get monthFebruary => '二月';

  @override
  String get monthMarch => '三月';

  @override
  String get monthApril => '四月';

  @override
  String get monthMay => '五月';

  @override
  String get monthJune => '六月';

  @override
  String get monthJuly => '七月';

  @override
  String get monthAugust => '八月';

  @override
  String get monthSeptember => '九月';

  @override
  String get monthOctober => '十月';

  @override
  String get monthNovember => '十一月';

  @override
  String get monthDecember => '十二月';

  @override
  String get buyMeCoffee => '请我喝杯咖啡 ☕';

  @override
  String get supportMyWork => '咖啡时间！如果你觉得这个应用有帮助，可以请我喝杯咖啡来支持我的工作。';

  @override
  String get linkOpenFailed => '无法打开链接';

  @override
  String get useCustomFileName => '使用自定义文件名';

  @override
  String get fileName => '文件名';

  @override
  String get fileNameHint => '例如：InvoiceLog';

  @override
  String get about => '关于';

  @override
  String get aboutDescription =>
      '这是一个用于上传和记录发票的应用程序。它支持图片识别、Google Drive 上传和 Google 表格同步。';

  @override
  String get aboutDisclaimer =>
      '鸣谢：\n- Flutter & Dart SDK\n- Google APIs（Drive, Sheets, Sign-In）\n- flutter_dotenv 用于环境配置\n- firebase_crashlytics\n- 以及其他开源库';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutVersionValue => '2508W1_NIGHTLY_BUILD';

  @override
  String get reportIssue => '报告问题';

  @override
  String get reportIssueSubtitle => '发现错误？请在 GitHub 上告诉我们。';

  @override
  String get permanentAutoFileName => '永久自动文件名';

  @override
  String get permanentAutoFileNameSubtitle => '始终自动生成文件名，无需手动编辑';

  @override
  String get permanentAutoFileNameEnabled => '已启用永久自动文件名';

  @override
  String get permanentAutoFileNameDisabled => '已禁用永久自动文件名';

  @override
  String get changelogTitle => '更新内容';

  @override
  String get changelog_1 => '新增繁体中文语言支持';

  @override
  String get changelog_2 => '新增关于页面';

  @override
  String get changelog_3 => '新增设置中永久启用自动生成文件名的选项';

  @override
  String get changelog_4 => '集成 Firebase Crashlytics 用于崩溃报告';

  @override
  String get changelog_5 => '新增“报告问题”按钮，跳转至 GitHub Issues（设置中）';

  @override
  String get changelog_6 => '新增网页访问功能';

  @override
  String get changelog_7 => '将 print() 替换为日志记录功能';

  @override
  String get changelog_8 => '修复了一些小问题';

  @override
  String get changelog_note =>
      '注：版本号采用 <1.0.0 表示预发布。构建号格式为 YYYYMMW-BUILD_TYPE，其中 BUILD_TYPE = RELEASE, BETA, NIGHTLY';

  @override
  String get changelog_latest_1 => '新增“最新动态”部分。';

  @override
  String get changelog_latest_2 => '应用名称已更改以符合当前功能。';

  @override
  String get changelog_latest_3 => '“发票上传”更名为“单个上传”。';

  @override
  String get changelog_latest_4 => '分类选择已重新设计，并在两种上传方式中同步。';

  @override
  String get changelog_latest_5 => '批量上传流程全面优化，更加直观。';

  @override
  String get changelog_latest_6 => '用户现在可以在批量上传中更改、添加和删除分类。';

  @override
  String get changelog_latest_7 => '修复颜色和字体，使其更具可读性。';

  @override
  String get changelog_latest_8 => '正在实现通知弹出功能，用于原型测试。';

  @override
  String get changelog_latest_9 => '正在实现上传队列功能。';

  @override
  String get changelog_latest_note => '注意：功能开发中，暂未启用。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class SZhTw extends SZh {
  SZhTw() : super('zh_TW');

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get language => '語言';

  @override
  String get appTitle => '財務與發票管理應用程式';

  @override
  String get theme => '主題';

  @override
  String get switchTheme => '切換主題';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '系統預設';

  @override
  String get settings => '設定';

  @override
  String signedInMessage(String email) {
    return '✅ 已登入：$email';
  }

  @override
  String get signInCancelled => '❌ 已取消登入';

  @override
  String get signedOut => '🔒 已登出';

  @override
  String signInError(String error) {
    return '❌ 登入錯誤：$error';
  }

  @override
  String get welcomeHeader => '歡迎！';

  @override
  String welcomeUser(String user) {
    return '歡迎，$user';
  }

  @override
  String get pleaseSignIn => '請先登入以開始使用。';

  @override
  String get signInButton => '登入';

  @override
  String get signOutButton => '登出';

  @override
  String get receiptUpload => '單筆上傳';

  @override
  String get spreadsheet => '試算表';

  @override
  String get noCategory => '⚠️ 尚未選擇類別。請先上傳至少一張收據。';

  @override
  String spreadsheetOpenFail(String error) {
    return '❌ 開啟試算表失敗：$error';
  }

  @override
  String get uploadSuccess => '✅ 上傳成功！';

  @override
  String uploadFailed(int statusCode, String error) {
    return '❌ 上傳失敗：$statusCode $error';
  }

  @override
  String get incompleteData => '❌ 資料不完整，請檢查輸入內容。';

  @override
  String get noImageSelected => '未選擇圖片';

  @override
  String get cameraButton => '相機';

  @override
  String get galleryButton => '相簿';

  @override
  String get categoryLabel => '類別';

  @override
  String get selectCategory => '選擇類別';

  @override
  String get addCategoryOption => '➕ 新增類別';

  @override
  String get newCategoryLabel => '新類別名稱';

  @override
  String deleteCategoryTitle(String category) {
    return '刪除「$category」？';
  }

  @override
  String get deleteCategoryTitlePlaceholder => '刪除所選分類';

  @override
  String get deleteCategoryConfirm => '確定要刪除此類別嗎？';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get amountLabel => '發票金額（例如 34.50）';

  @override
  String get enterAmount => '輸入金額';

  @override
  String get filenameLabel => '檔案名稱（可選：自動產生）';

  @override
  String get selectFiles => '選擇檔案';

  @override
  String get date => '日期';

  @override
  String get file => '檔案';

  @override
  String get previous => '上一個';

  @override
  String get next => '下一個';

  @override
  String get pickDate => '選擇日期';

  @override
  String get noDateSelected => '尚未選擇日期';

  @override
  String get uploadButton => '上傳！';

  @override
  String get uploadingPleaseWait => '正在上傳，請稍候...';

  @override
  String get uploadProgress => '上傳中並更新試算表...';

  @override
  String get uploadSuccessSnackbar => '✅ 已上傳並記錄於試算表！';

  @override
  String get uploadFailedSnackbar => '❌ 上傳失敗';

  @override
  String get uploadErrorTitle => '上傳錯誤';

  @override
  String get ok => '確定';

  @override
  String get viewExpenses => '查看支出';

  @override
  String get viewAll => '查看全部';

  @override
  String get bulkUpload => '批次上傳';

  @override
  String uploadedCount(int uploaded, int total) {
    return '已上傳 $uploaded 筆，共 $total 筆';
  }

  @override
  String get addMoreFiles => '新增檔案';

  @override
  String get originalName => '原始名稱';

  @override
  String get autoGenerateFilename => '自動產生檔案名稱';

  @override
  String get topCategories => '前三大類別';

  @override
  String get topSpends => '前三大支出';

  @override
  String get monthJanuary => '一月';

  @override
  String get monthFebruary => '二月';

  @override
  String get monthMarch => '三月';

  @override
  String get monthApril => '四月';

  @override
  String get monthMay => '五月';

  @override
  String get monthJune => '六月';

  @override
  String get monthJuly => '七月';

  @override
  String get monthAugust => '八月';

  @override
  String get monthSeptember => '九月';

  @override
  String get monthOctober => '十月';

  @override
  String get monthNovember => '十一月';

  @override
  String get monthDecember => '十二月';

  @override
  String get buyMeCoffee => '請我喝杯咖啡 ☕';

  @override
  String get supportMyWork => '咖啡時間！如果您覺得本應用程式有幫助，歡迎請我喝杯咖啡支持開發。';

  @override
  String get linkOpenFailed => '無法開啟連結';

  @override
  String get useCustomFileName => '使用自訂檔案名稱';

  @override
  String get fileName => '檔案名稱';

  @override
  String get fileNameHint => '例如：InvoiceLog';

  @override
  String get about => '關於';

  @override
  String get aboutDescription =>
      '這是一款簡單的應用程式，讓您能夠透過 Flutter 與 Google API 管理財務與發票。\n\n它能夠讓您上傳收據、記錄支出，並以結構化方式檢視您的財務資料。\n\n由 Larm Kai Xian 用愛打造。';

  @override
  String get aboutDisclaimer =>
      '致謝：\n- Flutter & Dart SDK\n - Google APIs（Drive、Sheets、登入）\n - flutter_dotenv 用於安全環境配置\n - firebase_crashlytics\n';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutVersionValue => '2508W1_NIGHTLY_BUILD';

  @override
  String get reportIssue => '回報問題';

  @override
  String get reportIssueSubtitle => '發現錯誤？請至 GitHub 回報。';

  @override
  String get permanentAutoFileName => '永久自動檔案名稱';

  @override
  String get permanentAutoFileNameSubtitle => '始終自動產生檔案名稱，無需手動編輯';

  @override
  String get permanentAutoFileNameEnabled => '已啟用永久自動檔案名稱';

  @override
  String get permanentAutoFileNameDisabled => '已停用永久自動檔案名稱';

  @override
  String get changelogTitle => '更新內容';

  @override
  String get changelog_1 => '新增繁體中文語言支援';

  @override
  String get changelog_2 => '新增關於頁面';

  @override
  String get changelog_3 => '新增永久自動檔名選項（於設定中）';

  @override
  String get changelog_4 => '加入 Firebase Crashlytics 處理崩潰回報';

  @override
  String get changelog_5 => '新增「回報錯誤」按鈕（設定中，導向 GitHub Issues）';

  @override
  String get changelog_6 => '新增網頁版功能，可透過網站使用應用程式';

  @override
  String get changelog_7 => '以日誌系統取代 print() 函數';

  @override
  String get changelog_8 => '小錯誤修復';

  @override
  String get changelog_note =>
      '注意：預發行版本號為 <1.0.0，建構號格式為 YYYYMMW-BUILD_TYPE，其中 BUILD_TYPE = RELEASE、BETA、NIGHTLY';

  @override
  String get changelog_latest_1 => '新增「最新消息」區塊。';

  @override
  String get changelog_latest_2 => '應用程式名稱已更新，以符合目前功能。';

  @override
  String get changelog_latest_3 => '「發票上傳」更名為「單筆上傳」。';

  @override
  String get changelog_latest_4 => '重新設計分類選擇，並同步兩種上傳方式。';

  @override
  String get changelog_latest_5 => '批量上傳流程全面改進，更加直覺易用。';

  @override
  String get changelog_latest_6 => '使用者現在可以在批量上傳中更改、添加和移除分類。';

  @override
  String get changelog_latest_7 => '修復顏色與字體，提升可讀性。';

  @override
  String get changelog_latest_8 => '實作通知彈出功能作為原型。';

  @override
  String get changelog_latest_9 => '實作排隊上傳功能。';

  @override
  String get changelog_latest_note => '注意：開發中，尚未啟用。';
}
