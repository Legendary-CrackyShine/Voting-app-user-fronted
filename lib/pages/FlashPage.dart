import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voting_client/utils/ApiProvider.dart';
import 'package:voting_client/utils/Vary.dart';

class FlashPage extends StatefulWidget {
  const FlashPage({super.key});

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  _loadData() async {
    await Future.delayed(Duration(seconds: 5));
    var vary = new Vary();
    var token = await vary.getToken();
    if (token == null) {
      context.go("/login");
    }
    bool isValid = await context.read<Apiprovider>().checkToken();
    if (isValid) {
      context.go("/home");
    } else {
      context.go("/login");
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/flashbg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeIn(
                      duration: Duration(seconds: 5),
                      child: SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                    ZoomIn(
                      delay: Duration(seconds: 1),
                      duration: Duration(seconds: 2),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset("assets/images/voting.png"),
                      ),
                    ),
                    FadeInUp(
                      delay: Duration(seconds: 2),
                      child: AnimatedTextKit(
                        totalRepeatCount: 10,
                        animatedTexts: [
                          WavyAnimatedText(
                            'System',
                            textStyle: TextStyle(
                              fontFamily: "ChelaOne",
                              fontSize: 30.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                        isRepeatingAnimation: true,
                      ),
                    ),
                    SizedBox(height: 150),
                  ],
                ),
              ),
              FadeIn(
                delay: Duration(seconds: 2),
                child: Text(
                  "Developed By CrackyShine",
                  style: TextStyle(color: Colors.black54),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
