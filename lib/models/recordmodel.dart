import 'dart:convert';

Record recordFromJson(String str) => Record.fromJson(json.decode(str));

String recordToJson(Record data) => json.encode(data.toJson());

class Record {
  Record({
    required this.id,
    required this.name,
    required this.guardian,
    required this.teacher,
    required this.age,
  });

   int id;
  String name;
  String guardian;
  String teacher;
  String age;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        guardian: json["guardian"] == null ? null : json["guardian"],
        teacher: json["teacher"] == null ? null : json["teacher"],
        age: json["age"] == null ? null : json["age"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id.toString(),
        "name": name == null ? null : name,
        "guardian": guardian == null ? null : guardian,
        "teacher": teacher == null ? null : teacher,
        "age": age == null ? null : age,
      };
}
