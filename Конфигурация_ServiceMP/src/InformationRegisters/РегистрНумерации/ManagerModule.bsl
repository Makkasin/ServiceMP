Функция СвободныйКод(МетаОбк) Экспорт
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ DISTINCT
	               |CASE WHEN ПОДСТРОКА(Номенклатура.Код, 2, 1)	= "" "" THEN ""        ""+ПОДСТРОКА(Номенклатура.Код, 1, 1)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 3, 1)	= "" "" THEN ""       ""+ПОДСТРОКА(Номенклатура.Код, 1, 2)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 4, 1)	= "" "" THEN ""      ""+ПОДСТРОКА(Номенклатура.Код, 1, 3)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 5, 1)	= "" "" THEN ""     ""+ПОДСТРОКА(Номенклатура.Код, 1, 4)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 6, 1)	= "" "" THEN ""    ""+ПОДСТРОКА(Номенклатура.Код, 1, 5)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 7, 1)	= "" "" THEN ""   ""+ПОДСТРОКА(Номенклатура.Код, 1, 6)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 8, 1)	= "" "" THEN ""  ""+ПОДСТРОКА(Номенклатура.Код, 1, 7)
	               |     WHEN ПОДСТРОКА(Номенклатура.Код, 9, 1)	= "" "" THEN "" ""+ПОДСТРОКА(Номенклатура.Код, 1, 8)
	               |	 ELSE ПОДСТРОКА(Номенклатура.Код, 1, 9) END Код
	               |	
	               |ИЗ
	               |	"+МетаОбк+" КАК Номенклатура
	               |ГДЕ
	               |	ПОДСТРОКА(Номенклатура.Код, 1, 1) В (""1"",""2"",""3"",""4"",""5"",""6"",""7"",""8"",""9"")
				   |ORDER BY Код";
				   
				   Тбл = Запрос.Выполнить().Выгрузить();
	//Тбл.Сортировать("Код");
	Для а=1 по Тбл.Количество() Цикл
		ПОпытка
			пЧс = Число(Тбл[а-1].Код);
		Исключение 
			Тбл.Удалить(Тбл[а-1]);
			а = а-1;
			продолжить;
		КонецПопытки;
			
		Если пЧс <> а ТОгда
		  //Сообщить("Код : "+Тбл[а-1].Код+" <> "+а);
			Возврат а-1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Тбл.Количество()+1;

	
	
КонецФункции

Процедура ЗаписатьПоследнийНомер(ОбкМета,ТекНомер=Неопределено) Экспорт
	
	Запись = РегистрыСведений.РегистрНумерации.СоздатьМенеджерЗаписи();
	Запись.ОбъектМета = ОбкМЕта;
	Если ТЕкНомер = Неопределено ТОгда
		Запись.Номер = СвободныйКод(ОбкМета);
	ИНаче
		Запись.Номер = ТекНомер;
	КонецЕСЛИ;
	Запись.Записать();
	
КонецПроцедуры

Функция ПолучитьНовыйНомер(ОбкМета)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегистрНумерации.Номер,
	               |	РегистрНумерации.ОбъектМета
	               |ИЗ
	               |	РегистрСведений.РегистрНумерации КАК РегистрНумерации
				   |WHERE ОбъектМета = &Обк";
				   Запрос.УстановитьПараметр("Обк",ОбкМета);
   Тбл =Запрос.Выполнить().Выгрузить();
   Если Тбл.Количество()=0 Тогда
	   ЗаписатьПоследнийНомер(ОбкМета);
	   Возврат ПолучитьНовыйНомер(ОбкМета);
   КонецЕСЛИ;
   
   ТекНомер = Формат(Тбл[0].Номер+1,"ЧГ=0");
   ВидСпр = Сред(ОбкМЕта,Найти(ОбкМЕта,".")+1);
   Если Не Справочники[ВидСпр].НайтиПоКоду(ТекНомер).Пустая() Тогда
	   ЗаписатьПоследнийНомер(ОбкМета);
	   Возврат ПолучитьНовыйНомер(ОбкМета);
   КонецЕСЛИ;
	   
	
   ЗаписатьПоследнийНомер(ОбкМета,ТекНомер);
   Возврат ТекНомер;
	
КонецФункции


Процедура ксНовыйНомерПриУстановкеНовогоКода(Источник, СтандартнаяОбработка, Префикс) Экспорт
	СтандартнаяОбработка = Ложь;
	
	пТип = XMLтипЗнч(Источник).ИмяТипа;
	пТип = СтрЗаменить(пТип,"CatalogObject","Справочник");
	пТип = СтрЗаменить(пТип,"DocumentObject","Документ");
	
	Источник.Код = РегистрыСведений.РегистрНумерации.ПолучитьНовыйНомер(пТип);
	
КонецПроцедуры

