import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      home: const MyHomePage(title: 'Add, Delete, or Edit Tasks'),
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.lightBlueAccent, // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: Colors.black, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.lightBlueAccent, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();

  void _addItem() {
    setState(() {
      reminders.insert(0, nameController1.text);
      details.insert(0, nameController2.text);
      date.insert(0, getDate());
      time.insert(0, getTime(selectedTime));
      nameController1.clear();
      nameController2.clear();
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
        backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: reminders.isEmpty
            ? const Center(
                child: Text(
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    'You have no Tasks to do RIGHT NOW'))
            : Column(children: <Widget>[
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
                                      const Icon(
                                        Icons.list,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                          child: ListTile(
                                              title: Text(
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                                reminders.elementAt(index),
                                              ),
                                              subtitle: Text(
                                                  details.elementAt(index)),
                                              trailing: const Icon(
                                                Icons.event,
                                                color: Colors.black,
                                              ))),
                                      Expanded(
                                          child: ListTile(
                                        title: Text(
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          date.elementAt(index),
                                        ),
                                        subtitle: Text(
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          time.elementAt(index),
                                        ),
                                      )),
                                      IconButton(
                                          onPressed: () => _removeItem(index),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
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
            backgroundColor: const Color.fromARGB(255, 134, 212, 251),
            title: const Text(
                textAlign: TextAlign.center,
                'Add a task and focus yourself so you do not end like Benjamin Chong'),
            content: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(1),
                  child: TextField(
                      controller: nameController1,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
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
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(),
                              labelText: "Task Detail",
                              labelStyle: TextStyle(color: Colors.black))))),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: const Text('Date Picker'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: const Text('Time Picker'),
                    ),
                  ),
                ],
              )
            ]),
            actions: <Widget>[
              // add button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
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
                  foregroundColor: Colors.white,
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController1.clear();
                  nameController2.clear();
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.lightBlue, // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: Colors.black, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        date[widget.index] = getDate();
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.lightBlue, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
        time[widget.index] = getTime(selectedTime);
      });
    }
    return selectedTime;
  }

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();

  void _edit(int index, int control) {
    setState(() {
      if (control == 1) {
        reminders[index] = nameController1.text;
        nameController1.clear();
      } else if (control == 2) {
        details[index] = nameController2.text;
        nameController2.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
          title: const Text("Changes"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.list,
                        color: Colors.black,
                      ),
                      Expanded(
                          child: ListTile(
                              title: Text(
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                reminders.elementAt(widget.index),
                              ),
                              subtitle: Text(details.elementAt(widget.index)),
                              trailing: const Icon(
                                Icons.event,
                                color: Colors.black,
                              ))),
                      Expanded(
                          child: ListTile(
                        title: Text(
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          date.elementAt(widget.index),
                        ),
                        subtitle: Text(
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          time.elementAt(widget.index),
                        ),
                      ))
                    ]))),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                  controller: nameController1,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Edit the name',
                  )),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _edit(widget.index, 1),
                    child: const Text('Press to Confirm Name Change'))),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                  controller: nameController2,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Press to edit the details ',
                  )),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _edit(widget.index, 2),
                    child: const Text('Press to Detail Change'))),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  _selectDate(context);
                },
                child: const Text('Press to Change Date'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  _selectTime(context);
                },
                child: const Text('Press to Change Time'),
              ),
            ),
          ],
        )));
  }
}
