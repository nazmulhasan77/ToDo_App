import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  DateTime dateTime;

  Todo({
    required this.title,
    required this.dateTime,
  });
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  TextEditingController _controller = TextEditingController();
  TextEditingController _editController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  bool isEditing = false;
  int editingIndex = -1;

  void _addTodo() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        todos.add(Todo(
          title: _controller.text,
          dateTime: DateTime.now(),
        ));
        _controller.clear();
      }
    });
  }

  void _removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _editTodo(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      _editController.text = todos[index].title;
    });
  }

  void _saveTodo() {
    setState(() {
      todos[editingIndex].title = _editController.text;
      isEditing = false;
      editingIndex = -1;
      _editController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: isEditing ? _editController : _controller,
            decoration: InputDecoration(
              hintText: 'Enter your todo',
            ),
            onSubmitted: (_) {
              if (isEditing) {
                _saveTodo();
              } else {
                _addTodo();
              }
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              ).then((pickedDate) {
                if (pickedDate != null) {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((pickedTime) {
                    if (pickedTime != null) {
                      setState(() {
                        _dateTimeController.text =
                            '$pickedDate ${pickedTime.format(context)}';
                      });
                    }
                  });
                }
              });
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            ),
            child: Text('Set Date & Time'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: isEditing && editingIndex == index
                      ? TextField(
                          controller: _editController,
                          decoration: InputDecoration(
                            hintText: 'Modify your todo',
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todos[index].title),
                            Text(
                              'Date & Time: ${todos[index].dateTime}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          isEditing ? _saveTodo() : _editTodo(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeTodo(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
