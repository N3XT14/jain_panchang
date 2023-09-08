import 'package:flutter/material.dart';
import 'package:jain_panchang/features/calendar/data/repository.dart';
import 'package:jain_panchang/features/calendar/domain/usecases/add_calendar_event.dart';
import 'package:jain_panchang/features/calendar/domain/usecases/load_calendar_data.dart';
import 'package:jain_panchang/shared/navigation_drawer/presentation/navigation_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Widget>> _events = {};
  List<DateTime> _interestDates = [];
  bool _showInterestComponents = false;

  void _addEvent(DateTime date, Widget event) {
    final addEventUseCase = AddEventUseCase();
    addEventUseCase.execute(date, event, _events);
  }

  @override
  void initState() {
    super.initState();
    _loadInterestDates();
  }

  Future<void> _loadInterestDates() async {
    final loadInterestDatesUseCase =
        LoadInterestDatesUseCase(CalendarRepository());
    final fetchedDates = await loadInterestDatesUseCase.execute();
    setState(() {
      _interestDates = fetchedDates;
      for (final date in _interestDates) {
        _addEvent(date, _buildEventCard('Jain Festival'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jain Calendar'),
      ),
      drawer: const CustomNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (date) {
                return _events[date] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _showInterestComponents =
                      _interestDates.contains(selectedDay);
                });
              },
            ),
            if (_showInterestComponents)
              Column(
                children: [
                  const SizedBox(height: 10),
                  _buildEventList(),
                ],
              ),
            if (!_showInterestComponents)
              const Center(
                child: Text('No events selected.'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String eventName) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          eventName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Event details go here.'),
      ),
    );
  }

  Widget _buildEventList() {
    final eventsForSelectedDay = _events[_selectedDay] ?? [];

    return Column(
      children: eventsForSelectedDay,
    );
  }
}
