import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp( MaterialApp(
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('accessed');
      var contacts = await ContactsService.getContacts(withThumbnails: false);
      
    } else if (status.isDenied) {
      print('failed');
      Permission.contacts.request();
    }
  }

  var total=3;
  var contacts = [
    {'name': '김영숙', 'phone': '010-1234-5678'},
    {'name': '홍길동', 'phone': '010-2345-6789'},
    {'name': '피자집', 'phone': '010-3456-7890'}
  ];

  addContact(name, phone) {
    setState(() {
      contacts.add({'name': name, 'phone': phone});
      total++;
    });
  }

  // 이름 순 정렬
  sortContacts() {
    setState(() {
      contacts.sort((a, b) => a['name']!.compareTo(b['name']!));
    });
  }

  addOne() {
    setState(() {
      total++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){showDialog( context: context, builder: (context){
            return DialogUI(addOne : addOne, addContact : addContact);
          },
          );}
      ),
      appBar: AppBar(
        title: Text(total.toString()),
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: sortContacts, // 이름 정렬 버튼
          ),
          IconButton(onPressed: (){ getPermission(); }, icon : Icon(Icons.contacts))
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.person), // 이미지 대신 아이콘
            title: Text(contacts[i]['name']!),
            subtitle: Text(contacts[i]['phone']!), // 전화번호 표시
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  contacts.removeAt(i); // 연락처 삭제
                  total--;
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.phone),
              Icon(Icons.message),
              Icon(Icons.contact_page),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne, this.addContact}) : super(key: key);
  final addOne;
  final addContact;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return AlertDialog(
      title: Text("새 연락처 추가"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "이름"),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "전화번호"),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // 닫기
          },
          child: Text("취소"),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
              addOne();
              addContact(nameController.text, phoneController.text);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                content: Text("値を正しく入力してください。"),
                duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: Text("추가"),
        ),
      ],
    );
  }
}