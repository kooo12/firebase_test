class Person {
  String? name;
  String? age;
  String? address;
  int? timestemp;
  String? profileUrl;
  Person(this.name, this.age, this.address, this.timestemp, this.profileUrl);

  factory Person.fromMap(Map map) {
    return Person(map['name'], map['age'], map['address'], map['timestemp'],
        map['profileUrl']);
  }
  Map<String, dynamic> toMap() => {
        'name': name,
        'age': age,
        'address': address,
        'timestemp': timestemp,
        'profileUrl': profileUrl
      };
}
