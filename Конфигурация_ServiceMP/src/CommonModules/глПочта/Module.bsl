
&НаСервере
Функция ПолучитьИнПрофиль(Отправитель,Пароль) экспорт

	Если ЗначениеЗаполнено(Отправитель)=Ложь ТОгда
		Отправитель="1C-sender@urals.pro";
		//Пароль="1!qqqqqq";
		Пароль="Vab63110"
	КонецЕСЛИ;
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;          
	Профиль.АдресСервераSMTP = "smtp.office365.com";
	
	Профиль.ПользовательSMTP = Отправитель;//"1C-sender@urals.pro";
	Профиль.ПарольSMTP = Пароль;//"1!qqqqqq";
	
	Профиль.ПортSMTP = 587;
    Профиль.ИспользоватьSSLSMTP = Ложь;
    Профиль.ТолькоЗащищеннаяАутентификацияSMTP = Истина;
	Возврат Профиль;
	
КонецФункции

&НаСервере
Процедура ДобавитьПолучателяВПисьмо(пПолучатель, пКудаДобавить)
	// + Алексей, парсинг адресов через ';' и ','
	Если СтрНайти(пПолучатель, ";") <> 0 Или СтрНайти(пПолучатель, ",") <> 0 Тогда
		мМультистрока = СтрЗаменить(СтрЗаменить(пПолучатель, ";", ","), ",", Символы.ПС);
		Для Итр = 1 По СтрЧислоСтрок(мМультистрока) Цикл
			мАдрес = СтрПолучитьСтроку(мМультистрока, Итр);
			Если СокрЛП(мАдрес) <> "" Тогда
				пКудаДобавить.Добавить(мАдрес);
			КонецЕсли;
		КонецЦикла;
	Иначе
		пКудаДобавить.Добавить(пПолучатель);
	КонецЕсли;
КонецПроцедуры

//															Пароль="1!qqqqqq"
&НаСервере
Функция Почта(Получатель,Отправитель="1C-sender@urals.pro",Пароль="Vab63110",Тема,Текст,ПутьВложения="",Копии="",ТипТекста = Неопределено,ИмяВложения="") Экспорт
	
	ИнПрофиль = ПолучитьИнПрофиль(Отправитель,Пароль);
	
	Если СокрЛП(Получатель)="" Тогда
		Сообщить("Не задан адрес получателя!");
		Возврат Ложь;
	КонецЕСЛИ;
	
	Если ЗначениеЗаполнено(ТипТекста)=Ложь Тогда
		Если ВРЕГ(Лев(Текст,14)) = "<!DOCTYPE HTML" Тогда
			ТипТекста = ТипТекстаПочтовогоСообщения.HTML;	
		КонецеСЛИ;
	КонецЕСли;
	
	
	//Отправим почту
	
	Письмо=Новый ИнтернетПочтовоеСообщение;
	Если ТипЗнч(Получатель) = Тип("Массив") Тогда
		Для каждого Эл из Получатель Цикл
			ДобавитьПолучателяВПисьмо(Эл, Письмо.Получатели);
		КонецЦиклА;
	ИНаче
		ДобавитьПолучателяВПисьмо(Получатель, Письмо.Получатели);
	КонецЕСЛИ;
	
	ЕСли Копии<>"" ТОгда
		ДобавитьПолучателяВПисьмо(Копии, Письмо.Копии);
	КонецЕсЛИ;
	
	Если ТипЗнч(ПутьВложения) = Тип("Соответствие")  Тогда
		Для каждого элВлж из ПутьВложения Цикл
			Письмо.Вложения.Добавить(элВлж.Значение,элВлж.Ключ);
		КонецЦикла;
	ИНАчеЕсли СокрЛП(ПутьВложения)<>"" Тогда
		Письмо.Вложения.Добавить(ПутьВложения,ИмяВложения);
	КонецЕСЛИ;
	
	Письмо.ИмяОтправителя=Отправитель;//+"@yandex.ru";//"@mail.ru";
	Письмо.Отправитель=Отправитель;//+"@yandex.ru";//"@mail.ru";
	Письмо.Кодировка="windows-1251";
	Письмо.Тема=Тема;
	Если ТипТекста=Неопределено ТОгда
		Письмо.Тексты.Добавить(Текст);
	ИНаче
		Письмо.Тексты.Добавить(Текст,ТипТекста);
	КонецЕСЛИ;
	
	ИнПочта=Новый ИнтернетПочта;
	ИнПочта.Подключиться(ИнПрофиль);
	ИнПочта.Послать(Письмо);
	//Сообщить("Почта отправлена!");
	ИнПочта.Отключиться();
	
	Письмо = Неопределено;
	
	Возврат Истина;

КонецФункции
