import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/app_styles.dart';
import '../utils/app_layout.dart';
import '../widgets/ticket_tabs.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  // Function to generate the PDF when clicked
  Future<void> generateTicketPdf(Map<String, dynamic> ticketData, Map<String, dynamic> userData) async {
    final pdf = pw.Document();

    // Add a page to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title
                pw.Text(
                  'Ticket Information',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),

                // User Information Section
                pw.Text('Name: ${userData['name'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Email: ${userData['email'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Gender: ${userData['gender'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Country: ${userData['country'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),

                // Flight Information Section
                pw.Text('Flight: ${ticketData['flight'] ?? 'N/A'}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Departure: ${ticketData['departure'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Arrival: ${ticketData['arrival'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Booking Date: ${ticketData['bookingDate'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Ticket Number: ${ticketData['tickets'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),

                // Contact Information
                pw.Text('Contact: ${ticketData['contact'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );

    // Display or save the generated PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is not logged in
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text("Please log in to view your tickets.", style: Styles.headLineStyle2),
        ),
      );
    }

    // Get the logged-in user's UID
    final userId = currentUser.uid;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getHeight(20),
              vertical: AppLayout.getHeight(20),
            ),
            children: [
              Gap(AppLayout.getHeight(40)),
              Text("Tickets", style: Styles.headLineStyle1),
              Gap(AppLayout.getHeight(20)),
              const AppTicketTabs(firstTab: "Upcoming", secondTab: "Previous"),
              Gap(AppLayout.getHeight(20)),

              // StreamBuilder with user-specific query
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('uid', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No tickets found."));
                  }

                  final bookings = snapshot.data!.docs;

                  return Column(
                    children: bookings.map((doc) {
                      final ticketData = doc.data() as Map<String, dynamic>;

                      // Fetch user profile information
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                            return const Center(child: Text("User data not found."));
                          }

                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                          return Padding(
                            padding: EdgeInsets.only(bottom: AppLayout.getHeight(15)),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                              child: GestureDetector(
                                onTap: () {
                                  // Generate PDF when the user taps on the ticket
                                  generateTicketPdf(ticketData, userData);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(AppLayout.getHeight(15)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(ticketData['departure'] ?? 'N/A', style: Styles.headLineStyle2),
                                              Gap(AppLayout.getHeight(5)),
                                              Text("Departure", style: Styles.headLineStyle4),
                                            ],
                                          ),
                                          const Icon(Icons.flight_takeoff, color: Colors.blue),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(ticketData['arrival'] ?? 'N/A', style: Styles.headLineStyle2),
                                              Gap(AppLayout.getHeight(5)),
                                              Text("Arrival", style: Styles.headLineStyle4),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Gap(AppLayout.getHeight(20)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Flight: ${ticketData['flight'] ?? 'N/A'}", style: Styles.headLineStyle3),
                                          Text("Date: ${ticketData['bookingDate'] ?? 'N/A'}", style: Styles.headLineStyle3),
                                        ],
                                      ),
                                      Gap(AppLayout.getHeight(10)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Contact: ${ticketData['contact'] ?? 'N/A'}", style: Styles.headLineStyle3),
                                          Text("Ticket: ${ticketData['tickets'] ?? 'N/A'}", style: Styles.headLineStyle3),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
