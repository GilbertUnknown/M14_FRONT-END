import 'package:flutter/material.dart';
import 'package:m12/profile.dart';
import 'package:m12/todospage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:m12/darktheme.dart';
import 'package:table_calendar/table_calendar.dart';

void onSaveTodo(String title, String description, String startDate,
    String endDate, String category, BuildContext context) {
  final homePageState = context.findAncestorStateOfType<_MainPageState>();
  homePageState?.addTodo(title, description, startDate, endDate, category);
  Navigator.pop(context);
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;
  

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<EventTime> eventData = [];
  TextEditingController judulController = TextEditingController();
  TextEditingController additionalController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSelesaiController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<Todo> _originalTodos = [];
  List<Todo> _filteredTodos = [];
  String? _value;
  final List<Stuff> _stuff = [
    Stuff('Work', Colors.red),
    Stuff('Routine', Colors.amber),
    Stuff('Others', Colors.green)
  ];
  PageController _pageController = PageController(initialPage: 0);

  void addTodo(String title, String description, String startDate,
      String endDate, String category) {
    setState(() {
      _originalTodos.add(Todo(
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        category: category,
        isChecked: false,
      
      ));
      _filteredTodos = _originalTodos;
    });
  }

  void _selectedChip(String? value) {
    List<Todo> filter;
    if (value != null) {
      filter = _originalTodos
          .where((tile) => tile.category.contains(value))
          .toList();
    } else {
      filter = _originalTodos;
    }
    setState(() {
      _filteredTodos = filter;
      _value = value;
    });
  }

  int _selectedButtomIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedButtomIndex = index;
    });
  }
    void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _counter(int num) {
    return Container(
      width: 20,
      height: 20,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  int doneNumber(String item) {
    List<Todo> filtered;
    filtered = _originalTodos
        .where((tile) => tile.category.contains(item) && tile.isChecked != true)
        .toList();
    return filtered.length.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final DateTime firstDay = DateTime.now().subtract(const Duration(days: 365));
    final DateTime lastDay = DateTime.now().add(const Duration(days: 365));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _selectedButtomIndex = index;
          });
        },
        children: [
          Column(

            children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(
                  _stuff.length,
                  (int index) {
                    return ChoiceChip(
                      label: Text(_stuff[index].label),
                      selectedColor: _stuff[index].color,
                      backgroundColor: Colors.white70,
                      side: BorderSide(color: _stuff[index].color, width: 2),
                      selected: _value == _stuff[index].label,
                      onSelected: (bool value) {
                        setState(() {
                          _value = value ? _stuff[index].label : null;
                        });

                        if (value) {
                          _selectedChip(_stuff[index].label);
                        } else {
                          _selectedChip(null);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Text(
          'Unfinished',
          textAlign: TextAlign.left,
        ),
        Divider(
          color: Colors.black,
        ),
         Expanded(
          child: ListView.builder(
            itemCount: _filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = _filteredTodos[index];
              return!todo.isChecked?ExpansionTile(
                leading: Checkbox(
                  value: todo.isChecked,
                  activeColor: _stuff
                      .firstWhere((element) => element.label == todo.category)
                      .color,
                  side: BorderSide(
                      color: _stuff
                          .firstWhere(
                              (element) => element.label == todo.category)
                          .color,
                      width: 2),
                  onChanged: (bool? value) {
                    setState(() {
                      todo.isChecked = value ?? false;
                    });
                  },
                ),
                title: Text(
                  todo.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  '${todo.startDate} s/d ${todo.endDate}',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                children: <Widget>[
                  ListTile(
                      title: Text(
                    todo.description,
                  )),
                ],
              ):Container();
            },
          ),
        ),
         Text(
          'Finished',
          textAlign: TextAlign.left,
        ),
        Divider(
          color: Colors.black,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = _filteredTodos[index];
              return todo.isChecked?ExpansionTile(
                leading: Checkbox(
                  value: todo.isChecked,
                  activeColor: _stuff
                      .firstWhere((element) => element.label == todo.category)
                      .color,
                  side: BorderSide(
                      color: _stuff
                          .firstWhere(
                              (element) => element.label == todo.category)
                          .color,
                      width: 2),
                  onChanged: (bool? value) {
                    setState(() {
                      todo.isChecked = value ?? false;
                    });
                  },
                ),
                title: Text(
                  todo.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  '${todo.startDate} s/d ${todo.endDate}',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                children: <Widget>[
                  ListTile(
                      title: Text(
                    todo.description,
                  )),
                ],
              ):Container();
            },
          ),
        ),
      ]),
       ListView(
      children: [
        TableCalendar(
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Event"),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextField(
                                      controller: judulController,
                                      style: TextStyle(
                                        color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Nama Event',
                                        labelStyle: TextStyle(
                                          color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextField(
                                      controller: additionalController,
                                      style: TextStyle(
                                        color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Keterangan tambahan',
                                        labelStyle: TextStyle(
                                          color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextField(
                                      controller: tglMulaiController,
                                      style: TextStyle(
                                        color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Tanggal mulai',
                                        labelStyle: TextStyle(
                                          color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        var selectedDate = DateTime.now();
                                        final DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          initialDatePickerMode: DatePickerMode.day,
                                          firstDate: DateTime(2015),
                                          lastDate: DateTime(2101),
                                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                dialogBackgroundColor: Colors.white, //Sesuaikan warna dengan kebutuhan
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            selectedDate = picked;
                                            tglMulaiController.text =
                                                DateFormat('dd MMM yyyy').format(selectedDate);
                                          });
                                        }
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: TextField(
                                      controller: tglSelesaiController,
                                      style: TextStyle(
                                        color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Tanggal selesai',
                                        labelStyle: TextStyle(
                                          color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black, //Sesuaikan warna dengan kebutuhan
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        var selectedDate = DateTime.now();
                                        final DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          initialDatePickerMode: DatePickerMode.day,
                                          firstDate: DateTime(2015),
                                          lastDate: DateTime(2101),
                                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                dialogBackgroundColor: Colors.white, //Sesuaikan warna dengan kebutuhan
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            selectedDate = picked;
                                            tglSelesaiController.text =
                                                DateFormat('dd MMM yyyy').format(selectedDate);
                                          });
                                        }
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    eventData.add(
                                      EventTime(
                                        judulController.text,
                                        additionalController.text,
                                        tglMulaiController.text,
                                        tglSelesaiController.text,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text("SET"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              if (eventData.length != 0)
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: eventData.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(eventData[index].title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(eventData[index].subtitle),
                              Text(
                                eventData[index].startDate == eventData[index].endDate
                                    ? eventData[index].endDate
                                    : "${eventData[index].startDate} - ${eventData[index].endDate}",
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                eventData.remove(eventData[index]);
                              });
                            },
                          ),
                          isThreeLine: true,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      )
      ]
      ),
      profile(data: _originalTodos,),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _selectedButtomIndex !=1,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => Todos(onSaveTodo: addTodo))));
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Todos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: 'Calender',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedButtomIndex,
        selectedItemColor: Colors.green,
        onTap: (int index){
          setState(() {
            _selectedButtomIndex = index;
            _pageController.animateToPage(
              index,
              duration:Duration(milliseconds: 300),
              curve: Curves.easeInOut
            );
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: themeProvider.darkTheme == false
                        ? Colors.blue
                        : Colors.grey),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('TODOS APP',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('By: Gilbert')
                  ],
                )),
            ListTile(
                title: Text('Work'),
                trailing: Visibility(
                    visible: doneNumber('Work') != 0,
                    child: _counter(doneNumber('Work')))),
            ListTile(
                title: Text('Routine'),
                trailing: Visibility(
                    visible: doneNumber('Routine') != 0,
                    child: _counter(doneNumber('Routine')))),
            ListTile(
                title: Text('Others'),
                trailing: Visibility(
                    visible: doneNumber('Others') != 0,
                    child: _counter(doneNumber('Others')))),
            Divider(),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                  value: themeProvider.darkTheme,
                  onChanged: (value) {
                    setState(() {
                      themeProvider.darkMode = value;
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class Stuff {
  String label;
  Color color;

  Stuff(this.label, this.color);
}

class Todo {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String category;
  bool isChecked;

  Todo({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    this.isChecked = false,
  });
}
class EventTime {
  String title;
  String subtitle;
  String startDate;
  String endDate;
  EventTime(this.title, this.subtitle, this.startDate, this.endDate);
}