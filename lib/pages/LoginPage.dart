import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting_client/utils/Consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginEnabled = false;
  bool _submitted = false;
  var codeErr = null;
  late Timer _timer;
  final _codeFocusNode = FocusNode();

  @override
  void dispose() {
    _timer.cancel();
    _codeFocusNode.dispose();
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _codeController.addListener(() {
      setState(() {
        isLoginEnabled = _codeController.text.length == 6;
      });
    });
  }

  var _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // var mSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                "assets/images/loginbg.png",
                errorBuilder: (context, error, stackTrace) {
                  return Text("Image not found");
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Login",
              style: TextStyle(
                color: NORMAL_COLOR,
                fontFamily: "Title",
                fontSize: 45.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: _submitted
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null; // valid
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        label: Text("Email"),
                        labelStyle: TextStyle(
                          color: NORMAL_COLOR,
                          fontSize: 18.0,
                        ),
                        enabledBorder: _getBorder(),
                        focusedBorder: _getFocusBorder(),
                        errorBorder: _getErrBorder(),
                        focusedErrorBorder: _getFocusErrFBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.number,
                            focusNode: _codeFocusNode,
                            onChanged: (value) {
                              // Reset error when user types
                              if (codeErr != null) {
                                setState(() {
                                  codeErr = null;
                                });
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // only 0-9 allowed
                            ],

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.verified_user),
                              suffixIcon: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _submitted = true;
                                    });

                                    if (_formKey.currentState!.validate()) {
                                      // sendOtpToApi(_emailController.text);
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_codeFocusNode);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/get.png",
                                    width: 10,
                                    height: 10,
                                  ),
                                ),
                              ),

                              labelText: "Verification Code",
                              errorText: codeErr,

                              labelStyle: TextStyle(
                                color: NORMAL_COLOR,
                                fontSize: 18.0,
                              ),
                              enabledBorder: _getBorder(),
                              focusedBorder: _getFocusBorder(),
                              errorBorder: _getErrBorder(),
                              focusedErrorBorder: _getFocusErrFBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoginEnabled
                            ? const Color(0xff4dffb8)
                            : Colors.white70,
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 40,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (!isLoginEnabled) {
                          setState(() {
                            codeErr = "Verification code must be 6 digits";
                          });
                        } else {
                          // login
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "ABeeZee",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: NORMAL_COLOR, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }

  _getFocusBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 1),
    );
  }

  _getErrBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.5),
    );
  }

  _getFocusErrFBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
    );
  }
}
