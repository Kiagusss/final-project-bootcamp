import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_scaffold/easy_scaffold.dart';
import 'package:final_project_bootcamp/bloc/auth_bloc/auth_bloc.dart';
import 'package:final_project_bootcamp/page/inventory_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _currentUser;
  String? _username;
  String? _email;
  String? _phoneNumber;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_currentUser!.uid).get();
      setState(() {
        _username = userDoc['username'];
        _email = userDoc['email'];
        _phoneNumber = userDoc['phoneNumber'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  openPage(const InventoryPage(), context);
                },
                child: const ListTile(
                  title: CustomText(text: "Product"),
                  trailing: Icon(Icons.food_bank_outlined),
                  // selected: true,
                  // selectedTileColor: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(Icons.menu)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogout());
            },
          ),
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: $_username',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Email: $_email', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Phone Number: $_phoneNumber',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
