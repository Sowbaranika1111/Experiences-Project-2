import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:expandable/expandable.dart';

class ExpDisplayField extends StatefulWidget {
  const ExpDisplayField({super.key});

  @override
  ExpDisplayFieldState createState() => ExpDisplayFieldState();
}

class ExpandableTextWidget extends StatelessWidget {
  final String text;

  const ExpandableTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 14,
            color: Pallete.fontColorExpDesc,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        final isTextOverflowing = textPainter.didExceedMaxLines;

        if (isTextOverflowing) {
          return ExpandableNotifier(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expandable(
                  collapsed: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Pallete.fontColorExpDesc,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Pallete.fontColorExpDesc,
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    var controller =
                        ExpandableController.of(context, required: true)!;
                    return TextButton(
                      child: Text(
                        controller.expanded ? "Show less" : "Read more",
                        style: const TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        controller.toggle();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Pallete.fontColorExpDesc,
            ),
          );
        }
      },
    );
  }
}

class ExpDisplayFieldState extends State<ExpDisplayField> {
  String displayText = 'Fetching...';
  List<dynamic> listResponse = [];
  final List<ChewieController> _chewieControllers = [];
  final Map<String, int> idToIndexMap = {};
  bool isLoading = false;
  int currentPage = 1;
  final int itemsPerPage = 5;
  bool hasMore = true;

  Future<void> expSubmitApiCall() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint("Attempting Fetching! Page: $currentPage");
      var response = await http
          .get(Uri.parse('$getExp?page=$currentPage&limit=$itemsPerPage'));

      if (response.statusCode == 200) {
        debugPrint("Data fetched successfully: ${response.body}");

        try {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['data'] != null &&
              jsonResponse['data'] is List &&
              (jsonResponse['data'] as List).isNotEmpty) {
            var newData = jsonResponse['data'] as List;
            setState(() {
              listResponse.addAll(newData.cast<Map<String, dynamic>>());
              for (int i = 0; i < newData.length; i++) {
                var id = newData[i]['_id']?.toString() ?? '';
                idToIndexMap[id] = listResponse.length - newData.length + i;
              }
              currentPage++;
              hasMore = newData.length == itemsPerPage;
            });
            await _initializeVideoControllers(
                newData.cast<Map<String, dynamic>>());
          } else {
            hasMore = false;
            if (listResponse.isEmpty) {
              setState(() {
                displayText = "No data available";
              });
            }
          }
        } catch (e) {
          debugPrint("Error parsing JSON: $e");
          setState(() {
            displayText = "Error parsing data: $e";
          });
        }
      } else {
        debugPrint("Failed to fetch data. Status code: ${response.statusCode}");
        setState(() {
          displayText =
              "Failed to load data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error in fetching: $e");
      setState(() {
        displayText = "Error in fetching data: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initializeVideoControllers(List<dynamic> newItems) async {
    for (var item in newItems) {
      if (item['video'] != null && item['video'].isNotEmpty) {
        final videoUrl = '$videoBaseUrl${item['video']}';
        debugPrint("Initializing video: $videoUrl");
        try {
          final videoPlayerController =
              VideoPlayerController.networkUrl(Uri.parse(videoUrl));
          await videoPlayerController.initialize();

          final chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            looping: true,
            aspectRatio: 18 / 15,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          );

          setState(() {
            _chewieControllers.add(chewieController);
          });
          debugPrint("Video initialized: ${item['video']}");
        } catch (error) {
          debugPrint("Error initializing video: $error");
        }
      } else {
        debugPrint("Invalid video key for item: $item");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    expSubmitApiCall();
  }

  @override
  void dispose() {
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> containerColors = [
      Colors.blue.withOpacity(0.1),
      Colors.green.withOpacity(0.1),
      Colors.purple.withOpacity(0.1),
    ];

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: listResponse.isEmpty
          ? Center(
              child: Text(displayText,
                  style: const TextStyle(color: Colors.black)))
          : ListView.builder(
              itemCount: listResponse.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == listResponse.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: expSubmitApiCall,
                              child: const Text('Load More'),
                            ),
                    ),
                  );
                }

                final item = listResponse[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: containerColors[index % containerColors.length],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index < _chewieControllers.length)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: AspectRatio(
                            aspectRatio: 18 / 18,
                            child:
                                Chewie(controller: _chewieControllers[index]),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '~${item['exp_category'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Pallete.fontColorExpDesc,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '~${item['name'] ?? 'Anonymous'}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Pallete.fontColorExpDesc,
                                        ),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item['profession'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Pallete.fontColorExpDesc,
                                        ),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ExpandableTextWidget(
                              text: item['exp_desc'] ??
                                  'No description available',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
