import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todocontainer extends StatefulWidget {
  const Todocontainer({super.key});

  @override
  State<Todocontainer> createState() => _TodocontainerState();
}

class Task {
  int id;
  String task;
  bool isDone;

  Task({required this.id, required this.task, this.isDone = false});

  @override
  String toString() {
    return '$id|$task|$isDone';
  }

  static Task fromString(String str) {
    final parts = str.split('|');
    return Task(
      id: int.parse(parts[0]),
      task: parts[1],
      isDone: parts[2] == 'true',
    );
  }
}

class _TodocontainerState extends State<Todocontainer> {
  List<Task> tasklist = [];
  List<Task> updatedList = [];
  TextEditingController textcontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  int i = 1, display = 1;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = tasklist.map((task) => task.toString()).toList();
    await prefs.setStringList('tasklist', taskStrings);
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasklist');
    if (taskStrings != null) {
      i = taskStrings.length + 1;
      setState(() {
        tasklist = taskStrings.map((s) => Task.fromString(s)).toList();
        updatedList = tasklist;
      });
    }
  }

  void addtask(String task, int id) {
    if (task.isEmpty) return;
    setState(() {
      tasklist.add(Task(id: i, task: task));
      i++;
      textcontroller.clear();
    });
    updateList(searchController.text);
    saveTasks();
  }

  void removetask(int id) {
    setState(() {
      tasklist.removeWhere((task) => task.id == id);
    });
    updateList(searchController.text);
    saveTasks();
  }

  void updateList(String s) {
    setState(() {
      if (s.isEmpty) {
        updatedList = tasklist;
      } else {
        updatedList =
            tasklist
                .where(
                  (item) => item.task.toLowerCase().contains(s.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void togglestatus(int id) {
    setState(() {
      Task t = tasklist.firstWhere((item) => item.id == id);
      t.isDone = !t.isDone;
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TODO APP",
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 101, 183),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: updateList,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child:
                    updatedList.isEmpty
                        ? Center(child: Text("No task allotted"))
                        : (() {
                          display = 1;
                          return ListView.builder(
                            itemCount: updatedList.length,
                            itemBuilder: (context, index) {
                              final task = updatedList[index];
                              return Card(
                                child: ListTile(
                                  leading: Checkbox(
                                    value: task.isDone,
                                    onChanged: (_) => togglestatus(task.id),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("${display++}"),
                                      Text(task.task),
                                      ElevatedButton(
                                        onPressed: () {
                                          removetask(task.id);
                                        },
                                        child: Text("Remove"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        })(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 174, 255),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: textcontroller,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter task',
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(8),
                      shadowColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 0, 0, 0),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 187, 248, 117),
                      ),
                    ),
                    onPressed: () {
                      addtask(textcontroller.text, i);
                    },
                    child: Text(
                      "ADD TODO",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

















































// import 'package:flutter/material.dart';

// class Todocontainer extends StatefulWidget {
//   const Todocontainer({super.key});

//   @override
//   State<Todocontainer> createState() => _TodocontainerState();
// }

// class Task {
//   int id = 0;
//   String task = "";
//   bool isDone;
//   Task({required this.id, required this.task, this.isDone = false});
// }

// class _TodocontainerState extends State<Todocontainer> {
//   List<Task> tasklist = [];
//   List<Task> updatedList = [];
//   TextEditingController textcontroller = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   int i = 1, display = 1;

//   addtask(String task, int id) {
//     if (task.isEmpty) return;
//     setState(() {
//       tasklist.add(Task(id: i, task: task));
//       i++;
//       textcontroller.clear();
//     });
//     updateList(searchController.text);
//   }

//   removetask(int id) {
//     setState(() {
//       tasklist.removeWhere((task) => task.id == id);
//       updateList(searchController.text);
//     });
//   }

//   updateList(String s) {
//     setState(() {
//       if (s.isEmpty) {
//         updatedList = tasklist;
//       } else {
//         updatedList =
//             tasklist
//                 .where(
//                   (item) => item.task.toLowerCase().contains(s.toLowerCase()),
//                 )
//                 .toList();
//       }
//     });
//   }

//   togglestatus(int id) {
//     setState(() {
//       Task t = tasklist.firstWhere((item) => item.id == id);
//       t.isDone = !t.isDone;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "TODO APP",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 36,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 0, 101, 183),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   labelText: 'Search...',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(Icons.search),
//                 ),
//                 onChanged: updateList,
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child:
//                     updatedList.isEmpty
//                         ? Center(child: Text("No task allotted"))
//                         : (() {
//                           display = 1; // 🔄 Reset before building list
//                           return ListView.builder(
//                             itemCount: updatedList.length,
//                             itemBuilder: (context, index) {
//                               final task = updatedList[index];
//                               return Card(
//                                 child: ListTile(
//                                   leading: Checkbox(
//                                     value: task.isDone,
//                                     onChanged:
//                                         (_) => togglestatus(
//                                           task.id,
//                                         ), // ✅ Fix here too
//                                   ),
//                                   title: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Text("${display++}"),
//                                       Text(task.task),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           removetask(task.id);
//                                         },
//                                         child: Text("Remove"),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         })(),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 75, 174, 255),
//               ),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: textcontroller,
//                     style: TextStyle(
//                       color: const Color.fromARGB(255, 0, 0, 0),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 20,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Enter task',
//                       contentPadding: EdgeInsets.all(12),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       elevation: WidgetStatePropertyAll(8),
//                       shadowColor: WidgetStatePropertyAll(
//                         const Color.fromARGB(255, 0, 0, 0),
//                       ),
//                       backgroundColor: WidgetStatePropertyAll(
//                         const Color.fromARGB(255, 187, 248, 117),
//                       ),
//                     ),
//                     onPressed: () {
//                       addtask(textcontroller.text, i);
//                     },
//                     child: Text(
//                       "ADD TODO",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }