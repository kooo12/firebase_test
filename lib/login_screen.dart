import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  String? _verificationID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: (_codeSent)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: _verificationID!,
                                smsCode: _otpController.text);
                        FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {})
                            .catchError((e) {});
                      },
                      child: const Text('Verify')),
                  (_loading)
                      ? const CircularProgressIndicator()
                      : const SizedBox()
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefix: Text('09')),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                        });
                        if (_phoneController.text.length > 5) {
                          FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+959${_phoneController.text}',
                              verificationCompleted: (credential) {},
                              verificationFailed: (exception) {},
                              codeSent: (s, n) {
                                _verificationID = s;
                                setState(() {
                                  _codeSent = true;
                                  _loading = false;
                                });
                              },
                              codeAutoRetrievalTimeout: (str) {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter vaild number')));
                        }
                      },
                      child: const Text('Get OTP')),
                  (_loading)
                      ? const CircularProgressIndicator()
                      : const SizedBox()
                ],
              ),
      ),
    );
  }
}
