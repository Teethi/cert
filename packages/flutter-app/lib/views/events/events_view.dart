import 'package:flutter_celo_composer/constants/routes.dart';
import 'package:flutter_celo_composer/services/auth/auth_service.dart';
import 'package:flutter_celo_composer/services/cloud/events/cloud_events.dart';
import 'package:flutter_celo_composer/services/cloud/events/firebase_cloud_events_storage.dart';
import 'package:flutter_celo_composer/services/cloud/events/firebase_storage.dart';
import 'package:flutter_celo_composer/views/events/event_template.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  late final FirebaseCloudStorageEvents _eventsService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;
  final DateTime today = DateTime.now();

  @override
  void initState() {
    _eventsService = FirebaseCloudStorageEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event view"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Events"),
              StreamBuilder(
                stream: _eventsService.allEvents(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allEvents =
                            snapshot.data as Iterable<CloudEvents>;
                        if (allEvents.isNotEmpty) {
                          for (var i in allEvents) {
                            if (i.dateOfEvent.toDate().isBefore(today)) {
                              _eventsService.deleteEvent(
                                  documentEventId: i.documentEventId);
                              storage.deleteImage(i.imageUrl);
                            }
                          }
                          return Column(
                            children: [
                              EventTemplate(
                                events: allEvents,
                                onTap: (event) {
                                  Navigator.of(context).pushNamed(
                                    eventsDetails,
                                    arguments: event,
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const Text("No Event To Show");
                        }
                      } else {
                        return const Text("No Event To Show");
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
