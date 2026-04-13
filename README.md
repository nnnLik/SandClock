# Песочные часы (Flutter, Windows)

Десктопное приложение «Песочные часы» для учебного проекта: задаётся время, на экране анимируется пересыпание песка, по окончании воспроизводится звук (без модального окна).

## Реализованный функционал

- Графика: `CustomPainter` — две колбы, плавное изменение уровня песка, струйка между колбами во время работы; песок не заполняет колбу на 100% (запас «воздуха»).
- Ввод времени: три компактных поля в один ряд — часы, минуты, секунды; остаток отображается как `MM:SS`.
- Управление: Старт, Сброс, Пауза / Продолжить; поля блокируются на время отсчёта; валидация — запуск только при суммарном времени > 0.
- Темы оформления (иконка палитры): «Песок пустыни», «Неон», «Монохром», «Ретро дерево» — меняются цвет песка и общая цветовая схема приложения (светлая/тёмная следует системе).
- Звук: файл `assets/sounds/timer_done.wav`, воспроизведение через пакет `audioplayers`; в AppBar — переключатель mute / unmute. По окончании таймера диалог не показывается.
- Окно Windows: фиксированный портретный размер, отключено изменение размера и кнопка развёртывания (см. `windows/runner`).

## Технологии

- Flutter / Dart (см. `pubspec.yaml`: SDK `>=3.11.4`)
- Material 3, `ThemeData` от seed-цвета темы
- [audioplayers](https://pub.dev/packages/audioplayers) для WAV из assets

## Зависимости и окружение

```bash
flutter pub get
```

Для **сборки под Windows** нужен Visual Studio с рабочей нагрузкой **Desktop development with C++**. Проверка:

```bash
flutter doctor -v
```

## Запуск в режиме разработки

```bash
flutter run -d windows
```

Или через `Makefile` (ниже).

## Сборка release

Через Flutter:

```bash
flutter build windows --release
```

Через `Makefile` в корне проекта:

| Цель | Действие |
|------|----------|
| `make pub` или `make get` | `flutter pub get` |
| `make analyze` | `flutter analyze` |
| `make run` | `flutter run -d windows` |
| `make build` | `flutter build windows --release` |
| `make build-debug` | `flutter build windows --debug` |
| `make clean` | `flutter clean` |

Готовые файлы появляются в каталоге:

`build/windows/x64/runner/Release/`

Там лежат как минимум `sandclock.exe`, `flutter_windows.dll`, `audioplayers_windows_plugin.dll` и папка `data/`. Для переноса на другой ПК или флешке копируй **всю папку `Release`**, а не один только `exe`.

Упаковка в один portable-файл (опционально): отдельная утилита **Enigma Virtual Box** (не путать с *Enigma Protector*): в виртуальный образ добавляют `sandclock.exe`, обе DLL и каталог `data`. Подпись кода для «тихого» SmartScreen не обязательна для учебного проекта.

Если сборка падает на шаге `INSTALL` / MSB3073: закрой запущенный `sandclock.exe`, снимите блокировку файлов (антивирус, Enigma), затем `flutter clean`, снова `flutter pub get` и `flutter build windows --release`.

## Структура каталогов (основное)

```text
sandclock/
  assets/sounds/timer_done.wav
  lib/
    main.dart
    app.dart
    core/constants/   app_constants, app_strings, app_theme_presets, app_colors
    core/theme/       app_theme.dart
    core/utils/       time_format.dart
    features/sand_clock/presentation/
      screens/sand_clock_screen.dart
      widgets/hourglass_painter.dart, sand_color_picker_dialog.dart
  windows/runner/     main.cpp, win32_window.cpp — размер окна, запрет ресайза
  Makefile
  README.md
```

## Идеи для курсовой работы

- Выбор Flutter для десктопного UI и единого кода.
- `CustomPainter` и анимация через `AnimationController`.
- Разделение на `core` (константы, тема, утилиты) и `features` (экран песочных часов).
- Подключение нативного звука через плагин и assets.
- Настройка Windows runner под фиксированное окно.
