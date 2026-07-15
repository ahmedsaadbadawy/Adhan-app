import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../features/adhan/presentation/azan_screen.dart';
import '../features/adhan/presentation/cubit/adhan_cubit/adhan_cubit.dart';
import '../features/background_sound/presentation/cubit/quran_player_cubit/quran_player_cubit.dart';
import '../features/background_sound/presentation/views/quran_player_screen.dart';
import '../features/splash/presentation/cubit/splash_cubit/splash_cubit.dart';
import '../features/splash/presentation/views/splash_screen.dart';
import 'DI/service_allocator.dart';
import 'services/adhan_service.dart';
import 'services/audio/audio_player_service.dart';
import 'services/notifications/prayer_notification_scheduler.dart';

abstract class AppRouter {
  static const splash = '/';
  static const azan = '/azan';
  static const quranPlayer = '/quran-player';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              SplashCubit(getIt(), getIt(), getIt())..initialize(),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRouter.azan,
        builder: (context, state) {
          final location = tz.getLocation('Africa/Cairo');

          const coordinates = Coordinates(31.04, 31.38);

          return BlocProvider(
            create: (_) => AdhanCubit(
              getIt<AdhanService>(),
              getIt<PrayerNotificationScheduler>(),
            )..start(coordinates: coordinates, location: location),
            child: const AzanScreen(),
          );
        },
      ),
      GoRoute(
        path: quranPlayer,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              QuranPlayerCubit(audioService: getIt<AudioPlayerService>())
                ..initialize(),
          child: const QuranPlayerScreen(),
        ),
      ),
    ],
  );
}
