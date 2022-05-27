class ListData {
  String courtName;
  String address;
  String photoURL;
  ListData(
      {required this.courtName, required this.address, required this.photoURL});

  String toString() => courtName + "(split)" + address + "(split)" + photoURL;
}
