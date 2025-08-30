import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_client/utils/CountDownProvider.dart';

class CountdownFAB extends StatelessWidget {
  const CountdownFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountdownProvider>(
      builder: (context, countdown, _) {
        if (!countdown.isVisible) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              // Action when pressed (optional)
            },
            backgroundColor: Colors.transparent, // transparent to show gradient
            elevation: 0, // remove default shadow
            icon: const Icon(Icons.timer, color: Colors.white),
            label: Text(
              "Ends in ${countdown.formattedTime}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
