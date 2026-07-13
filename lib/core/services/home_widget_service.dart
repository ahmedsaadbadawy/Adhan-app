import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static Future<void> updateUrl(String url) async {
    await HomeWidget.saveWidgetData<String>('url', url);

    await HomeWidget.updateWidget(name: 'MyWidgetHome');
  }
}
