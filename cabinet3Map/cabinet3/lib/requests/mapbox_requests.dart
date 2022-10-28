import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

import '../helpers/dio_exceptions.dart';

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
String navType = 'cycling';
// https://api.mapbox.com/directions/v5/mapbox/cycling/
Dio _dio = Dio();

Future getCyclingRouteUsingMapbox(LatLng source, LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
  }
}

var current_location_info = null;

Future<dynamic> GetCurrentLocationInfo(LatLng source) async {
  String url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${source.longitude},${source.latitude}.json?types=postcode&access_token=pk.eyJ1IjoiZTU3YXNtYWEiLCJhIjoiY2w5ZWV5NzVmMGlqaTNzbDlzN3Z6bDlxaSJ9.XdvuvlmQ9wTvfWNZzXTlXQ";
  await http.get(Uri.parse(url)).then((response) {
    current_location_info = json.decode(response.body);
  }).catchError((onError) {
    print(onError);
  });
  return current_location_info;
}

var listCabinet = null;

Future<dynamic> GetListCabinets(String minLong,String minLat,String maxLong,String maxLat ) async {
  String url = "https://api.mapbox.com/geocoding/v5/mapbox.places/cabinets.json?limit=10&bbox=${minLong},${minLat},${maxLong},${maxLat}&access_token=pk.eyJ1IjoiZTU3YXNtYWEiLCJhIjoiY2w5ZWV5NzVmMGlqaTNzbDlzN3Z6bDlxaSJ9.XdvuvlmQ9wTvfWNZzXTlXQ";
  await http.get(Uri.parse(url)).then((response) {
    listCabinet = json.decode(response.body);
  }).catchError((onError) {
    print(onError);
  });
  return listCabinet;
}



