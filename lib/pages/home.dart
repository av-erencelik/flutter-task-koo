import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/services/todo.dart';
import 'package:flutter_todo_app/services/supabase.dart';
import 'package:flutter_todo_app/theme.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _todoStream;
  final _supabaseController = SupabaseManager();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  String title = "";
  DateTime day = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  @override
  void initState() {
    super.initState();

    _todoStream = _supabaseController.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                double mWidth = MediaQuery.of(context).size.width;
                double mHeight = MediaQuery.of(context).size.height;
                return showNewTodoForm(mHeight, mWidth, context);
              });
        },
        elevation: 2,
        child: const Icon(Icons.add, size: 50, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        elevation: 15,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Tasks",
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: CustomAppbar(supabaseController: _supabaseController),
        ),
      ),
      body: Wrap(
        children: [
          TodayReminder(supabaseController: _supabaseController),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 325,
              child: StreamBuilder(
                  stream: _todoStream,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final todos = snapshot.data!.map((e) => Todo.fromJson(e)).toList();
                    final todosByDueDate = groupTodosByDueDate(todos);
                    return TodoList(todosByDueDate: todosByDueDate, supabaseController: _supabaseController);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Container showNewTodoForm(double mHeight, double mWidth, BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      height: mHeight * 0.8,
      width: mWidth,
      child: Container(
        height: mHeight * 1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80),
            topRight: Radius.circular(80),
          ),
        ),
        child: Column(children: [
          Transform.translate(
            offset: const Offset(0, -25),
            child: ElevatedButton(
              onPressed: () {
                timeinput.text = "";
                dateinput.text = "";
                Navigator.pop(context);
              },
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: const MaterialStatePropertyAll(0),
                    shape: const MaterialStatePropertyAll(CircleBorder()),
                  ),
              child: const Icon(
                Icons.close,
                size: 50,
              ),
            ),
          ),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.title, color: Theme.of(context).colorScheme.primary),
                      hintText: "Title",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        title = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: dateinput,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 1000)),
                      );
                      setState(() {
                        day = pickedDate!;
                        dateinput.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Date",
                      icon: Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: timeinput,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          time = pickedTime;
                          print(time.hour);
                          timeinput.text = pickedTime.format(context);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Time",
                      icon: Icon(Icons.timelapse, color: Theme.of(context).colorScheme.primary),
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        print(time);
                        if (_formKey.currentState!.validate()) {
                          final timestamp = DateTime(day.year, day.month, day.day, time.hour, time.minute);
                          Random random = new Random();
                          final todo = {
                            'title': title,
                            'day': timestamp.toIso8601String(),
                            'time': timestamp.toString(),
                            'userId': _supabaseController.getCurrentUser()!.id,
                            'colorId': random.nextInt(10)
                          };
                          _supabaseController.insetNewTodo(todo);
                        }
                        Navigator.pop(context);
                        dateinput.text = "";
                        timeinput.text = "";
                        _formKey.currentState!.reset();
                      },
                      child: Text(
                        'Add',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Map<String, List<Todo>> groupTodosByDueDate(List<Todo> todos) {
    return todos.fold({}, (map, todo) {
      final dueDate = todo.day;
      if (!map.containsKey(dueDate)) {
        map[dueDate] = [];
      }
      map[dueDate]!.add(todo);
      return map;
    });
  }
}

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todosByDueDate,
    required SupabaseManager supabaseController,
  }) : _supabaseController = supabaseController;

  final Map<String, List<Todo>> todosByDueDate;
  final SupabaseManager _supabaseController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: todosByDueDate.length,
        itemBuilder: (context, index) {
          final dueDate = todosByDueDate.keys.elementAt(index);
          final todosForDueDate = todosByDueDate[dueDate]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UniqueDayTitle(title: dueDate),
              ...todosForDueDate.map((todo) => dismissibleTaskCard(context, todo)).toList(),
            ],
          );
        });
  }

  Dismissible dismissibleTaskCard(BuildContext context, Todo todo) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Delete ${todo.title}"),
                  content: const Text("Are you sure you want to delete this todo?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("No", style: TextStyle(color: Colors.red))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes", style: TextStyle(color: Colors.green))),
                  ],
                ));
      },
      onDismissed: (direction) {
        _supabaseController.deleteTodoById(todo.id);
      },
      background: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.red[100],
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )),
      ),
      key: UniqueKey(),
      child: TodoTask(
        todo: todo,
        supabaseController: _supabaseController,
      ),
    );
  }
}

class TodoTask extends StatelessWidget {
  const TodoTask({
    super.key,
    required this.todo,
    required this.supabaseController,
  });

  final Todo todo;
  final SupabaseManager supabaseController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(21.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(21.4),
          ),
        ),
        leading: CustomCheckbox(colorId: todo.colorId, finished: todo.finished, id: todo.id),
        title: Text(
          todo.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: todo.finished ? TextDecoration.lineThrough : TextDecoration.none),
        ),
        subtitle: Text(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(todo.time)),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 10)),
        trailing: InkWell(
          onTap: () {
            supabaseController.updateNotificationsStatus(todo.id, !todo.notifications);
          },
          child: Icon(
            Icons.notifications,
            color: todo.notifications ? Colors.yellow[700] : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    required this.colorId,
    required this.finished,
    required this.id,
  });
  final int? colorId;
  final bool finished;
  final String id;
  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;
  final _supabaseController = SupabaseManager();
  @override
  void initState() {
    super.initState();
    _value = widget.finished;
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.finished != widget.finished) {
      setState(() {
        _value = widget.finished;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        value: _value,
        onChanged: (value) => setState(() {
          _supabaseController.updateFinishedStatus(widget.id, value!);
        }),
        activeColor: ToDoColors.tileColors[widget.colorId ?? 1],
        overlayColor: MaterialStateProperty.all(ToDoColors.tileColors[widget.colorId ?? 1].withOpacity(0.1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide(color: ToDoColors.tileColors[widget.colorId ?? 1], width: 2),
      ),
    );
  }
}

class UniqueDayTitle extends StatelessWidget {
  const UniqueDayTitle({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5, left: 5),
      child: Text(
        checkIfTodayOrTomorrow(title),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  checkIfTodayOrTomorrow(String date) {
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dateToCheck = DateTime.parse(date);
    if (dateToCheck.day == today.day && dateToCheck.month == today.month && dateToCheck.year == today.year) {
      return "Today";
    } else if (dateToCheck.day == tomorrow.day &&
        dateToCheck.month == tomorrow.month &&
        dateToCheck.year == tomorrow.year) {
      return "Tomorrow";
    } else {
      return DateFormat.yMMMd().format(dateToCheck);
    }
  }
}

class TodayReminder extends StatefulWidget {
  const TodayReminder({
    super.key,
    required this.supabaseController,
  });

  final SupabaseManager supabaseController;

  @override
  State<TodayReminder> createState() => _TodayReminderState();
}

class _TodayReminderState extends State<TodayReminder> {
  bool show = false;
  Todo? current;
  @override
  void initState() {
    super.initState();
    widget.supabaseController.fetchTodaysLatestNotificationsTrueTodo().then((value) {
      if (value.length > 0) {
        setState(() {
          current = value[0];
          show = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 160,
      color: Theme.of(context).colorScheme.primary,
      child: show
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
              ),
              padding: const EdgeInsets.all(17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Today Reminder",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        current?.title ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                      Text(
                        DateFormat.jm().format(DateFormat("hh:mm:ss").parse(current?.time ?? "")),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  Row(
                    children: [
                      const Image(
                        image: AssetImage("assets/ring.png"),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            transform: Matrix4.translationValues(5, -10, 0),
                            child: InkWell(
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  show = false;
                                });
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            )
          : Align(
              child: Text("No reminders today. Add some! 🎉",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white))),
    );
  }
}

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({
    super.key,
    required SupabaseManager supabaseController,
  }) : _supabaseController = supabaseController;

  final SupabaseManager _supabaseController;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  late int todaysTasks = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._supabaseController.fetchNumberOfTodaysTasks().then((value) {
      setState(() {
        todaysTasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget._supabaseController.getCurrentUser()?.userMetadata!.values.first ?? "No user",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text("Today you have $todaysTasks tasks",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
          ],
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/default.png"),
        ),
      ],
    );
  }
}
