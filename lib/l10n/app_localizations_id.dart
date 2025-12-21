// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get generalTodo => 'Tugas Umum';

  @override
  String get weeklyReview => 'Tinjauan Mingguan';

  @override
  String get settings => 'Pengaturan';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Mode Terang';

  @override
  String get themeGothic => 'Mode Gelap Gotik';

  @override
  String get language => 'Bahasa';

  @override
  String get close => 'Tutup';

  @override
  String get addTask => 'Tambah tugas...';

  @override
  String get confirmCompletion => 'Konfirmasi Penyelesaian';

  @override
  String get confirmCompletionMessage =>
      'Apakah Anda benar-benar menyelesaikan tugas ini di masa lalu?';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get delete => 'Hapus';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get getStarted => 'Mulai';

  @override
  String get habits => 'Kebiasaan';

  @override
  String get addHabit => 'Tambah Kebiasaan';

  @override
  String get habitName => 'Nama Kebiasaan';

  @override
  String get habitColor => 'Warna Kebiasaan';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get addHabitTooltip => 'Tambah Kebiasaan';

  @override
  String get goToTodayTooltip => 'Ke Hari Ini';

  @override
  String get empty => 'Kosong';

  @override
  String get newHabit => 'Kebiasaan Baru';

  @override
  String get habitTitle => 'Judul Kebiasaan';

  @override
  String get habitTitleHint => 'Silakan masukkan judul';

  @override
  String get duration => 'Durasi';

  @override
  String get oneWeek => '1 Minggu';

  @override
  String get oneMonth => '1 Bulan';

  @override
  String get custom => 'Kustom';

  @override
  String get permanent => 'Permanen';

  @override
  String get durationDays => 'Durasi (Hari)';

  @override
  String get daysSuffix => 'hari';

  @override
  String get enterDuration => 'Silakan masukkan durasi';

  @override
  String get validNumber => 'Silakan masukkan angka yang valid';

  @override
  String get color => 'Warna';

  @override
  String get dailyPerformance => 'Kinerja Harian';

  @override
  String get habitConsistency => 'Konsistensi Kebiasaan';

  @override
  String get completion => 'Penyelesaian';

  @override
  String daysCount(Object active, Object completed) {
    return '$completed/$active hari';
  }
}
