import 'dart:async';
import 'package:final_project/model/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/model/users.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<UserList> futureUserList;
  int _selectedIndex = -1;

  String? _userStoredName;
  String? _userStoredPass;

  bool _checkAuthorization() {
    if ((_userStoredName == '9008007000')&&(_userStoredPass == 'root')) {
      return true;
    }
    return false;
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userStoredName = (prefs.getString('userStoredName') ?? '');
      _userStoredPass = (prefs.getString('userStoredPass') ?? '');
    });
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userStoredName', (_userStoredName ?? ''));
    prefs.setString('userStoredPass', (_userStoredPass ?? ''));
  }


  @override
  void initState() {
    super.initState();
    _loadUserData();
    futureUserList = fetchUserList();
  }


  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar: myAppBar('Final Project'),
        drawer: navDrawer(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FutureBuilder<UserList>(
                future: futureUserList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.items.length,
                      itemBuilder:(BuildContext context, int index) {
                        return Container(
                          height: 50,
                          color: (_selectedIndex == index ?
                          Theme.of(context).primaryColor
                              :(index % 2 == 1 ?
                          Theme.of(context).primaryColor.withOpacity(0.25):
                          Theme.of(context).primaryColor.withOpacity(0.05))),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(snapshot.data!.items[index].id.toString(), style: Theme.of(context).textTheme.bodyText2,)
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(snapshot.data!.items[index].name, style: Theme.of(context).textTheme.bodyText1,)
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(snapshot.data!.items[index].email, style: Theme.of(context).textTheme.caption, textAlign: TextAlign.right,)
                                ),
                              ],
                            ),
                            selected: index == _selectedIndex,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              Navigator.pushNamed(
                                  context,
                                  '/tasks',
                                  arguments: snapshot.data!.items[index].id
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Icon(Icons.verified_user, size: 50, color: Theme.of(context).primaryColor,),
                const SizedBox(height: 50),
                Text(
                  '???????????? ????????????????! ?????????????? ?????????????????? ?????????? ?? ????????????.',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
