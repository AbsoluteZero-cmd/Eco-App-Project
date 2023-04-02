
class MyUser {
  final String uid;
  final String name;
  final int points;
  final bool was_yesterday;
  final int days_streak;

  MyUser(
      {required this.uid,
      required this.name,
      this.points = 0,
      this.was_yesterday = false,
      this.days_streak = 1});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "points": points,
      "was_yesterday": was_yesterday,
      "days_streak": days_streak,
    };
  }

  MyUser.fromMap(Map<String, dynamic> addressMap)
      : uid = addressMap["uid"],
        name = addressMap["name"],
        points = addressMap["points"],
        was_yesterday = addressMap["was_yesterday"],
        days_streak = addressMap["days_streak"];
}