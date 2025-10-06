import 'package:docterapp/controllers/docter_list_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class DoctorMapScreen extends StatefulWidget {
  const DoctorMapScreen({super.key});

  @override
  State<DoctorMapScreen> createState() => _DoctorMapScreenState();
}

class _DoctorMapScreenState extends State<DoctorMapScreen> {
  final DoctorController controller = Get.put(DoctorController());
  late osm.MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = osm.MapController(
      initPosition: osm.GeoPoint(latitude: 30.3753, longitude: 69.3451),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctors on Map",
          style: GoogleFonts.openSans(
            fontSize: 20,
            color: const Color(0xFF0B8FAC),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.blue),
            onPressed: () async {
              await mapController.currentLocation();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.doctor.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Convert Firestore GeoPoint -> OSM GeoPoint
        final doctorLocations = controller.doctor
            .map((doc) {
              final loc = doc["location"];
              if (loc is firestore.GeoPoint) {
                return osm.GeoPoint(
                  latitude: loc.latitude,
                  longitude: loc.longitude,
                );
              }
              return null;
            })
            .whereType<osm.GeoPoint>()
            .toList();

        if (doctorLocations.isEmpty) {
          return const Center(child: Text("No locations found for doctors"));
        }

        final firstLoc = doctorLocations.first;

        return Stack(
          children: [
            osm.OSMFlutter(
              controller: mapController,

              osmOption: osm.OSMOption(
                zoomOption: const osm.ZoomOption(
                  initZoom: 10,
                  minZoomLevel: 2,
                  maxZoomLevel: 18,
                  stepZoom: 1.0,
                ),
                userLocationMarker: osm.UserLocationMaker(
                  personMarker: const osm.MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const osm.MarkerIcon(
                    icon: Icon(Icons.navigation, color: Colors.blue, size: 48),
                  ),
                ),
                roadConfiguration: const osm.RoadOption(roadColor: Colors.blue),
              ),

              onMapIsReady: (isReady) async {
                if (isReady) {
                  // Move map to first doctor
                  await mapController.changeLocation(firstLoc);

                  // Add all doctor markers
                  for (var doc in controller.doctor) {
                    final loc = doc["location"];
                    if (loc is firestore.GeoPoint) {
                      final osmPoint = osm.GeoPoint(
                        latitude: loc.latitude,
                        longitude: loc.longitude,
                      );

                      await mapController.addMarker(
                        osmPoint,
                        markerIcon: osm.MarkerIcon(
                          iconWidget: Tooltip(
                            message: doc["speciality"] != null
                                ? "${doc["name"]} • ${doc["speciality"]}"
                                : doc["name"] ?? "Unknown",
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundImage: doc["image"] != null
                                            ? NetworkImage(doc["image"])
                                            : const AssetImage(
                                                    "assets/images/doctor.png",
                                                  )
                                                  as ImageProvider,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        doc["name"] ?? "Unknown",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            ),

            Positioned(
              right: 10,
              bottom: 80,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "zoomIn",
                    mini: true,
                    onPressed: () async => await mapController.zoomIn(),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: "zoomOut",
                    mini: true,
                    onPressed: () async => await mapController.zoomOut(),
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
