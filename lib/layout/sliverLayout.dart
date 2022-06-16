import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliverLayout extends StatefulWidget {
  const SliverLayout({
    Key? key,
    required this.photoURLList,
    required this.myTabs,
    required this.myTabsView,
    this.fixTabNumber,
  }) : super(key: key);

  /// String Type 의 photoURL. CarouselSlider 로 출력.
  final List<String>? photoURLList;

  /// Tab. 개수에 맞게 labelPadding 자동 조절.
  final List<Tab>? myTabs;

  /// Tab 에 들어가는 컨텐츠 , myTabs 개수와 같아야 한다.
  final List<Widget>? myTabsView;

  /// 스크롤 불가능 하게 설정할 페이지 넘버 (ex. 3 번째 탭 고정 -> 3)
  final int? fixTabNumber;

  @override
  State<SliverLayout> createState() => _SliverLayoutState();
}

class _SliverLayoutState extends State<SliverLayout>
    with SingleTickerProviderStateMixin {
  List<int>? _photoIndexList;
  int? _sliderNumber;
  TabController? _tabController;
  ScrollController? _scrollController;
  bool _fixedScroll = false;

  _smoothScrollToTop() {
    _scrollController!.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      _fixedScroll = widget.fixTabNumber == null
          ? _tabController!.index == widget.myTabs!.length + 1
          : _tabController!.index == widget.fixTabNumber! - 1;
    });
  }

  _scrollListener() {
    if (_fixedScroll == true) {
      _scrollController!.jumpTo(0);
    }
  }

  @override
  void initState() {
    _photoIndexList = List<int>.generate(widget.photoURLList!.length, (i) => i);
    _sliderNumber = 1;
    _tabController = TabController(length: widget.myTabs!.length, vsync: this);
    _tabController!.addListener(_smoothScrollToTop);
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: widget.myTabs!.length,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, bool innerBoxIsScrolled) {
            Size _size = MediaQuery.of(context).size;
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    backgroundColor: Colors.white,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    // forceElevated: innerBoxIsScrolled,
                    expandedHeight: 350,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 350,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _sliderNumber = index + 1;
                                });
                              },
                              viewportFraction: 0.96, // 1 로 하면 경계선 X
                            ),
                            items: _photoIndexList!.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: _size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent),
                                    child: Image.network(
                                      widget.photoURLList![i],
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Positioned(
                            bottom: 60,
                            right: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: SizedBox(
                                  width: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$_sliderNumber / ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        (widget.photoURLList!.length)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.zero,
                      child: Container(
                        color: Colors.white,
                        width: _size.width,
                        child: Center(
                          child: TabBar(
                            labelPadding: EdgeInsets.only(
                                left: _size.width / (widget.myTabs!.length * 3),
                                right:
                                    _size.width / (widget.myTabs!.length * 3)),
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xFF646464),
                                ),
                                insets: EdgeInsets.only(bottom: 4)),
                            controller: _tabController,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black54,
                            isScrollable: true,
                            tabs: widget.myTabs!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: widget.myTabsView!,
          ),
        ),
      ),
    );
  }
}
