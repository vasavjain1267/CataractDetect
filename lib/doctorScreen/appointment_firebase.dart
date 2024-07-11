import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Future<void> bookAppointment(String userId, Map<String, dynamic> appointment) async {
    await _db.collection('users').doc(userId).collection('Appointments').add(appointment);
  }

  Stream<List<Map<String, dynamic>>> getAppointments(String userId, String status) {
    return _db
        .collection('users')
        .doc(user!.uid)
        .collection('Appointments')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> updateAppointmentStatus(String userId, String appointmentId, String status) async {
    await _db.collection('users').doc(userId).collection('Appointments').doc(appointmentId).update({'status': status});
  }
}