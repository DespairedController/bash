## Задание 4\. Менеджер процессов

Реализуйте менеджер процессов. Он должен в цикле считывать команды со стандартного потока ввода и обрабатывать их.

Должны поддерживаться следующие команды:

*   `list` — вывести список процессов в виде двух столбцов: PID и команда запуска
*   `info <PID>` — вывести подробную информацию по PID — родительский процесс (PID и команда запуска), пользователь, путь к исполняемому файлу, рабочая директория, затрачиваемая память
*   `find <QUERY>` — выводит список процессов, команда запуска которых содержит запрос
*   `send <SIGNAL> <PID>` — отправит сигнал указанному процессу
*   `stream` — включает режим отслеживания. В этом режиме с клавиатуры ничего не считывается, а на консоль выводятся события вида:
    *   `process 12346 (bash script.sh) started`
    *   `process 12177 (/usr/bin/gnome-terminal) finished`
*   `exit`, `help`

Для получения информации о процессах используйте директорию `/proc`. Использование команд `ps`, `top` и аналогов запрещается.

Если данные (например, команда запуска) не влезают в одну строку, обрежьте их.

**Важно:** В режиме отслеживания допускается пропускать процессы, проработавшие меньше двух секунд (подумайте, как легко реализовать режим с этим ограничением).

Нажатие клавиш Ctrl+C (и соответствующий сигнал) должно перехватываться и завершать только режим отслеживания, а не весь менеджер.

С помощью ANSI Escape Codes добавьте цветное оформление вывода на свой вкус (можно совсем немного).

## Задание 5\. Работа с файловой системой

### Подзадание 5-1\. Удаление дубликатов

Реализуйте скрипт для удаления дубликатов файлов.

Скрипт должен принимать в качестве аргумента директорию (если она не указана, используется текущая директория. Необходимо найти в указанной директории и во всех её поддиректориях дублирующиеся файлы. Оставьте один из них, все остальные удалите и замените их на жёсткие ссылки (hard links) на первый файл.

Вы можете считать, что файлы одинаковые, если совпадает их размер и какая-нибудь хеш-функция. Обратите внимание, что у одинаковых файлов могут быть разные названия.

Выведите информацию о проведенных заменах на экран.

### Подзадание 5-2\. Файловый сервер

Реализуйте TCP-сервер. Для этого напишите два скрипта:

*   первый скрипт читает запросы со стандартного потока ввода (`stdin`), обрабатывает их и выводит на стандартный поток вывода (`stdout`)
*   второй скрипт запускает TCP-сервер на порту 24344 с первым скриптом в качестве обработчика

Для запуска сервера используйте Netcat (во многих дистрибутивах — команда `nc`). Если Netcat в вашем дистрибутиве не поддерживает запуск программы-обработчика с помощью флага `-e`, установите пакет `netcat-traditional`. Сервер должен не завершаться после первого обработанного запроса. Тестировать запущенный сервер можно с помощью команды `nc -v 127.0.0.1 24344`.

В запросе в единственной строке указывается путь к файлу, который нужно получить из директории `/tmp/files/`. Сервер должен вывести содержимое файла. Например, если в файле `/tmp/files/temp/test.txt` записано `Hello World!`, то на запрос `temp/test.txt` сервер должен отвечать `Hello World!`.

В целях безопасности у клиента не должно быть возможности прочесть произвольный файл. Например, на запрос `../../etc/passwd` (и `/etc/passwd` тоже) не должно выводиться содержимое файла `/etc/passwd`.

## Задание 6\. Работа с операционной системой Windows

### Подзадание 6-1\. Make

Реализуйте сокращенный аналог утилиты `make`.

Скрипт должен в качестве аргумента принимать один аргумент — цель, которую необходимо собрать. Скрипт должен найти файл `Makefile` в рабочей директории, который может состоять из одного или нескольких блоков следующего вида:

    target-name: dep1-name dep2-name
    	command1
    	command2
    	command3

Скрипт должен сначала собрать все зависимости (после двоеточия, разделены пробелами), а затем выполнить все команды блока. Строки с командами начинаются с символа табуляции (код 9). Блоки разделены пустыми строками. Гарантируется, что файл `Makefile` существует и соответствует указанному описанию, циклические зависимости отсутствуют.

### Подзадание 6-2\. Notification manager

Реализуйте сервис для получения уведомлений в Windows.

Заведите на сервере собственный пул уведомлений. У вас появится возможность добавить или изменить активное уведомление, а также URL для получения уведомления. По данному URL будет либо текст уведомления, если оно установлено, либо пустая строка.

Скрипт должен регулярно опрашивать данный ресурс, и в случае изменения активного уведомления вывести его на рабочем столе пользователя.

При запуске скрипта с аргументами `poll <URL_HERE>` он начинает опрос по переданному URL.

При запуске скрипта с аргументами `background <URL_HERE>`, он запускает опрос **в фоновом режиме** — то есть во время работы не показывается консольное окно.

При запуске скрипта без аргументов выведите справку по использованию.
