import 'package:cataract_detector1/Camera/result_history_screen.dart';
import 'package:cataract_detector1/media_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAndGroupResults() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('eye_results')
        .orderBy('date_time', descending: true)
        .get();

    List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add document ID to the data
      return data;
    }).toList();

    Map<String, List<Map<String, dynamic>>> groupedResults = {};

    for (var result in results) {
      DateTime dateTime = (result['date_time'] as Timestamp?)?.toDate() ?? DateTime.now();
      String date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      if (groupedResults.containsKey(date)) {
        groupedResults[date]!.add(result);
      } else {
        groupedResults[date] = [result];
      }
    }

    return groupedResults;
  }

  Future<void> _deleteResult(Map<String, dynamic> result) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('eye_results')
        .doc(result['id'])
        .delete();
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> result) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(result['righteyeimage'] ?? ''),
        ),
        title: Text(
          'Right Eye: ${result['righteyeresult'] ?? 'No result'}, Left Eye: ${result['lefteyeresult'] ?? 'No result'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Test Time: " + DateFormat('HH:mm').format((result['date_time'] as Timestamp?)?.toDate() ?? DateTime.now())),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.blue),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete Result'),
                content: Text('Are you sure you want to delete this result?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await _deleteResult(result);
              (context as Element).markNeedsBuild(); // This updates the UI
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultDetailScreen(resultId: result['id']),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false; // Prevent default back button action
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Results History'),
        ),
        body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: _fetchAndGroupResults(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            Map<String, List<Map<String, dynamic>>> groupedResults = snapshot.data!;
            List<String> dates = groupedResults.keys.toList();

            return ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                String date = dates[index];
                List<Map<String, dynamic>> resultsForDate = groupedResults[date]!;

                return ExpansionTile(
                  title: Text(
                    'Date: $date',
                    style: TextStyle(
                      fontSize: getScaledWidth(20, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: resultsForDate.map((result) {
                    return _buildCard(context, result);
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
