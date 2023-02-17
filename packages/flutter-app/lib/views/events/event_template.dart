import 'package:flutter_celo_composer/services/cloud/events/cloud_events.dart';
import 'package:flutter_celo_composer/services/cloud/events/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

typedef ConcessionCallBack = void Function(CloudEvents event);

class EventTemplate extends StatelessWidget {
  final Iterable<CloudEvents> events;
  final ConcessionCallBack onTap;

  const EventTemplate({
    super.key,
    required this.events,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    final eventSort = events.toList();
    eventSort
        .sort((a, b) => a.dateOfEvent.seconds.compareTo(b.dateOfEvent.seconds));
    return Column(
      children: [
        ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: eventSort.length,
          itemBuilder: (context, index) {
            final event = eventSort.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  onTap(event);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: storage.downloadUrl(event.imageUrl),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return SizedBox(
                                  width: 300,
                                  height: 250,
                                  child: Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  ));
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return Container();
                          }),
                      Text("Committee ${event.committeeName}"),
                      Text("Event ${event.eventName}"),
                      Text(
                          "Event Date ${event.dateOfEvent.toDate().day}/${event.dateOfEvent.toDate().month}/${event.dateOfEvent.toDate().year} ${event.dateOfEvent.toDate().hour}:${event.dateOfEvent.toDate().minute}"),
                      Text("Venue ${event.venue}"),
                      ElevatedButton(
                        onPressed: () {},
                        child: InkWell(
                          child: const Text("Register"),
                          onTap: () => launchUrlString(event.registrationLink),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
