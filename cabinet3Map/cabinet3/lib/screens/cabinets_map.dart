import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/cabinets.dart';
import '../helpers/commons.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/carousel_card.dart';

class CabinetsMap extends StatefulWidget {
  const CabinetsMap({Key? key}) : super(key: key);

  @override
  State<CabinetsMap> createState() => _CabinetsMapState();
}

class _CabinetsMapState extends State<CabinetsMap> {
  // Mapbox related
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kCabinetsList;
  List<Map> carouselData = [];

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: 15);

    // Calculate the distance and time from data in SharedPreferences
    for (int index = 0; index < cabinets.length; index++) {
      num distance = getDistanceFromSharedPrefs(index) / 1000;
      num duration = getDurationFromSharedPrefs(index) / 60;
      carouselData
          .add({'index': index, 'distance': distance, 'duration': duration});
    }
    carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
        cabinets.length,
            (index) => carouselCard(carouselData[index]['index'],
            carouselData[index]['distance'], carouselData[index]['duration']));

    // initialize map symbols in the same order as carousel widgets
    _kCabinetsList = List<CameraPosition>.generate(
        cabinets.length,
            (index) => CameraPosition(
            target: getLatLngFromCabinetData(carouselData[index]['index']),
            zoom: 15));
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_kCabinetsList[index]));

    // Add a polyLine between source and destination
    Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    for (CameraPosition _kCabinet in _kCabinetsList) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: _kCabinet.target,
          iconSize: 0.2,
          iconImage: "assets/icon/cabinet33.png",
        ),
      );
    }
    _addSourceAndLineLayer(0, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cabinets medicaux'),
        backgroundColor: Color(0xff3EBDE0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: MapboxMap(
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
              ),
            ),
            CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
                height: 100,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged:
                    (int index, CarouselPageChangedReason reason) async {
                  setState(() {
                    pageIndex = index;
                  });
                  _addSourceAndLineLayer(index, true);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
