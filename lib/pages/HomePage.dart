import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voting System")),
      body: SingleChildScrollView(child: Column(children: [_makeNavbar()])),
    );
  }

  // _makeProductGrid(List<Product> products) {
  //   return GridView.builder(
  //     itemCount: products.length,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //     ),
  //     itemBuilder: (context, index) => _makeProduct(products[index]),
  //   );
  // }

  _makeNavbar() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          // Category cat = cats[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              onTap: () {
                // currentIndex = index;
                // catId = cat.id;
                // _loadProducts();
              },
              child: Column(
                children: [
                  Text("JrCS"),
                  SizedBox(height: 5),
                  Container(height: 5, width: 70, color: Colors.amber),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
