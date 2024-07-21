import 'package:flutter/material.dart';
import 'package:experiences_project/pallete.dart';
import 'category_videos_page.dart';

class CategoryScrollingSection extends StatefulWidget {
  const CategoryScrollingSection({super.key});

  @override
  CategoryScrollingSectionState createState() =>
      CategoryScrollingSectionState();
}

class CategoryScrollingSectionState extends State<CategoryScrollingSection> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Pallete.backgroundColorLoginPg,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleImageWithText(
                context, 'assets/all_categories_img.webp', 'All'),
            _buildCircleImageWithText(
                context, 'assets/exp_1_mental_health_img.jpg', 'Mental Health'),
            _buildCircleImageWithText(context,
                'assets/exp_2_physical_health_img.jpg', 'Physical Health'),
            _buildCircleImageWithText(context,
                'assets/exp_3_manifestations_img.webp', 'Manifestations'),
            _buildCircleImageWithText(
                context, 'assets/exp_4_miracles_img.webp', 'Miracles'),
            _buildCircleImageWithText(
                context, 'assets/exp_5_healing_img.png', 'Healing'),
            _buildCircleImageWithText(
                context, 'assets/exp_6_visions_img.jpg', 'Visions'),
            _buildCircleImageWithText(context,
                'assets/exp_7_msgs_received_img.png', 'Messages Received'),
            _buildCircleImageWithText(
                context,
                'assets/exp_8_meta_physical_subjects_img.jpg',
                'Meta Physical Experiences'),
            _buildCircleImageWithText(
                context, 'assets/exp_9_other_exp_img.png', 'Other Experiences'),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleImageWithText(
      BuildContext context, String imagePath, String text) {
    bool isSelected = _selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategory == text) {
            _selectedCategory = 'All';
          } else {
            _selectedCategory = text;
          }
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CategoryVideosPage(category: _selectedCategory)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              width: 100.0,
              height: 50,
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
