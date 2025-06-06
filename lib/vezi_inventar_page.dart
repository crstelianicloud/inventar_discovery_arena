import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VeziInventarPage extends StatefulWidget {
  @override
  _VeziInventarPageState createState() => _VeziInventarPageState();
}

class _VeziInventarPageState extends State<VeziInventarPage> {
  String dataZilei() {
    return DateTime.now().toIso8601String().substring(0, 10);
  }

  Future<Map<String, dynamic>?> getInventar() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('inventare')
        .doc(dataZilei())
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String dataAstazi = dataZilei();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventar pentru $dataAstazi'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getInventar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Eroare: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Nu există inventar pentru această zi.'));
          }

          Map<String, dynamic> inventar = snapshot.data!;
          Map<String, dynamic>? produse = inventar['produse'];

          if (produse == null || produse.isEmpty) {
            return Center(child: Text('Inventar este gol.'));
          }

          return ListView(
            children: produse.entries.map((entry) {
              String nume = entry.key;
              var detalii = entry.value;
              return ListTile(
                title: Text(nume),
                subtitle: Text('Cantitate: ${detalii['cantitate']}, Preț: ${detalii['pret']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}