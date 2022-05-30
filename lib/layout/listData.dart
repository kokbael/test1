class ListData {
  String courtName;
  String address;
  String photoURL;
  ListData(
      {required this.courtName, required this.address, required this.photoURL});

  // '가좌테니스장(split)서울 서대문구 홍은동 산 26-170(split)https://... '
  @override
  String toString() => courtName + "(split)" + address + "(split)" + photoURL;
}
