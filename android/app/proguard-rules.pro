-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter Local Notifications (Crucial for background receivers)
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver { *; }

# Workmanager (Crucial for background workers)
-keep class dev.fluttercommunity.workmanager.** { *; }
-keep class androidx.work.** { *; }

# Shared Preferences & JSON (Often used internally by plugins for background data)
-keep class com.google.gson.** { *; }

-dontwarn com.google.android.play.core.**

-keepattributes Signature
-keepattributes *Annotation*
-keep class com.ryanheise.** { *; }
-keep class es.antonborri.home_widget.** { *; }
-keep class com.example.azan_app.** { *; }