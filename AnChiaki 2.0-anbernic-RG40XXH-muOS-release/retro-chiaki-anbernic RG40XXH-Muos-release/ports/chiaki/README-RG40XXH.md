# Chiaki для Anbernic RG40XX H (muOS)

Сборка основана на архиве `retro-chiaki-v0.3.2-portmaster-muos-h700`.
Целевое устройство: **Anbernic RG40XX H** (Allwinner H700, aarch64) на прошивке **muOS**.

> Chiaki — открытый клиент PS4/PS5 Remote Play. Он **не содержит** игр и не
> связан с Sony. Для работы нужны консоль PlayStation 4/5, аккаунт PSN
> (для PS5 — PSN ID в настройках) и консоль в одной сети с роутером.

---

## 1. Что было изменено относительно исходного архива

| # | Проблема в исходном архиве | Что сделано |
|---|---|---|
| 1 | **Неверный маппинг геймпада.** В `Chiaki.sh` был жёстко прописан `SDL_GAMECONTROLLERCONFIG` для RG34XXSP (GUID `19000000010000000100000000010000`, аналог на `a0-a3`). На RG40XX H стики и кнопки работали бы неправильно. | Лаунчер сначала использует `$sdl_controllerconfig`, который PortMaster выдаёт для конкретного устройства, а если его нет — три встроенных маппинга (RG40XX H, RG35XX H, RG34XXSP) с явным приоритетом. |
| 2 | **Жёсткий путь к GL-драйверу.** `ln -sf /usr/lib/libGLESv2.so.2` — если в прошивке драйвер лежит в другом месте, графика не стартует. | Добавлен перебор типовых путей H700 (`/usr/lib`, `/usr/lib/mali*`, `/usr/lib/aarch64-linux-gnu` и т. д.) с поиском через `find` как запасной вариант. |
| 3 | **Молчаливый отказ при отсутствии библиотек.** Порту нужны `libudev.so.1`, `libevdev.so.2`, `libpulse.so.0` — их нет в архиве, они берутся из прошивки. | Добавлена проверка на старте: в `log.txt` пишется `WARNING`, если какой-то библиотеки нет. |
| 4 | **`LD_PRELOAD` без проверки.** Если `libmaliegl.so` отсутствует, приложение падало бы сразу. | `LD_PRELOAD` выставляется только если файл реально существует. |
| 5 | **Разрешение по умолчанию 640x480** вместо нативного 720x720 у RG40XX H. | Значения по умолчанию изменены на 720x720; автоопределение из `/sys/class/graphics/fb0/modes` сохранено. |
| 6 | Порт не сообщал, что он вообще запустился. | Лаунчер пишет в `log.txt` версию прошивки, модель, разрешение, найденный GL-драйвер и выбранный источник маппинга геймпада. |
| 7 | Не было диагностики. | Добавлен скрипт `chiaki-rg40xxh-diagnose.sh` (см. раздел 4). |

**Не менялось:** 145 исходных бинарных объектов Chiaki, их runtime-библиотеки, исходные platform/imageformat Qt-плагины, данные `xkb`, иконки и обложки muOS. В тестовом архиве launcher переключён на `GPTOKEYB2` PortMaster с `libinterpose` и отдельным SDL mapping-файлом; тестовый профиль `chiaki-gptokeyb2.gptk` назначает крестовине одновременно движение мыши и клавиши стрелок; A=Enter, B=Esc, X=Space, Y=Tab. Включён `QT_DEBUG_PLUGINS=1` and `QT_LOGGING_RULES=qt.qpa.input.debug=true;qt.qpa.input.keymap.debug=true`; после старта gptokeyb2 launcher находит `Fake Keyboard Mouse` и `Fake Absolute Mouse` в `/sys/class/input` и передаёт соответствующие `/dev/input/event*` напрямую Qt через `QT_QPA_EVDEV_KEYBOARD_PARAMETERS` и `QT_QPA_EVDEV_MOUSE_PARAMETERS`.
**Добавлены:** два ARM64 generic Qt 5.15.3 input-плагина из Ubuntu Jammy (`libqevdevkeyboardplugin.so` и `libqevdevmouseplugin.so`). Они соответствуют `QT_QPA_GENERIC_PLUGINS=evdevkeyboard,evdevmouse`, уже заданному лаунчером.

---

## 2. Установка на карту памяти

Порт рассчитан на **карту с играми (Card 2 / TF2)**, которая в muOS монтируется
как `/mnt/mmc`.

В поставке **два архива** с одинаковым содержимым — отличается только способ
установки:

| Архив | Для чего |
|---|---|
| `retro-chiaki-v0.3.2-RG40XXH-muos.zip` | Распаковать вручную в корень карты |
| `retro-chiaki-v0.3.2-RG40XXH-AUTOINSTALL.zip` | Положить как есть в папку автоустановки |

### Вариант А — распаковать архив вручную

1. Выключите консоль и вытащите карту с играми.
2. Вставьте её в компьютер.
3. Распакуйте **содержимое** архива в **корень** карты (не во вложенную папку!).
   Должно получиться так:

```
<корень карты>/
├── MUOS/
│   └── info/catalogue/External - Ports/
│       ├── box/Chiaki.png
│       └── preview/Chiaki.png
├── ports/
│   └── chiaki/
│       ├── chiaki
│       ├── chiaki-cli
│       ├── chiaki.gptk
│       ├── libs/ ...
│       └── xkb/ ...
└── ROMS/
    └── Ports/
        └── Chiaki.sh          <- файл запуска
```

4. Безопасно извлеките карту, верните в консоль, включите.
5. В muOS: **Apps > System > Content Refresh** (обновить список).
6. Запуск: **Content > Ports > Chiaki**.

### Вариант Б — автоустановка через PortMaster

Файл `retro-chiaki-v0.3.2-RG40XXH-AUTOINSTALL.zip` **не распаковывать**.
Положить его целиком в папку:

```
MUOS/PortMaster/autoinstall/
```

То есть на карте: `MUOS/PortMaster/autoinstall/retro-chiaki-v0.3.2-RG40XXH-AUTOINSTALL.zip`

> **Проверено на устройстве:** на RG40XX H с muOS работает именно эта папка.
> Официальная документация PortMaster указывает также `/mnt/mmc/ports/autoinstall/`,
> но там автоустановка **не срабатывает** — так что используйте `MUOS/PortMaster/autoinstall/`.
> Это объясняется тем, что PortMaster проверяет две папки:
> `$controlfolder/autoinstall` (= `MUOS/PortMaster/autoinstall`) и
> `/$directory/ports/autoinstall`, а вторая на этой прошивке не указывает на карту с играми.

Затем:

1. Безопасно извлеките карту, верните в консоль, включите.
2. Запустите **PortMaster** из меню (Apps > Tools > PortMaster).
3. PortMaster сам распакует архив и установит порт. Выйдите из PortMaster
   **штатно** — список портов обновляется при выходе.
4. Запуск: **Content > Ports > Chiaki**.

> **PortMaster не запускает порты.** В нём есть только «Установить /
> Переустановить / Удалить». Кнопки «Запустить» там нет по устройству программы.
> Запуск делается из меню портов (`Apps → Ports` или `Explore Content → Ports`).

> **Важно:** архив автоустановки — это полная сборка, поэтому после установки
> в корне карты останутся `README-RG40XXH.md`, `chiaki-rg40xxh-diagnose.sh`
> и сам `.zip`. Работе они не мешают, их можно удалить вручную.
> Копия `README-RG40XXH.md` при этом уже лежит внутри `ports/chiaki/`.

### Важно про регистр имён

muOS различает регистр. Именно `ROMS/Ports/` и `ports/chiaki/` —
`Ports` с большой буквы, `ports` с маленькой. Не переименовывайте папки.

---

## 3. Первый запуск и настройка

1. Подключите консоль к той же сети Wi-Fi, что и PlayStation.
2. Запустите Chiaki из списка портов.
3. В Chiaki откройте **Settings** и введите **PSN Account ID**:
   - PS4: введите свой PSN ID (логин), Chiaki сама получит Account ID;
   - PS5: нужен PSN Account ID в base64 (можно получить на сайтах-конвертерах
     PSN ID → Account ID).
4. Консоль должна быть включена, в настройках Remote Play — разрешить
   удалённое подключение.
5. Управление зависит от геймпада. Если кнопки/стики работают неправильно —
   перейдите к разделу 4.

**Лог запуска:** `ports/chiaki/log.txt` на карте с играми. Это первое, что
нужно смотреть, если порт не стартует.

---

## 4. Если порт не запускается

Лаунчер этой сборки начинает писать лог **с самых первых строк** — ещё до того,
как что-либо может упасть. Поэтому файл

```
ports/chiaki/log.txt
```

на карте с играми почти всегда объясняет причину. Смотрите его в первую очередь.

Что лаунчер пишет в лог:

- архитектуру и версию ядра, `HOME`, путь к самому скрипту;
- значения `directory`, `controlfolder`, `CFW_NAME`, `DEVICE_NAME`, `DEVICE_ARCH`;
- путь к найденной папке PortMaster;
- строку `calling get_controls...` и `get_controls done` — если вторая строка
  отсутствует, значит процесс завис на определении контроллера;
- найденный GL-драйвер и предупреждения об отсутствующих системных библиотеках;
- итоговое `GAMEDIR` и код выхода `chiaki`.

Если папка `ports/chiaki` не найдена вообще, лаунчер выведет список того, что
реально лежит в `/mnt/mmc`, `/roms` и в папке портов — по этому списку сразу
видно, куда распаку́ется архив.

### Быстрая проверка карты на компьютере

В поставке есть `check-card.bat` (Windows). Вставьте карту(ы) в ПК и запустите
двойным щелчком — рядом появится файл `chiaki-card-check.txt`. Он покажет:
какие диски найдены, на месте ли `ROMS/Ports/Chiaki.sh` и `ports/chiaki/`,
сколько библиотек распаковалось, нет ли лишней вложенности папок, что лежит в
`autoinstall` и сколько свободного места. **Пришлите этот файл, если порт не
работает.**

### Частые причины

| Симптом | Причина | Что делать |
|---|---|---|
| В логе нет ни строки, `log.txt` отсутствует | Лаунчер не запускался: порт не появился в меню | `Apps > System > Content Refresh`, затем перезагрузка |
| В логе есть `FATAL: cannot find the port folder` | Архив распакован во вложенную папку | Переместить `ports/` и `ROMS/` в **корень** карты |
| В логе есть `MISSING ports/chiaki/libs` | Автоустановка не докачала файлы (мало места) | Освободить место и установить заново |
| Лог обрывается на `calling get_controls...` | Определение контроллера зависло | Прислать лог |
| `FATAL: PortMaster control folder not found` | PortMaster не установлен или лежит по другому пути | Установить PortMaster: `Applications > Archive Manager` (файл `muos.portmaster.zip` в папку `/ARCHIVE/`) |

---

## 5. Если геймпад работает неправильно

Исходный порт был собран под RG34XXSP, и маппинга для RG40XX H в нём не было.
Теперь лаунчер сначала берёт `$sdl_controllerconfig` от PortMaster — если база
PortMaster знает это устройство, маппинг будет заведомо правильным. Встроенный
маппинг RG40XX H используется только как запасной вариант, и он **не проверен
на реальном устройстве**: в базе, встроенной в поставляемую
`libSDL2-2.0.so.0`, нет ни одной записи Anbernic (проверено: 302 записи,
ни одного GUID с префиксом `1900…`).

Если кнопки или стики ведут себя неправильно:

1. Скопируйте `chiaki-rg40xxh-diagnose.sh` в корень карты с играми.
2. На консоли откройте терминал (**Apps > Terminal**) или подключитесь по SSH.
3. Выполните:

```sh
cd /mnt/mmc
bash chiaki-rg40xxh-diagnose.sh
```

4. На карте появится файл **`chiaki-diagnose.txt`**. Пришлите его мне —
   по нему я подставлю точный GUID и раскладку кнопок в `Chiaki.sh`.

Скрипт ничего не меняет на устройстве, он только читает информацию.

### Правка вручную

В `ROMS/Ports/Chiaki.sh` найдите строки `GP_RG40XXH`, `GP_RG35XXH`,
`GP_RG34XXSP`. Формат записи SDL:

```
<GUID>,<Имя>,a:b0,b:b1,x:b3,y:b2,back:b8,start:b7,leftx:a0,lefty:a1,...
```

- `bN` — номер кнопки, `aN` — номер аналоговой оси, `h0.N` — направление крестовины.
- GUID зависит от USB vendor/product ID и набора кнопок, поэтому его нужно
  брать именно для вашего контроллера.
- **Порядок важен:** первая запись для данного GUID побеждает, более поздняя
  его не переопределяет. GUID `19000000010000000100000000010000` общий у
  RG35XX H и RG34XXSP, поэтому при совпадении выигрывает RG35XX H.

---

## 6. Технические подробности сборки

| Параметр | Значение |
|---|---|
| Архитектура | aarch64 (ELF 64-bit, `ld-linux-aarch64.so.1`) — совпадает с H700 |
| Всего ELF-объектов | 147, **все** aarch64 |
| Графический стек | Qt5 + EGLFS, `QT_OPENGL=es2`, Mali GLESv2 |
| Разрешение | определяется в рантайме, по умолчанию 720x720 |
| Звук | ALSA (`SDL_AUDIODRIVER=alsa`) |
| Из прошивки берутся | `libc.so.6`, `libm.so.6`, `libpthread.so.0`, `libresolv.so.2`, `libudev.so.1`, `libevdev.so.2`, `libpulse.so.0`, `libGLESv2.so.2` |

Формула масштаба текста Qt: `физическая_ширина_мм = ширина_пикселей * 254 / 960`,
то есть панель описывается как 96 DPI. Для 720x720 это даёт ~190 мм —
так текст на квадратном экране остаётся того же физического размера, что и на
720x480 у других H700-устройств. Если шрифт кажется слишком мелким или
крупным, измените делитель `960` (меньше делитель → крупнее текст).

---

## 7. Правовая заметка

Chiaki — свободное ПО с открытым исходным кодом (AGPL-3.0). Порт
распространяется сообществом PortMaster. Этот архив не содержит образов игр,
BIOS-файлов или ключей Sony. Использование Remote Play требует собственной
консоли PlayStation и учётной записи PSN.


RG40XXH input test profile: left-stick directions move the mouse; D-pad keeps mouse movement plus arrow keys; A=left mouse button, B=Escape, X=Space, Y=Enter (confirm), Start=Escape, Back=Tab.


RG40XXH control profile v2 uses gptokeyb2's documented section format: left analog stick and D-pad move the mouse; A=left click, B=Escape, X=Space, Y=Enter. Unmapped controls are cleared to avoid default bindings.


### Закрытие Chiaki

Чтобы закрыть приложение из меню или во время стрима, одновременно нажми физические кнопки **M (Menu) + Start**. Chiaki получает M как PS5 Touchpad, Start как Options; помощник gptokeyb2 настроен на тот же выход.


### Исправленная раскладка кнопок

SDL-карта использует индексы, снятые с RG40XX H: A=b1, B=b2, X=b7, Y=b3, L1=b4, R1=b5, L2=b10, R2=b11, Select=b6, M=b8, Start=b7, L3=b9, R3=b12. В карте Chiaki M назначена как Touchpad, Select как Guide; Start остаётся Options. Оси стиков 0-a3 и D-pad не изменены. L2/R2 — цифровые кнопки устройства, привязанные к триггерам SDL; сенсорная панель физически отсутствует.


### Audio on muOS

The launcher exports ALSA_PLUGIN_DIR=/usr/lib/alsa-lib so SDL/ALSA can find muOS's installed PipeWire PCM module. This routes Chiaki stream audio through the existing PipeWire server without changing /etc/asound.conf.


### PS5 face-button layout

In Chiaki gameplay, physical A maps to PS5 Circle, B to Cross, X to Triangle, and Y to Square. Stick axes, shoulders, triggers, audio routing, and the M + Start exit shortcut is mapped to Touchpad + Options.


### Контроллер — раскладка подтверждена сканом

Физические индексы SDL: A=b0, B=b1, X=b3, Y=b2, R3=b12, Start=b7, Select=b6; L1=b4, R1=b5, L2=b10, R2=b11, M=b8, L3=b9. Карта игрового контроллера передаёт A как PS5 Circle, B как Cross, Y как Square, X как Triangle, R3 как R3 и Start как Options. Оси стиков a0-a3, D-pad, плечевые кнопки и звук не менялись. Профиль клавиатурного помощника оставляет A=клик/подтверждение, B=Escape/отмена, X=Space, Y=Enter; карта помощника синхронизирована с последними физическими индексами.


### Updated face-button swap

A and B, and X and Y, are swapped relative to the previous package in both gameplay and the Chiaki menu. Physical A/B/X/Y now follow SDL buttons b0/b1/b3/b2; menu actions are A=Escape, B=mouse click, X=Enter, Y=Space. Other controls and settings are unchanged.


### Выход из Chiaki в muOS

Удерживай M (Menu) и нажми Start (или нажми обе одновременно). В SDL-карте M назначена как PS5 Touchpad, а Start — как Options; эта пара закрывает Chiaki во время стрима. Профиль gptokeyb2 использует ту же комбинацию как резервный выход. Select назначена как Guide.
