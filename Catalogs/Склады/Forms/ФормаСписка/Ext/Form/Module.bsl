﻿
&НаКлиенте
Процедура ОбновитьСправочник(Команда)
	
	если ЗначениеЗаполнено(ФильтрОрганизация)=Ложь Тогда Возврат; КонецеСЛИ;
	
	глВыгрузкаДанных.ЗагрузитьНоменклатуруАлга("REFSKL",ФильтрОрганизация);
	Элементы.Список.Обновить();
	ФильтрОрганизацияПриИзменении();

КонецПроцедуры

&НаКлиенте
Процедура ФильтрОрганизацияПриИзменении(Элемент=Неопределено)
	Если ЗначениеЗаполнено(ЭтаФорма.ФильтрОрганизация) Тогда
		ОтборСпискаНаСервере(ЭтаФорма.ФильтрОрганизация,"Организация");
	ИНаче
		ОтборСпискаНаСервере(Неопределено,"Организация");
	КонецЕСЛИ;

КонецПроцедуры

&НаСервере
Процедура ОтборСпискаНаСервере(Зн=Неопределено,РекПоле = "Состояние")
	Поле = Новый ПолеКомпоновкиДанных(РекПоле);
	ТипГРп =  Тип("ГруппаЭлементовОтбораКомпоновкиДанных");
	//Для каждого Эл из список.Отбор.Элементы Цикл
	Для каждого Эл из список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(Эл) = ТипГРп ТОгда Продолжить; КонецеСЛИ;
		
		Если Эл.ЛевоеЗначение = поле ТОгда
			Если Зн = Неопределено  Тогда
				Эл.Использование = Ложь;
			ИНАче
				Эл.Использование = Истина;
				Эл.ПравоеЗначение = Зн;
			КонецеслИ;
		КонецесЛИ;
		
	КонецЦИкла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
КонецПроцедуры

