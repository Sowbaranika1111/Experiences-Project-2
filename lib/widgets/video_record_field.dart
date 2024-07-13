// import 'package:flutter/material.dart';
// import 'package:universal_html/html.dart' as html;
// import 'dart:ui' as ui;
// import 'package:universal_html/js.dart' as js;

// class VideoRecordField extends StatefulWidget {
//   const VideoRecordField({super.key});

//   @override
//   State<VideoRecordField> createState() => _VideoRecordFieldState();
// }

// class _VideoRecordFieldState extends State<VideoRecordField> {
//   // To make a video preview, use VideoElement from dart:html.
//   late html.VideoElement _preview;

//   // MediaRecorder to start and stop recording;
//   late html.MediaRecorder _recorder; 

//   //to store and display the result
//   late html.VideoElement _result;

//   @override
//   void initState() {
//     super.initState();

//     _preview = html.VideoElement()
//       ..autoplay = true
//       ..muted = true
//       ..width = html.window.innerWidth!
//       ..height = html.window.innerHeight!;

//     // ignore: undefined_prefixed_name
//       ui.platformViewRegistry
//         .registerViewFactory('preview',(int _) => _preview);

//     //to display the recording
//     _result = html.VideoElement()
//       ..autoplay = false
//       ..muted = false
//       ..width = html.window.innerWidth!
//       ..height = html.window.innerHeight!
//       ..controls = true;

//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory('result', (int _) => _result);
//   }

//   void startRecording(html.MediaStream stream){
//     _recorder = html.MediaRecorder(stream);
//     _recorder.start();

//     _recorder.addEventListener('stop', (event){
//       stream.getTracks().forEach((track){
//         if(track.readyState == 'live'){
//           track.stop();
//         }
//       });

//       html.Blob blob = html.Blob([]);

//       _recorder.addEventListener('dataavailable', (event){
//         blob = js.JsObject.fromBrowserObject(event)['data'];
//       },true);

//       _recorder.addEventListener('stop', (event){
//         final url = html.Url.createObjectUrl(blob);
//         _result.src = url;
//       });
//     });
//   }
//   void stopRecording() => _recorder.stop();

//   //?display the recording result


//   Future<html.MediaStream?> _openCamera() async {
//     final html.MediaStream? stream = await html.window.navigator.mediaDevices?.getUserMedia({'video': true , 'audio': true});
//     _preview.srcObject = stream;
//     return stream;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Recording Video",
//       home:  Column(
//         children: [
//           Container(
//             width: 300,
//             height: 200,
//             color: Colors.blue,
//             child: HtmlElementView(
//               key: UniqueKey(),
//               viewType: 'preview',
//             )
//             ),
//             ElevatedButton
//             (onPressed: () async
//             {
//               final html.MediaStream? stream = await _openCamera();
//               startRecording(stream!);
//             }     
//             , child: const Text('Start Reacording')),
//             ElevatedButton(onPressed: ()=>stopRecording(), child:const Text('Stop Recording'),
//             ),
//             Container(
//               width: 300,
//             height: 200,
//             color: Colors.blue,
//             child: HtmlElementView(
//               key: UniqueKey(),
//               viewType: 'result',
//             ),
//             )
//             ]
//             ),
//     );
//   }
// }
