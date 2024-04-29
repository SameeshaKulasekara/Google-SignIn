import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_signin/constants/image_urls.dart';
import 'package:google_signin/pages/home_page.dart';
import 'package:google_signin/pages/register.dart';
import 'package:google_signin/services/validation.dart';

class LoginForm extends StatefulWidget {
 const LoginForm({super.key});

 @override
 _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
 TextEditingController userNameController = TextEditingController();
 TextEditingController passwordController = TextEditingController();
 final GlobalKey<FormState> _key = GlobalKey<FormState>();
 bool _isObscure = true;

 String? validateText(String formText) {
    if (formText.isEmpty) return 'Field is Required';
    return null;
  }

 Future<UserCredential?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
 }

 void handleSignIn({required String email, required String password}) async {
    EasyLoading.show(status: 'Authenticating...');
    try {
      final creds = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      if (creds.user != null) {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Invalid Credentials');
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        EasyLoading.showError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError('Wrong password provided for that user.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred during sign in.');
    }
 }

void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.pink,
      content: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: () {
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView ( 
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  signInScreenImg,
                  width: double.infinity, 
                  height: 250, 
                  fit: BoxFit.cover, 
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      'assets/icons/email_icon.svg',
                      color: Colors.pink,
                      height: 17.187,
                      width: 20,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: userNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field is Required';
                          }
                          if (validateEmail(value) == false) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          border: InputBorder.none,
                          hintText: 'Enter Username',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      'assets/icons/Lock1.svg',
                      color: Colors.pink,
                    ),
                    Expanded(
                      child: TextFormField(
                        obscureText: _isObscure,
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field is Required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters!';
                          }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                          ? Icons.visibility
                          : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                          contentPadding: const EdgeInsets.all(20.0),
                          border: InputBorder.none,
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        if (validateEmail(userNameController.text) && validatePassword(passwordController.text)) {
                          handleSignIn(email: userNameController.text,
                          password: passwordController.text);
                        } else {
                            showSnackBar(context, "Invalid Email or Password");
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                        ),
                    ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 182, 200),
                    borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async {
                  final UserCredential? userCredential = await _signInWithGoogle();
                  if (userCredential != null) {
                      // Navigate to the next screen
                      Navigator.pushNamed(context, '/home');
                  }
                  },
                    child: const Text(
                    'Sign in with Google',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an Account?",
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterForm()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
