import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_youth/data/unit.dart';

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
        'xp': 0,
        'level': 1,
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

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
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

  Future<void> updateProgress(
    int unitNum,
    Map<String, dynamic> feedback,
    String scenario,
    String userResponse,
  ) async {
    if (_user == null) return;
    try {
      //get user data
      //initial XP Gained value
      int xpGained = 3;
      if (feedback['score'] <= 10 && feedback['score'] >= 8) {
        xpGained = 10;
      } else if (feedback['score'] <= 7 && feedback['score'] >= 5) {
        xpGained = 5;
      }
      int level = _userData?['level'];
      int xpCost = 15 + 5 * (level - 1);
      int currXP = _userData?['xp'] + xpGained;
      if (currXP >= xpCost) {
        level++;
        currXP -= xpCost;
      }

      await _db.collection('users').doc(_user!.uid).update({
        'level': level,
        'xp': currXP,
      });
      await _db.collection('users').doc(_user!.uid).collection('progress').add({
        'unitNumber': unitNum,
        'scenario': scenario,
        'response': userResponse,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await loadUserData();
    } on Exception catch (e) {
      print("Error updating the user progress");
    } finally {
      notifyListeners();
    }
  }

  Future<List<double>> getAvgScore() async {
    try {
      final snapshot =
          await _db
              .collection('users')
              .doc(_user!.uid)
              .collection('progress')
              .get();
      double totalscore = 0;
      int completedScenarios = snapshot.docs.length;

      List<double> getAvgScorePerUnit = List.generate(
        units.length,
        (index) => 0.0,
      );
      List<int> completedScenariosPerUnit = List.generate(
        units.length,
        (index) => 0,
      );
      for (final doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        int unitNumber = data['unitNumber'];
        int docScore = data['feedback']['score'];
        getAvgScorePerUnit[unitNumber - 1] += docScore;
        completedScenariosPerUnit[unitNumber - 1]++;
      }

      for (int i = 0; i < getAvgScorePerUnit.length; i++) {
        if (completedScenariosPerUnit[i] != 0) {
          getAvgScorePerUnit[i] /= completedScenariosPerUnit[i];
        } else {
          getAvgScorePerUnit[i] = 0;
        }
      }
      return getAvgScorePerUnit;
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error resetting password!");
      //when we catch an error, print it out and throw the same error to
      // this method
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } catch (e) {
      print("Password is already in use");
      rethrow;
    }
  }
}
