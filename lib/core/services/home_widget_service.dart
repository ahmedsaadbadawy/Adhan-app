import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class HomeWidgetService {
  const HomeWidgetService._();

  static Future<void> updateCurrentTime() async {
    final now = DateTime.now();

    final text = 'آخر وقت متسجل هو\n${DateFormat('HH:mm:ss').format(now)}';

    await HomeWidget.saveWidgetData('widgetText', text);

    await HomeWidget.updateWidget(name: 'MyWidgetHome');
  }

  static Future<void> updateText(String text) async {
    await HomeWidget.saveWidgetData('widgetText', text);

    await HomeWidget.updateWidget(name: 'MyWidgetHome');
  }
}
