import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarehub/models/delivery.dart';

class DeliveryProvider extends ChangeNotifier {
  late CollectionReference _deliveriesCollectionRef;

  List<Delivery> _deliveries = [];

  List<Delivery> get deliveries => _deliveries;

  DeliveryProvider() {
    _deliveriesCollectionRef =
        FirebaseFirestore.instance.collection('deliveries');
    _loaddeliveries();
  }

  Future<void> _loaddeliveries() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot = await _deliveriesCollectionRef.get();
      _deliveries =
          snapshot.docs.map((doc) => Delivery.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading deliveries: $e');
    }
  }

  Future<void> loadDeliveries(String userId) async {
    try {
      final snapshot =
          await _deliveriesCollectionRef.where('userId', isEqualTo: userId).get();
      _deliveries =
          snapshot.docs.map((doc) => Delivery.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading deliveries: $e');
    }
  }

  Future<void> addDelivery(
      String orderId,
      String status,
    ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final docRef = await _deliveriesCollectionRef.add({
        'orderId': orderId,
        'status': status,
      });
      final delivery = Delivery(
        id: docRef.id,
        orderId: orderId,
        status: status,
      );
      _deliveries.add(delivery);
      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  
  Future<void> updateDelivery(Delivery delivery) async {
    try {
      await _deliveriesCollectionRef.doc(delivery.id).update(delivery.toMap());
      _deliveries[_deliveries.indexWhere((t) => t.id == delivery.id)] = delivery;
      notifyListeners();
    } catch (e) {
      print('Error updating delivery: $e');
    }
  }


  Future<void> deleteDeliveryById(String id) async {
    try {
      await _deliveriesCollectionRef.doc(id).delete();
      _deliveries.removeWhere((delivery) => delivery.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting delivery: $e');
    }
  }

}
