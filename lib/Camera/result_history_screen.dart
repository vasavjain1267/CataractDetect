import 'package:cataract_detector1/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'result.dart';

class ResultDetailScreen extends StatelessWidget {
  final String resultId;

  const ResultDetailScreen({Key? key, required this.resultId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final eyeResultRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('eye_results')
        .doc(resultId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Result Details', style: TextStyle(fontWeight: FontWeight.bold, height: 5, fontSize: getScaledWidth(25.0, context))
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: eyeResultRef.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching result details'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No result found'));
            } else {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
        
              final result = Result(
                rightEyeResult: data?['righteyeresult'] ?? 'No result',
                leftEyeResult: data?['lefteyeresult'] ?? 'No result',
                rightEyeImagePath: data?['righteyeimage'] ?? '',
                leftEyeImagePath: data?['lefteyeimage'] ?? '',
                dateTime: (data?['date_time'] as Timestamp?)?.toDate() ?? DateTime.now(),
              );
        
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      result.rightEyeImagePath,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Failed to load right eye image');
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Right Eye Result: ${result.rightEyeResult}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Image.network(
                      result.leftEyeImagePath,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Failed to load left eye image');
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Left Eye Result: ${result.leftEyeResult}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
