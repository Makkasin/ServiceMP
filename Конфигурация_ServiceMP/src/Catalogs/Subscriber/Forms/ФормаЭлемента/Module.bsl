#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Сообщить("1");
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура Отправить(Команда)
	Структура = Новый Структура();
	Структура.Вставить("receiver", Объект.Код);
	Структура.Вставить("type", "text");
	Структура.Вставить("text", СокрЛП(ТекстСообщения));
	Структура.Вставить("sender",Новый Структура("name","urals bot"));
	
	глViber.ОтправитьЗапросНаСерверВайбера("send_message", Структура);

КонецПроцедуры
