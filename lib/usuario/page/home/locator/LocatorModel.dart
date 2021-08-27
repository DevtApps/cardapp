import 'package:cardapio/usuario/page/home/locator/AddressEdit.dart';
import 'package:cardapio/usuario/page/home/locator/LocatorView.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

import 'LocatorManager.dart';

abstract class LocatorModel extends State<LocatorView>
    with SingleTickerProviderStateMixin {
  TextEditingController addressController = TextEditingController();
  Set<Marker> markers = Set();
  GoogleMapController controller;
  List<SearchResult> places = [];
  CameraPosition cameraPosition =
      CameraPosition(target: LatLng(-22.5686791, -48.164824), zoom: 14);

  FocusNode nodeSearch = FocusNode();
  var loading = false;

  SearchResult place;

  var googlePlace = GooglePlace("AIzaSyAes8jQzNxHbHSzYdPlRlTTDr0AKnIIWkI");
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200),()async{
      var position = await determinePosition();
      if (position is Position) {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(position.latitude, position.longitude), 16),
        );
        List<Address> result = await Geocoder.local
            .findAddressesFromCoordinates(
            Coordinates(position.latitude, position.longitude));
        askUsePosition(result.first);
        setState(() {
          setMyLocation(LatLng(position.latitude, position.longitude));
        });
      }
    });
  }

  void askUsePosition(position){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usar seu local?"), action: SnackBarAction(label: "Sim",onPressed: ()async{
      var isNewAddress = await Navigator.of(context).push(
        PageRouteBuilder(
            maintainState: true,
            transitionDuration: Duration(milliseconds: 700),
            reverseTransitionDuration: Duration(milliseconds: 700),
            pageBuilder: (ctx, an1, an2) => AddressEdit(position),
            opaque: false),
      );
      if (isNewAddress != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Novo endereço adicionado")));
        Navigator.of(context).pop();
      }
    },),));
  }

  search() async {
    print(addressController.text);
    if (addressController.text.length > 3) {
      setState(() {
        places.clear();
        loading = true;
      });

      googlePlace.search.getTextSearch(addressController.text).then((value) {
        try {

          if (value.results.isNotEmpty) {
            if (nodeSearch.hasFocus)
              setState(() {
                loading = false;
                places = value.results;
              });
          }
        } catch (e) {
          print(e.toString());
          setState(() {
            loading = false;
            places = [];
          });
        }
      });
    }
  }

  setMyLocation(LatLng latlng) {
    Marker marker = Marker(
      draggable: true,
      onDragEnd: (newLatLang) {
        addressController.text = newLatLang.toString();
        search();
      },
      position: latlng,
      markerId: MarkerId("mylocation"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    markers.clear();
    markers.add(marker);
  }

  searchById(String id) async {
    DetailsResponse details =
        await googlePlace.details.get(id, language: "pt_BR");
    if (details.status == "OK") {
      return details.result;
    } else
      return null;
  }

  showSheet() async {
    List<Address> result = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(place.geometry.location.lat, place.geometry.location.lng));
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => AddressEdit(result.first)));
  }
}
