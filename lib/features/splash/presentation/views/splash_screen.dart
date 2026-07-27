import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/app_router.dart';
import '../cubit/splash_cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        switch (state) {
          case SplashNavigateHome():
            final prefs = await SharedPreferences.getInstance();
            bool isFirstLaunch = prefs.getBool("firstLaunch") ?? true;
            if (!context.mounted) return;
            isFirstLaunch && Platform.isAndroid
                ? context.go(AppRouter.permissionSetup)
                : context.go(AppRouter.azan);
            break;

          case SplashNavigatePrayerTimes():
            context.go(AppRouter.azan);
            break;

          case SplashNavigateQuran():
            context.go(AppRouter.quranPlayer);
            break;

          default:
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('زاد', style: TextStyle(fontSize: 46, color: Colors.green)),
              Text(
                '{وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى}',
                style: TextStyle(fontSize: 24, color: Colors.greenAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
