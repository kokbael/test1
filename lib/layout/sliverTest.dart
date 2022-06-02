import 'package:flutter/material.dart';

class SliverTest extends StatefulWidget {
  const SliverTest({Key? key}) : super(key: key);

  @override
  State<SliverTest> createState() => _SliverTestState();
}

class _SliverTestState extends State<SliverTest>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> _myTabs = [
    Tab(text: 'tab1'),
    Tab(text: 'tab2'),
    Tab(text: 'tab3'),
  ];
  TabController? _tabController;
  ScrollController? _scrollController;
  bool fixedScroll = true;

  _scrollListener() {
    if (fixedScroll == true) {
      _scrollController!.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController!.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      fixedScroll = _tabController!.index == 2;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_smoothScrollToTop);

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
      appBar: AppBar(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          Size _size = MediaQuery.of(context).size;
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/court_image%2Fbusan%2F%EB%8F%99%EC%84%9C%EB%8C%80%ED%95%99%EA%B5%90.png?alt=media&token=d2ac1034-efaa-4077-b176-56387ef20085',
                      fit: BoxFit.cover,
                      width: _size.width,
                      height: _size.height,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Container(
                          // width: size.width,
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
                                children: const [
                                  Text(
                                    '1 / ', // index
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    '1', // list.length
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // title:
              ),
            ),
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              // flexibleSpace:
              title: Align(
                alignment: Alignment.center,
                child: TabBar(
                  labelPadding: EdgeInsets.only(
                      left: _size.width / 12, right: _size.width / 12),
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
                  tabs: _myTabs,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              height: 400,
              color: Colors.blueAccent,
              child: Text('Tab 1'),
            ),
            Container(
              height: 800,
              color: Colors.red,
            ),
            Container(
              height: 1200,
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
