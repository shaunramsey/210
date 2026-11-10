import 'package:clouddemo/stream_fetch.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAuthWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<MyAuthWidget> createState() => _MyAuthWidgetState();
}

class _MyAuthWidgetState extends State<MyAuthWidget> {
  bool _obscureVision = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login({bool register = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error message
    });
    try {
      if (register) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } catch (e) {
      debugPrint('Error during ${register ? 'registration' : 'login'}: $e');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
      // Handle errors here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: StreamBuilder<User?>(
        // Listen to Firebase auth state changes dynamically
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If Firebase is still checking the login status, show a loading spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            //return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _errorMessage,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.email),
                  ],
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText:
                                  _errorMessage, // Display error message if any
                            ),

                            obscureText: _obscureVision,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: _obscureVision
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureVision = !_obscureVision;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(58.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: Text('Login | $_isLoading'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _login(register: true),
                  child: Text('Register | $_isLoading'),
                ),
                Center(child: Text('No user is currently logged in.')),
              ],
            );
          }
          _passwordController.clear();
          _emailController.clear();
          return CloudStreamCount(
            email: snapshot.data?.email ?? "None",
            uid: snapshot.data?.uid ?? "NULL",
          );
        },
      ),
    );
  }
}
