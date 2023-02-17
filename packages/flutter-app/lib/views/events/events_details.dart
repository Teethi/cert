import 'package:flutter_celo_composer/services/cloud/events/cloud_events.dart';
import 'package:flutter_celo_composer/services/cloud/events/firebase_storage.dart';
import 'package:flutter_celo_composer/utilities/generics/get_arguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late String _eventName;
  late Timestamp _eventDate;
  late String _eventDetails;
  late String _imgUrl;

  Future<void> getExistingEvents(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudEvents>();
    if (widgetConcession != null) {
      _eventName = widgetConcession.eventName;
      _eventDate = widgetConcession.dateOfEvent;
      _eventDetails = widgetConcession.eventDetails;
      _imgUrl = widgetConcession.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getExistingEvents(context),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Column(children: [
                        FutureBuilder(
                            future: storage.downloadUrl(_imgUrl),
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
                        const Text("Event Details"),
                        Text("Event Name $_eventName"),
                        Text(
                            "Event Date ${_eventDate.toDate().day}/${_eventDate.toDate().month}/${_eventDate.toDate().year} ${_eventDate.toDate().hour}:${_eventDate.toDate().minute}"),
                        Text("Venue $_eventDetails"),
                      ]);
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
