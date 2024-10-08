// functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Cloud Function to delete a Firebase Authentication user
 * when their corresponding Firestore document is deleted.
 */
exports.deleteAuthUser = functions.firestore
    .document("users/{userId}")
    .onDelete(async (snap, context) => {
      const uid = context.params.userId;

      try {
      // Delete the user from Firebase Authentication
        await admin.auth().deleteUser(uid);
        console.log(`Successfully deleted user with UID: ${uid}`);
      } catch (error) {
        console.error(`Error deleting user with UID: ${uid}`, error);
      }
    });
