import 'package:flutter/material.dart';

class HotelBookingScreen extends StatefulWidget {
  final Map hotel;

  const HotelBookingScreen({Key? key, required this.hotel}) : super(key: key);

  @override
  _HotelBookingScreenState createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int numRooms = 1;
  int numDays = 1;
  double pricePerNight = 100; // Example price, you can fetch it dynamically
  double totalPrice = 0;

  void _calculateTotalPrice() {
    setState(() {
      totalPrice = (numRooms * numDays * pricePerNight).toDouble();  // Ensure it's a double
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking for ${widget.hotel['name']}")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hotel: ${widget.hotel['name']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _idController, decoration: const InputDecoration(labelText: 'ID Card')),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rooms: $numRooms"),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numRooms++;
                    });
                    _calculateTotalPrice();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      numRooms = numRooms > 1 ? numRooms - 1 : 1;
                    });
                    _calculateTotalPrice();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Days: $numDays"),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numDays++;
                    });
                    _calculateTotalPrice();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      numDays = numDays > 1 ? numDays - 1 : 1;
                    });
                    _calculateTotalPrice();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Total Price: \$${totalPrice.toStringAsFixed(2)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform booking logic
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    content: Text("Booking Successful!"),
                  ),
                );
              },
              child: const Text("Book Now"),
            ),
          ],
        ),
      ),
    );
  }
}
