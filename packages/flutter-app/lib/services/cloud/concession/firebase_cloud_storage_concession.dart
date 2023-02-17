import 'package:flutter_celo_composer/services/cloud/concession/cloud_concession.dart';
import 'package:flutter_celo_composer/services/cloud/concession/cloud_storage_constants_concession.dart';
import 'package:flutter_celo_composer/services/cloud/cloud_storage_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorageConcession {
  final concessions = FirebaseFirestore.instance.collection('concessions');

  Future<void> deleteConcession({required String documentConcessionId}) async {
    try {
      await concessions.doc(documentConcessionId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateConcession({
    required String documentConcessionId,
    required String trainClass,
    required String period,
    required String dateOfApplication,
    required String receivedStatus,
    required String completedStatus,
  }) async {
    try {
      await concessions.doc(documentConcessionId).update({
        trainClassField: trainClass,
        periodField: period,
        dateOfApplicationField: dateOfApplication,
        receivedStatusField: receivedStatus,
        completedStatusField: completedStatus,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudConcession>> allConcessions({required String userId}) =>
      concessions.snapshots().map(((event) => event.docs
          .map((doc) => CloudConcession.fromSnapshot(doc))
          .where((concession) => concession.userId == userId)));

  Stream<Iterable<CloudConcession>> allTrueConcessions(
          {required String userId}) =>
      concessions.snapshots().map(((event) => event.docs
          .map((doc) => CloudConcession.fromSnapshot(doc))
          .where((concession) =>
              concession.receivedStatus == "true" &&
              concession.completedStatus == "false")));

  Future<CloudConcession> createNewConcession({
    required String userId,
    required String name,
    required String gender,
    required String email,
    required String nearestStation,
    required String address,
    required String dob,
    required String destinationStation,
  }) async {
    // final document =
    final document = await concessions.add({
      userIdField: userId,
      nameField: name,
      genderField: gender,
      emailField: email,
      nearestStationField: nearestStation,
      addressField: address,
      dobField: dob,
      destinationStationField: destinationStation,
      trainClassField: "",
      periodField: "",
      dateOfApplicationField: "",
      receivedStatusField: "false",
      completedStatusField: "false",
    });
    final fetchedConcession = await document.get();
    return CloudConcession(
      documentConcessionId: fetchedConcession.id,
      userId: userId,
      name: name,
      gender: gender,
      email: email,
      nearestStation: nearestStation,
      address: address,
      dob: dob,
      destinationStation: destinationStation,
      trainClass: "",
      period: "",
      dateOfApplication: "",
      receivedStatus: "false",
      completedStatus: "false",
    );
  }

  static final FirebaseCloudStorageConcession _shared =
      FirebaseCloudStorageConcession._sharedInstance();
  FirebaseCloudStorageConcession._sharedInstance();
  factory FirebaseCloudStorageConcession() => _shared;
}
