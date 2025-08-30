import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voting_client/utils/ApiProvider.dart';
import 'package:voting_client/utils/Component.dart';
import 'package:voting_client/utils/ConnectionErrorWidget.dart';

class HistroyPage extends StatefulWidget {
  final id;
  const HistroyPage({required this.id, super.key});

  @override
  State<HistroyPage> createState() => _HistroyPageState();
}

class _HistroyPageState extends State<HistroyPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<Apiprovider>().showVotedHistory(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Apiprovider apiprovider = Provider.of<Apiprovider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("History")),
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
            : _makeTable(apiprovider),
      ),
    );
  }

  _makeTable(apiprovider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Horizontal scroll for small screens
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder.all(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          columnWidths: {
            0: FixedColumnWidth(40), // No.
            1: FixedColumnWidth(80), // Code
            2: FixedColumnWidth(160), // Title
            3: FixedColumnWidth(60), // Marks
            4: FixedColumnWidth(60), // Action
          },
          children: [
            // Table Header
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                tableCell('No.', isHeader: true),
                tableCell('Code', isHeader: true),
                tableCell('Title', isHeader: true),
                tableCell('Marks', isHeader: true),
                tableCell('Action', isHeader: true),
              ],
            ),
            // Table Rows
            ...apiprovider.votes.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final data = entry.value;
              return TableRow(
                children: [
                  tableCell(index.toString()),
                  tableCell(data.code),
                  tableCell(data.title),
                  tableCell(data.points.toString()),
                  tableCellButton(Icons.edit, () {
                    _showVoteDialog(
                      context,
                      data.id,
                      data.points.toString(),
                      apiprovider,
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  tableCellButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.blue, size: 20),
      onPressed: onPressed,
    );
  }

  void _showVoteDialog(BuildContext context, id, points, apiprovider) {
    final TextEditingController _voteController = TextEditingController();
    _voteController.text = points;
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
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // only numbers allowed
                ],
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
              onPressed: () async {
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
                final json = jsonEncode({
                  "id": id,
                  "points": _voteController.text,
                });
                bool success = await apiprovider.editVote(json);
                Navigator.of(context).pop();

                if (success) {
                  await _loadData();
                  Component.successToast(context, "Successfully edited.");
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
}
