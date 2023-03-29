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
  @override
  void initState() {
    super.initState();

    // Retrieve the user's todos from Supabase and sort them by their due date
    _todoStream = _supabaseController.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
          const TodayReminder(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: StreamBuilder(
                  stream: _todoStream,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final todos = snapshot.data!.map((e) => Todo.fromJson(e)).toList();
                    final todosByDueDate = groupTodosByDueDate(todos);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: todosByDueDate.length,
                        itemBuilder: (context, index) {
                          final dueDate = todosByDueDate.keys.elementAt(index);
                          final todosForDueDate = todosByDueDate[dueDate]!;
                          return Column(
                            children: [
                              UniqueDayTitle(title: dueDate),
                              ...todosForDueDate
                                  .map((todo) => TodoTask(
                                        todo: todo,
                                        supabaseController: _supabaseController,
                                      ))
                                  .toList(),
                            ],
                          );
                        });
                  }),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 10, top: 5),
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

class TodayReminder extends StatelessWidget {
  const TodayReminder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 160,
      color: Theme.of(context).colorScheme.primary,
      child: Container(
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
                  "Meeting with client",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
                Text(
                  "10:00 AM",
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
                        onTap: () {},
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required SupabaseManager supabaseController,
  }) : _supabaseController = supabaseController;

  final SupabaseManager _supabaseController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _supabaseController.getCurrentUser()?.userMetadata!.values.first ?? "No user",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text("Today you have 9 tasks", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
          ],
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/default.png"),
        ),
      ],
    );
  }
}
