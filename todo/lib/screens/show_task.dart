import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/widgets/task_item.dart';

import '../models/request.dart';

class ShowTasks extends StatefulWidget {
  const ShowTasks({super.key});

  @override
  State<ShowTasks> createState() => _ShowTasksState();
}

List<dynamic> tasklist = [];

class _ShowTasksState extends State<ShowTasks> {
  final task = TextEditingController();
  int id = 1;

  Future openDialog(BuildContext context, int id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter Task Details"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: ". . .",
            ),
            controller: task,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (task.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Empty Task Input!!")));
                } else {
                  var url =
                      "http://127.0.0.1:5000/add?id=$id&task=${task.text}";
                  var data = await getData(url);
                  var decoded = json.decode(data);
                  Navigator.of(context).pop();
                  tasklist.clear();
                  tasklist.addAll(decoded["tasks"]);
                  updateTasks();
                }
              },
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );

  Future updateTasks() async {
    await Future.delayed(const Duration(seconds: 1), () => setState(() {}));
  }

  Future deleteTask(int id) async {
    var url = "http://127.0.0.1:5000/delete?id=$id";
    var data = await getData(url);
    var decoded = json.decode(data);

    tasklist.clear();
    tasklist.addAll(decoded["tasks"]);
    updateTasks();
  }

  @override
  Widget build(BuildContext context) {
    var routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    String name = routeArgs['name'];
    tasklist = routeArgs["tasks"];
    id = routeArgs["id"];
    List<Widget> tasks = [];

    for (var i in tasklist.reversed) {
      tasks.add(
        TaskItem(
          key: Key(i[3].toString()),
          personId: i[0],
          name: i[1],
          id: i[3],
          task: i[4],
          del: deleteTask,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User: $name",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: tasks,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add item"),
        icon: const Icon(Icons.add_box_outlined),
        onPressed: () {
          openDialog(context, id);
        },
      ),
    );
  }
}
