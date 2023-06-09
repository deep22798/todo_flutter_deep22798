import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
class todo extends StatefulWidget {
  const todo({Key? key}) : super(key: key);

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {



  final FocusNode _focusNode = FocusNode();
  List<String> todo=[];
  List<String> filteredList = [];


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    // print(object)
  }
  void filterList(String searchTerm) {
    // Filter the list based on the search term
    setState(() {
      filteredList = todo
          .where((item) => item.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController updateController = TextEditingController();
  Future<void> addItemToList()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todo.add(nameController.text);
      // msgCount.insert(0, 0);
      nameController.clear();
      print(todo);
    });
    await prefs.setStringList('items', todo);
  }  Future<void> load()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      todo=prefs.getStringList('items')!;
    });
  }
  void deleteItemToList(int index)async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todo.removeAt(index);
      // msgCount.insert(0, 0);
      print(todo);
    });
    await prefs.setStringList('items', todo);
  }

  void updatelistItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedItem = todo[index];
        return AlertDialog(
          title: Text('Update todo'),
          content: TextField(

            decoration: InputDecoration(
              focusedBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
              labelText: 'enter the updated text',labelStyle: TextStyle(color: Colors.teal),
              border: OutlineInputBorder(

              ),
            ),
            controller: updateController,
            onChanged: (value) {
              updatedItem = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update',style: TextStyle(color: Colors.teal),),
              onPressed: () async{
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  todo[index] = updatedItem;
                });
                await prefs.setStringList('items', todo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Center(child: Text("TodoList",style: TextStyle(color: Colors.teal,fontSize: 25,fontWeight: FontWeight.bold),)),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Column(
              children: [
                Lottie.asset("assets/splash.json",height: 100),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    autofocus: false,

                    controller: nameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.teal),
                      hintStyle: TextStyle(color: Colors.teal),
                      suffixIcon: Icon(Icons.title,color: Colors.teal,),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.teal
                          )
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    minWidth: 150,
                    color: Colors.teal,
                    child: Text('Add',style: TextStyle(fontSize: 14,color: Colors.white),),
                    onPressed: () {
                      if(nameController.value.text.isNotEmpty){
                        addItemToList();
                      }else{
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          content: Text("Please enter todo"),
                          title: Text("Field is empty"),
                          actions: [
                            MaterialButton(

                                onPressed: (){Navigator.pop(context);},child: Text("ok",style: TextStyle(color: Colors.teal),),)
                          ],
                        ));}

                    },
                  ),
                ),
                Align(alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20,bottom: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Total: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${todo.length}"),
                        ],
                      )),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context,index){
                  final reversedIndex = todo.length - index - 1;
                return Card(
                  color: Colors.teal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(

                          child: Center(child: Align(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(todo[reversedIndex],style: TextStyle(color: Colors.white,fontSize: 18)),
                            ),alignment: Alignment.centerLeft,)),width: 250,),
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              nameController.clear();
                              setState(() {
                                updateController.text=todo[reversedIndex];
                              });
                              updatelistItem(reversedIndex);
                            }, icon: Icon(Icons.edit,color: Colors.white,),),
                            IconButton(onPressed: (){
                              deleteItemToList(reversedIndex);
                            }, icon: Icon(Icons.delete,color: Colors.red
                              ,),)
                          ],
                        ),
                      ],
                    )
                );
              },
                itemCount: todo.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
