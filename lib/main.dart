import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_test/home.dart';

void main() {
  runApp(ApiApp());
}

class ApiApp extends StatefulWidget {
  @override
  _ApiAppState createState() => _ApiAppState();
}

class _ApiAppState extends State<ApiApp> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      setState(() {
        users = jsonData.map((item) => User.fromJson(item)).toList();
      });
    }
  }

  Future<void> createUser() async {
    final user = User(id: users.length + 1, name: 'New User', email: '');
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final newUser = User.fromJson(json.decode(response.body));
      setState(() {
        users.add(newUser);
      });
    }
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<void> deleteUser(User user) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/users/${user.id}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        users.remove(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('API App'),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              onTap: () => _editUser(context, user),
              onLongPress: () => _deleteUser(context, user),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createUser(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _createUser(BuildContext context) async {
    await createUser();
  }

  void _editUser(BuildContext context, User user) async {
    final updatedUser = await showDialog<User>(
      context: context,
      builder: (context) => _UserDialog(user: user),
    );
    if (updatedUser != null) {
      await updateUser(updatedUser);
    }
  }

  void _deleteUser(BuildContext context, User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteUser(user);
    }
  }
}

class _UserDialog extends StatefulWidget {
  final User user;

  _UserDialog({required this.user});

  @override
  __UserDialogState createState() => __UserDialogState();
}

class __UserDialogState extends State<_UserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final updatedUser = User(
              id: widget.user.id,
              name: _nameController.text,
              email: _emailController.text,
            );
            Navigator.pop(context, updatedUser);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
