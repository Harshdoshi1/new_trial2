import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Display Image")),
      body: Center(
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/new-trial1-370a6.appspot.com/o/image.jpeg?alt=media&token=81df2024-5c44-401f-ac50-eb8d89d4269d',
          width: 200, // Set the desired width of the image
          height: 200, // Set the desired height of the image
          fit: BoxFit.cover, // Adjusts how the image fits within the container
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.error,
            size: 50,
            color: Colors.red,
          ), // Shows an error icon if the image can't load
        ),
      ),
    );
  }
}
