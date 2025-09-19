import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isAuthen = false;
  String _email = '';
  String _password = '';
  String _username = '';
  final _formKey = GlobalKey<FormState>();
  void _submit() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isAuthen = true;
    });
    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
              'id': credential.user!.uid,
              'email': _email,
              'username': _username,
              'createdAt': Timestamp.now(),
            });
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message!)));
    }
    if (!mounted) return;
    setState(() {
      _isAuthen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/chat.png', width: 250),
                Card(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null ||
                                    value.trim() == '' ||
                                    !value.contains('@')) {
                                  return 'please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _email = newValue!,
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'password must be at least 6 characters.';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _password = newValue!,
                            ),
                            if (!_isLogin) SizedBox(height: 4),
                            if (!_isLogin)
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                ),

                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 4) {
                                    return 'username must be at least 4 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) => _username = newValue!,
                              ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                _submit();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                              ),
                              child:
                                  _isAuthen
                                      ? SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(),
                                      )
                                      : Text(_isLogin ? 'Log in' : 'Sign up'),
                            ),
                            if (!_isAuthen)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'Create an account'
                                      : 'I already have an account',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
