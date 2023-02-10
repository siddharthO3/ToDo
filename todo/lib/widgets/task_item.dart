import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final int id;
  final String name;
  final String task;
  final int personId;
  final Function del;

  TaskItem({
    super.key,
    required this.id,
    required this.name,
    required this.task,
    required this.personId,
    required this.del,
  });

  final colors = [
    Colors.deepPurpleAccent[100],
    Colors.amberAccent[100],
    Colors.redAccent[100],
    Colors.indigoAccent[100],
    Colors.greenAccent[100],
    Colors.blueAccent[100],
    Colors.deepOrangeAccent[100],
  ];

  Color invert(Color color) {
    final r = 255 - color.red;
    final g = 255 - color.green;
    final b = 255 - color.blue;

    return Color.fromRGBO(r, g, b, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 0.9 * MediaQuery.of(context).size.width,
        child: ListTile(
          
          tileColor: colors[(personId - 1) % 7],
          leading: Text(id.toString()),
          title: Text(task),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task Deleted!!")));
                  del(id);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                tooltip: "Delete this task",
                color: invert(colors[(personId - 1) % 7]!),
                hoverColor: invert(colors[(personId - 1) % 7]!),
              )
            ],
          ),
          style: ListTileStyle.list,
        ),
      ),
    );
  }
}
