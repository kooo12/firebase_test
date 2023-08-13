import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/add_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final Stream<QuerySnapshot<Map>> _contactDocs =
      FirebaseFirestore.instance.collection('contacts').snapshots();

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
        body: StreamBuilder<QuerySnapshot<Map>>(
            stream: _contactDocs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map>>? contactDocsList =
                    snapshot.data?.docs;
                if (contactDocsList != null) {
                  return ListView.builder(
                      itemCount: contactDocsList.length,
                      itemBuilder: (context, position) {
                        QueryDocumentSnapshot contactDoc =
                            contactDocsList[position];
                        return ListTile(
                          title: Text(contactDoc['name']),
                          subtitle: Text(contactDoc['address']),
                          trailing: Text(contactDoc['age']),
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
