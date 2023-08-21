import 'dart:io';

import 'package:firebase_test/image/image_service.dart';
import 'package:firebase_test/model/person.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final CollectionReference<Person> _contacts = FirebaseFirestore.instance
      .collection('contacts')
      .withConverter<Person>(
          fromFirestore: (snapshot, _) => Person.fromMap(snapshot.data()!),
          toFirestore: (person, _) => person.toMap());
  bool _loading = false;
  bool _success = false;
  bool _error = false;
  File? _profilePic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Contacts'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Name',
                  label: Text('Name'),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Age',
                  label: Text('Age'),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Address',
                  label: Text('Address'),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () async {
                    File? image = await selectImage();
                    if (image != null) {
                      setState(() {
                        _profilePic = image;
                      });
                    }
                  },
                  icon: const Icon(Icons.photo)),
              (_profilePic != null)
                  ? Image.file(
                      _profilePic!,
                      width: 100,
                      height: 100,
                    )
                  : const SizedBox(),
              ElevatedButton(
                  onPressed: _addContacts, child: const Text('Save contacts')),
              (_loading) ? const CircularProgressIndicator() : const SizedBox(),
              (_success) ? const Text('Success') : const SizedBox(),
              (_error) ? const Text('Error') : const SizedBox(),
            ],
          ),
        ));
  }

  Future<void> _addContacts() async {
    String? profileUrl;
    setState(() {
      _loading = true;
      _success = false;
      _error = false;
    });
    if (_profilePic != null) {
      profileUrl = await uploadImage(_profilePic!);
    }

    _contacts
        .add(Person(_name.text, _age.text, _address.text,
            DateTime.now().microsecondsSinceEpoch, profileUrl))
        .then((value) {
      setState(() {
        _loading = false;
        _success = true;
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }).whenComplete(() {
      _name.text = '';
      _age.text = '';
      _address.text = '';
    });
  }
}
