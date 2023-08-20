import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  
  final CollectionReference movieCollection = FirebaseFirestore.instance.collection('Movies');
  final CollectionReference collectionCollection = FirebaseFirestore.instance.collection('History');
  final CollectionReference ticketsCollection = FirebaseFirestore.instance.collection('Tickets');

}