import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_locator/GlobalProvider.dart';
import 'package:provider/provider.dart';

//----------------------------------------------------------------------------//
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//----------------------------------------------------------------------------//
class _HomePageState extends State<HomePage> {
//----------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).init();
  }

//----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Provider.of<LocationProvider>(context, listen: true);
    return Scaffold(
      body: _buildBody(),
    );
  }

  //----------------------------------------------------------------------------//
  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: _getMap(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 5, right: 5),
          child: Consumer<LocationProvider>(
              builder: (context, providerValue, child) {
                if (providerValue.currentLocation?.latitude == null) {
                  return const Text(
                    'Current Location: 0, 0',
                    style: TextStyle(fontSize: 16.0),
                  );
                }
                return Text(
                  'Current Location: ${providerValue.currentLocation?.latitude ?? 0}, ${providerValue.currentLocation?.longitude ?? 0}',
                  style: const TextStyle(fontSize: 14.0),
                );
              }),
        ),
        Padding(
          padding:
          const EdgeInsets.only(left: 5.0, top: 5, right: 5, bottom: 10),
          child: Consumer<LocationProvider>(
              builder: (context, providerValue, child) {
                if (providerValue.Findcity == null) {
                  return const Text(
                    'Current Address:',
                    style: TextStyle(fontSize: 16.0),
                  );
                }
                return Text(
                  'Current Address: ${providerValue.Findcity ?? ""}, ${providerValue.Findstate ?? ""}, ${providerValue.Findcountry ?? ""}',
                  style: const TextStyle(fontSize: 14.0),
                );
              }),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------//
  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("assets/Marker.png")),
    );
  }

  //----------------------------------------------------------------------------//
  Widget _getMap() {
    return Stack(
      children: [
        Consumer<LocationProvider>(builder: (context, providerValue, child) {
          if (providerValue.currentLocation?.latitude == null) {
            return Container();
          }
          return GoogleMap(
            initialCameraPosition: providerValue.cameraPosition!,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              // now we need a variable to get the controller of google map
              if (!providerValue.googleMapController.isCompleted) {
                providerValue.googleMapController.complete(controller);
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        }),
        Positioned.fill(
            child: Align(alignment: Alignment.center, child: _getMarker()))
      ],
    );
  }
}
