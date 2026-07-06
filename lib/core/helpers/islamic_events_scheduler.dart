import 'dart:convert';

import 'package:flutter/services.dart';

import '../../features/adhan/data/models/islamic_events.dart';

class IslamicEventsScheduler {
  const IslamicEventsScheduler();

  Future<List<IslamicEvent>> loadEvents() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/islamic_events.json',
    );

    return (jsonDecode(jsonString) as List)
        .map((e) => IslamicEvent.fromJson(e))
        .toList();
  }
}
