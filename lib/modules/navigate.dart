import 'package:flutter/cupertino.dart';

// Navigates to the given router page
void navigate(BuildContext context, String routeName, {Object? args}) {
  Navigator.pushNamed(context, routeName, arguments: args);
}

// Extract arguments when navigating
class Arguments {
  late String title;

  void printArgs() => debugPrint("name: $title");

  Arguments(BuildContext context) {
    var data = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;

    title =
        data.containsKey("title") ? data["title"] as String : "Game of Thrones";
  }
}
