import 'package:azan_app/core/services/adhan_service.dart';
import 'package:azan_app/core/services/notafications_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

// دالة الـ DI الأصلية لتطبيقك (تعمل في الـ UI)
Future<void> setupDependencyInjection() async {
  getIt.registerSingleton<AdhanService>(const AdhanService());
  getIt.registerSingleton<NotificationService>(NotificationService());
  // باقي الخدمات مثل Cubits والـ Audio...
}

// 🟢 الدالة الجديدة المخصصة فقط للخلفية (Background Isolate DI)
Future<void> setupBackgroundDependencies() async {
  // نتحقق أولاً إذا كانت الخدمات مسجلة بالفعل لتجنب خطأ إعادة التسجيل
  if (!getIt.isRegistered<AdhanService>()) {
    getIt.registerSingleton<AdhanService>(const AdhanService());
  }
  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingleton<NotificationService>(NotificationService());
  }
}