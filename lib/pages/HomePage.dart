import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:voting_client/utils/Component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // track which item is selected
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
  var teams = [
    ["JrCS-01", "E-Commerce System", "Alpha"],
    ["JrCS-02", "Car Tickets", "Team Liquid"],
    ["JrCS-03", "Hospital System", "Onic PH"],
    ["JrCS-04", "Blood Donation System", "K1NGKONG"],
    ["JrCS-05", "Social Medai", "Yangon Galacticos"],
    ["JrCS-06", "E-Library System", "Falcon"],
    ["JrCS-07", "AI Robot System", "Mythic Seal"],
    ["JrCS-08", "Online Leaning System", "Shadow Coder"],
    ["JrCS-08", "Online Leaning System", "Shadow Coder"],
    ["JrCS-08", "Online Leaning System", "Shadow Coder"],
    ["JrCS-08", "Online Leaning System", "Shadow Coder"],
    ["JrCS-08", "Online Leaning System", "Shadow Coder"],
  ];
  var images = ["battle.jpg", "naruto.jpg", "call.jpg", "Joker.jpg"];
  String title =
      "ခေါင်းစဉ်သည် ဤနေရာတွင် ပေါ်မည်ဖြစ်၍ အသုံးပြုသူများအနေဖြင့် ဤနေရာကို နှိပ်ပါ။";
  String para1 =
      """မြန်မာစာစတင်ဖြစ်ပေါ်လာခြင်းသည် မြန်မာသည် ပျူနှင့်မွန်စာရေးနည်းကို စံတင်ပြီး (၁၂)ရာစုတွင် မြန်မာဘာသာ ပေါ်ထွန်းလာခဲ့ခြင်းဖြစ်သည်။ မြန်မာနိုင်ငံ စတင်တည်ထောင်စဉ်ကာလ အနော်ရထာမင်း၏ လက်ထက်တွင် သက္ကတဘာသာစာဖြင့် ရေးသောအုတ်ခွက်စာများ၊ ပါဠိစာများဖြင့်ရေးသော အုတ်ခွက်စာများကို အထောက်အထားပြုကာ မြန်မာ့တို့သည် မူလက ပါဠိနှင့် သက္ကတဘာသာတို့ကို ရင်းနှီးခဲ့ကြောင်း သိရသည်။ သက္ကတဘာသာသည် မဟာယာန ဗုဒ္ဓဘာသာနှင့် ဆက်နွယ်ပြီး ပါဠိဘာသာသည် ထေရဝါဒဗုဒ္ဓဘာသာနှင့် နှီးနွယ်ကြောင်းသိရသည်။""";
  String para2 =
      """မြန်မာတို့သည် တိုင်းခြားဘာသာဖြစ်သော ပါဠိစာကိုဗုဒ္ဓဘာသာစာပေအဖြစ် လက်ခံလာချိန်တွင် မြန်မာတိုင်းရင်းသားများ၏ စာပေဖြစ်သော ပျူစာ၊ မွန်စာတို့သည် ရှင်သန်နှင့် နေပြီးဖြစ်ကြောင်း သိရသည်။ မြန်မာစာပေါ်ပေါက်လာသော အခါတွင် မြန်မာတို့သည် မြန်မာစာနှင့်အတူ တိုင်းရင်း ပျူ၊ မွန်စာပေတို့ကိုလည်း ဆက်လက်ပြုစုလာခဲ့ကြပြီး ခရစ်နှစ်(၁၁၁၃)ခုနှစ် တွင် ရာဇကုမာရ်မင်းသား ရေးထိုးသော မြစေတီ ကျောက်စာတွင် ပျူ၊ မွန်၊ မြန်မာဘာသာ တို့ကို ပါဠိစာပေနှင့် အတူ ယှဉ်တွဲ တွေ့ရှိရသည်။ ပါဠိစာပေမှ မြန်မာစာပေသို့ အပြန်အလှန် ဘာသာပြန် အရေးအသားနှင့် ပါဠိဘာသာပြန်ရေးသည့် အရေးအသားများ ထွန်းကားလာခဲ့ပြီး (၁၁)ရာစု အနော်ရထာမင်း လက်ထက်တွင် ထေရဝါဒဗုဒ္ဓသာသနာနှင့် အတူ ပိဋိကတ်စာပေများ ပုဂံသို့ရောက်ရှိလာပြီးနောက်တွင် (၁၁) ရာစု နှောင်းပိုင်းတွင် မြန်မာစာ စတင် ပေါ်ပေါက် ထွန်းကားခဲ့ကြောင်း သမိုင်းအထောက်အထားများက ပြဆိုထားသည်။""";
  String para3 =
      """မြန်မာစာ ပေါ်ပေါက်လာပုံကို ပုဂံခေတ် ကျန်စစ်သားမင်း နတ်ရွာစံပြီး ခရစ်နှစ် (၁၁၁၃) ခန့်တွင် ရေးထိုးသော ရာဇကုမာရ်ကျောက်စာသည် သက္ကရာဇ် အခိုင်အမာ ပါသော အစောဆုံး မြန်မာစာ ဖြစ်ကြောင်းသိရသည်။ မြန်မာစာစတင် ဖော်ပြရာတွင် ဗုဒ္ဓစာပေများကို ကျောက်စာ၊ မှင်စာများဖြင့် ဇာတ်နိပါတ်၊ ပန်းချီ၊ ပန်းပု များနှင့် အတူ မှင်ဖြင့် ဖော်ပြကြပြီး ကျောက်စာများ ၊ မှင်စာများ စတင် ပေါ်ပေါက်လာခဲ့ရကြောင်း သိရသည်။ နောက်ပိုင်းတွင် ဗုဒ္ဓစာပေ အကြောင်းအရာများကို စကားပြေဖြင့်လည်းကောင်း ကဗျာများဖြင့်လည်းကောင်း ဖွဲ့နွဲလာကြပြီး ဗုဒ္ဓစာပေကို အခြေခံကာ မြန်မာစာပေ အရေးအဖွဲ့ အမျိုးမျိုး ပေါ်ထွန်းလာရကြောင်းသိရသည်။ ပါဠိ၊ ပျူ၊ မွန်၊ မြန်မာ ဟူသော ဘာသာစကားတို့မှ စကားလုံးများကို မွေးစား သုံးနှုန်းခြင်း၊ ဘာသာပြန်သုံးနှုန်းခြင်းတို့ဖြင့် မြန်မာစကား နှင့် စာပေ ဖွံ့ဖြိုးကြွယ်ဝ လာခဲ့ သည်ဟု ဆိုကြသည်။ ပင်းယခေတ် (၁၃၀၉ ခုနှစ် ခန့် မှ ၁၃၆၀) နှင့် အင်းဝခေတ် (၁၃၆၄ မှ ၁၄၈၆) တစ်လျောက်လုံးတွင် မြန်မာတို့သည် ဗုဒ္ဓစာပေအမွေအနှစ်များကို ပါဠိဘာသာမှ တစ်ဆင့် ဘာသာပြန်ပြုစုလာခဲ့ကြပြီး မြန်မာစာပေအနေနှင့် အရေးအသား အသုံးအနှုန်းများ ခိုင်မြဲစွာ အမြစ်တွယ် ထွန်းကားနေပြီ ဖြစ်သည်။""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Online Voting System",
          style: TextStyle(fontFamily: "Title", fontSize: 20),
        ),
        actions: [
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

      body: Column(
        children: [
          _makeNavbar(),
          Expanded(child: _makeCardGrid()),
        ],
      ),
    );
  }

  _makeNavbar() {
    List<String> items = ["JrCS", "JrCT", "SrCS", "SrCT"];

    return LayoutBuilder(
      builder: (context, constraints) {
        // calculate total width of items (approx)
        double totalWidth =
            items.length * 100.0; // estimate item width including spacing
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
              children: List.generate(items.length, (index) {
                bool isSelected = index == _selectedIndex;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
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
                          items[index],
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

  _makeCardGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: 12,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => _makeTeam(
        teams[index][0],
        teams[index][1],
        teams[index][2],
        colors[index][0],
        colors[index][1],
        colors[index][2],
      ),
    );
  }

  _makeTeam(code, title, name, badgeColor, startColor, endColor) {
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
                  _buildBadge(code, badgeColor),
                  const SizedBox(height: 12),

                  // Task title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Note
            Text(
              "TEAM - " + name,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.how_to_vote),
                TextButton(
                  onPressed: () {
                    _makeModalBtnSheet();
                  },
                  child: Text("Detail", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: badgeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _makeModalBtnSheet() {
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
                          _makeModalBody(),
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
                child: Image.asset("assets/images/" + image),
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

  _makeModalBody() {
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
                    "TEAM-Alpha",
                    style: TextStyle(
                      fontFamily: 'ABeeZee',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildBadge("JrCS-01", Color(0xff33ff77)),
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
                      text: "E-Commerce System",
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
              _makeObjText(
                "မြန်မာတို့သည် တိုင်းခြားဘာသာဖြစ်သော ပါဠိစာကိုဗုဒ္ဓဘာသာ စာပေအဖြစ် လက်ခံလာစေရန်",
              ),
              _makeObjText(
                "မြန်မာနိုင်ငံ စတင်တည်ထောင်စဉ်ကာလ အနော်ရထာမင်း၏ လက်ထက်တွင် သက္ကတဘာသာစာဖြင့် ရေးသောအုတ်ခွက်စာများရေးသာစေရန်",
              ),
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
              _makePataText(para1),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _showVoteDialog(context);
              },
              icon: const Icon(
                Icons.how_to_vote,
                color: Colors.white,
                size: 22,
              ),
              label: const Text(
                "Vote",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // button color
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5, // shadow effect
              ),
            ),
          ),
        ),
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
              onPressed: () {
                // handle logout logic here
                Navigator.of(context).pop();
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

  void _showVoteDialog(BuildContext context) {
    final TextEditingController _voteController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your points (0 - 100):",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _voteController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "0 - 100",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                int? points = int.tryParse(_voteController.text);
                if (points == null || points < 0 || points > 100) {
                  // show error if invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter a valid number between 0 and 100",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // handle vote logic here
                print("User voted: $points points");

                Navigator.of(context).pop(); // close dialog
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
}
