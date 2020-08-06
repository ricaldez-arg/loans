import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loans/models/debt/debt.dart';
import 'package:loans/providers/debt/receive_debt_provider.dart';
import 'package:loans/providers/session/loggin_provider.dart';
import 'package:loans/providers/session/session_provider.dart';
import 'package:loans/screens/debt/receive/receive_screen.dart';
import 'package:loans/services/user_service/debt_service.dart';
import 'package:loans/utils/constants.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  customDrawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Text(
              'Loans',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

  userAvatar(context) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              'Username',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        // IconButton(icon: Icon(Icons.account_circle, size: 40,), onPressed: () {})
        PopupMenuButton(
            icon: Icon(
              Icons.account_circle,
              size: 40,
            ),
            elevation: 3.2,
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: 'This is tooltip',
            itemBuilder: (_) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: Colors.grey[600],
                          ),
                          Container(width: 5),
                          Text('Perfil')
                        ],
                      ),
                      value: 'p'),
                  PopupMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.grey[600],
                          ),
                          Container(width: 5),
                          Text('Cerrar session')
                        ],
                      ),
                      value: 'l'),
                ],
            onSelected: (value) {
              if (value == 'l') {
                Provider.of<LoginProvider>(context, listen: false).clear();
                Provider.of<SessionProvider>(context, listen: false).signOut();
              }
            }),
      ],
    );
  }

  makeBody(context) {
    var futureBuilder = FutureBuilder(
        future: DebtService.getDebts(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List data = snapshot.data ?? [];
          return ListView(
            children: data.map<Widget>((entry) {
              return ListTile(
                title: Row(
                  children: <Widget>[
                    Text(entry.creditor),
                    Text(entry.debtor),
                    Text('v/'),
                  ],
                ),
              );
            }).toList(),
          );
        });
    return Center(
      child: futureBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ReceiveDebtProvider>(context, listen: false).loadDebts(context);
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          title: Text('Loans'),
          actions: <Widget>[
            userAvatar(context),
          ],
        ),
        backgroundColor: Colors.grey[300],
        // body: Container(
        //   child: makeBody(context),
        // ),
        body: ReceiveScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, newDebtRoute);
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
