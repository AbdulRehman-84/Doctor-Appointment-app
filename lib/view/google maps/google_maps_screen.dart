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
  final TextEditingController searchController = TextEditingController();

  /// yahan doctors ke location ke sath unki detail store karenge
  final Map<osm.GeoPoint, Map<String, dynamic>> doctorMap = {};

  @override
  void initState() {
    super.initState();
    mapController = osm.MapController(
      initPosition: osm.GeoPoint(latitude: 30.3753, longitude: 69.3451),
    );
  }

  /// Doctor search by name
  Future<void> _searchDoctor(String query) async {
    if (query.isEmpty) return;

    final matchedDoctor = controller.doctor.firstWhereOrNull(
      (doc) => (doc["name"] ?? "").toString().toLowerCase().contains(
        query.toLowerCase(),
      ),
    );

    if (matchedDoctor != null) {
      final loc = matchedDoctor["location"];
      if (loc is firestore.GeoPoint) {
        final geoPoint = osm.GeoPoint(
          latitude: loc.latitude,
          longitude: loc.longitude,
        );

        await mapController.changeLocation(geoPoint);
        await mapController.setZoom(zoomLevel: 14.0);

        Get.snackbar(
          "Doctor Found",
          matchedDoctor["name"] ?? "Unknown",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 1),
        );
      }
    } else {
      Get.snackbar(
        "Not Found",
        "No doctor matched your search",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
      );
    }
  }

  /// 🔽 Bottom Sheet for doctor details
  void _showDoctorDetails(Map<String, dynamic> doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          doc["image"].toString().startsWith("http")
                          ? NetworkImage(doc["image"])
                          : AssetImage(doc["image"]) as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        doc["name"] ?? "Unknown",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text("Speciality: ${doc["speciality"] ?? "N/A"}"),
                Text("Fee: Rs. ${doc["fee"] ?? "N/A"}"),
                Text("Rating: ⭐ ${doc["rating"] ?? "N/A"}"),
                const SizedBox(height: 10),
                Text(
                  doc["desc"] ?? "",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  doc["details"] ?? "",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
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

        final doctorLocations = controller.doctor
            .map((doc) {
              final loc = doc["location"];
              if (loc is firestore.GeoPoint) {
                final geo = osm.GeoPoint(
                  latitude: loc.latitude,
                  longitude: loc.longitude,
                );
                doctorMap[geo] = doc; // doctor info ko map mein save
                return geo;
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
            /// 🌍 Map Widget
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

              /// Add markers after map ready
              onMapIsReady: (isReady) async {
                if (isReady) {
                  await mapController.changeLocation(firstLoc);
                  await mapController.setZoom(zoomLevel: 12.0);

                  for (var entry in doctorMap.entries) {
                    await mapController.addMarker(
                      entry.key,
                      markerIcon: osm.MarkerIcon(
                        iconWidget: Column(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 55,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
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
                              child: Text(
                                entry.value["name"] ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },

              /// 👇 Marker click handler
              onGeoPointClicked: (geoPoint) {
                final doc = doctorMap[geoPoint];
                if (doc != null) {
                  _showDoctorDetails(doc);
                }
              },
            ),

            /// 🔍 Search Bar
            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search doctor by name...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: searchController,
                      builder: (context, value, child) {
                        return value.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: _searchDoctor,
                ),
              ),
            ),

            /// ➕ ➖ Zoom buttons
            Positioned(
              right: 10,
              bottom: 80,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: const Color(0xFF0B8FAC),
                    heroTag: "zoomIn",
                    mini: true,
                    onPressed: () async => await mapController.zoomIn(),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    backgroundColor: const Color(0xFF0B8FAC),
                    heroTag: "zoomOut",
                    mini: true,
                    onPressed: () async => await mapController.zoomOut(),
                    child: const Icon(Icons.remove, color: Colors.white),
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
