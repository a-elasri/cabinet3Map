import 'package:mapbox_gl/mapbox_gl.dart';

import '../requests/globals.dart';

LatLng getLatLngFromCabinetData(int index) {
  return LatLng(double.parse(cabinets[index].coordinates['latitude']!),
      double.parse(cabinets[index].coordinates['longitude']!));
}
