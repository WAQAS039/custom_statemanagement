import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      routes: {
        '/new_contact':(context)=>const NewContactView()
      },
    );
  }
}
class Contact{
  final String id;
  final String name;
  Contact({required this.name}) : id = const Uuid().v4();
}
class ContactBook extends ValueNotifier<List<Contact>>{
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _share = ContactBook._sharedInstance();
  factory ContactBook()=> _share;
  final List<Contact> _contact = [];
  int get length => value.length;
  void add({required Contact contact}){
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
    // value.add(contact);
    // notifyListeners();
  }
  void remove({required Contact contact}){
    final contacts = value;
    if(contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact? getContact({required int atIndex}) => value.length > atIndex ? value[atIndex]:null;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (BuildContext context, value, Widget? child) {
          final List<Contact> contact = value;
          return ListView.builder(
              itemCount: contact.length,
              itemBuilder: (context,index){
                final item = contact[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  onDismissed: (direction){
                    // contact.remove(item);
                    ContactBook().remove(contact: item);
                  },
                  child: Material(
                    color: Colors.white,
                    elevation: 6.0,
                    child: ListTile(
                      title: Text(item!.name),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          Navigator.of(context).pushNamed('/new_contact');
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter a new Contact Name Here...."
            ),
          ),
          TextButton(onPressed: (){
            final contact = Contact(name: _controller.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
          }, child: const Text("Add Contact"))
        ],
      ),
    );
  }
}

