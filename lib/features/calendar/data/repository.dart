class CalendarRepository {
  // Replace with your database logic to fetch interest dates.
  Future<List<DateTime>> getInterestDates() async {
    // For testing, return static data.
    final staticData = [
      DateTime.utc(2023, 9, 10),
      DateTime.utc(2023, 10, 15),
      DateTime.utc(2023, 9, 20),
      DateTime.utc(2023, 9, 25),
      // Add more dates of interest here
    ];
    return staticData;
  }
}
