import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80),

                // ÜSTTEKİ "TEDCOM YAZISI"
                Text(
                  'Tedcom',
                  style: GoogleFonts.rosario(
                    fontSize: 50,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Beyaz kutu içinde form
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Log In ve Sign Up düğmelerinin bulunduğu alan
                      Stack(
                        children: [
                          // Üstteki kırmızı ve beyaz çubuklar
                          Container(
                            width: 320,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(146, 236, 187, 187),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              )
                            ),

                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: isLogin
                                      ? -2
                                      : 150,
                                  child: Container(
                                    width: 160,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade900,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Log In ve Sign Up düğmeleri
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = true;
                                  });
                                },
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isLogin
                                        ? Colors.white
                                        : Colors.red.shade600,
                                  ),
                                ),
                              ),

                              SizedBox(width: 70, height: 50),
                              
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isLogin
                                        ? Colors.red.shade700
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Formu gösteren widget
                      SizedBox(height: 20),
                      
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isLogin ? LoginForm() : SignUpForm(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// LOGIN FORMU
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(1),
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'E-mail',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Şifre',
          ),
          obscureText: true,
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Şifrenizi mi unuttunuz?',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: _loginUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade800,
          ),
          child: const Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// SIGNUP FORMU
class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController(); // Yeni eklendi
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _signUpUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    try {
      // Kullanıcıyı Firebase Authentication'a kaydet
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Firestore'da kullanıcı bilgilerini sakla
      await FirebaseFirestore.instance
          .collection('users') // 'users' koleksiyonuna kayıt yap
          .doc(userCredential.user!.uid) // UID ile belge oluştur
          .set({
        'name': _nameController.text.trim(), // İsim ve soy isim
        'email': _emailController.text.trim(), // E-posta
        'createdAt': DateTime.now(), // Oluşturulma tarihi
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up Failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(2),
      children: [
        TextField(
          controller: _nameController, // Yeni eklenen alan
          decoration: InputDecoration(
            labelText: 'İsim Soyİsim',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'E-mail',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Şifre',
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Şifre Tekrar',
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _signUpUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade800,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
