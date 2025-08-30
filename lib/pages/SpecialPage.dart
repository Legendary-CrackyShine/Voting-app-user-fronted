import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voting_client/utils/ApiProvider.dart';
import 'package:voting_client/utils/Component.dart';
import 'package:voting_client/utils/ConnectionErrorWidget.dart';
import 'package:voting_client/utils/Consts.dart';

class SpecialPage extends StatefulWidget {
  const SpecialPage({super.key});

  @override
  State<SpecialPage> createState() => _SpecialPageState();
}

class _SpecialPageState extends State<SpecialPage> {
  Map<String, String?> _selectedContestantPerLevel = {};
  var _emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<Apiprovider>().getAllLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    Apiprovider apiprovider = Provider.of<Apiprovider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("iOS Users")),
      body: apiprovider.connErr
          ? (apiprovider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ConnectionErrorWidget(
                    errorMessage:
                        "Connection error! Please check your internet.",
                    onRetry: () async {
                      await apiprovider.retryAll();
                    },
                  ))
          : apiprovider.isLoading
          ? Component.showLoading()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Online Voting System",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                label: Text("email"),
                                labelStyle: TextStyle(
                                  color: NORMAL_COLOR,
                                  fontSize: 14.0,
                                ),
                                enabledBorder: _getBorder(),
                                focusedBorder: _getFocusBorder(),
                                errorBorder: _getErrBorder(),
                                focusedErrorBorder: _getFocusErrFBorder(),
                              ),
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
                            ),
                          ),
                          SizedBox(height: 30),
                          _makeLevelCard(apiprovider),
                          SizedBox(height: 50),
                          apiprovider.voteLoading
                              ? _makeLoadingBtn()
                              : _makeSubmitBtn(() async {
                                  if (_formKey.currentState!.validate() ==
                                      false) {
                                    return;
                                  }
                                  bool allSelected = apiprovider.levels.every(
                                    (level) =>
                                        _selectedContestantPerLevel[level.id] !=
                                        null,
                                  );

                                  if (!allSelected) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please select a contestant for every level!",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  final json = jsonEncode({
                                    "email": _emailController.text,
                                    "data": _selectedContestantPerLevel,
                                  });
                                  bool success = await apiprovider.specialVote(
                                    json,
                                  );
                                  if (success) {
                                    Component.successToast(
                                      context,
                                      "You’ve voted! Best of luck to your contestant.",
                                    );
                                    context.go('/home');
                                  } else {
                                    Component.errorToast(
                                      context,
                                      apiprovider.error,
                                    );
                                  }
                                }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _makeLevelCard(apiprovider) {
    return Container(
      width: 400,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ...apiprovider.levels.map((level) {
            return ExpansionTile(
              title: Text(
                level.name,
                style: TextStyle(
                  fontFamily: "Title",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ...(level.contestant ?? []).map(
                  (cont) => RadioListTile<String>(
                    title: Text(cont.title),
                    value: cont.id,
                    groupValue: _selectedContestantPerLevel[level.id],
                    onChanged: (value) {
                      setState(() {
                        _selectedContestantPerLevel[level.id] = value;
                      });
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  _makeSubmitBtn(call) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: call,
        icon: const Icon(Icons.how_to_vote, color: Colors.white, size: 30),
        label: Text(
          "Vote",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
      ),
    );
  }

  _makeLoadingBtn() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        label: Text(
          "Loading...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
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
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }

  _getErrBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }

  _getFocusErrFBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }
}
