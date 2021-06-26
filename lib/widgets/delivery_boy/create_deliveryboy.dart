import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kuickmeat_admin_app/services/firebase_services.dart';

class CreateNewBoyWidget extends StatefulWidget {
  @override
  _CreateNewBoyWidgetState createState() => _CreateNewBoyWidgetState();
}

class _CreateNewBoyWidgetState extends State<CreateNewBoyWidget> {

  FirebaseServices _services = FirebaseServices();
  bool _visible = false;

  var emailText = TextEditingController();
  var passwordText = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Colors.redAccent.shade200.withOpacity(.1),
        animationDuration: Duration(milliseconds: 500));

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      height: 80,
      child: Row(
        children: [
          Visibility(
            visible: _visible ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                child: FlatButton(
                  child: Text('Create new Delivery Boy',style: TextStyle(color: Colors.white),),
                  onPressed:(){
                    setState(() {
                      _visible = true;
                    });
                  },
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Visibility(
            visible: _visible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          //TODO: Email Validator
                          controller: emailText,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black54,width: 1
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Email ID',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          //TODO: Password Validator
                          controller: passwordText,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black54,width: 1
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      FlatButton(
                        child: Text('Save',style: TextStyle(color: Colors.white),),
                        onPressed:(){
                          if(emailText.text.isEmpty){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Email ID',
                                message: 'Email ID not entered'
                            );
                          }
                          if(passwordText.text.isEmpty){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Password',
                                message: 'Password not entered'
                            );
                          }
                          //minimum 6 characters required for password
                          if(passwordText.text.length<6){
                            return _services.showMyDialog(
                                context: context,
                                title: 'Password',
                                message: 'minimum 6 characters required'
                            );
                          }
                          progressDialog.show();
                          _services.saveDeliveryBoys(emailText.text, passwordText.text).whenComplete((){
                            emailText.clear();
                            passwordText.clear();
                            progressDialog.dismiss();
                            _services.showMyDialog(
                              context: context,
                              title: 'Save Delivery Boy',
                              message: 'Saved Successfully'
                            );
                          });
                        },
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
