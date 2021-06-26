import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kuickmeat_admin_app/screens/manage_banners.dart';
import 'package:kuickmeat_admin_app/services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final _formKey=GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Colors.redAccent.shade200.withOpacity(.1),
        animationDuration: Duration(milliseconds: 500));

    _login({username, password}) async {
      progressDialog.show();
      _services.getAdminCredentials(username).then((value) async {
        if(value.exists){
          if(value.data()['username']==username){
            if(value.data()['password']==password){
              //if both is correct, will login
              try{
                UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                if(userCredential!=null){
                  //if signin success, will navigate to Banner Screen
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, BannerScreen.id);
                }

              }catch(e){
                //if signing failed
                progressDialog.dismiss();
                _services.showMyDialog(
                  context: context,
                  title: 'Login',
                  message: '${e.toString()}',
                );
              }

              return;
            }
            //if password is incorrect
            progressDialog.dismiss();
            _services.showMyDialog(
                context: context,
                title: 'Incorrect Password',
                message: 'Password you have entered is invalid, try again'
            );
            return;
          }
          //if username is incorrect
          progressDialog.dismiss();
          _services.showMyDialog(
              context: context,
            title: 'Invalid Username',
            message: 'Username you have entered is incorrect, try again'
          );
        }
        progressDialog.dismiss();
        _services.showMyDialog(
            context: context,
            title: 'Invalid Username',
            message: 'Username you have entered is incorrect, try again'
        );
      });
    }

    return Scaffold(

      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
              child: Text('Connection Failed'),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent.shade200,
                    Colors.white,
                  ],
                  stops: [1.0,1.0],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0,0.0),
                ),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 450,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.red,width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                              children: [
                                Container(child: Image.asset('images/logo.png',height: 220,width: 220,)),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _usernameTextController,
                                        validator: (value){
                                          if(value.isEmpty){
                                            return 'Enter Username';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                                          hintText: 'Username',
                                          focusColor: Theme.of(context).primaryColor,
                                          contentPadding: EdgeInsets.only(left: 20,right: 20),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context).primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        validator: (value){
                                          if(value.isEmpty){
                                            return 'Enter Password';
                                          }
                                          if(value.length<6){
                                            return 'Minimum 6 characters required';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.vpn_key_sharp,color: Theme.of(context).primaryColor,),
                                          hintText: 'Minimum 6 characters required',
                                          focusColor: Theme.of(context).primaryColor,
                                          contentPadding: EdgeInsets.only(left: 20,right: 20),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context).primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () async {
                                            if(_formKey.currentState.validate()){
                                              _login(
                                                username: _usernameTextController.text,
                                                password: _passwordTextController.text,
                                              );
                                            }
                                          },
                                          child: Text('Login',style: TextStyle(color: Colors.white),),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),),
                    ),
                  ),
                ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

}