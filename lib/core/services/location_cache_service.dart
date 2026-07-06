import 'package:adhan_dart/adhan_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class CachedLocation {
  const CachedLocation({required this.coordinates, required this.location});

  final Coordinates coordinates;
  final tz.Location location;
}

class LocationCacheService {
  const LocationCacheService();

  Future<void> save({
    required double lat,
    required double lng,
    required String timezoneName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_lat', lat);
    await prefs.setDouble('last_lng', lng);
    await prefs.setString('last_timezone', timezoneName);
  }

  Future<CachedLocation?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_lat');
    final lng = prefs.getDouble('last_lng');
    final tzName = prefs.getString('last_timezone');

    if (lat == null || lng == null || tzName == null) return null;

    return CachedLocation(
      coordinates: Coordinates(lat, lng),
      location: tz.getLocation(tzName),
    );
  }
}
