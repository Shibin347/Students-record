import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject1/helpers/database_helper.dart';
import 'package:flutterproject1/models/recordmodel.dart';
import 'package:flutterproject1/screens/students_record_screen.dart';

class AddRecordScreen extends StatefulWidget {
  final Record? record;

  AddRecordScreen({this.record});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  static final RegExp guardianRegExp = RegExp('[a-zA-Z]');
  static final RegExp teacherRegExp = RegExp('[a-zA-Z]');
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _guardian = '';
  String _teacher = '';
  String _age = '';

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _name = widget.record!.name.toUpperCase();
      _guardian = widget.record!.guardian;
      _teacher = widget.record!.teacher;
      _age = widget.record!.age;
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_name, $_guardian, $_teacher, $_age');

      Record record = Record(
          name: _name,
          guardian: _guardian,
          teacher: _teacher,
          age: _age,
          id: widget.record?.id ?? DateTime.now().millisecondsSinceEpoch);

      if (widget.record == null) {
        DatabaseHelper.instance.insertRecord(record);
      } else {
        DatabaseHelper.instance.updateRecord(record);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StudentsRecordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Add Record',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Student Name',
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (input) => input!.isEmpty
                                ? 'Enter Student Name'
                                : (nameRegExp.hasMatch(input)
                                    ? null
                                    : 'Enter a Valid Name'),
                            onSaved: (input) => _name = input!,
                            initialValue: _name,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Guardian Name',
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (input) => input!.isEmpty
                                ? 'Enter Guardian Name'
                                : (guardianRegExp.hasMatch(input)
                                    ? null
                                    : 'Enter a Valid Name'),
                            onSaved: (input) => _guardian = input!,
                            initialValue: _guardian,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Teacher Name',
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (input) => input!.isEmpty
                                ? 'Enter Teacher Name'
                                : (teacherRegExp.hasMatch(input)
                                    ? null
                                    : 'Enter a Valid Name'),
                            onSaved: (input) => _teacher = input!,
                            initialValue: _teacher,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? 'Please enter the age of the student'
                                : null,
                            onSaved: (input) => _age = input!,
                            initialValue: _age,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            child: Text(
                              widget.record == null ? "Save" : "Update",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: _submit,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
