import 'dart:convert';
import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/intro_page.dart';
import 'package:experiences_project/widgets/dialogue_box_video_rec.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:experiences_project/widgets/video_preview.dart';

class AddYoursPage extends StatefulWidget {
  const AddYoursPage({super.key});

  @override
  State<AddYoursPage> createState() => _AddYoursPageState();
}

class _AddYoursPageState extends State<AddYoursPage> {
  final _formKey = GlobalKey<FormState>();
  String? age;
  String? experienceCategory;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController meditatingExperienceController =
      TextEditingController();
  final TextEditingController experienceDescriptionController =
      TextEditingController();
  File? selectedVideoFile;
  late SharedPreferences prefs;

  VideoPlayerController? videoPlayerController;

  void _showUploadRecordOption() async {
    final result = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return const UploadRecordOption();
      },
    );

    if (result != null) {
      setState(() {
        selectedVideoFile = result;
      });
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    if (selectedVideoFile != null) {
      videoPlayerController?.dispose();
      videoPlayerController = VideoPlayerController.file(selectedVideoFile!)
        ..initialize().then((_) {
          setState(() {});
          videoPlayerController?.play();
          // videoPlayerController?.pause();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tell Your Tale",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          centerTitle: true,
          backgroundColor: Pallete.appBar,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFormField('Name',
                        _buildNameInput(nameController, 'Enter your name')),
                    _buildFormField(
                        'Email',
                        _buildEmailInput(
                            emailController, 'Enter registered email')),
                    _buildFormField('Age', _buildAgeDropdown()),
                    _buildFormField(
                        'Country',
                        _buildTextInput(
                            countryController, 'Enter your country')),
                    _buildFormField(
                        'Profession',
                        _buildTextInput(
                            professionController, 'Enter your profession')),
                    _buildFormField(
                        'Meditating Experience',
                        _buildTextInput(meditatingExperienceController,
                            'Eg: 2.3 years or 6 months')),
                    _buildFormField('Experience Category',
                        _buildExperienceCategoryDropdown()),
                    _buildFormField('Video', _buildVideoUploads()),
                    _buildFormField(
                        'Experience Description',
                        _buildTextArea(experienceDescriptionController,
                            'Few lines about your experience')),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget input) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          input,
        ],
      ),
    );
  }

  Widget _buildNameInput(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter your name' : null,
    );
  }

  Widget _buildEmailInput(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter your email' : null,
    );
  }

  Widget _buildAgeDropdown() {
    return DropdownButtonFormField<String>(
      value: age,
      isExpanded: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      hint: const Text('Select your age range'),
      items: <String>['below 15', '16-30', '31-45', '46-60', 'above 60']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          age = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select an age range' : null,
    );
  }

  Widget _buildTextInput(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter a value' : null,
    );
  }

  Widget _buildExperienceCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: experienceCategory,
      isExpanded: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      hint: const Text('Select your experience category'),
      items: <String>[
        'Mental Health',
        'Physical Health',
        'Manifestations',
        'Miracles',
        'Healing',
        'Visions',
        'Messages Received',
        'Meta Physical Experiences',
        'Other Experiences'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          experienceCategory = newValue;
        });
      },
      validator: (value) =>
          value == null ? 'Please select an experience category' : null,
    );
  }

  Widget _buildVideoUploads() {
    return GestureDetector(
      onTap: _showUploadRecordOption,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.camera),
                SizedBox(width: 8.0),
                Text("Upload or Record a Video",
                    style: TextStyle(
                      fontSize: 14,
                    )),
              ],
            ),
            if (selectedVideoFile != null && videoPlayerController != null)
              AspectRatio(
                aspectRatio: videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(videoPlayerController!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter a description' : null,
    );
  }

//initialising SharedPreferences in init state
  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // we can make use of this instance 'prefs' to store the data in SharedPreference
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    initSharedPref();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedVideoFile != null) {
      try {
        debugPrint('Attempting submission');
      final nonNullableAge = age ?? ''; //  meaning of ??-null-coalescing operator
      final nonNullableExperienceCategory = experienceCategory ?? '';

      // a value of type string can't be assigned to the variable of type string error while directly assigning request.fields['age'] = age 
      //due to attempting to assign nullable types (String?) to non-nullable variables (String). Need to ensure that these values are non-null before assigning them to request.fields.

        // Create a MultipartRequest , since File obj can't be converted directly into json
        var request = http.MultipartRequest('POST', Uri.parse(addYours));

        // Add text fields
        request.fields['name'] = nameController.text;
        request.fields['email'] = emailController.text;
        request.fields['age'] = nonNullableAge;
        request.fields['profession'] = professionController.text;
        request.fields['country'] = countryController.text;
        request.fields['meditating_experience'] =
            meditatingExperienceController.text;
        request.fields['exp_category'] = nonNullableExperienceCategory;
        request.fields['exp_desc'] = experienceDescriptionController.text;

//Determining correct MIME type for the video file
final mimeType = lookupMimeType(selectedVideoFile!.path)?? 'video/webm';

        // Add the video file
        var videoStream = http.ByteStream(selectedVideoFile!.openRead());
        var videoLength = await selectedVideoFile!.length();
        var videoMultipartFile = http.MultipartFile(
            'video', videoStream, videoLength,
            filename: selectedVideoFile!.path.split('/').last,
            contentType:MediaType.parse(mimeType));
            
        request.files.add(videoMultipartFile);

        // Send the request
        var streamedResponse =
            await request.send().timeout(const Duration(seconds: 120));
        var response = await http.Response.fromStream(streamedResponse);

        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          if (!mounted) return;
          if (jsonResponse['success'] == true) {
            
            var myToken = jsonResponse['tokenValue'];
            prefs.setString('tokenValue', myToken);

            debugPrint('Response body: $jsonResponse');
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Thankyou for sharing!'),
            ));

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const IntroPage()));
          } else {
            debugPrint('Submission failed: ${jsonResponse['message']}');
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Submission failed. Please try again.'),
            ));
          }
        } else {
          throw Exception(
              'Server responded with status code: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint("Error during submission $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('An error occurred during submission. Please try again.'),
        ));
      }

      // Debug prints
      debugPrint('Name: ${nameController.text}');
      debugPrint('Email: ${emailController.text}');
      debugPrint('Age: $age');
      debugPrint('Country: ${countryController.text}');
      debugPrint('Profession: ${professionController.text}');
      debugPrint(
          'Meditating Experience: ${meditatingExperienceController.text}');
      debugPrint('Experience Category: $experienceCategory');
      debugPrint(
          'Experience Description: ${experienceDescriptionController.text}');
      debugPrint("Video: $selectedVideoFile");
    }
  }
}
