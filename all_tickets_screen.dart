import 'package:flutter/material.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'booking_screen.dart'; // Import the BookingScreen

class AllTicketsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tickets; // Change to dynamic to accommodate Firestore data

  const AllTicketsScreen({Key? key, required this.tickets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Available Tickets"),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to BookingScreen when a ticket is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(ticket: tickets[index]), // Pass the selected ticket
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: AppLayout.getHeight(10), horizontal: AppLayout.getWidth(15)),
              padding: EdgeInsets.all(AppLayout.getHeight(10)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 1, spreadRadius: 1),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.flight_takeoff_rounded, color: Colors.blue),
                  SizedBox(width: AppLayout.getWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tickets[index]['flight'] ?? 'Unknown Flight', style: Styles.headLineStyle2),
                      Text('${tickets[index]['departure']} to ${tickets[index]['arrival']}', style: Styles.headLineStyle3),
                      Text(tickets[index]['price'] ?? '\$0', style: Styles.textStyle),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}