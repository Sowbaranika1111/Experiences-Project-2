import 'package:flutter/material.dart';
import 'package:experiences_project/pallete.dart';
import '../shared/menu_drawer.dart';

class CategoryScrollingSection extends StatelessWidget {
  const CategoryScrollingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Container(
        color: Pallete.backgroundColorLoginPg,
        child: Column(
          children: [
            // Horizontal scrolling images
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleImageWithText(
                      'assets/exp_1_mental_health_img.jpg', 'Mental Health'),
                  _buildCircleImageWithText(
                      'assets/exp_2_physical_health_img.jpg',
                      'Physical Health'),
                  _buildCircleImageWithText(
                      'assets/exp_3_manifestations_img.webp', 'Manifestations'),
                  _buildCircleImageWithText(
                      'assets/exp_4_miracles_img.webp', 'Miracles'),
                  _buildCircleImageWithText(
                      'assets/exp_5_healing_img.png', 'Healing'),
                  _buildCircleImageWithText(
                      'assets/exp_6_visions_img.jpg', 'Visions'),
                  _buildCircleImageWithText(
                      'assets/exp_7_msgs_received_img.png',
                      'Messages Received'),
                  _buildCircleImageWithText(
                      'assets/exp_8_meta_physical_subjects_img.jpg',
                      'Meta Physical Experiences'),
                  _buildCircleImageWithText(
                      'assets/exp_9_other_exp_img.png', 'Other Experiences'),
                ],
              ),
            ),
            // Centered text box
          ],
        ),
      ),
    );
  }

  Widget _buildCircleImageWithText(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0), // Adjust padding as needed
            child: ClipOval(
              child: Image.asset(
                imagePath,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: 100.0,
            height: 50.0, // Increased width for better text fit
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              // overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
