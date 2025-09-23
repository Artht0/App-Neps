// lib/video_widget.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// ===============================================================
///  DETECÇÃO DE TIPO DE URL
/// ===============================================================
bool _isYouTubeUrl(String url) {
  final u = Uri.tryParse(url);
  if (u == null) return false;
  final host = (u.host).toLowerCase();
  return host.contains('youtube.com') || host.contains('youtu.be');
}

String? _extractYouTubeId(String url) {
  // Suporta: https://www.youtube.com/watch?v=XXXX  |  https://youtu.be/XXXX
  final u = Uri.tryParse(url);
  if (u == null) return null;
  if (u.host.contains('youtu.be')) {
    return u.pathSegments.isNotEmpty ? u.pathSegments.first : null;
  }
  if (u.host.contains('youtube.com')) {
    if (u.queryParameters['v'] != null) return u.queryParameters['v'];
    // shorts / embed (opcional)
    if (u.pathSegments.contains('shorts') && u.pathSegments.length >= 2) {
      return u.pathSegments[1];
    }
    final embedIndex = u.pathSegments.indexOf('embed');
    if (embedIndex != -1 && u.pathSegments.length > embedIndex + 1) {
      return u.pathSegments[embedIndex + 1];
    }
  }
  return null;
}

/// ===============================================================
///  PÁGINA UNIVERSAL (YouTube OU MP4) — use esta no _MenuItem
/// ===============================================================
class UniversalVideoPage extends StatelessWidget {
  final String title;
  final String url;

  const UniversalVideoPage({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se for link do YouTube, abre a página específica com iframe
    if (_isYouTubeUrl(url)) {
      final id = _extractYouTubeId(url);
      if (id == null) {
        return _ErrorScaffold(title: title, message: 'URL do YouTube inválida.');
      }
      return YouTubePage(title: title, videoId: id);
    }
    // Caso contrário, tratamos como MP4/HLS direto:
    return VideoPage(title: title, url: url);
  }
}

class _ErrorScaffold extends StatelessWidget {
  final String title;
  final String message;
  const _ErrorScaffold({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
///  PÁGINA (MP4/HLS direto) — usa package:video_player
/// ===============================================================
class VideoPage extends StatefulWidget {
  final String title;
  final String url;

  const VideoPage({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Se precisar de asset local: VideoPlayerController.asset('assets/video.mp4')
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _controller
        .initialize()
        .then((_) async {
      await _controller.setLooping(true);
      if (mounted) setState(() => _ready = true);
    })
        .catchError((e) {
      if (mounted) setState(() => _error = 'Erro ao inicializar vídeo: $e');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!_ready) return;
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _ErrorScaffold(title: widget.title, message: _error!);
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: Center(
        child: _ready
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio == 0
              ? 16 / 9
              : _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: _ready
          ? FloatingActionButton(
        onPressed: _toggle,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
    );
  }
}

class VideoListItem extends StatelessWidget {
  final String title;
  final String url;
  const VideoListItem({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UniversalVideoPage(title: title, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.play_circle_fill),
      title: Text(title),
      onTap: () => _open(context),
    );
  }
}

class VideoSection extends StatelessWidget {
  final String sectionTitle;
  final List<Map<String, String>> items; // [{title, url}]
  const VideoSection({
    Key? key,
    required this.sectionTitle,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
          child: Text(
            sectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...items.map(
              (m) => VideoListItem(
            title: m['title'] ?? 'Vídeo',
            url: m['url'] ?? '',
          ),
        ),
      ],
    );
  }
}

/// ===============================================================
///  PÁGINA (YouTube) — usa iframe oficial
/// ===============================================================
class YouTubePage extends StatefulWidget {
  final String title;
  final String videoId; // apenas o ID do vídeo
  const YouTubePage({Key? key, required this.title, required this.videoId}) : super(key: key);

  @override
  State<YouTubePage> createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  late final YoutubePlayerController _yt;

  @override
  void initState() {
    super.initState();
    _yt = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        // autoPlay: false, // ← REMOVIDO para compatibilidade com a sua versão
        strictRelatedVideos: true,
      ),
    )..loadVideoById(videoId: widget.videoId);
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(controller: _yt),
        ),
      ),
    );
  }
}
