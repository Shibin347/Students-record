import 'package:flutter/material.dart';
import 'package:flutterproject1/helpers/database_helper.dart';
import 'package:flutterproject1/models/recordmodel.dart';
import 'package:flutterproject1/screens/add_task_screen.dart';

class StudentsRecordScreen extends StatefulWidget {
  @override
  _StudentsRecordScreenState createState() => _StudentsRecordScreenState();
}

class _StudentsRecordScreenState extends State<StudentsRecordScreen> {
  List<Record> _recordList = [];

  bool searchOn = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    _recordList = await DatabaseHelper.instance.getRecordList();
    setState(() {});
  }

  void searchOnOff() {
    searchOn = !searchOn;
    if (searchOn) fetchData();
    setState(() {});
  }

  Future<void> searchQuery(String text) async {
    _recordList = await DatabaseHelper.instance.search(text);
    setState(() {});
  }

  Widget _buildRecord(Record record) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Name: ${record.name.toUpperCase()} ${record.guardian.toUpperCase()}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            '\n\nGuardian: ${record.guardian.toUpperCase()}, \n\nTeacher: ${record.teacher.toUpperCase()}, \n\nAge: ${record.age}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddRecordScreen(record: record),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    AlertDialog alert = AlertDialog(
                      title: Text("Are You Sure"),
                      content: Text(
                          "Do you want to delete the data of the student;"),
                      actions: [
                        ElevatedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                            child: Text("Delete"),
                            onPressed: () {
                              DatabaseHelper.instance
                                  .deleteRecord(record.id)
                                  .whenComplete(() => fetchData());
                              Navigator.pop(context);
                            }),
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }),
            ],
          ),
        ),
        Divider(
          thickness: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students Records',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                searchOnOff();
              },
              icon: Icon(searchOn ? Icons.clear : Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              if (searchOn)
                TextField(
                    onChanged: (String text) => searchQuery(text),
                    decoration: InputDecoration(hintText: "Search")),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _recordList.isEmpty
                          ? Center(
                              child: Text(
                              "No Records",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ))
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _recordList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildRecord(_recordList[index]);
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddRecordScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
