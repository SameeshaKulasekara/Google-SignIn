import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_signin/constants/image_urls.dart';
import 'package:google_signin/pages/home_page.dart';
import 'package:google_signin/pages/login_page.dart';
import 'package:google_signin/services/validation.dart';

class RegisterForm extends StatefulWidget {
 const RegisterForm({super.key});

 @override
 _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
 bool _isObscure = true;
 String? value;


 void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 233, 30, 99),
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

  showSuccessDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.of(context)
          ..pop()
          ..pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) =>  HomePage()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Success!"),
      content: const Text("Successfully Registered!"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
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
                    registerScreenImg,
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
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Email',
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
                        height: 17.187,
                        width: 20,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                        controller: passwordController,
                        obscureText: _isObscure,
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
                          border: InputBorder.none,
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
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
                    height: 17.187,
                    width: 20,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: passwordConfirmController,
                      obscureText: _isObscure,
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
                          border: InputBorder.none,
                          hintText: 'Enter Confirm Password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 30, 99),
                    borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          String pattern = r'\w+@\w+\.\w+';
                          RegExp regex = RegExp(pattern);
                          String passPattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+]).{8,}$';
                          RegExp passRegex = RegExp(passPattern);

                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              passwordConfirmController.text.isEmpty) {
                            showSnackBar(
                              context, 'All Fields are Required!');
                          } else if (!regex
                                .hasMatch(emailController.text)) {
                              showSnackBar(context,
                                'Invalid E-mail Address format!');
                          } else if (!passRegex
                              .hasMatch(passwordController.text)) {
                              showSnackBar(context,
                              'Password must be at least 8 characters,including at least one uppercase letter,one lower case letter,one digit and one Special character');
                          } else {
                              if (validateEmail(emailController.text)) {
                                if (passwordController.text ==
                                  passwordConfirmController.text) {
                                    EasyLoading.show(
                                        status: "Creating account...");
                                        try {
                                          final cred = await FirebaseAuth
                                              .instance
                                              .createUserWithEmailAndPassword(
                                                  email: emailController.text,
                                                  password:
                                                  passwordController.text
                                              );
                                        } 
                                        on FirebaseAuthException catch (e) {
                                          if (e.code == 'weak-password') {
                                            EasyLoading.dismiss();
                                            showSnackBar(context,
                                                'The password provided is too weak.');
                                          } else if (e.code == 'email-already-in-use') {
                                            EasyLoading.dismiss();
                                            showSnackBar(context,
                                                'The account already exists for that email.');
                                          }
                                        } catch (e) {
                                          EasyLoading.dismiss();
                                          showSnackBar(context, "Something went wrong! Try again!");
                                        }
                                      } else {
                                        showSnackBar(context,
                                            'Password and Confirm Password does not match!');
                                      }
                                } else {
                                    showSnackBar(context,
                                        'Invalid email address format!');
                               }
                          }
                        } catch (error) {}
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
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
                        'Already have an Account?',
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginForm()));
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold
                          ),
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
