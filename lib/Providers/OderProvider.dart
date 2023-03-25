import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/Oder.dart';


class OderProvider with ChangeNotifier {
 // final DatabaseReference _database = FirebaseDatabase.instance.reference();
  late CollectionReference _oderCollectionRef;

  List<Oder> _Oder = [];

  List<Oder> get oder => _Oder;


OderProvider(){
  _oderCollectionRef = FirebaseFirestore.instance.collection('OderItems');
}

  Future<void> loadAllOder() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot =
          await _oderCollectionRef.get();
      _Oder =
          snapshot.docs.map((doc) => Oder.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }
 
Future<void> loadCartItems(String userId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot =
          await _oderCollectionRef.where('userId', isEqualTo: userId).get();
      _Oder =
          snapshot.docs.map((doc) => Oder.fromDocumentSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading items: $e');
    }
  }

 Future<void> addOder(String name, double price,int quantity,String itemId,String status ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final docRef = await _oderCollectionRef.add({
        'name': name,
        'price': price,
        'quantity': quantity,
        'userId': user!.uid,
        'itemId': itemId,
        'status':status,
      });
      final oder =Oder(
        id: docRef.id,
        name: name,
        price: price,
        quantity: quantity,
        userId: user.uid,
        itemId:itemId,
        status:status,
      );
      _Oder.add(oder);
      notifyListeners();
    } catch (e) {
      print('Error adding cartItem: $e');
    }
  }

  Future<void> updateItem(Oder oder) async {
    try {
      await _oderCollectionRef.doc(oder.id).update(oder.toMap());
      _Oder[_Oder.indexWhere((t) => t.id == oder.id)] = oder;
      notifyListeners();
    } catch (e) {
      print('Error updating item: $e');
    }
  }


Future<void> deleteOderById(String id) async {
    try {
      await _oderCollectionRef.doc(id).delete();
      _Oder.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }


}
