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

### Shared Preference

- to store the user token in the application itself we make use of state preference, if the response is successful
  
- in pubspec.yaml file make use of the package shared_preference  
- initialize the shared preference in necessary places for the usage
- In login_page.dart `late SharedPreferences` prefs -prefs can be any name
  
```dart
class _SignUpPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

//initialising SharedPreferences in init state
  @override
  void initState() {
    // implement initState
    super.initState();
    initSharedPref();
  }

//func to initialise our shared_preference

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // we can make use of this instance 'prefs' to store the data in SharedPreference
  }
}
```

**diff b/w button and elevated btn lrn  
**

`late html.VideoElement _preview;`  

### late

- The late keyword in Dart is used to declare a non-nullable variable that will be initialized later before it is used. This is useful for variables that cannot be immediately initialized in the constructor but are guaranteed to be initialized before any use  

### html.VideoElement

- html.VideoElement is a type from the dart:html library, which provides HTML elements for web applications. VideoElement specifically represents the HTML `<video>` element, which is used to embed video content on web pages

##### Variable Declaration:

- _preview is a variable that will hold an instance of html.VideoElement. This element can be used to create a video preview within a web context

##### Display recording result

- In the last step, we want to display the recording result. Here we use VideoElement again with control to play the video. While recording, we can get **Blob** data, which we need to save while recording. When it’s finished, we should set the URL into our result’s VideoElement  
  