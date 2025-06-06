import 'package:flutter/material.dart';
import 'package:inventar_discovery_arena/adauga_inventar_page.dart';
import 'package:inventar_discovery_arena/vezi_inventar_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventar Zilnic'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Adaugă inventar pentru azi'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdaugaInventarPage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Vezi inventar pentru azi'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VeziInventarPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}