import 'package:final_project/model//theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


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
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar: myAppBar('Final Project'),
        drawer: navDrawer(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Icon(Icons.verified_user, size: 50, color: Theme.of(context).primaryColor,),
                const SizedBox(height: 50),
                Text(
                  'Вы успешно авторизированы!',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: const [
                    Expanded(child: SizedBox(height: 20)),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: (){
                        _userStoredName ='';
                        _userStoredPass ='';
                        _saveUserData();
                        setState(() {});
                      },
                      child: const Text('Выход')
                  ),
                )
              ],
            ),
          ),
        ),

      );
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Icon(Icons.account_balance, size: 50, color: Theme.of(context).primaryColor,),
                  const SizedBox(height: 50),
                  Text(
                    'Введите логин\nв виде 10 цифр номера телефона',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: userController,
                          keyboardType: TextInputType.phone,
                          decoration: textFieldDecoration('Телефон', context),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Обязательное поле';
                            } else if (value.length !=10){
                              return 'Введите ровно 10 цифр';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: textFieldDecoration('Пароль', context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Обязательное поле';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: SizedBox()
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            _userStoredName = userController.text;
                            _userStoredPass = passController.text;
                            if (_checkAuthorization()) {
                              _saveUserData();
                            } else {
                              _userStoredName = '';
                              _userStoredPass = '';
                              _saveUserData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Доступ запрещен! Введите корректно логин и пароль.'), duration: Duration(seconds: 2)),
                              );
                            }
                          }
                          setState(() {});
                        },
                        child: const Text('Вход')
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Демо-доступ:'),
                  Text('Тел: ${'9008007000'}'),
                  Text('Пароль: ${'root'}'),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}