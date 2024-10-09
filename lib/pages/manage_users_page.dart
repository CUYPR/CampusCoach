// lib/pages/manage_users_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart'; // Ensure you have this page for logout functionality
import 'package:url_launcher/url_launcher.dart'; // Add this package to launch URLs

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to users collection
  Stream<QuerySnapshot<Map<String, dynamic>>> get _usersStream =>
      _firestore.collection('users').snapshots();

  // Controllers for Add/Edit User Dialog
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cuEmailController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String _selectedRole = 'Player'; // Default role
  bool _isAdmin = false;
  String _adminName = '';
  bool _isLoading = false; // For loading indicators

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cuEmailController.dispose();
    _regNoController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  // Fetch current user's role and name
  Future<void> _fetchCurrentUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data();
        setState(() {
          _isAdmin = data?['role'] == 'Admin';
          _adminName = data?['name'] ?? 'Admin';
        });
      } else {
        // Handle case where user document does not exist
        setState(() {
          _isAdmin = false;
          _adminName = 'Admin';
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Method to add a new user
  Future<void> _addUser() async {
    _nameController.clear();
    _cuEmailController.clear();
    _regNoController.clear();
    _roleController.clear();
    _selectedRole = 'Player'; // Reset to default

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              // Personal Email Field
              TextField(
                controller: _cuEmailController,
                decoration: const InputDecoration(labelText: 'Personal Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              // Registration Number Field
              TextField(
                controller: _regNoController,
                decoration: const InputDecoration(labelText: 'Registration Number'),
              ),
              const SizedBox(height: 10),
              // Role Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: <String>['Admin', 'Player', 'Coach']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
              // Note: isFirstLogin is automatically set to true and not editable
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get Admin's Password
              String? adminPassword = await _promptForAdminPassword();
              if (adminPassword == null) {
                // User canceled password prompt
                return;
              }

              String name = _nameController.text.trim();
              String cuEmail = _cuEmailController.text.trim();
              String regNo = _regNoController.text.trim();
              String role = _selectedRole;
              bool isFirstLogin = true; // Automatically set to true

              if (name.isEmpty ||
                  cuEmail.isEmpty ||
                  regNo.isEmpty ||
                  role.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              // Validate personal email format
              final RegExp emailRegExp = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Simple email validation
              if (!emailRegExp.hasMatch(cuEmail)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid personal email')),
                );
                return;
              }

              // Validate regNo for alphanumeric only
              final RegExp regNoRegExp = RegExp(r'^[A-Za-z0-9]+$');
              if (!regNoRegExp.hasMatch(regNo)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration Number contains invalid characters.')),
                );
                return;
              }

              // Construct the login email using regNo
              String loginEmail = '$regNo@campuscoach.com';

              Navigator.pop(context); // Close the dialog

              setState(() {
                _isLoading = true;
              });

              try {
                String adminEmail = _auth.currentUser!.email!;

                // Check if regNo is unique
                final QuerySnapshot<Map<String, dynamic>> existingUsers = await _firestore
                    .collection('users')
                    .where('regNo', isEqualTo: regNo)
                    .get();

                if (existingUsers.docs.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration Number already exists.')),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                }

                // Create a new user in Firebase Authentication with the login email
                UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                    email: loginEmail, password: '123456'); // Use a strong temporary password

                User? newUser = userCredential.user;
                String newUserUid = newUser?.uid ?? '';

                // After creating the user, Firebase automatically signs in as the new user
                // We need to sign back in as the Admin
                await _auth.signOut();

                // Sign back in as Admin
                await _auth.signInWithEmailAndPassword(
                    email: adminEmail, password: adminPassword);

                if (newUserUid.isNotEmpty) {
                  // Add user details to Firestore
                  await _firestore.collection('users').doc(newUserUid).set({
                    'uid': newUserUid,
                    'name': name,
                    'cuEmail': cuEmail,
                    'email': loginEmail, // Login email
                    'regNo': regNo,
                    'role': role,
                    'isFirstLogin': isFirstLogin,
                    'createdBy': _adminName, // Set createdBy to Admin's name
                    'createdAt': FieldValue.serverTimestamp(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  });

                  // Send password reset email to the login email
                  await _auth.sendPasswordResetEmail(email: loginEmail);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'User added successfully. A password reset email has been sent to the login email.')),
                  );

                  // Refresh Admin's authentication state
                  await _auth.currentUser!.reload();
                  await _fetchCurrentUserDetails();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create user.')),
                  );
                }
              } on FirebaseAuthException catch (e) {
                String message = '';
                if (e.code == 'email-already-in-use') {
                  message = 'The login email address is already in use.';
                } else if (e.code == 'invalid-email') {
                  message = 'The login email address is invalid.';
                } else if (e.code == 'weak-password') {
                  message = 'The password is too weak.';
                } else if (e.code == 'wrong-password') {
                  message = 'The admin password is incorrect.';
                } else {
                  message = 'Authentication Error: ${e.message}';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } on FirebaseException catch (e) {
                String message = '';
                if (e.code == 'permission-denied') {
                  message = 'You do not have permission to add users.';
                  _handlePermissionDenied();
                } else {
                  message = 'Firestore Error: ${e.message}';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<String?> _promptForAdminPassword() async {
    String? password;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your password to confirm this action:'),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                password = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Confirm
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return password;
  }


  // Method to edit an existing user
  Future<void> _editUser(Map<String, dynamic> userData) async {
    _nameController.text = userData['name'] ?? '';
    _cuEmailController.text = userData['cuEmail'] ?? '';
    _regNoController.text = userData['regNo'] ?? '';
    _roleController.text = userData['role'] ?? '';
    _selectedRole = userData['role'] ?? 'Player';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              // Personal Email Field
              TextField(
                controller: _cuEmailController,
                decoration: const InputDecoration(labelText: 'Personal Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              // Registration Number Field (read-only to prevent changes)
              TextField(
                controller: _regNoController,
                decoration: const InputDecoration(labelText: 'Registration Number'),
                readOnly: true, // Prevent changing regNo as it affects login email
              ),
              const SizedBox(height: 10),
              // Role Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: <String>['Admin', 'Player', 'Coach']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
              // Note: isFirstLogin is not editable
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String name = _nameController.text.trim();
              String cuEmail = _cuEmailController.text.trim();
              String regNo = _regNoController.text.trim();
              String role = _roleController.text.trim().isEmpty
                  ? _selectedRole
                  : _roleController.text.trim();

              if (name.isEmpty || cuEmail.isEmpty || role.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              // Validate personal email format
              final RegExp emailRegExp = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Simple email validation
              if (!emailRegExp.hasMatch(cuEmail)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid personal email')),
                );
                return;
              }

              Navigator.pop(context); // Close the dialog

              setState(() {
                _isLoading = true;
              });

              try {
                String uid = userData['uid'];

                // Update user details in Firestore
                await _firestore.collection('users').doc(uid).update({
                  'name': name,
                  'cuEmail': cuEmail,
                  'role': role,
                  'updatedAt': FieldValue.serverTimestamp(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User updated successfully')),
                );

                // Refresh Admin's authentication state
                await _auth.currentUser!.reload();
                await _fetchCurrentUserDetails();
              } on FirebaseAuthException catch (e) {
                String message = '';
                if (e.code == 'invalid-email') {
                  message = 'The email address is invalid.';
                } else if (e.code == 'email-already-in-use') {
                  message = 'The email address is already in use.';
                } else {
                  message = 'Authentication Error: ${e.message}';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } on FirebaseException catch (e) { // Firestore-specific exceptions
                String message = '';
                if (e.code == 'permission-denied') {
                  message = 'You do not have permission to perform this action.';
                  _handlePermissionDenied();
                } else {
                  message = 'Firestore Error: ${e.message}';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Method to delete a user
  Future<void> _deleteUser(String uid, String name) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete user "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog

              setState(() {
                _isLoading = true;
              });

              try {
                // Fetch user data before deletion to get loginEmail
                DocumentSnapshot<Map<String, dynamic>> userDoc =
                await _firestore.collection('users').doc(uid).get();

                String loginEmail = userDoc.data()?['email'] ?? '';

                // Delete user from Firestore
                await _firestore.collection('users').doc(uid).delete();

                // Inform the Admin to manually delete the user from Firebase Authentication
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete from Authentication'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            'User has been deleted from Firestore. To fully remove the user, please delete them from Firebase Authentication manually.'),
                        const SizedBox(height: 10),
                        Text('Login Email: $loginEmail'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            // Open Firebase Authentication Users page
                            final Uri authUrl =
                            Uri.parse('https://console.firebase.google.com/project/${_firestore.app.name}/authentication/users');

                            if (await canLaunchUrl(authUrl)) {
                              await launchUrl(authUrl,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Could not launch Firebase Authentication page. Please navigate there manually.')),
                              );
                            }
                          },
                          child: const Text('Go to Authentication'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } on FirebaseException catch (e) {
                String message = '';
                if (e.code == 'permission-denied') {
                  message = 'You do not have permission to delete this user.';
                  _handlePermissionDenied();
                } else {
                  message = 'Error deleting user: ${e.message}';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting user: $e')),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red color for delete action
            ),
          ),
        ],
      ),
    );
  }

  // Method to handle permission denied errors
  void _handlePermissionDenied() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
            'You do not have the necessary permissions to perform this action. Please try logging out and logging back in to refresh your permissions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Widget to build each user row
  Widget _buildUserItem(Map<String, dynamic> userData) {
    String name = userData['name'] ?? 'N/A';
    String cuEmail = userData['cuEmail'] ?? 'N/A';
    String email = userData['email'] ?? 'N/A'; // login email
    String regNo = userData['regNo'] ?? 'N/A';
    String role = userData['role'] ?? 'N/A';
    bool isFirstLogin = userData['isFirstLogin'] ?? false;
    String createdBy = userData['createdBy'] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Login Email: $email'),
            Text('Email: $cuEmail'),
            Text('Reg No: $regNo'),
            Text('Role: $role'),
            Text('First Login: ${isFirstLogin ? 'Yes' : 'No'}'),
            Text('Created By: $createdBy'),
          ],
        ),
        trailing: _isAdmin
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Button
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () => _editUser(userData),
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(userData['uid'], name),
            ),
          ],
        )
            : null, // Hide buttons for non-admin users
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
        onPressed: _addUser,
        backgroundColor: const Color(0xFF566DA1),
        child: const Icon(Icons.add),
      )
          : null, // Hide FAB for non-admin users
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _usersStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // List of user documents
              final users = snapshot.data!.docs;

              if (users.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _buildUserItem(users[index].data());
                },
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
