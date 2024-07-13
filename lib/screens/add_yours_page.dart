import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/widgets/dialogue_box_video_rec.dart';
import 'package:flutter/material.dart';

class AddYoursPage extends StatefulWidget {
  const AddYoursPage({super.key});

  @override
  State<AddYoursPage> createState() => _AddYoursPageState();
}

class _AddYoursPageState extends State<AddYoursPage> {
  final _formKey = GlobalKey<FormState>();
  String? age;
  String? experienceCategory;
  final TextEditingController countryController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController meditatingExperienceController =
      TextEditingController();
  final TextEditingController experienceDescriptionController =
      TextEditingController();

  void _showUploadRecordOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const UploadRecordOption();
      },
    );
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
            child: const Row(
              children: [
                Icon(Icons.camera),
                SizedBox(width: 8.0),
                Text("Upload or Record a Video"),
              ],
            )));
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the form data to your backend
      // For now, we'll just print the values
      debugPrint('Age: $age');
      debugPrint('Country: ${countryController.text}');
      debugPrint('Profession: ${professionController.text}');
      debugPrint(
          'Meditating Experience: ${meditatingExperienceController.text}');
      debugPrint('Experience Category: $experienceCategory');
      debugPrint(
          'Experience Description: ${experienceDescriptionController.text}');
    }
  }
}
