import "package:flutter/material.dart";

class ReadScreenView extends StatelessWidget {
  const ReadScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book name", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: const [
          Icon(Icons.favorite_outline, color: Colors.white),
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.comment, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
