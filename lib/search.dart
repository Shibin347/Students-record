import 'package:flutter/material.dart';

class NameSearch extends SearchDelegate<String>{

  final List<String> name;
  NameSearch(this.name);

  @override
  List<Widget> buildActions(BuildContext context) {
   return [
     IconButton(
         onPressed: (){
         },
         icon: Icon(Icons.clear),
     ),
   ];
   
  }

  @override
  Widget buildLeading(BuildContext context) {
  return IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios)
  );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = name.where((record){
      return record.toLowerCase().contains(query.toLowerCase());
    });
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder:(BuildContext context, int index){
          return ListTile(
            title: Text(suggestions.elementAt(index)),
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = name.where((record){
     return record.toLowerCase().contains(query.toLowerCase());
   });
    return ListView.builder(
      itemCount: suggestions.length,
        itemBuilder:(BuildContext context, int index){
        return ListTile(
          title: Text(suggestions.elementAt(index)),
        );
        }
    );
  }

}