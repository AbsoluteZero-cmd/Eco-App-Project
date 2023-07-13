class MyUser {
  final String uid;
  final String name;
  final int points;
  final bool was_yesterday, was_today;
  final int days_streak;
  final int history_items;

  MyUser({
    required this.uid,
    required this.name,
    this.points = 0,
    this.was_yesterday = false,
    this.was_today = false,
    this.days_streak = 1,
    this.history_items = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "points": points,
      "was_yesterday": was_yesterday,
      "was_today": was_today,
      "days_streak": days_streak,
      "history_items": history_items,
    };
  }

  MyUser.fromMap(Map<String, dynamic> addressMap)
      : uid = addressMap["uid"],
        name = addressMap["name"],
        points = addressMap["points"],
        was_yesterday = addressMap["was_yesterday"],
        was_today = addressMap["was_today"],
        days_streak = addressMap["days_streak"],
        history_items = addressMap["history_items"];
}
