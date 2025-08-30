import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:voting_client/models/Contestant.dart';
import 'package:voting_client/models/Level.dart';
import 'package:voting_client/utils/ApiProvider.dart';
import 'package:voting_client/utils/Component.dart';
import 'package:voting_client/utils/ConnectionErrorWidget.dart';
import 'package:voting_client/utils/CountDownFAB.dart';
import 'package:voting_client/utils/CountDownProvider.dart';
import 'package:voting_client/utils/Vary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var colors = [
    [Colors.blue.shade700, Color(0xFFD7E1FF), Color(0xFF7C95FF)], // 1
    [Color(0xFF009985), Color(0xFF84FFFF), Color(0xFF26A69A)], // 2
    [Color(0xFFB71C1C), Color(0xFFFFCDD2), Color(0xFFEF5350)], // 3
    [Color(0xFF8B4513), Color(0xFFD2B48C), Color(0xFFF5DEB3)], // 4
    [Color(0xFFf99c06), Color(0xFFFFECB3), Color(0xFFFDD835)], // 5
    [Color(0xff00b38f), Color(0xFFE0F7FA), Color(0xFF80DEEA)], // 6
    [Color(0xFF6A1B9A), Color(0xFFE1BEE7), Color(0xFF9C27B0)], // 7
    [Color(0xFFB39DDB), Color(0xFFEDE7F6), Color(0xFFE1BEE7)], //8
    [Color(0xFFB71C1C), Color(0xFFE57373), Color(0xFFFFCDD2)], // 9
    [Color(0xFFcc7a00), Color(0xFFFFCC80), Color(0xFFFFB74D)], // 10
    [Colors.blue.shade700, Color(0xFFD7E1FF), Color(0xFF7C95FF)], //11
    [Color(0xFF009985), Color(0xFF84FFFF), Color(0xFF26A69A)], // 12
    [Color(0xFFB71C1C), Color(0xFFFFCDD2), Color(0xFFEF5350)], // 13
    [Color(0xFF8B4513), Color(0xFFD2B48C), Color(0xFFF5DEB3)], // 14
    [Color(0xFFf99c06), Color(0xFFFFECB3), Color(0xFFFDD835)], // 15
    [Color(0xff00e6b8), Color(0xFFE0F7FA), Color(0xFF80DEEA)], // 16
  ];
  var images = ["naruto.jpg", "battle.jpg", "call.jpg"];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<Apiprovider>().getAllLevel();
      await context.read<Apiprovider>().getMe();
      await context.read<CountdownProvider>().getCountDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    Apiprovider apiprovider = Provider.of<Apiprovider>(context);
    CountdownProvider coutdownprovider = Provider.of<CountdownProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Online Voting System",
          style: TextStyle(fontFamily: "Title", fontSize: 20),
        ),
        actions: [
          (apiprovider.user.role == "BOARD_MEMBER")
              ? IconButton(
                  onPressed: () async {
                    context.push("/history/${apiprovider.user.id}");
                  },
                  icon: Icon(Icons.task_alt_outlined, color: Colors.green),
                )
              : (apiprovider.user.role == "SPECIAL")
              ? IconButton(
                  onPressed: () async {
                    context.push("/special");
                  },
                  icon: Icon(Icons.diamond_outlined, color: Colors.orange),
                )
              : SizedBox(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
        backgroundColor: Colors.white38, // Set a specific background color
        scrolledUnderElevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: _loadData,
        child: apiprovider.connErr
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
            : Column(
                children: [
                  _makeNavbar(apiprovider.levels, apiprovider),
                  Expanded(
                    child: _makeCardGrid(
                      apiprovider.levels[apiprovider.selectedIndex].contestant,
                      apiprovider,
                      coutdownprovider,
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: const CountdownFAB(),
    );
  }

  _makeNavbar(List<Level> levels, apiprovider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // calculate total width of items (approx)
        double totalWidth =
            levels.length * 100.0; // estimate item width including spacing
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: 50, // ensures it fills screen if smaller
            ),
            child: Row(
              mainAxisAlignment: totalWidth < constraints.maxWidth
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: List.generate(levels.length, (index) {
                bool isSelected = index == apiprovider.selectedIndex;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      apiprovider.setSelectedIndex(index);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.greenAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          levels[index].name.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  _makeCardGrid(List<Contestant> cont, apiprovider, coutdownprovider) {
    if (cont.length > 0) {
      return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: cont.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => _makeTeam(
          cont[index],
          colors[index][0],
          colors[index][1],
          colors[index][2],
          apiprovider,
          coutdownprovider,
        ),
      );
    } else {
      return Center(
        child: Text(
          "No data",
          style: TextStyle(
            fontFamily: "English",
            fontSize: 50,
            color: Colors.red,
          ),
        ),
      );
    }
  }

  _makeTeam(
    cont,
    badgeColor,
    startColor,
    endColor,
    apiprovider,
    coutdownprovider,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadge(cont.code, badgeColor),
                      (cont.status == 1 || cont.status == 2)
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events_outlined,
                                  color: Colors.yellow,
                                ),
                                (cont.status == 1)
                                    ? const Text(
                                        "1st",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        "2nd",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    cont.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              "TEAM - " + cont.name,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                apiprovider.votedCont.contains(cont.id)
                    ? const Icon(Icons.how_to_vote, size: 30)
                    : const SizedBox(),
                TextButton(
                  onPressed: () {
                    _makeModalBtnSheet(cont, apiprovider, coutdownprovider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: badgeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Detail",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _makeModalBtnSheet(cont, apiprovider, coutdownprovider) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 20),
                          _makeSlide(images),
                          _makeModalBody(cont, apiprovider, coutdownprovider),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _makeSlide(List<String> images) {
    return CarouselSlider(
      items: images.map<Widget>((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset("assets/images/$image"),
              ),
            );
          },
        );
      }).toList(), // now it's List<Widget>
      options: CarouselOptions(
        height: 180,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }

  _makeModalBody(cont, apiprovider, coutdownprovider) {
    final currentLevel = apiprovider.levels.firstWhere(
      (lvl) => lvl.id == cont.level,
    );
    bool IsAuthLevel = currentLevel.boardIds.contains(apiprovider.user.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TEAM-${cont.name}",
                    style: TextStyle(
                      fontFamily: 'ABeeZee',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildBadge(cont.code, Color(0xff33ff77)),
                ],
              ),
            ],
          ),
        ),

        // Title with red line
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xff33ff77),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SelectableText.rich(
                    TextSpan(
                      text: cont.title,
                      style: TextStyle(
                        fontFamily: 'Title',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // objective
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "ရည်ရွယ်ချက်များ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Padauk',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ...cont.objective.asMap().entries.map((entry) {
                final obj = entry.value;
                return _makeObjText(obj);
              }),
              SizedBox(height: 30),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "အကြောင်းအရာများ",
                style: TextStyle(
                  fontFamily: 'Padauk',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              _makePataText(cont.desc),
            ],
          ),
        ),
        if (coutdownprovider.isVisible)
          if (apiprovider.user.role == "NORMAL")
            apiprovider.votedLvl.contains(cont.level)
                ? SizedBox()
                : apiprovider.voteLoading
                ? _makeLoadingBtn()
                : _voteButton(context, cont, apiprovider)
          else if (apiprovider.user.role == "BOARD_MEMBER")
            apiprovider.votedCont.contains(cont.id)
                ? SizedBox()
                : (IsAuthLevel)
                ? _voteButton(context, cont, apiprovider, isBoard: true)
                : apiprovider.voteLoading
                ? _makeLoadingBtn()
                : _voteButton(context, cont, apiprovider)
          else
            apiprovider.voteLoading
                ? _makeLoadingBtn()
                : _voteButton(context, cont, apiprovider),
      ],
    );
  }

  _makeObjText(String text) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: const TextStyle(color: Colors.black), // needed for RichText
        children: [TextSpan(text: "- " + text)],
      ),
    );
  }

  _makePataText(String text) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: const TextStyle(color: Colors.black), // needed for RichText
        children: [
          const WidgetSpan(child: SizedBox(width: 20)),
          TextSpan(text: text),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to dismiss
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 10),
              Text("Logout", style: TextStyle(fontFamily: 'English')),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                var vary = new Vary();
                await vary.delToken();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _voteButton(
    BuildContext context,
    cont,
    apiprovider, {
    bool isBoard = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            if (!isBoard) {
              // NORMAL or SPECIAL
              final json = jsonEncode({
                "voterId": apiprovider.user.id,
                "level": cont.level,
                "contestantId": cont.id,
              });
              bool success = await apiprovider.vote(json);
              if (success) {
                await apiprovider.retryAll();
                Component.successToast(
                  context,
                  "You’ve voted! Best of luck to your contestant.",
                );
                Navigator.of(context).pop();
              } else {
                Component.errorToast(
                  context,
                  "Something went wrong. Try again later.",
                );
                Navigator.of(context).pop();
              }
            } else {
              // BOARD MEMBER
              _showVoteDialog(context, cont, apiprovider);
            }
          },
          icon: const Icon(Icons.how_to_vote, color: Colors.white, size: 22),
          label: const Text(
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
      ),
    );
  }

  void _showVoteDialog(BuildContext context, cont, apiprovider) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final Map<String, int> maxMarks = {
          "Innovation": 10,
          "Technology": 40,
          "Business": 10,
          "Benefit in Society": 14,
          "Teamwork presentation": 13,
          "Project UI design": 13,
        };

        final Map<String, TextEditingController> controllers = {
          for (var key in maxMarks.keys) key: TextEditingController(),
        };

        final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.how_to_vote, color: Colors.blue),
              SizedBox(width: 10),
              Text("Cast Your Vote"),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: maxMarks.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${entry.key}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: controllers[entry.key],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "0 - ${entry.value}",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              final intValue = int.tryParse(value);
                              if (intValue == null) {
                                return "Enter number";
                              }
                              if (intValue < 0 || intValue > entry.value) {
                                return "Max ${entry.value}";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                int total = 0;
                maxMarks.forEach((key, max) {
                  total += int.parse(controllers[key]!.text);
                });
                final json = jsonEncode({
                  "voterId": apiprovider.user.id,
                  "level": cont.level,
                  "type": "BOARD_MEMBER",
                  "contestantId": cont.id,
                  "points": total,
                });
                bool success = await apiprovider.vote(json);
                if (success) {
                  await apiprovider.retryAll();
                  Component.successToast(
                    context,
                    "You’ve voted successfully! Total: $total",
                  );
                  Navigator.of(context).pop();

                  Future.delayed(const Duration(seconds: 1), () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  });
                } else {
                  Component.errorToast(
                    context,
                    "Something went wrong. Try again later.",
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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
}
