#Использовать v8runner
#Использовать cmdline

Перем СЕРВЕР;
Перем СЕРВЕР_ПОРТ;
Перем БАЗА;
Перем ЭТО_ФАЙЛОВАЯ_БАЗА;
Перем ПОЛЬЗОВАТЕЛЬ;
Перем ПАРОЛЬ;
Перем ПЛАТФОРМА_ВЕРСИЯ;
Перем ИМЯ_РАСШИРЕНИЯ;
Перем КАТАЛОГ_ХРАНИЛИЩА;
Перем ЮЗЕР_ХРАНИЛИЩА;
Перем ПАРОЛЬ_ХРАНИЛИЩА;

Перем Конфигуратор;
Перем Лог;

Функция Инициализация()

    Парсер = Новый ПарсерАргументовКоманднойСтроки();
    Парсер.ДобавитьИменованныйПараметр("-platform");
    Парсер.ДобавитьИменованныйПараметр("-server");
    Парсер.ДобавитьИменованныйПараметр("-base");
    Парсер.ДобавитьИменованныйПараметр("-user");
    Парсер.ДобавитьИменованныйПараметр("-passw");
    Парсер.ДобавитьИменованныйПараметр("-repofolder");
    Парсер.ДобавитьИменованныйПараметр("-extension");
    Парсер.ДобавитьИменованныйПараметр("-repouser");
    Парсер.ДобавитьИменованныйПараметр("-repopwd");

    Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);
    
    ПЛАТФОРМА_ВЕРСИЯ  = Параметры["-platform"];//"8.3.10.2639"; // если пустая строка, то будет взята последняя версия
    СЕРВЕР            =  Параметры["-server"];
    СЕРВЕР_ПОРТ       = 1541; // 1541 - по умолчанию
    БАЗА              = Параметры["-base"];
    ЭТО_ФАЙЛОВАЯ_БАЗА = Не ЗначениеЗаполнено(СЕРВЕР);
    ПОЛЬЗОВАТЕЛЬ      = Параметры["-user"];
    ПАРОЛЬ            = Параметры["-passw"];
    ИМЯ_РАСШИРЕНИЯ    = Параметры["-extension"];
    КАТАЛОГ_ХРАНИЛИЩА = Параметры["-repofolder"];
    ЮЗЕР_ХРАНИЛИЩА    = Параметры["-repouser"];
    ПАРОЛЬ_ХРАНИЛИЩА  = Параметры["-repopwd"];

    //ПЛАТФОРМА_ВЕРСИЯ  = "8.3.12.1685";
    //СЕРВЕР            = "devadapter";
    //СЕРВЕР_ПОРТ       = 1541; // 1541 - по умолчанию
    //БАЗА              = "rkudakov_adapter_adapter";
    //ЭТО_ФАЙЛОВАЯ_БАЗА = Не ЗначениеЗаполнено(СЕРВЕР);
    //ПОЛЬЗОВАТЕЛЬ      = "Administrator";
    //ПАРОЛЬ            = "111";
    //ИМЯ_РАСШИРЕНИЯ    = "ext1";
    //КАТАЛОГ_ХРАНИЛИЩА = "tcp://storage1c.bit-erp.loc:2542/testrepo";
    //ЮЗЕР_ХРАНИЛИЩА = "auto";
    //ПАРОЛЬ_ХРАНИЛИЩА = "111";

    Конфигуратор = Новый УправлениеКонфигуратором();
    Конфигуратор.УстановитьКонтекст(СтрокаСоединенияИБ(), ПОЛЬЗОВАТЕЛЬ, ПАРОЛЬ);
    Конфигуратор.ИспользоватьВерсиюПлатформы(ПЛАТФОРМА_ВЕРСИЯ);

    Лог = Логирование.ПолучитьЛог("createExtensionRepo");

    ЛОГ.Отладка("СЕРВЕР = " + СЕРВЕР);
    ЛОГ.Отладка("ПЛАТФОРМА_ВЕРСИЯ = " + ПЛАТФОРМА_ВЕРСИЯ);

КонецФункции

Функция СоздатьХранилищеДляРасширения()

    ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();

    ПараметрыЗапуска.Добавить("/ConfigurationRepositoryF """ + КАТАЛОГ_ХРАНИЛИЩА + """");
    ПараметрыЗапуска.Добавить("/ConfigurationRepositoryN """ + ЮЗЕР_ХРАНИЛИЩА + """");
    ПараметрыЗапуска.Добавить("/ConfigurationRepositoryP """ + ПАРОЛЬ_ХРАНИЛИЩА + """");
    ПараметрыЗапуска.Добавить("/ConfigurationRepositoryCreate ");
    ПараметрыЗапуска.Добавить("-AllowConfigurationChanges");
    ПараметрыЗапуска.Добавить("-ChangesAllowedRule ObjectIsEditableSupportEnabled");
    ПараметрыЗапуска.Добавить("-ChangesNotRecommendedRule ObjectNotEditable");
    ПараметрыЗапуска.Добавить("-Extension " + ИМЯ_РАСШИРЕНИЯ);
    
    Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);

КонецФункции

Функция СтрокаСоединенияИБ() 
    Если ЭТО_ФАЙЛОВАЯ_БАЗА Тогда
        Возврат "/F" + БАЗА; 
    Иначе   
        Возврат "/IBConnectionString""Srvr=" + СЕРВЕР + ?(ЗначениеЗаполнено(СЕРВЕР_ПОРТ),":" + СЕРВЕР_ПОРТ,"") + ";Ref='"+ БАЗА + "'""";
    КонецЕсли;
КонецФункции

Инициализация();
Лог.Информация("Creating storage for extension...");
СоздатьХранилищеДляРасширения();
Лог.Информация("Sucessfuly xreated storage for extension");