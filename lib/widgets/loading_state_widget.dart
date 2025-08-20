import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading'),
          SizedBox(height: 8),
          Text(
            'This usually takes just a moment',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
