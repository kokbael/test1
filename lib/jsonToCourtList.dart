///   [
///     {},
///     {}, ...
///   ]
///  list of map 이므로
///  Map 형식으로 직렬화한 [Court Class] 를
///  List 형식으로 [CourtList Class] 에서 다시 직렬화 한다.

class CourtList {
  final List<dynamic>? courts;

  CourtList({
    this.courts,
  });

  factory CourtList.fromJson(List<dynamic> parsedJson) {
    List<dynamic> courts;
    courts = parsedJson.map((i) => Court.fromJson(i)).toList();
    return CourtList(courts: courts);
  }
}

class Court {
  String? city;
  String? courtName;
  int? courtEA;
  String? contact;
  String? chargeInfo;
  String? reservation;
  String? address;

  Court(
      {this.courtEA,
      this.courtName,
      this.address,
      this.reservation,
      this.chargeInfo,
      this.contact,
      this.city});

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      courtEA: json['courtEA'],
      courtName: json['courtName'],
      address: json['address'],
      reservation: json['reservation'],
      chargeInfo: json['chargeInfo'],
      contact: json['contact'],
      city: json['city'],
    );
  }
}
