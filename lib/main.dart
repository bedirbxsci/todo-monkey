import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Reminders and TODO',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: const Color.fromARGB(0, 232, 32, 32),
          secondary: const Color.fromARGB(0, 6, 250, 177),
        ),
      ),
      home: const MyHomePage(title: 'Add, Delete, or Edit Tasks, You Lazy Bum'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> reminders = [];
List<String> details = [];
List<String> date = [];
List<String> time = [];

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();
  TextEditingController nameController3 = TextEditingController();
  TextEditingController nameController4 = TextEditingController();
  void _addItem() {
    setState(() {
      reminders.insert(0, nameController1.text);
      details.insert(0, nameController2.text);
      date.insert(0, nameController3.text);
      time.insert(0, nameController4.text);
      nameController1.clear();
      nameController2.clear();
      nameController3.clear();
      nameController4.clear();
    });
  }

  void _removeItem(int index) {
    setState(() {
      reminders.removeAt(index);
      date.removeAt(index);
      time.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 129, 9, 2),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: reminders.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    SecondRoute(index: index))),
                          ).then((value) => setState(() {}));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  '${reminders.elementAt(index)} : ${date.elementAt(index)} : ${time.elementAt(index)}',
                                )),
                                IconButton(
                                    onPressed: () => _removeItem(index),
                                    icon: const Icon(Icons.delete)),
                              ])),
                              
                        ));
                  }))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(context),
            tooltip: 'Add Item',
            child: const Icon(Icons.add)));
  }

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            insetPadding: const EdgeInsets.all(20),
            backgroundColor: const Color.fromARGB(221, 255, 233, 233),
            title: const Text(
                textAlign: TextAlign.center,
                'Add a task and focus yourself so you do not end like Benjamin Chong'),
            content: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(1),
                  child: TextField(
                      controller: nameController1,
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(221, 255, 233, 233),
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: "Task Name",
                          labelStyle: TextStyle(color: Colors.black)))),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                          controller: nameController2,
                          maxLines: 30,
                          decoration: const InputDecoration(
                              fillColor: Color.fromARGB(221, 255, 233, 233),
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: "Task Detail",
                              labelStyle: TextStyle(color: Colors.black))))),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: nameController3,
                          decoration: const InputDecoration(
                              fillColor: Color.fromARGB(221, 255, 233, 233),
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: "Date",
                              labelStyle: TextStyle(color: Colors.black)))),
                  Expanded(
                      child: TextField(
                          controller: nameController4,
                          decoration: const InputDecoration(
                              fillColor: Color.fromARGB(221, 255, 233, 233),
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: "Time",
                              labelStyle: TextStyle(color: Colors.black))))
                ],
              )
            ]),
            actions: <Widget>[
              // add button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 254, 0, 85),
                ),
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _addItem();
                  });
                },
              ),
              // Cancel button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 254, 0, 85),
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController1.clear();
                  nameController2.clear();
                  nameController3.clear();
                  nameController4.clear();
                },
              )
            ],
          );
        });
  }
}

class SecondRoute extends StatefulWidget {
  final int index;
  const SecondRoute({required this.index, Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();
  TextEditingController nameController3 = TextEditingController();
  TextEditingController nameController4 = TextEditingController();

  void _edit(int index, int control) {
    setState(() {
      if (control == 1) {
        reminders[index] = nameController1.text;
        nameController1.clear();
      } else if (control == 2) {
        details[index] = nameController2.text;
        nameController2.clear();
      } else if (control == 3) {
        date[index] = nameController3.text;
        nameController3.clear();
      } else if (control == 4) {
        time[index] = nameController4.text;
        nameController4.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 129, 9, 2),
        appBar: AppBar(
          title: const Text("Changes"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                    '${reminders.elementAt(widget.index)} : ${date.elementAt(widget.index)} : ${time.elementAt(widget.index)}')),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                    details.elementAt(widget.index))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                  controller: nameController1,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(221, 255, 233, 233),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Edit the name',
                  )),
            ),
            ElevatedButton(
                onPressed: () => _edit(widget.index, 1),
                child: const Text('Press to Confirm Name Change')),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                  controller: nameController2,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(221, 255, 233, 233),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Edit the Details of the thing',
                  )),
            ),
            ElevatedButton(
                onPressed: () => _edit(widget.index, 2),
                child: const Text('Press to Confirm Detail Change')),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                  controller: nameController3,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(221, 255, 233, 233),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Edit the date',
                  )),
            ),
            ElevatedButton(
                onPressed: () => _edit(widget.index, 3),
                child: const Text('Press to Confirm Date Change')),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                  controller: nameController4,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(221, 255, 233, 233),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Edit the time',
                  )),
            ),
            ElevatedButton(
                onPressed: () => _edit(widget.index, 4),
                child: const Text('Press to Confirm Time Change')),
          ],
        )));
  }
}
