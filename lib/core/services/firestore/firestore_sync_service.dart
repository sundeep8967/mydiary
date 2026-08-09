import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:storypad/core/databases/models/story_db_model.dart';
import 'package:storypad/core/services/logger/app_logger.dart';

class FirestoreSyncService {
  static final FirestoreSyncService instance = FirestoreSyncService._();
  FirestoreSyncService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> ensureAuthenticated() async {
    if (_auth.currentUser != null) return _auth.currentUser;
    try {
      final credential = await _auth.signInAnonymously();
      return credential.user;
    } catch (e) {
      AppLogger.error('FirestoreSyncService: Failed anonymous authentication: $e');
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>> _userStoriesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('stories');
  }

  Future<bool> syncStory(StoryDbModel story, {String? userId}) async {
    final uid = userId ?? currentUser?.uid;
    if (uid == null) {
      AppLogger.d('FirestoreSyncService: No user authenticated for syncStory');
      return false;
    }

    try {
      final docRef = _userStoriesCollection(uid).doc(story.id.toString());
      final json = story.toJson();
      json['syncedAt'] = FieldValue.serverTimestamp();
      await docRef.set(json, SetOptions(merge: true));
      AppLogger.d('FirestoreSyncService: Successfully synced story ${story.id}');
      return true;
    } catch (e, stack) {
      AppLogger.error('FirestoreSyncService: Error syncing story ${story.id}: $e', stackTrace: stack);
      return false;
    }
  }

  Future<bool> syncAllStories(List<StoryDbModel> stories, {String? userId}) async {
    final uid = userId ?? currentUser?.uid;
    if (uid == null) return false;

    try {
      final batch = _firestore.batch();
      for (final story in stories) {
        final docRef = _userStoriesCollection(uid).doc(story.id.toString());
        final json = story.toJson();
        json['syncedAt'] = FieldValue.serverTimestamp();
        batch.set(docRef, json, SetOptions(merge: true));
      }
      await batch.commit();
      AppLogger.d('FirestoreSyncService: Batch synced ${stories.length} stories');
      return true;
    } catch (e, stack) {
      AppLogger.error('FirestoreSyncService: Error in batch sync: $e', stackTrace: stack);
      return false;
    }
  }

  Future<List<StoryDbModel>> fetchStories({String? userId}) async {
    final uid = userId ?? currentUser?.uid;
    if (uid == null) return [];

    try {
      final snapshot = await _userStoriesCollection(uid).get();
      final List<StoryDbModel> stories = [];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          data.remove('syncedAt');
          stories.add(StoryDbModel.fromJson(data));
        } catch (e) {
          AppLogger.error('FirestoreSyncService: Error parsing story document ${doc.id}: $e');
        }
      }
      return stories;
    } catch (e, stack) {
      AppLogger.error('FirestoreSyncService: Error fetching stories: $e', stackTrace: stack);
      return [];
    }
  }

  Future<bool> deleteStory(int storyId, {String? userId}) async {
    final uid = userId ?? currentUser?.uid;
    if (uid == null) return false;

    try {
      await _userStoriesCollection(uid).doc(storyId.toString()).delete();
      AppLogger.d('FirestoreSyncService: Deleted story $storyId from Firestore');
      return true;
    } catch (e) {
      AppLogger.error('FirestoreSyncService: Error deleting story $storyId: $e');
      return false;
    }
  }
}
