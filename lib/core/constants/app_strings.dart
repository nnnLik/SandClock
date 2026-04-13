abstract final class AppStrings {
  AppStrings._();

  static const String appTitle = 'Песочные часы';

  static const String dialogTimeUpTitle = 'Время вышло';
  static const String dialogTimeUpBody = 'Время истекло.';
  static const String dialogOk = 'OK';

  static const String sandColorTitle = 'Цвет песка';
  static const String cancel = 'Отмена';
  static const String tooltipSandColor = 'Цвет песка';

  static const String fieldSecondsLabel = 'Секунды';

  static const String start = 'Старт';
  static const String reset = 'Сброс';
  static const String pause = 'Пауза';
  static const String resume = 'Продолжить';

  static String remainingMmSs(String mmSs) => 'Осталось: $mmSs';
}
