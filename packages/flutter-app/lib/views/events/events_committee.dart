import 'package:flutter_celo_composer/enums/menu_action.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_celo_composer/services/auth/bloc/auth_event.dart';
import 'package:flutter_celo_composer/services/cloud/events/cloud_events.dart';
import 'package:flutter_celo_composer/services/cloud/events/firebase_cloud_events_storage.dart';
import 'package:flutter_celo_composer/services/cloud/events/firebase_storage.dart';
import 'package:flutter_celo_composer/utilities/dialogs/logout_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_celo_composer/services/auth/auth_service.dart';
import 'package:flutter_celo_composer/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsAdd extends StatefulWidget {
  const EventsAdd({super.key});

  @override
  State<EventsAdd> createState() => _EventsAddState();
}

class _EventsAddState extends State<EventsAdd> {
  TimeOfDay _day = const TimeOfDay(hour: 10, minute: 30);
  DateTime _dob = DateTime(2023, 01, 01);
  late final TextEditingController _details;
  late final TextEditingController _eventName;
  late final DateTime now;
  late final String _imageUrl;
  late final TextEditingController _venue;
  late final TextEditingController _registrationLink;
  late final TextEditingController _committeeName;
  late Timestamp _date;

  final currentUser = AuthService.firebase().currentUser!;

  CloudEvents? _events;
  late final FirebaseCloudStorageEvents _eventsService;

  @override
  void initState() {
    now = DateTime.now();
    _registrationLink = TextEditingController();
    _venue = TextEditingController();
    _eventsService = FirebaseCloudStorageEvents();
    _eventName = TextEditingController();
    _details = TextEditingController();
    _committeeName = TextEditingController();
    super.initState();
  }

  Future<CloudEvents> createNewEvent() async {
    final existingEvents = _events;
    if (existingEvents != null) {
      return existingEvents;
    }
    final newEvents = await _eventsService.createNewEvent(
      dateOfEvent: _date,
      eventDetails: _details.text,
      eventName: _eventName.text,
      imageUrl: _imageUrl,
      registrationLink: _registrationLink.text,
      venue: _venue.text,
      committeeName: _committeeName.text,
    );
    _events = newEvents;
    return newEvents;
  }

  @override
  void dispose() {
    _eventName.dispose();
    _details.dispose();
    _venue.dispose();
    _registrationLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Add"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (!mounted) return;
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("loc.logout_button"),
                ),
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Committee Name"),
              TextField(
                controller: _committeeName,
                enableSuggestions: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Committee Name",
                ),
              ),
              const Text("Event Name"),
              TextField(
                controller: _eventName,
                enableSuggestions: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Event Name",
                ),
              ),
              const Text("Event Details"),
              TextField(
                controller: _details,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Event Details",
                ),
              ),
              const Text("Registration Link"),
              TextField(
                controller: _registrationLink,
                enableSuggestions: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Registration Link",
                ),
              ),
              const Text("Venue"),
              TextField(
                controller: _venue,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Venue",
                ),
              ),
              ElevatedButton(
                onPressed: (() async {
                  final results = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: false,
                    allowCompression: true,
                    allowedExtensions: ['png', 'jpg'],
                  );

                  if (results == null) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No File has been picked"),
                    ));
                    return;
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image Uploaded"),
                    ));
                  }
                  final newName =Timestamp.now();
                  final path = results.files.single.path!;
                  final fileName = newName.toString();
                  storage.uploadFile(path, fileName);
                  _imageUrl = newName.toString();
                }),
                child: const Text("Upload"),
              ),
              const Text("Date and time of the Event"),
              Text(
                  "${_dob.day}/${_dob.month}/${_dob.year} ${_day.hour}:${_day.minute}"),
              ElevatedButton(
                child: const Text("Select Date"),
                onPressed: () async {
                  DateTime? dob = await showDatePicker(
                    context: context,
                    initialDate: _dob,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(now.year + 2),
                  );
                  if (dob == null) {
                    return;
                  }
                  setState(() => _dob = dob);
                },
              ),
              ElevatedButton(
                child: const Text("Select Time"),
                onPressed: () async {
                  TimeOfDay? day = await showTimePicker(
                    context: context,
                    initialTime: _day,
                  );

                  if (day == null) {
                    return;
                  }
                  setState(() => _day = day);
                },
              ),
              ElevatedButton(
                onPressed: (() async {
                  final DateTime a = DateTime(
                      _dob.year, _dob.month, _dob.day, _day.hour, _day.minute);

                  _date = Timestamp.fromDate(a);
                  createNewEvent();
                  await showRegistrationDialog(context);
                  if (!mounted) return;
                }),
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
