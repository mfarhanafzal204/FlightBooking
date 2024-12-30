import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_styles.dart';
import '../utils/app_layout.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> ticket; // Accept ticket data

  const BookingScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idCardController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController ticketsController = TextEditingController();

  // Function to generate a random ticket number
  String generateTicketNumber() {
    final random = Random();
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (index) => characters[random.nextInt(characters.length)]).join();
  }

  // Function to handle booking confirmation and saving data to Firestore
  void bookTicket() async {
    String name = nameController.text;
    String idCard = idCardController.text;
    String contact = contactController.text;
    String tickets = ticketsController.text;

    if (name.isNotEmpty && idCard.isNotEmpty && contact.isNotEmpty && tickets.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in. Please log in to book a ticket.')),
        );
        return;
      }

      String ticketNumber = generateTicketNumber();

      try {
        final bookingData = {
          'uid': user.uid,
          'name': name,
          'idCard': idCard,
          'contact': contact,
          'tickets': tickets,
          'ticketNumber': ticketNumber,
          'flight': widget.ticket['flight'], // Include flight info
          'departure': widget.ticket['departure'], // Include departure info
          'arrival': widget.ticket['arrival'], // Include arrival info
          'price': widget.ticket['price'], // Include price
          'bookingDate': DateTime.now().toString(),
        };

        await FirebaseFirestore.instance.collection('bookings').add(bookingData);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Booking Confirmation'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: $name'),
                  Text('ID Card: $idCard'),
                  Text('Contact: $contact'),
                  Text('Tickets: $tickets'),
                  Text('Ticket Number: $ticketNumber'),
                  Text('Flight: ${widget.ticket['flight']}'),
                  Text('Departure: ${widget.ticket['departure']}'),
                  Text('Arrival: ${widget.ticket['arrival']}'),
                  Text('Price: ${widget.ticket['price']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking confirmed successfully!')),
                    );
                    Navigator.pop(context); // Close the booking screen
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error confirming booking: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Book Ticket")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20), vertical: AppLayout.getHeight(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking for ${widget.ticket['flight']}', style: Styles.headLineStyle1), // Display flight name
              SizedBox(height: AppLayout.getHeight(20)),
              // Name Field
              Text('Name:', style: Styles.headLineStyle2),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter your name'),
              ),
              SizedBox(height: AppLayout.getHeight(20)),
              // ID Card Field
              Text('ID Card:', style: Styles.headLineStyle2),
              TextField(
                controller: idCardController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter your ID card number'),
              ),
              SizedBox(height: AppLayout.getHeight(20)),
              // Contact Field
              Text('Contact:', style: Styles.headLineStyle2),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter your contact number'),
              ),
              SizedBox(height: AppLayout.getHeight(20)),
              // Number of Tickets
              Text('Number of Tickets:', style: Styles.headLineStyle2),
              TextField(
                controller: ticketsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter number of tickets'),
              ),
              SizedBox(height: AppLayout.getHeight(30)),
              // Confirm Booking Button
              GestureDetector(
                onTap: bookTicket,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: AppLayout.getWidth(18), horizontal: AppLayout.getWidth(15)),
                  decoration: BoxDecoration(
                    color: const Color(0xD91130CE),
                    borderRadius: BorderRadius.circular(AppLayout.getWidth(10)),
                  ),
                  child: Center(
                    child: Text(
                      "Confirm Booking",
                      style: Styles.textStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}