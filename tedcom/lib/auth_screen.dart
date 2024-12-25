import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Üstte "tedcom" yazısı
                Text(
                  'tedcom',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Log In ve Sign Up düğmelerinin bulunduğu alan
                Stack(
                  children: [
                    // Üstteki kırmızı ve beyaz çubuklar
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            left: isLogin ? 0 : MediaQuery.of(context).size.width / 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  isLogin ? 'Log In' : 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
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
                              color: isLogin ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = false;
                            });
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: isLogin ? Colors.white : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Beyaz kutu içinde form
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: isLogin ? LoginForm() : SignUpForm(),
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

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(1),
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'E-mail',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Şifre',
          ),
          obscureText: true,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Log In'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Düğme rengi
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.network("https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",scale: 6,),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/2048px-2021_Facebook_icon.svg.png", scale: 36,),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(2),
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'E-mail',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'İsim Soyisim',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Şifre',
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Şifre Tekrar',
          ),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Sign Up'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Düğme rengi
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.network("https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",scale: 6,),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/2048px-2021_Facebook_icon.svg.png", scale: 36,),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
