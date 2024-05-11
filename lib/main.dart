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

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> todos = [];

  TextEditingController _controller = TextEditingController();
  TextEditingController _editController = TextEditingController();
  bool isEditing = false;
  int editingIndex = -1;

  void _addTodo() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        todos.add(_controller.text);
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
      _editController.text = todos[index];
    });
  }

  void _saveTodo() {
    setState(() {
      todos[editingIndex] = _editController.text;
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
              if (isEditing) {
                _saveTodo();
              } else {
                _addTodo();
              }
            },
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
          SizedBox(height: 20),
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
                      : Text(todos[index]),
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
