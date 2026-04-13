abstract final class AppStrings {
  AppStrings._();

  static const String appTitle = 'Песочные часы';

  static const String themeTitle = 'Тема оформления';
  static const String cancel = 'Отмена';
  static const String tooltipTheme = 'Тема оформления';
  static const String tooltipMute = 'Выключить звук';
  static const String tooltipUnmute = 'Включить звук';

  static const String fieldHoursLabel = 'Часы';
  static const String fieldMinutesLabel = 'Минуты';
  static const String fieldSecondsLabel = 'Секунды';

  static const String start = 'Старт';
  static const String reset = 'Сброс';
  static const String pause = 'Пауза';
  static const String resume = 'Продолжить';

  static String remainingMmSs(String mmSs) => 'Осталось: $mmSs';
}
