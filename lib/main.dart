import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Viewer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MediaViewerPage(),
    );
  }
}

class MediaViewerPage extends StatefulWidget {
  @override
  _MediaViewerPageState createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late VideoPlayerController _assetVideoController;
  late VideoPlayerController _networkVideoController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi video dari asset
    _assetVideoController =
        VideoPlayerController.asset('assets/videos/cinematik.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
    // Inisialisasi video dari jaringan (gunakan URL video publik, misalnya dari YouTube atau server)
    _networkVideoController =
        VideoPlayerController.network(
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          ) // Contoh URL video publik
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _assetVideoController.dispose();
    _networkVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Muhammad Hasby As - IF B 23')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar dari Asset
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Gambar dari Asset',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/images/art.jpg',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            // Gambar dari Jaringan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Gambar dari Jaringan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Image.network(
                    'https://picsum.photos/300/200', // Contoh URL gambar acak
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Gagal memuat gambar'),
                  ),
                ],
              ),
            ),
            // Video dari Asset
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Video dari Asset',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _assetVideoController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _assetVideoController.value.aspectRatio,
                          child: VideoPlayer(_assetVideoController),
                        )
                      : CircularProgressIndicator(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _assetVideoController.value.isPlaying
                            ? _assetVideoController.pause()
                            : _assetVideoController.play();
                      });
                    },
                    child: Text(
                      _assetVideoController.value.isPlaying ? 'Pause' : 'Play',
                    ),
                  ),
                ],
              ),
            ),
            // Video dari Jaringan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Video dari Jaringan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _networkVideoController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio:
                              _networkVideoController.value.aspectRatio,
                          child: VideoPlayer(_networkVideoController),
                        )
                      : CircularProgressIndicator(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _networkVideoController.value.isPlaying
                            ? _networkVideoController.pause()
                            : _networkVideoController.play();
                      });
                    },
                    child: Text(
                      _networkVideoController.value.isPlaying
                          ? 'Pause'
                          : 'Play',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
