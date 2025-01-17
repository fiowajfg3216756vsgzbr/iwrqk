import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../global_widgets/iwr_progress_indicator.dart';

class IwrGallery extends StatefulWidget {
  final List<String> imageUrls;
  final bool isfullScreen;
  final int? lastPage;
  final void Function(int index)? onPageChanged;

  const IwrGallery({
    Key? key,
    required this.imageUrls,
    this.isfullScreen = false,
    this.lastPage,
    this.onPageChanged,
  }) : super(key: key);

  @override
  State<IwrGallery> createState() => _IwrGalleryState();
}

class _IwrGalleryState extends State<IwrGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.lastPage ?? 0);
    _currentIndex = widget.lastPage ?? 0;
  }

  Widget _buildGallery() {
    return PhotoViewGallery.builder(
      customSize:
          widget.isfullScreen ? null : Size.copy(MediaQuery.of(context).size),
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        var imageProvider = CachedNetworkImageProvider(widget.imageUrls[index]);

        return PhotoViewGalleryPageOptions(
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    imageProvider.evict();
                  });
                },
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.arrowRotateLeft,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ));
          },
        );
      },
      itemCount: widget.imageUrls.length,
      loadingBuilder: (context, event) => const Center(
        child: IwrProgressIndicator(),
      ),
      pageController: _pageController,
      onPageChanged: (index) {
        widget.onPageChanged?.call(index);
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildDotPageFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imageUrls.length, (index) {
        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 150),
                curve: Curves.bounceIn);
          },
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextPageFooter() {
    return Text(
      "${_currentIndex + 1} / ${widget.imageUrls.length}",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isfullScreen) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.white,
            ),
          ),
          title: widget.imageUrls.length > 1 ? _buildTextPageFooter() : null,
          centerTitle: true,
        ),
        body: Padding(
          padding: MediaQuery.of(context).padding,
          child: Stack(
            children: [
              _buildGallery(),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
              body: IwrGallery(
                isfullScreen: true,
                imageUrls: widget.imageUrls,
                lastPage: _currentIndex,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _pageController.jumpToPage(_currentIndex);
                },
              ),
            ),
          ));
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildGallery(),
              if (widget.imageUrls.length > 15)
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: _buildTextPageFooter()),
              if (widget.imageUrls.length <= 15 && widget.imageUrls.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: _buildDotPageFooter(),
                ),
            ],
          ),
        ),
      );
    }
  }
}
