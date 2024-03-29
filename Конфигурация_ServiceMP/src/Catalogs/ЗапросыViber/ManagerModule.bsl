Функция ПолучитьПолеКлиентJIRA()
	Возврат "customfield_10028";
КонецФункции


Процедура ОбработкаJIRA(Обк,Соо)
	
	поля = Соо.Получить("fields");
	Если поля=Неопределено Тогда
		Обк.Комментарий = "Ошибка поиска полей!";
		Обк.Записать();
		Возврат;
	КонецЕСЛИ;
	
	емайл = поля.получить(ПолучитьПолеКлиентJIRA());
	Если емайл=Неопределено Тогда
		Обк.Комментарий = "Не найдено поле клиент: "+ПолучитьПолеКлиентJIRA();
		Обк.Записать();
		Возврат;
	КонецЕСЛИ;
	
	//Проверим корректность емайла
	п1 = Найти(емайл,"@");
	Если п1=0 или НАйти(Сред(емайл,п1),".")=0 ТОгда
		Обк.Комментарий = "Некорректный емайл "+емайл;
		Обк.Записать();
		Возврат;
	КонецеСЛИ;
	
	//Статус
	мСтатус = поля.получить("status");
	Если мСтатус=Неопределено Тогда
		Обк.Комментарий = "Не найдено поле status";
		Обк.Записать();
		Возврат;
	КонецЕСЛИ;
	Статус   = СокрЛП(мСтатус.Получить("description"));
	Если Статус = "" Тогда
		Статус   = мСтатус.Получить("name");
	КонецЕСЛИ;
	Описание = поля.Получить("description");
	
	Заголовок = поля.получить("summary");
	
	мИсп = поля.Получить("assignee");
	Исполнитель = "";
	Если мИсп<>Неопределено Тогда
		Исполнитель = мИсп.Получить("displayName");
	КонецЕСЛИ;
	
	//комметарии
	мКом0 = поля.получить("comment");
	Коммент = "";
	КомментЗгл = "";
	Если мКом0 <> Неопределено Тогда
		Для каждого эл из мКом0.Получить("comments") Цикл
			Коммент = Коммент+(Дата(1970,1,1)+Число(эл.Получить("created"))/1000 + 3600*5)+" - "+эл.Получить("body")+Символы.ПС;		
		КонецЦикла;
	КонецЕСЛИ;
	Если Коммент<>"" Тогда
		КомментЗгл = "Комментарии :";
	КонецеСЛИ;
	
	
	
	Текст =  "<!DOCTYPE html>
|<html>
|<head>
|	<title>be1.ru</title>
|</head>
|<body>
|<p><strong>Изменилось состояние :</strong> <span style=""color:#2980b9"">"+Статус+" </span></p>
|
|
|<p><strong>Задание :</strong> <span style=""color:#2980b9"">"+Заголовок+"</span></p>
|
|<p><strong>Описание задания :</strong> <span style=""color:#2980b9"">"+Описание+"</span></p>
|
|<p><strong>Исполнитель :</strong> <span style=""color:#2980b9"">"+Исполнитель+" </span></p>
|
|<p><strong>"+КомментЗгл+"</strong> <span style=""color:#2980b9"">"+Коммент+" </span></p>
|<hr />
|
|<p>&nbsp;</p>
|
|</body>
|</html>
|";
	
	
	Если глПочта.Почта(емайл,,,"Изменение состояния задачи 1с",Текст,,,ТипТекстаПочтовогоСообщения.HTML) ТОгда
		Обк.Комментарий = "Почта отправлена "+емайл;
	КонецЕСЛИ;
	
	  Обк.Обработан = Истина;
	  Обк.Записать();
	  
	  
	  ТБл =  глViber.НайтиПодписчиков(емайл);
	  Если Тбл.Количество()<>0 Тогда
		  Текст = "Задача 1с
		  |Изменилось состояние : "+Статус+"
		  |
		  |Задание:
		  | "+Заголовок+"
		  |
		  |Описание:
		  | "+Описание+"
		  |
		  |Исполнитель:
		  |"+Исполнитель+"
		  |"+КомментЗгл+" "+Коммент;
		  Для каждого Стр из Тбл Цикл
			  глViber.ОтправитьТекстовоеСообщение(Стр.Ссылка,Текст);
		  КонецЦикла;
	  КонецЕСЛИ;
	
	
КонецПроцедуры


Процедура ОбрабратботкаПринятогоСообщения(сс) Экспорт
	
	Обк = сс.ПолучитьОбъект();
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(Обк.Тело);
	Попытка
		Стк = ПрочитатьJSON(Чтение,Истина);
	Исключение
		Обк.Комментарий = ОписаниеОшибки();
		Обк.Записать();
		Возврат;
	КонецПопытки;
	
	Если Найти(ОБк.Тело,"atlassian.net/rest/api/")<>0 Тогда
		ОБработкаJIRA(Обк,Стк);
		return;
	КонецЕсли;
	
	
	
	Если Стк.Получить("event")=Неопределено Тогда Возврат; КонецЕСЛи;
	
	Если    Стк.Получить("event") = "message" Тогда
		ОбработкаMessage(Обк,Стк);
	ИначеЕсли  Стк.Получить("event") = "conversation_started" Тогда
		Стк.Вставить("sender",Стк.Получить("user"));
		ОбработкаMessage(Обк,Стк);
	ИНаче
		Обк.ОБработан=Истина;
		Обк.Записать();
		Возврат;
	КонецеслИ;
	
	
	
	
КонецПроцедуры

#Область Viber

Процедура ОбработкаMessage(Обк,Стк)
	
	ЭтоНовый = Ложь;
	ссSub = НайтиSubscriber(Стк.Получить("sender"),ЭтоНовый);
	Если ЭтоНовый Тогда
		тхт = "Вы не зарегистрированы в системе. Для регистрации пришлите серию и номер Вашего паспорта или емайл, который вы указали для получения Расчетного листа";
		глViber.ОтправитьТекстовоеСообщение(ссSub,тхт);
		
	ИНачеЕсли ссSub.Зарегистрирован Тогда
		глViber.ОтправитьТекстовоеСообщение(ссSub,Справочники.Subscriber.ДанныеОПодписчике(ссSub));
		
	ИНачеЕсли СокрЛП(ссSub.кодРегистрации)<>"" ТОгда
		ПроверкаКодаЗапросаНаРегистрацию(ссSub,Стк);
	ИНаче
		ПроверкаЗапросаНаРегистрацию(ссSub,Стк);
	КонецЕсли;
	
	Обк.Обработан = Истина;
	Обк.Записать();
	

КонецПроцедуры

Процедура ПроверкаКодаЗапросаНаРегистрацию(ссSub,Стк)
	Если Стк.Получить("message").Получить("type") <> "text" Тогда
		глViber.ОтправитьТекстовоеСообщение(ссSub,"Пришлите, пожалуйста, ответ в текстовом формате");
		Возврат;
	КонецесЛИ;
	
	//Проверка по времени действия кода
	Если ТекущаяДата() - ссSub.датаКодаРегистрации > 60*15 Тогда
		глViber.ОтправитьТекстовоеСообщение(ссSub,"Истек срок действия кода регистрации. Вам на email отправлен новый код регистрации.");
		ОтправитьКодРегистрации(ссSub);
		Возврат;
	КонецеСЛИ;
	
	
	тхт = СокрЛП(Стк.Получить("message").Получить("text"));
	тхт = СтрЗаменить(тхт," ",Символы.ПС);
	Код = СокрЛП(ссSub.кодРегистрации);
	
	Для а=1 по СтрЧислоСтрок(тхт) Цикл
		Если код = СтрПолучитьСтроку(тхт,а) Тогда
			Обк = ссSub.ПолучитьОБъект();
			Обк.Зарегистрирован = Истина;
			Обк.Записать();
			глViber.ОтправитьТекстовоеСообщение(ссSub,"Вы успешно зарегистрированы!");
			Возврат;
		КонецеСЛИ;
	КонецЦиклА;
	
	глViber.ОтправитьТекстовоеСообщение(ссSub,"Неверный код регистрации");
	
КонецПроцедуры


Процедура ПроверкаЗапросаНаРегистрацию(ссSub,Стк)
	Если Стк.Получить("message").Получить("type") <> "text" Тогда
		глViber.ОтправитьТекстовоеСообщение(ссSub,"Пришлите, пожалуйста, ответ в текстовом формате");
		Возврат;
	КонецесЛИ;
	
	тхт = СокрЛП(Стк.Получить("message").Получить("text"));
	рез = ОпределитьЕмайл(Тхт,ссSub);
	Если рез=-1 Тогда
		глViber.ОтправитьТекстовоеСообщение(ссSub,"В кадровой базе данных Сотрудник с таким email не найден. Проверьте правильность присланного сообщения и пришлите повторно. Либо свяжитесь с кадровой службой Вашего предприятия");
		Возврат;
	ИНачеЕсли Рез=0 Тогда
		Рез = ОпределитьПаспорт(Тхт,ссSub);
		Если рез=-1 Тогда
			глViber.ОтправитьТекстовоеСообщение(ссSub,"В кадровой базе данных Сотрудник с таким паспортом не найден. Проверьте правильность присланного сообщения и пришлите повторно. Либо свяжитесь с кадровой службой Вашего предприятия");
			Возврат;
		ИНАчеЕсли рез=-2 Тогда
			глViber.ОтправитьТекстовоеСообщение(ссSub,"Для сотрудника "+ссSub.ФИО+" не задан email для информирования. Обратитесь в кадровую службу Вашего предприятия.");
			Возврат;
		ИНАчеЕсли рез=0 Тогда
			глViber.ОтправитьТекстовоеСообщение(ссSub,"Ошибка определения данных паспорта или email. Проверьте правильность присланного сообщения и пришлите повторно. Либо свяжитесь с кадровой службой Вашего предприятия");
			Возврат;
		КонецЕСЛИ;
	КонецесЛИ;
	
	ОтправитьКодРегистрации(ссSub);
	
КонецПроцедуры

Процедура ОтправитьКодРегистрации(ссSub)
	
	
	//ГСЧ = Новый ГенераторСлучайныхЧисел(255);  ФормаТ(ГСЧ.СлучайноеЧисло(0, 10000),"ЧРГ=' '; ЧГ=0");
	п = Лев(Формат(ЦЕЛ(Число(Формат(ТекущаяДата(),"ДФ=ssmmdMMHH"))/1019),"ЧГ=0"),4);

	Обк = ссSub.ПолучитьОбъект();
	Обк.кодРегистрации = п;
	Обк.датаКодаРегистрации = ТекущаяДата();
	Обк.Записать();
	
	глПочта.Почта(Обк.email,,,"Код регистрации в системе Viber","Код для регистрации в системе Viber: "+Обк.кодРегистрации);
	
	глViber.ОтправитьТекстовоеСообщение(ссSub,"На Ваш email отправлен код подтверждения регистрации. Отправьте этот код через Viber для подтверждения регистрации");
	
КонецПроцедуры

Функция  ОпределитьЕмайл(Тхт,ссSub) 
	
	Если Найти(тхт,"@")=0 тогда Возврат 0; КонецеСли;
	
	пСтр = СтрЗаменить(Тхт," ",Символы.ПС);
	Для а=1 по СтрЧислоСтрок(пСтр) Цикл
		п = СтрПолучитьСтроку(пСтр,а);
		Если Найти(п,"@")<>0 Тогда
			СткФЛ = глViber.НайтиФЛпоЕмайлу(п);
			Если сткФЛ = Неопределено Тогда
				Возврат -1;	
			Иначе
				обк = ссSub.ПолучитьОбъект();
				Обк.Паспорт = СткФЛ.Паспорт;
				Обк.email   = СткФЛ.емайл;
				Обк.ФИО     = СткФЛ.ФИО;
				Обк.идФЛ    = СткФЛ.idFL;
				Обк.Записать();
				Возврат 1;
			КонецеСЛИ;
		КонецЕслИ;
	Конеццикла;
	
	Возврат 0;
	
КонецФункции

Функция  ОпределитьПаспорт(Тхт,ссSub) 
	
	Рез="";
	
	пСтр = СтрЗаменить(Тхт," ","");
	Для а=1 по СтрДлина(пСтр) Цикл
		п = Сред(пСтр,а,1);
		Если Найти("1234567890",п)=0 ТОгда
			Рез="";
		ИНаче
			Рез = Рез+п;
			Если СтрДлина(Рез)=10 Тогда
				СткФЛ = глViber.НайтиФЛпоПаспорту(Рез);
				Если сткФЛ = Неопределено Тогда
					Возврат -1;	
					
				Иначе
					обк = ссSub.ПолучитьОбъект();
					Обк.Паспорт = СткФЛ.Паспорт;
					Обк.email   = СткФЛ.емайл;
					Обк.ФИО     = СткФЛ.ФИО;
					Обк.идФЛ    = СткФЛ.idFL;
					Обк.Записать();
					
					Если СокрлП(СткФЛ.емайл)="" Тогда
						Возврат -2;
					ИНАче
						Возврат 1;
					КонецЕСЛИ;
					
				КонецеСЛИ;
			КонецЕсЛИ;
		КонецЕСЛИ;
	КонецЦикла;
	
	
	Возврат 0;
	
КонецФункции

Функция НайтиSubscriber(Стк,ЭтоНовый)
	
	сс = Справочники.Subscriber.НайтиПоКоду(Стк.Получить("id"));
	ЕСли сс.Пустая() ТОгда
		Обк = Справочники.Subscriber.СоздатьЭлемент();
		Обк.Код = Стк.Получить("id");
		Обк.Наименование = Стк.ПОлучить("name");
		Обк.avatar = Стк.ПОлучить("avatar");
		Обк.Записать();
		сс = обк.ссылка;
		ЭтоНовый = Истина;
	КонецЕСЛИ;
	
	Возврат сс;
	
	
КонецФункции

#КонецОбласти