import 'package:cardapio/usuario/page/home/locator/LocatorManager.dart';
import 'package:cardapio/usuario/page/home/locator/LocatorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'AddressEdit.dart';

class LocatorView extends StatefulWidget {
  @override
  _LocatorViewState createState() => _LocatorViewState();
}

class _LocatorViewState extends LocatorModel {
  hide() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    hide();
  }

  @override
  void initState() {
    super.initState();
    hide();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    hide();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            markers: markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: cameraPosition,
            zoomGesturesEnabled: true,
            onMapCreated: (controller) {
              this.controller = controller;
            },
            onTap: (LatLng lng) {
              nodeSearch.unfocus();
              setState(() {});
            },
          ),
          Container(
            margin: EdgeInsets.only(
                left: 8, right: 8, top: MediaQuery.of(context).padding.top + 8),
            child: Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(4),
                  child: TextField(
                    onEditingComplete: () {
                      search();
                    },
                    focusNode: nodeSearch,
                    controller: addressController,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: "Search...",
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.orange,
                        )),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  height: nodeSearch.hasFocus
                      ? loading
                          ? size.height * 0.1
                          : places.length < 5
                              ? size.height * (places.length / 10)
                              : size.height * 0.5
                      : 0,
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                            value: null,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (c, i) {
                            return ListTile(
                              dense: true,
                              title: Text(places[i].name),
                              subtitle: Text(
                                places[i].formattedAddress,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              onTap: () async {
                                place = places[i];
                                nodeSearch.unfocus();
                                await controller.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      LatLng(places[i].geometry.location.lat,
                                          places[i].geometry.location.lng),
                                      16),
                                );
                                Future.delayed(Duration(milliseconds: 600), () {
                                  setState(() {
                                    setMyLocation(LatLng(
                                        places[i].geometry.location.lat,
                                        places[i].geometry.location.lng));
                                  });
                                  showSheet();
                                });
                              },
                            );
                          },
                          itemCount: places.length,
                        ),
                ),
              ],
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var position = await determinePosition();
          if (position is Position) {
            await controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                  LatLng(position.latitude, position.longitude), 16),
            );
            List<Address> result = await Geocoder.local
                .findAddressesFromCoordinates(
                    Coordinates(position.latitude, position.longitude));
            setState(() {
              setMyLocation(LatLng(position.latitude, position.longitude));
            });
            askUsePosition(result.first);
          }
        },
        child: Icon(
          Icons.my_location_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
