import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/cabinets.dart';

LatLng getLatLngFromCabinetData(int index) {
  return LatLng(double.parse(cabinets[index]['coordinates']['latitude']),
      double.parse(cabinets[index]['coordinates']['longitude']));
}
