import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/app_router.dart';

void main() {
  runApp(const AzanApp());
}

class AzanApp extends StatelessWidget {
  const AzanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: ThemeData(
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontSize: 16.sp, color: Colors.greenAccent),
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
