import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Ledger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SalesRecord> salesRecords = [];
  final TextEditingController itemController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  int? selectedIndex;

  void _addRecord() {
    final item = itemController.text;
    final date = dateController.text;
    final amount = amountController.text;

    if (item.isNotEmpty && date.isNotEmpty && amount.isNotEmpty) {
      setState(() {
        salesRecords.add(SalesRecord(item, date, amount));
        itemController.clear();
        dateController.clear();
        amountController.clear();
      });
    }
  }

  void _updateRecord() {
    final item = itemController.text;
    final date = dateController.text;
    final amount = amountController.text;

    if (item.isNotEmpty && date.isNotEmpty && amount.isNotEmpty && selectedIndex != null) {
      setState(() {
        salesRecords[selectedIndex!] = SalesRecord(item, date, amount);
        itemController.clear();
        dateController.clear();
        amountController.clear();
        selectedIndex = null;
      });
    }
  }

  void _deleteRecord(int index) {
    setState(() {
      salesRecords.removeAt(index);
    });
  }

  void _editRecord(int index) {
    final record = salesRecords[index];
    itemController.text = record.item;
    dateController.text = record.date;
    amountController.text = record.amount;
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Ledger'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataTable(
              columns: [
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Actions')),
              ],
              rows: salesRecords
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final record = entry.value;
                return DataRow(cells: [
                  DataCell(Text(record.item)),
                  DataCell(Text(record.date)),
                  DataCell(Text(record.amount)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editRecord(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteRecord(index);
                        },
                      ),
                    ],
                  )),
                ]);
              })
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: itemController,
                    decoration: InputDecoration(labelText: 'Item'),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedIndex == null) {
                      _addRecord();
                    } else {
                      _updateRecord();
                    }
                  },
                  child: Text(selectedIndex == null ? 'Add Record' : 'Update Record'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SalesRecord {
  final String item;
  final String date;
  final String amount;

  SalesRecord(this.item, this.date, this.amount);
}
