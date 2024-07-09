# experiences_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Run  

- **.\scrcpy**
- full path **PS E:\android_mirroring_app\scrcpy-win64-v2.5> .\scrcpy**

### BuildContext

- telling the location of the pages in the entire widget tree
- Every widget we extend by a stless or stateful widget (text,center,etc,..) will have access to build context bcz flutter wants to know it's loction  
- in the entire widget tree , build context tells the location of a particular widget (where the widget is built) in the entire widget tree  
- to tell flutter where to perform navigation  

### Navigation  

- to change the page in flutter we use navigator  
- A common way to add navigation menus to our apps is using a drawer  
- Navigator is based on a stack ,, when u push() it goes on top, when u pop() the thing on top gets popped  
- **LIFO** - Last In First Out data structure type

- for navigation we use named routes , it allows us to define all the     navigation in a single place when we create material app  
- in **main.dart file define the routes parameter** ,it takes a map, which is a group of keys and values  
- keys are strings with the name of the routes and the values are the builders that call a specific page  
- after setting the routes in the main.dart file , set ontap function in intro_page.dart  
