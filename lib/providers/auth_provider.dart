import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//AuthProvider holds all the code for authentication state-encapsulation of all relevant code that are important to it
class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //user must have a ?(null operator) because a user may or may not exist
  User? _user;
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  User? get user => _user;

  AuthenticationProvider() {
    //stream of user data and the authentication changes without notice.
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
    //listen is a function. when the program receive the user input,
    //the program stores it into the instance variable so it can be accessed by
    //the user in the app.
  }

  Future<void> loadUserData() async {
    if (_user == null) {
      return;
    }
    try {
      final doc = await _db.collection('users').doc(_user!.uid).get();
      _userData = doc.data();
      if (_userData != null) {
        _userData!['uid'] = _user!.uid;
      }
      //notifyListeners() notify the rest of the widgets, that depend on the authentication state,
      // that the authentication state has changed
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _db.collection('users').doc(credential.user!.uid).set({
        //creating documents
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } finally {
      notifyListeners();
    }
  }

  Future<void> login(String email, String pswd) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pswd,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
  }) async {
    if (_user == null) {
      return;
    }
    //fill in the updatedProfile map with only the elements
    // the user wants to update
    //only add non-null fields to updatedProfile
    Map<String, dynamic> updatedProfile = {};
    if (firstName != null) {
      updatedProfile['firstName'] = firstName;
    }
    if (lastName != null) {
      updatedProfile['lastName'] = lastName;
    }
    if (username != null) {
      updatedProfile['username'] = username;
    }
    try {
      await _db.collection('users').doc(_user!.uid).update(updatedProfile);
      await loadUserData();
    } finally {
      notifyListeners();
    }
  }
}
