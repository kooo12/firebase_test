import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/add_screen.dart';
import 'package:firebase_test/model/person.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot<Person>> _contactDocs = FirebaseFirestore.instance
      .collection('contacts')
      .withConverter<Person>(
          fromFirestore: (snapshot, _) => Person.fromMap(snapshot.data()!),
          toFirestore: (person, _) => person.toMap())
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Test'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot<Person>>(
            stream: _contactDocs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Person>>? contactDocsList =
                    snapshot.data?.docs;
                if (contactDocsList != null) {
                  return ListView.builder(
                      itemCount: contactDocsList.length,
                      itemBuilder: (context, position) {
                        QueryDocumentSnapshot<Person> contactDoc =
                            contactDocsList[position];
                        return Card(
                          child: ListTile(
                              title: Text(contactDoc.data().name ?? ''),
                              subtitle: Text(contactDoc.data().address ?? ''),
                              trailing: Text(contactDoc.data().age ?? ''),
                              leading: (contactDoc.data().profileUrl != null)
                                  ? Image.network(
                                      contactDoc.data().profileUrl!,
                                      width: 45,
                                      height: 40,
                                    )
                                  : const SizedBox()),
                        );
                      });
                } else {
                  return const Text('Empty Dat');
                }
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something Wrong'),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
