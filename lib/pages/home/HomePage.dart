import 'package:flutter/material.dart';
import 'package:wanandroid/model/homebanner/HomeBannerModel.dart';
import 'package:wanandroid/api/CommonService.dart';
import 'package:wanandroid/model/homebanner/HomeBannerItemModel.dart';
import 'package:wanandroid/widget/BannerView.dart';
import 'package:wanandroid/model/homelist/HomeListModel.dart';
import 'package:wanandroid/model/homelist/HomeListDataItemModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<HomeBannerItemModel> _bannerData;
  List<HomeListDataItemModel> _listData;
  int _listDataPage = 0;

  @override
  void initState() {
    super.initState();
    _loadBannerData();
    _loadListData(_listDataPage);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ((null == _listData) ? 0 : _listData.length) + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildBanner();
          } else {
            return _buildListViewItemLayout(index - 1);
          }
        });
  }

  Widget _buildBanner() {
    if (null == _bannerData || _bannerData.length <= 0) {
      return Center(
        child: Text("loading"),
      );
    } else
      return BannerView<HomeBannerItemModel>(
        data: _bannerData,
        buildShowView: (index, data) {
          return Image.network((data as HomeBannerItemModel).imagePath);
        },
      );
  }

  Widget _buildListViewItemLayout(int index) {
    if (null == _listData ||
        _listData.length <= 0 ||
        index < 0 ||
        index >= _listData.length) {
      return Container();
    }
    HomeListDataItemModel item = _listData[index];
    return Card(
      margin: new EdgeInsets.all(2.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildListViewItem(item),
      ),
    );
  }

  Widget _buildListViewItem(HomeListDataItemModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          item.title,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Text(
          "作者:${item.author} 分类:${item.superChapterName}/${item.chapterName} 时间:${item.niceDate}",
          textAlign: TextAlign.left,
        )
      ],
    );
  }

  void _loadBannerData() {
    CommonService().getBanner((HomeBannerModel _bean) {
      if (_bean.data.length > 0) {
        setState(() {
          _bannerData = _bean.data;
        });
      }
    });
  }

  void _loadListData(int page) {
    CommonService().getHomeListData((HomeListModel _bean) {
      if (_bean.data.datas.length > 0) {
        setState(() {
          _listData = _bean.data.datas;
        });
      }
    }, page);
  }
}