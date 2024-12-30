import 'package:booktickets/screens/hotel_screen.dart';
import 'package:booktickets/screens/ticket_view.dart';
import 'package:booktickets/screens/search_screen.dart'; // Import the SearchScreen
import 'package:booktickets/utils/app_info_list.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/double_text_widget.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List ticketListFiltered = ticketList; // Initially, show all tickets
  List hotelListFiltered = hotelList; // Initially, show all hotels

  bool showFlights = false; // Control for showing all flights
  bool showHotels = false; // Control for showing all hotels

  // Function to navigate to SearchScreen
  void _navigateToSearch() {
    Get.to(() => const SearchScreen());
  }

  // Function to navigate to HotelScreen
  void _navigateToHotelScreen(hotel) {
    Get.to(() => HotelScreen(hotel: hotel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: ListView(
        children: [
          // Attractive Top Section with background image
          Stack(
            children: [
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/beautiful_header.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good Morning!",
                      style: Styles.headLineStyle3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      "Book Your Perfect Trip",
                      style: Styles.headLineStyle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(15),
                    ElevatedButton(
                      onPressed: _navigateToSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Start Booking",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(25),
          // Upcoming Flights Section
GestureDetector(
  onTap: () {
    setState(() {
      showFlights = !showFlights;
      if (showFlights) {
        showHotels = false;
      }
    });
  },
  child: AppDoubleTextWidget(
    bigText: "Upcoming Flights",
    smallText: showFlights ? "Show less" : "View all",
  ),
),
const Gap(15),
// Ticket List
showFlights
    ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: ticketListFiltered.map((singleTicket) {
            return GestureDetector(
              onTap: () {
                // Navigate to SearchScreen when a ticket is tapped
                _navigateToSearch();
              },
              child: Column(
                children: [
                  TicketView(ticket: singleTicket),
                  const Gap(15),
                ],
              ),
            );
          }).toList(),
        ),
      )
    : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Fixes overflow issue
          children: ticketListFiltered.take(3).map((singleTicket) {
            return GestureDetector(
              onTap: () {
                // Navigate to SearchScreen when a ticket is tapped
                _navigateToSearch();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15), // Adds spacing between tickets
                child: TicketView(ticket: singleTicket),
              ),
            );
          }).toList(),
        ),
      ),
const Gap(15),

          // Hotels Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showHotels = !showHotels;
                  if (showHotels) {
                    showFlights = false;
                  }
                });
              },
              child: AppDoubleTextWidget(
                bigText: "Hotels",
                smallText: showHotels ? "Show less" : "View all",
              ),
            ),
          ),
          const Gap(15),
          // Hotel List
          showHotels
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: hotelListFiltered.map((singleHotel) {
                return GestureDetector(
                  onTap: () {
                    _navigateToHotelScreen(singleHotel);
                  },
                  child: Column(
                    children: [
                      HotelScreen(hotel: singleHotel),
                      const Gap(15),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: hotelListFiltered.take(3).map((singleHotel) {
                return GestureDetector(
                  onTap: () {
                    _navigateToHotelScreen(singleHotel);
                  },
                  child: HotelScreen(hotel: singleHotel),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          // "For Booking" Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "For Booking",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}