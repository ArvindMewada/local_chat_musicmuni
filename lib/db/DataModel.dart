class Client {
  int id;
  String firstName;

  Client({
    this.id,
    this.firstName,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    firstName: json["first_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "first_name": firstName
  };
}