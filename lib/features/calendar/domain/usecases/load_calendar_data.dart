import 'package:jain_panchang/features/calendar/data/repository.dart';

class LoadInterestDatesUseCase {
  final CalendarRepository _repository;

  LoadInterestDatesUseCase(this._repository);

  Future<List<DateTime>> execute() async {
    return await _repository.getInterestDates();
  }
}
