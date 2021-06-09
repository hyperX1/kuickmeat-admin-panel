import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kuickmeat_admin_app/services/firebase_services.dart';
import 'package:kuickmeat_admin_app/widgets/vendor/vendor_details_box.dart';
class VendorDataTable extends StatefulWidget {
  @override
  _VendorDataTableState createState() => _VendorDataTableState();
}

class _VendorDataTableState extends State<VendorDataTable> {

  FirebaseServices _services = FirebaseServices();

  int tag = 0;
  List<String> options = [
    'All Vendors', //0
    'Active Vendors', //1
    'Inactive Vendors', //2
    'Top Picked', //3
    'Top Rated', //4
  ];

  bool topPicked;
  bool active;

  filter(val){
    if(val==1){
      setState(() {
        active =true;
      });
    }
    if(val==2){
      setState(() {
        active =false;
      });
    }
    if(val==3){
      setState(() {
        topPicked =true;
      });
    }
    if(val==0){
      setState(() {
        topPicked =null;
        active = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val){
            setState(() {
              tag = val;
            });
            filter(val);
          },
          choiceItems: C2Choice.listFrom<int, String>(
            activeStyle: (i,v){
              return C2ChoiceStyle(
                brightness: Brightness.dark,
                color: Colors.black54,
              );
            },
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        Divider(thickness: 5,),
        StreamBuilder(
            stream: _services.vendors.where('isTopPicked',isEqualTo: topPicked)
                .where('accVerified',isEqualTo: active)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showBottomBorder: true,
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  //table header
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Active / Inactive',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Top Picked',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Shop Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Rating',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total Sales',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Mobile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'View Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  //details
                  rows: _vendorDetailsRows(snapshot.data, _services),
                ),
              );
            }),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          IconButton(
            onPressed: () {
              services.updateVendorStatus(
                  id: document.data()['uid'],
                  status: document.data()['accVerified']);
            },
            icon: document.data()['accVerified']
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              services.updateTopPicked(
                  id: document.data()['uid'],
                  status: document.data()['isTopPicked']);
            },
            icon: document.data()['isTopPicked']
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.remove_circle,
              color: Colors.red,
                  ),
          ),
        ),
        DataCell(
          Text(document.data()['shopName']),
        ),
        DataCell(Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.grey,
            ),
            Text('3.5'),
          ],
        )),
        DataCell(
          Text('20,000'),
        ),
        DataCell(
          Text(document.data()['mobile']),
        ),
        DataCell(
          Text(document.data()['email']),
        ),
        DataCell(IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            //will popup vendor details screen
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return VendorDetailsBox(document.data()['uid']);
            }
            );
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
