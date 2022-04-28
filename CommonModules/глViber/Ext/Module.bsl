Функция ПолучитьСтруктуруСообщения(СтруктураПараметров = Неопределено)
	
	КлючАПИ = "4afd762813a7de20-fb4587015db3af0a-701c864a8148b712";
	Админ = "stL+dIfHmFdneswK5G0uiA==";
	
	СтруктураНастроек = Новый Структура();
	СтруктураНастроек.Вставить("auth_token", КлючАПИ);
	СтруктураНастроек.Вставить("from", Админ);
	
	Если СтруктураПараметров <> Неопределено Тогда
		Для Каждого стрПараметр Из СтруктураПараметров Цикл
			СтруктураНастроек.Вставить(стрПараметр.Ключ, стрПараметр.Значение);
		КонецЦикла;
	КонецЕсли; 
		
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтруктураНастроек);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Функция ОтправитьЗапросНаСерверВайбера(ИмяКоманды, СтруктураПараметров = Неопределено) Экспорт
	
	Сервер = "chatapi.viber.com";
	
	ТелоЗапроса = ПолучитьСтруктуруСообщения(СтруктураПараметров);	
	Соединение 	= Новый HTTPСоединение(Сервер,,,,Новый ИнтернетПрокси(истина),5, Новый ЗащищенноеСоединениеOpenSSL);
	Запрос 		= Новый HTTPЗапрос("pa/"+ИмяКоманды);
	Если ТелоЗапроса <> Неопределено Тогда
		Запрос.Заголовки.Вставить("Content-Type","application/json");
		Запрос.УстановитьТелоИзСтроки(ТелоЗапроса, "UTF-8");
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Иначе
		Ответ = Соединение.Получить(Запрос);
	КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	ОтветСтрокой = Ответ.ПолучитьТелоКакСтроку(); 
	Чтение.УстановитьСтроку(ОтветСтрокой);
	Результат = ПрочитатьJSON(Чтение);
	
	Возврат Результат;

КонецФункции  

Процедура ОтправитьТекстовоеСообщение(subs,Сообщение) Экспорт
	
	Структура = Новый Структура();
	Структура.Вставить("receiver", subs.код);
	Структура.Вставить("type", "text");
	Структура.Вставить("text", Сообщение);
	Структура.Вставить("sender",Новый Структура("name","urals bot"));
	
	ОтправитьЗапросНаСерверВайбера("send_message", Структура);
	
	
КонецПроцедуры


Функция НайтиДанныеEmployees(ТекстЗапроса)
	Соединение = глОбщий.ПолучитьСоединениеAZURESQL();
	Записи=Новый ComObject("ADODB.RecordSet");
	Записи.Open(ТекстЗапроса,Соединение);
	
	Рез = Неопределено;
	Если Записи.EOF() = 0 ТОгда 
		ФИО   = Сокрлп(Записи.Fields("descrFL").Value);
		емайл   = Сокрлп(Записи.Fields("email").Value);
		паспорт = Сокрлп(Записи.Fields("passport").Value);
		idFL = Сокрлп(Записи.Fields("idFL").Value);
		
		Рез = Новый Структура("ФИО,емайл,паспорт,idFL",ФИО,емайл,паспорт,idFL);
		 
	КонецЕсли; 
	
	Записи.Close(); 
	Соединение.Close(); 
	
	
	Возврат Рез;
	
	
КонецФункции


Функция НайтиФЛпоЕмайлу(емайл) Экспорт
	
	ТекстЗапроса = "
	|select * from employees where email = N'"+СокрЛП(НРЕГ(емайл))+"'
	|
	|";
	
	Возврат НайтиДанныеEmployees(ТекстЗапроса);
	
КонецФункции


Функция НайтиФЛпоПаспорту(СерияНомерПаспорта) Экспорт
	
	ТекстЗапроса = "
	|select * from employees where passport = N'"+СокрЛП(СерияНомерПаспорта)+"'
	|
	|";
	
	Возврат НайтиДанныеEmployees(ТекстЗапроса);
КонецФункции

#Область АЗУР

Функция ТекущаяДатаGMT();
	
	Дата=УниверсальноеВремя(ТекущаяДата());     
	ДениНедели = Новый Соответствие;
	ДениНедели.Вставить(1,"Mon");
	ДениНедели.Вставить(2,"Tue");
	ДениНедели.Вставить(3,"Wed");
	ДениНедели.Вставить(4,"Thu");
	ДениНедели.Вставить(5,"Fri");
	ДениНедели.Вставить(6,"Sat");
	ДениНедели.Вставить(7,"Sun");	
	
	Возврат XMLСтрока(ДениНедели.Получить(ДеньНедели(Дата))+", "+Формат(Дата,"Л=en; ДФ='dd MMM yyyy HH:mm:ss'")+" GMT");
	
КонецФункции

Функция ПолучитьMIMEФайла(Расширение)
	
	
	ТипыФайлов = Новый Соответствие;
	
	
	
	ТипыФайлов.Вставить(".123","application/vnd.lotus-1-2-3");               //Lotus 1-2-3
	ТипыФайлов.Вставить(".3dml","text/vnd.in3d.3dml");               //In3D - 3DML
	ТипыФайлов.Вставить(".3g2","video/3gpp2");               //3GP2
	ТипыФайлов.Вставить(".3gp","video/3gpp");               //3GP
	ТипыФайлов.Вставить(".7z","application/x-7z-compressed");               //7-Zip
	ТипыФайлов.Вставить(".aab","application/x-authorware-bin");               //Adobe (Macropedia) Authorware - Binary File
	ТипыФайлов.Вставить(".aac","audio/x-aac");               //Advanced Audio Coding (AAC)
	ТипыФайлов.Вставить(".aam","application/x-authorware-map");               //Adobe (Macropedia) Authorware - Map
	ТипыФайлов.Вставить(".aas","application/x-authorware-seg");               //Adobe (Macropedia) Authorware - Segment File
	ТипыФайлов.Вставить(".abw","application/x-abiword");               //AbiWord
	ТипыФайлов.Вставить(".ac","application/pkix-attr-cert");               //Attribute Certificate
	ТипыФайлов.Вставить(".acc","application/vnd.americandynamics.acc");               //Active Content Compression
	ТипыФайлов.Вставить(".ace","application/x-ace-compressed");               //Ace Archive
	ТипыФайлов.Вставить(".acu","application/vnd.acucobol");               //ACU Cobol
	ТипыФайлов.Вставить(".adp","audio/adpcm");               //Adaptive differential pulse-code modulation
	ТипыФайлов.Вставить(".aep","application/vnd.audiograph");               //Audiograph
	ТипыФайлов.Вставить(".afp","application/vnd.ibm.modcap");               //MO:DCA-P
	ТипыФайлов.Вставить(".ahead","application/vnd.ahead.space");               //Ahead AIR Application
	ТипыФайлов.Вставить(".ai","application/postscript");               //PostScript
	ТипыФайлов.Вставить(".aif","audio/x-aiff");               //Audio Interchange File Format
	ТипыФайлов.Вставить(".air","application/vnd.adobe.air-application-installer-package+zip");               //Adobe AIR Application
	ТипыФайлов.Вставить(".ait","application/vnd.dvb.ait");               //Digital Video Broadcasting
	ТипыФайлов.Вставить(".ami","application/vnd.amiga.ami");               //AmigaDE
	ТипыФайлов.Вставить(".apk","application/vnd.android.package-archive");               //Android Package Archive
	ТипыФайлов.Вставить(".application","application/x-ms-application");               //Microsoft ClickOnce
	ТипыФайлов.Вставить(".apr","application/vnd.lotus-approach");               //Lotus Approach
	ТипыФайлов.Вставить(".asf","video/x-ms-asf");               //Microsoft Advanced Systems Format (ASF)
	ТипыФайлов.Вставить(".aso","application/vnd.accpac.simply.aso");               //Simply Accounting
	ТипыФайлов.Вставить(".atc","application/vnd.acucorp");               //ACU Cobol
	ТипыФайлов.Вставить(".atom, .xml","application/atom+xml");               //Atom Syndication Format
	ТипыФайлов.Вставить(".atomcat","application/atomcat+xml");               //Atom Publishing Protocol
	ТипыФайлов.Вставить(".atomsvc","application/atomsvc+xml");               //Atom Publishing Protocol Service Document
	ТипыФайлов.Вставить(".atx","application/vnd.antix.game-component");               //Antix Game Player
	ТипыФайлов.Вставить(".au","audio/basic");               //Sun Audio - Au file format
	ТипыФайлов.Вставить(".avi","video/x-msvideo");               //Audio Video Interleave (AVI)
	ТипыФайлов.Вставить(".aw","application/applixware");               //Applixware
	ТипыФайлов.Вставить(".azf","application/vnd.airzip.filesecure.azf");               //AirZip FileSECURE
	ТипыФайлов.Вставить(".azs","application/vnd.airzip.filesecure.azs");               //AirZip FileSECURE
	ТипыФайлов.Вставить(".azw","application/vnd.amazon.ebook");               //Amazon Kindle eBook format
	ТипыФайлов.Вставить(".bcpio","application/x-bcpio");               //Binary CPIO Archive
	ТипыФайлов.Вставить(".bdf","application/x-font-bdf");               //Glyph Bitmap Distribution Format
	ТипыФайлов.Вставить(".bdm","application/vnd.syncml.dm+wbxml");               //SyncML - Device Management
	ТипыФайлов.Вставить(".bed","application/vnd.realvnc.bed");               //RealVNC
	ТипыФайлов.Вставить(".bh2","application/vnd.fujitsu.oasysprs");               //Fujitsu Oasys
	ТипыФайлов.Вставить(".bin","application/octet-stream");               //
	ТипыФайлов.Вставить(".bmi","application/vnd.bmi");               //BMI Drawing Data Interchange
	ТипыФайлов.Вставить(".bmp","image/bmp");               //Bitmap Image File
	ТипыФайлов.Вставить(".box","application/vnd.previewsystems.box");               //Preview Systems ZipLock/VBox
	ТипыФайлов.Вставить(".btif","image/prs.btif");               //BTIF
	ТипыФайлов.Вставить(".bz","application/x-bzip");               //Bzip Archive
	ТипыФайлов.Вставить(".bz2","application/x-bzip2");               //Bzip2 Archive
	ТипыФайлов.Вставить(".c","text/x-c");               //C Source File
	ТипыФайлов.Вставить(".c11amc","application/vnd.cluetrust.cartomobile-config");               //ClueTrust CartoMobile - Config
	ТипыФайлов.Вставить(".c11amz","application/vnd.cluetrust.cartomobile-config-pkg");               //ClueTrust CartoMobile - Config Package
	ТипыФайлов.Вставить(".c4g","application/vnd.clonk.c4group");               //Clonk Game
	ТипыФайлов.Вставить(".cab","application/vnd.ms-cab-compressed");               //Microsoft Cabinet File
	ТипыФайлов.Вставить(".car","application/vnd.curl.car");               //CURL Applet
	ТипыФайлов.Вставить(".cat","application/vnd.ms-pki.seccat");               //Microsoft Trust UI Provider - Security Catalog
	ТипыФайлов.Вставить(".ccxml","application/ccxml+xml,");               //Voice Browser Call Control
	ТипыФайлов.Вставить(".cdbcmsg","application/vnd.contact.cmsg");               //CIM Database
	ТипыФайлов.Вставить(".cdkey","application/vnd.mediastation.cdkey");               //MediaRemote
	ТипыФайлов.Вставить(".cdmia","application/cdmi-capability");               //Cloud Data Management Interface (CDMI) - Capability
	ТипыФайлов.Вставить(".cdmic","application/cdmi-container");               //Cloud Data Management Interface (CDMI) - Contaimer
	ТипыФайлов.Вставить(".cdmid","application/cdmi-domain");               //Cloud Data Management Interface (CDMI) - Domain
	ТипыФайлов.Вставить(".cdmio","application/cdmi-object");               //Cloud Data Management Interface (CDMI) - Object
	ТипыФайлов.Вставить(".cdmiq","application/cdmi-queue");               //Cloud Data Management Interface (CDMI) - Queue
	ТипыФайлов.Вставить(".cdx","chemical/x-cdx");               //ChemDraw eXchange file
	ТипыФайлов.Вставить(".cdxml","application/vnd.chemdraw+xml");               //CambridgeSoft Chem Draw
	ТипыФайлов.Вставить(".cdy","application/vnd.cinderella");               //Interactive Geometry Software Cinderella
	ТипыФайлов.Вставить(".cer","application/pkix-cert");               //Internet Public Key Infrastructure - Certificate
	ТипыФайлов.Вставить(".cgm","image/cgm");               //Computer Graphics Metafile
	ТипыФайлов.Вставить(".chat","application/x-chat");               //pIRCh
	ТипыФайлов.Вставить(".chm","application/vnd.ms-htmlhelp");               //Microsoft Html Help File
	ТипыФайлов.Вставить(".chrt","application/vnd.kde.kchart");               //KDE KOffice Office Suite - KChart
	ТипыФайлов.Вставить(".cif","chemical/x-cif");               //Crystallographic Interchange Format
	ТипыФайлов.Вставить(".cii","application/vnd.anser-web-certificate-issue-initiation");               //ANSER-WEB Terminal Client - Certificate Issue
	ТипыФайлов.Вставить(".cil","application/vnd.ms-artgalry");               //Microsoft Artgalry
	ТипыФайлов.Вставить(".cla","application/vnd.claymore");               //Claymore Data Files
	ТипыФайлов.Вставить(".class","application/java-vm");               //Java Bytecode File
	ТипыФайлов.Вставить(".clkk","application/vnd.crick.clicker.keyboard");               //CrickSoftware - Clicker - Keyboard
	ТипыФайлов.Вставить(".clkp","application/vnd.crick.clicker.palette");               //CrickSoftware - Clicker - Palette
	ТипыФайлов.Вставить(".clkt","application/vnd.crick.clicker.template");               //CrickSoftware - Clicker - Template
	ТипыФайлов.Вставить(".clkw","application/vnd.crick.clicker.wordbank");               //CrickSoftware - Clicker - Wordbank
	ТипыФайлов.Вставить(".clkx","application/vnd.crick.clicker");               //CrickSoftware - Clicker
	ТипыФайлов.Вставить(".clp","application/x-msclip");               //Microsoft Clipboard Clip
	ТипыФайлов.Вставить(".cmc","application/vnd.cosmocaller");               //CosmoCaller
	ТипыФайлов.Вставить(".cmdf","chemical/x-cmdf");               //CrystalMaker Data Format
	ТипыФайлов.Вставить(".cml","chemical/x-cml");               //Chemical Markup Language
	ТипыФайлов.Вставить(".cmp","application/vnd.yellowriver-custom-menu");               //CustomMenu
	ТипыФайлов.Вставить(".cmx","image/x-cmx");               //Corel Metafile Exchange (CMX)
	ТипыФайлов.Вставить(".cod","application/vnd.rim.cod");               //
	ТипыФайлов.Вставить(".cpio","application/x-cpio");               //CPIO Archive
	ТипыФайлов.Вставить(".cpt","application/mac-compactpro");               //Compact Pro
	ТипыФайлов.Вставить(".crd","application/x-mscardfile");               //Microsoft Information Card
	ТипыФайлов.Вставить(".crl","application/pkix-crl");               //Internet Public Key Infrastructure - Certificate Revocation Lists
	ТипыФайлов.Вставить(".cryptonote","application/vnd.rig.cryptonote");               //CryptoNote
	ТипыФайлов.Вставить(".csh","application/x-csh");               //C Shell Script
	ТипыФайлов.Вставить(".csml","chemical/x-csml");               //Chemical Style Markup Language
	ТипыФайлов.Вставить(".csp","application/vnd.commonspace");               //Sixth Floor Media - CommonSpace
	ТипыФайлов.Вставить(".css","text/css");               //Cascading Style Sheets (CSS)
	ТипыФайлов.Вставить(".csv","text/csv");               //Comma-Seperated Values
	ТипыФайлов.Вставить(".cu","application/cu-seeme");               //CU-SeeMe
	ТипыФайлов.Вставить(".curl","text/vnd.curl");               //Curl - Applet
	ТипыФайлов.Вставить(".cww","application/prs.cww");               //
	ТипыФайлов.Вставить(".dae","model/vnd.collada+xml");               //COLLADA
	ТипыФайлов.Вставить(".daf","application/vnd.mobius.daf");               //Mobius Management Systems - UniversalArchive
	ТипыФайлов.Вставить(".davmount","application/davmount+xml");               //Web Distributed Authoring and Versioning
	ТипыФайлов.Вставить(".dcurl","text/vnd.curl.dcurl");               //Curl - Detached Applet
	ТипыФайлов.Вставить(".dd2","application/vnd.oma.dd2+xml");               //OMA Download Agents
	ТипыФайлов.Вставить(".ddd","application/vnd.fujixerox.ddd");               //Fujitsu - Xerox 2D CAD Data
	ТипыФайлов.Вставить(".deb","application/x-debian-package");               //Debian Package
	ТипыФайлов.Вставить(".der","application/x-x509-ca-cert");               //X.509 Certificate
	ТипыФайлов.Вставить(".dfac","application/vnd.dreamfactory");               //DreamFactory
	ТипыФайлов.Вставить(".dir","application/x-director");               //Adobe Shockwave Player
	ТипыФайлов.Вставить(".dis","application/vnd.mobius.dis");               //Mobius Management Systems - Distribution Database
	ТипыФайлов.Вставить(".djvu","image/vnd.djvu");               //DjVu
	ТипыФайлов.Вставить(".dmg","application/x-apple-diskimage");               //Apple Disk Image
	ТипыФайлов.Вставить(".dna","application/vnd.dna");               //New Moon Liftoff/DNA
	ТипыФайлов.Вставить(".doc","application/msword");               //Microsoft Word
	ТипыФайлов.Вставить(".docm","application/vnd.ms-word.document.macroenabled.12");               //Microsoft Word - Macro-Enabled Document
	ТипыФайлов.Вставить(".docx","application/vnd.openxmlformats-officedocument.wordprocessingml.document");               //Microsoft Office - OOXML - Word Document
	ТипыФайлов.Вставить(".dotm","application/vnd.ms-word.template.macroenabled.12");               //Microsoft Word - Macro-Enabled Template
	ТипыФайлов.Вставить(".dotx","application/vnd.openxmlformats-officedocument.wordprocessingml.template");               //Microsoft Office - OOXML - Word Document Template
	ТипыФайлов.Вставить(".dp","application/vnd.osgi.dp");               //OSGi Deployment Package
	ТипыФайлов.Вставить(".dpg","application/vnd.dpgraph");               //DPGraph
	ТипыФайлов.Вставить(".dra","audio/vnd.dra");               //DRA Audio
	ТипыФайлов.Вставить(".dsc","text/prs.lines.tag");               //PRS Lines Tag
	ТипыФайлов.Вставить(".dssc","application/dssc+der");               //Data Structure for the Security Suitability of Cryptographic Algorithms
	ТипыФайлов.Вставить(".dtb","application/x-dtbook+xml");               //Digital Talking Book
	ТипыФайлов.Вставить(".dtd","application/xml-dtd");               //Document Type Definition
	ТипыФайлов.Вставить(".dts","audio/vnd.dts");               //DTS Audio
	ТипыФайлов.Вставить(".dtshd","audio/vnd.dts.hd");               //DTS High Definition Audio
	ТипыФайлов.Вставить(".dvi","application/x-dvi");               //Device Independent File Format (DVI)
	ТипыФайлов.Вставить(".dwf","model/vnd.dwf");               //Autodesk Design Web Format (DWF)
	ТипыФайлов.Вставить(".dwg","image/vnd.dwg");               //DWG Drawing
	ТипыФайлов.Вставить(".dxf","image/vnd.dxf");               //AutoCAD DXF
	ТипыФайлов.Вставить(".dxp","application/vnd.spotfire.dxp");               //TIBCO Spotfire
	ТипыФайлов.Вставить(".ecelp4800","audio/vnd.nuera.ecelp4800");               //Nuera ECELP 4800
	ТипыФайлов.Вставить(".ecelp7470","audio/vnd.nuera.ecelp7470");               //Nuera ECELP 7470
	ТипыФайлов.Вставить(".ecelp9600","audio/vnd.nuera.ecelp9600");               //Nuera ECELP 9600
	ТипыФайлов.Вставить(".edm","application/vnd.novadigm.edm");               //Novadigm's RADIA and EDM products
	ТипыФайлов.Вставить(".edx","application/vnd.novadigm.edx");               //Novadigm's RADIA and EDM products
	ТипыФайлов.Вставить(".efif","application/vnd.picsel");               //Pcsel eFIF File
	ТипыФайлов.Вставить(".ei6","application/vnd.pg.osasli");               //Proprietary P&G Standard Reporting System
	ТипыФайлов.Вставить(".eml","message/rfc822");               //Email Message
	ТипыФайлов.Вставить(".emma","application/emma+xml");               //Extensible MultiModal Annotation
	ТипыФайлов.Вставить(".eol","audio/vnd.digital-winds");               //Digital Winds Music
	ТипыФайлов.Вставить(".eot","application/vnd.ms-fontobject");               //Microsoft Embedded OpenType
	ТипыФайлов.Вставить(".epub","application/epub+zip");               //Electronic Publication
	ТипыФайлов.Вставить(".es","application/ecmascript");               //ECMAScript
	ТипыФайлов.Вставить(".es3","application/vnd.eszigno3+xml");               //MICROSEC e-Szign?
	ТипыФайлов.Вставить(".esf","application/vnd.epson.esf");               //QUASS Stream Player
	ТипыФайлов.Вставить(".etx","text/x-setext");               //Setext
	ТипыФайлов.Вставить(".exe","application/x-msdownload");               //Microsoft Application
	ТипыФайлов.Вставить(".exi","application/exi");               //Efficient XML Interchange
	ТипыФайлов.Вставить(".ext","application/vnd.novadigm.ext");               //Novadigm's RADIA and EDM products
	ТипыФайлов.Вставить(".ez2","application/vnd.ezpix-album");               //EZPix Secure Photo Album
	ТипыФайлов.Вставить(".ez3","application/vnd.ezpix-package");               //EZPix Secure Photo Album
	ТипыФайлов.Вставить(".f","text/x-fortran");               //Fortran Source File
	ТипыФайлов.Вставить(".f4v","video/x-f4v");               //Flash Video
	ТипыФайлов.Вставить(".fbs","image/vnd.fastbidsheet");               //FastBid Sheet
	ТипыФайлов.Вставить(".fcs","application/vnd.isac.fcs");               //International Society for Advancement of Cytometry
	ТипыФайлов.Вставить(".fdf","application/vnd.fdf");               //Forms Data Format
	ТипыФайлов.Вставить(".fe_launch","application/vnd.denovo.fcselayout-link");               //FCS Express Layout Link
	ТипыФайлов.Вставить(".fg5","application/vnd.fujitsu.oasysgp");               //Fujitsu Oasys
	ТипыФайлов.Вставить(".fh","image/x-freehand");               //FreeHand MX
	ТипыФайлов.Вставить(".fig","application/x-xfig");               //Xfig
	ТипыФайлов.Вставить(".fli","video/x-fli");               //FLI/FLC Animation Format
	ТипыФайлов.Вставить(".flo","application/vnd.micrografx.flo");               //Micrografx
	ТипыФайлов.Вставить(".flv","video/x-flv");               //Flash Video
	ТипыФайлов.Вставить(".flw","application/vnd.kde.kivio");               //KDE KOffice Office Suite - Kivio
	ТипыФайлов.Вставить(".flx","text/vnd.fmi.flexstor");               //FLEXSTOR
	ТипыФайлов.Вставить(".fly","text/vnd.fly");               //mod_fly / fly.cgi
	ТипыФайлов.Вставить(".fm","application/vnd.framemaker");               //FrameMaker Normal Format
	ТипыФайлов.Вставить(".fnc","application/vnd.frogans.fnc");               //Frogans Player
	ТипыФайлов.Вставить(".fpx","image/vnd.fpx");               //FlashPix
	ТипыФайлов.Вставить(".fsc","application/vnd.fsc.weblaunch");               //Friendly Software Corporation
	ТипыФайлов.Вставить(".fst","image/vnd.fst");               //FAST Search & Transfer ASA
	ТипыФайлов.Вставить(".ftc","application/vnd.fluxtime.clip");               //FluxTime Clip
	ТипыФайлов.Вставить(".fti","application/vnd.anser-web-funds-transfer-initiation");               //ANSER-WEB Terminal Client - Web Funds Transfer
	ТипыФайлов.Вставить(".fvt","video/vnd.fvt");               //FAST Search & Transfer ASA
	ТипыФайлов.Вставить(".fxp","application/vnd.adobe.fxp");               //Adobe Flex Project
	ТипыФайлов.Вставить(".fzs","application/vnd.fuzzysheet");               //FuzzySheet
	ТипыФайлов.Вставить(".g2w","application/vnd.geoplan");               //GeoplanW
	ТипыФайлов.Вставить(".g3","image/g3fax");               //G3 Fax Image
	ТипыФайлов.Вставить(".g3w","application/vnd.geospace");               //GeospacW
	ТипыФайлов.Вставить(".gac","application/vnd.groove-account");               //Groove - Account
	ТипыФайлов.Вставить(".gdl","model/vnd.gdl");               //Geometric Description Language (GDL)
	ТипыФайлов.Вставить(".geo","application/vnd.dynageo");               //DynaGeo
	ТипыФайлов.Вставить(".gex","application/vnd.geometry-explorer");               //GeoMetry Explorer
	ТипыФайлов.Вставить(".ggb","application/vnd.geogebra.file");               //GeoGebra
	ТипыФайлов.Вставить(".ggt","application/vnd.geogebra.tool");               //GeoGebra
	ТипыФайлов.Вставить(".ghf","application/vnd.groove-help");               //Groove - Help
	ТипыФайлов.Вставить(".gif","image/gif");               //Graphics Interchange Format
	ТипыФайлов.Вставить(".gim","application/vnd.groove-identity-message");               //Groove - Identity Message
	ТипыФайлов.Вставить(".gmx","application/vnd.gmx");               //GameMaker ActiveX
	ТипыФайлов.Вставить(".gnumeric","application/x-gnumeric");               //Gnumeric
	ТипыФайлов.Вставить(".gph","application/vnd.flographit");               //NpGraphIt
	ТипыФайлов.Вставить(".gqf","application/vnd.grafeq");               //GrafEq
	ТипыФайлов.Вставить(".gram","application/srgs");               //Speech Recognition Grammar Specification
	ТипыФайлов.Вставить(".grv","application/vnd.groove-injector");               //Groove - Injector
	ТипыФайлов.Вставить(".grxml","application/srgs+xml");               //Speech Recognition Grammar Specification - XML
	ТипыФайлов.Вставить(".gsf","application/x-font-ghostscript");               //Ghostscript Font
	ТипыФайлов.Вставить(".gtar","application/x-gtar");               //GNU Tar Files
	ТипыФайлов.Вставить(".gtm","application/vnd.groove-tool-message");               //Groove - Tool Message
	ТипыФайлов.Вставить(".gtw","model/vnd.gtw");               //Gen-Trix Studio
	ТипыФайлов.Вставить(".gv","text/vnd.graphviz");               //Graphviz
	ТипыФайлов.Вставить(".gxt","application/vnd.geonext");               //GEONExT and JSXGraph
	ТипыФайлов.Вставить(".h261","video/h261");               //H.261
	ТипыФайлов.Вставить(".h263","video/h263");               //H.263
	ТипыФайлов.Вставить(".h264","video/h264");               //H.264
	ТипыФайлов.Вставить(".hal","application/vnd.hal+xml");               //Hypertext Application Language
	ТипыФайлов.Вставить(".hbci","application/vnd.hbci");               //Homebanking Computer Interface (HBCI)
	ТипыФайлов.Вставить(".hdf","application/x-hdf");               //Hierarchical Data Format
	ТипыФайлов.Вставить(".hlp","application/winhlp");               //WinHelp
	ТипыФайлов.Вставить(".hpgl","application/vnd.hp-hpgl");               //HP-GL/2 and HP RTL
	ТипыФайлов.Вставить(".hpid","application/vnd.hp-hpid");               //Hewlett Packard Instant Delivery
	ТипыФайлов.Вставить(".hps","application/vnd.hp-hps");               //Hewlett-Packard's WebPrintSmart
	ТипыФайлов.Вставить(".hqx","application/mac-binhex40");               //Macintosh BinHex 4.0
	ТипыФайлов.Вставить(".htke","application/vnd.kenameaapp");               //Kenamea App
	ТипыФайлов.Вставить(".html","text/html");               //HyperText Markup Language (HTML)
	ТипыФайлов.Вставить(".hvd","application/vnd.yamaha.hv-dic");               //HV Voice Dictionary
	ТипыФайлов.Вставить(".hvp","application/vnd.yamaha.hv-voice");               //HV Voice Parameter
	ТипыФайлов.Вставить(".hvs","application/vnd.yamaha.hv-script");               //HV Script
	ТипыФайлов.Вставить(".i2g","application/vnd.intergeo");               //Interactive Geometry Software
	ТипыФайлов.Вставить(".icc","application/vnd.iccprofile");               //ICC profile
	ТипыФайлов.Вставить(".ice","x-conference/x-cooltalk");               //CoolTalk
	ТипыФайлов.Вставить(".ico","image/x-icon");               //Icon Image
	ТипыФайлов.Вставить(".ics","text/calendar");               //iCalendar
	ТипыФайлов.Вставить(".ief","image/ief");               //Image Exchange Format
	ТипыФайлов.Вставить(".ifm","application/vnd.shana.informed.formdata");               //Shana Informed Filler
	ТипыФайлов.Вставить(".igl","application/vnd.igloader");               //igLoader
	ТипыФайлов.Вставить(".igm","application/vnd.insors.igm");               //IOCOM Visimeet
	ТипыФайлов.Вставить(".igs","model/iges");               //Initial Graphics Exchange Specification (IGES)
	ТипыФайлов.Вставить(".igx","application/vnd.micrografx.igx");               //Micrografx iGrafx Professional
	ТипыФайлов.Вставить(".iif","application/vnd.shana.informed.interchange");               //Shana Informed Filler
	ТипыФайлов.Вставить(".imp","application/vnd.accpac.simply.imp");               //Simply Accounting - Data Import
	ТипыФайлов.Вставить(".ims","application/vnd.ms-ims");               //Microsoft Class Server
	ТипыФайлов.Вставить(".ipfix","application/ipfix");               //Internet Protocol Flow Information Export
	ТипыФайлов.Вставить(".ipk","application/vnd.shana.informed.package");               //Shana Informed Filler
	ТипыФайлов.Вставить(".irm","application/vnd.ibm.rights-management");               //IBM DB2 Rights Manager
	ТипыФайлов.Вставить(".irp","application/vnd.irepository.package+xml");               //iRepository / Lucidoc Editor
	ТипыФайлов.Вставить(".itp","application/vnd.shana.informed.formtemplate");               //Shana Informed Filler
	ТипыФайлов.Вставить(".ivp","application/vnd.immervision-ivp");               //ImmerVision PURE Players
	ТипыФайлов.Вставить(".ivu","application/vnd.immervision-ivu");               //ImmerVision PURE Players
	ТипыФайлов.Вставить(".jad","text/vnd.sun.j2me.app-descriptor");               //J2ME App Descriptor
	ТипыФайлов.Вставить(".jam","application/vnd.jam");               //Lightspeed Audio Lab
	ТипыФайлов.Вставить(".jar","application/java-archive");               //Java Archive
	ТипыФайлов.Вставить(".java","text/x-java-source,java");               //Java Source File
	ТипыФайлов.Вставить(".jisp","application/vnd.jisp");               //RhymBox
	ТипыФайлов.Вставить(".jlt","application/vnd.hp-jlyt");               //HP Indigo Digital Press - Job Layout Languate
	ТипыФайлов.Вставить(".jnlp","application/x-java-jnlp-file");               //Java Network Launching Protocol
	ТипыФайлов.Вставить(".joda","application/vnd.joost.joda-archive");               //Joda Archive
	ТипыФайлов.Вставить(".jpeg, .jpg","image/jpeg");               //JPEG Image
	ТипыФайлов.Вставить(".jpeg, .jpg","image/x-citrix-jpeg");               //JPEG Image (Citrix client)
	ТипыФайлов.Вставить(".jpgv","video/jpeg");               //JPGVideo
	ТипыФайлов.Вставить(".jpm","video/jpm");               //JPEG 2000 Compound Image File Format
	ТипыФайлов.Вставить(".js","application/javascript");               //JavaScript
	ТипыФайлов.Вставить(".json","application/json");               //JavaScript Object Notation (JSON)
	ТипыФайлов.Вставить(".karbon","application/vnd.kde.karbon");               //KDE KOffice Office Suite - Karbon
	ТипыФайлов.Вставить(".kfo","application/vnd.kde.kformula");               //KDE KOffice Office Suite - Kformula
	ТипыФайлов.Вставить(".kia","application/vnd.kidspiration");               //Kidspiration
	ТипыФайлов.Вставить(".kml","application/vnd.google-earth.kml+xml");               //Google Earth - KML
	ТипыФайлов.Вставить(".kmz","application/vnd.google-earth.kmz");               //Google Earth - Zipped KML
	ТипыФайлов.Вставить(".kne","application/vnd.kinar");               //Kinar Applications
	ТипыФайлов.Вставить(".kon","application/vnd.kde.kontour");               //KDE KOffice Office Suite - Kontour
	ТипыФайлов.Вставить(".kpr","application/vnd.kde.kpresenter");               //KDE KOffice Office Suite - Kpresenter
	ТипыФайлов.Вставить(".ksp","application/vnd.kde.kspread");               //KDE KOffice Office Suite - Kspread
	ТипыФайлов.Вставить(".ktx","image/ktx");               //OpenGL Textures (KTX)
	ТипыФайлов.Вставить(".ktz","application/vnd.kahootz");               //Kahootz
	ТипыФайлов.Вставить(".kwd","application/vnd.kde.kword");               //KDE KOffice Office Suite - Kword
	ТипыФайлов.Вставить(".lasxml","application/vnd.las.las+xml");               //Laser App Enterprise
	ТипыФайлов.Вставить(".latex","application/x-latex");               //LaTeX
	ТипыФайлов.Вставить(".lbd","application/vnd.llamagraphics.life-balance.desktop");               //Life Balance - Desktop Edition
	ТипыФайлов.Вставить(".lbe","application/vnd.llamagraphics.life-balance.exchange+xml");               //Life Balance - Exchange Format
	ТипыФайлов.Вставить(".les","application/vnd.hhe.lesson-player");               //Archipelago Lesson Player
	ТипыФайлов.Вставить(".link66","application/vnd.route66.link66+xml");               //ROUTE 66 Location Based Services
	ТипыФайлов.Вставить(".lrm","application/vnd.ms-lrm");               //Microsoft Learning Resource Module
	ТипыФайлов.Вставить(".ltf","application/vnd.frogans.ltf");               //Frogans Player
	ТипыФайлов.Вставить(".lvp","audio/vnd.lucent.voice");               //Lucent Voice
	ТипыФайлов.Вставить(".lwp","application/vnd.lotus-wordpro");               //Lotus Wordpro
	ТипыФайлов.Вставить(".m21","application/mp21");               //MPEG-21
	ТипыФайлов.Вставить(".m3u","audio/x-mpegurl");               //M3U (Multimedia Playlist)
	ТипыФайлов.Вставить(".m3u8","application/vnd.apple.mpegurl");               //Multimedia Playlist Unicode
	ТипыФайлов.Вставить(".m4v","video/x-m4v");               //M4v
	ТипыФайлов.Вставить(".ma","application/mathematica");               //Mathematica Notebooks
	ТипыФайлов.Вставить(".mads","application/mads+xml");               //Metadata Authority Description Schema
	ТипыФайлов.Вставить(".mag","application/vnd.ecowin.chart");               //EcoWin Chart
	ТипыФайлов.Вставить(".mathml","application/mathml+xml");               //Mathematical Markup Language
	ТипыФайлов.Вставить(".mbk","application/vnd.mobius.mbk");               //Mobius Management Systems - Basket file
	ТипыФайлов.Вставить(".mbox","application/mbox");               //Mbox database files
	ТипыФайлов.Вставить(".mc1","application/vnd.medcalcdata");               //MedCalc
	ТипыФайлов.Вставить(".mcd","application/vnd.mcd");               //Micro CADAM Helix D&D
	ТипыФайлов.Вставить(".mcurl","text/vnd.curl.mcurl");               //Curl - Manifest File
	ТипыФайлов.Вставить(".mdb","application/x-msaccess");               //Microsoft Access
	ТипыФайлов.Вставить(".mdi","image/vnd.ms-modi");               //Microsoft Document Imaging Format
	ТипыФайлов.Вставить(".meta4","application/metalink4+xml");               //Metalink
	ТипыФайлов.Вставить(".mets","application/mets+xml");               //Metadata Encoding and Transmission Standard
	ТипыФайлов.Вставить(".mfm","application/vnd.mfmp");               //Melody Format for Mobile Platform
	ТипыФайлов.Вставить(".mgp","application/vnd.osgeo.mapguide.package");               //MapGuide DBXML
	ТипыФайлов.Вставить(".mgz","application/vnd.proteus.magazine");               //EFI Proteus
	ТипыФайлов.Вставить(".mid","audio/midi");               //MIDI - Musical Instrument Digital Interface
	ТипыФайлов.Вставить(".mif","application/vnd.mif");               //FrameMaker Interchange Format
	ТипыФайлов.Вставить(".mj2","video/mj2");               //Motion JPEG 2000
	ТипыФайлов.Вставить(".mlp","application/vnd.dolby.mlp");               //Dolby Meridian Lossless Packing
	ТипыФайлов.Вставить(".mmd","application/vnd.chipnuts.karaoke-mmd");               //Karaoke on Chipnuts Chipsets
	ТипыФайлов.Вставить(".mmf","application/vnd.smaf");               //SMAF File
	ТипыФайлов.Вставить(".mmr","image/vnd.fujixerox.edmics-mmr");               //EDMICS 2000
	ТипыФайлов.Вставить(".mny","application/x-msmoney");               //Microsoft Money
	ТипыФайлов.Вставить(".mods","application/mods+xml");               //Metadata Object Description Schema
	ТипыФайлов.Вставить(".movie","video/x-sgi-movie");               //SGI Movie
	ТипыФайлов.Вставить(".mp4","application/mp4");               //MPEG4
	ТипыФайлов.Вставить(".mp4","video/mp4");               //MPEG-4 Video
	ТипыФайлов.Вставить(".mp4a","audio/mp4");               //MPEG-4 Audio
	ТипыФайлов.Вставить(".mpc","application/vnd.mophun.certificate");               //Mophun Certificate
	ТипыФайлов.Вставить(".mpeg","video/mpeg");               //MPEG Video
	ТипыФайлов.Вставить(".mpga","audio/mpeg");               //MPEG Audio
	ТипыФайлов.Вставить(".mpkg","application/vnd.apple.installer+xml");               //Apple Installer Package
	ТипыФайлов.Вставить(".mpm","application/vnd.blueice.multipass");               //Blueice Research Multipass
	ТипыФайлов.Вставить(".mpn","application/vnd.mophun.application");               //Mophun VM
	ТипыФайлов.Вставить(".mpp","application/vnd.ms-project");               //Microsoft Project
	ТипыФайлов.Вставить(".mpy","application/vnd.ibm.minipay");               //MiniPay
	ТипыФайлов.Вставить(".mqy","application/vnd.mobius.mqy");               //Mobius Management Systems - Query File
	ТипыФайлов.Вставить(".mrc","application/marc");               //MARC Formats
	ТипыФайлов.Вставить(".mrcx","application/marcxml+xml");               //MARC21 XML Schema
	ТипыФайлов.Вставить(".mscml","application/mediaservercontrol+xml");               //Media Server Control Markup Language
	ТипыФайлов.Вставить(".mseq","application/vnd.mseq");               //3GPP MSEQ File
	ТипыФайлов.Вставить(".msf","application/vnd.epson.msf");               //QUASS Stream Player
	ТипыФайлов.Вставить(".msh","model/mesh");               //Mesh Data Type
	ТипыФайлов.Вставить(".msl","application/vnd.mobius.msl");               //Mobius Management Systems - Script Language
	ТипыФайлов.Вставить(".msty","application/vnd.muvee.style");               //Muvee Automatic Video Editing
	ТипыФайлов.Вставить(".mts","model/vnd.mts");               //Virtue MTS
	ТипыФайлов.Вставить(".mus","application/vnd.musician");               //MUsical Score Interpreted Code Invented for the ASCII designation of Notation
	ТипыФайлов.Вставить(".musicxml","application/vnd.recordare.musicxml+xml");               //Recordare Applications
	ТипыФайлов.Вставить(".mvb","application/x-msmediaview");               //Microsoft MediaView
	ТипыФайлов.Вставить(".mwf","application/vnd.mfer");               //Medical Waveform Encoding Format
	ТипыФайлов.Вставить(".mxf","application/mxf");               //Material Exchange Format
	ТипыФайлов.Вставить(".mxl","application/vnd.recordare.musicxml");               //Recordare Applications
	ТипыФайлов.Вставить(".mxml","application/xv+xml");               //MXML
	ТипыФайлов.Вставить(".mxs","application/vnd.triscape.mxs");               //Triscape Map Explorer
	ТипыФайлов.Вставить(".mxu","video/vnd.mpegurl");               //MPEG Url
	ТипыФайлов.Вставить(".n-gage","application/vnd.nokia.n-gage.symbian.install");               //N-Gage Game Installer
	ТипыФайлов.Вставить(".n3","text/n3");               //Notation3
	ТипыФайлов.Вставить(".nbp","application/vnd.wolfram.player");               //Mathematica Notebook Player
	ТипыФайлов.Вставить(".nc","application/x-netcdf");               //Network Common Data Form (NetCDF)
	ТипыФайлов.Вставить(".ncx","application/x-dtbncx+xml");               //Navigation Control file for XML (for ePub)
	ТипыФайлов.Вставить(".ngdat","application/vnd.nokia.n-gage.data");               //N-Gage Game Data
	ТипыФайлов.Вставить(".nlu","application/vnd.neurolanguage.nlu");               //neuroLanguage
	ТипыФайлов.Вставить(".nml","application/vnd.enliven");               //Enliven Viewer
	ТипыФайлов.Вставить(".nnd","application/vnd.noblenet-directory");               //NobleNet Directory
	ТипыФайлов.Вставить(".nns","application/vnd.noblenet-sealer");               //NobleNet Sealer
	ТипыФайлов.Вставить(".nnw","application/vnd.noblenet-web");               //NobleNet Web
	ТипыФайлов.Вставить(".npx","image/vnd.net-fpx");               //FlashPix
	ТипыФайлов.Вставить(".nsf","application/vnd.lotus-notes");               //Lotus Notes
	ТипыФайлов.Вставить(".oa2","application/vnd.fujitsu.oasys2");               //Fujitsu Oasys
	ТипыФайлов.Вставить(".oa3","application/vnd.fujitsu.oasys3");               //Fujitsu Oasys
	ТипыФайлов.Вставить(".oas","application/vnd.fujitsu.oasys");               //Fujitsu Oasys
	ТипыФайлов.Вставить(".obd","application/x-msbinder");               //Microsoft Office Binder
	ТипыФайлов.Вставить(".oda","application/oda");               //Office Document Architecture
	ТипыФайлов.Вставить(".odb","application/vnd.oasis.opendocument.database");               //OpenDocument Database
	ТипыФайлов.Вставить(".odc","application/vnd.oasis.opendocument.chart");               //OpenDocument Chart
	ТипыФайлов.Вставить(".odf","application/vnd.oasis.opendocument.formula");               //OpenDocument Formula
	ТипыФайлов.Вставить(".odft","application/vnd.oasis.opendocument.formula-template");               //OpenDocument Formula Template
	ТипыФайлов.Вставить(".odg","application/vnd.oasis.opendocument.graphics");               //OpenDocument Graphics
	ТипыФайлов.Вставить(".odi","application/vnd.oasis.opendocument.image");               //OpenDocument Image
	ТипыФайлов.Вставить(".odm","application/vnd.oasis.opendocument.text-master");               //OpenDocument Text Master
	ТипыФайлов.Вставить(".odp","application/vnd.oasis.opendocument.presentation");               //OpenDocument Presentation
	ТипыФайлов.Вставить(".ods","application/vnd.oasis.opendocument.spreadsheet");               //OpenDocument Spreadsheet
	ТипыФайлов.Вставить(".odt","application/vnd.oasis.opendocument.text");               //OpenDocument Text
	ТипыФайлов.Вставить(".oga","audio/ogg");               //Ogg Audio
	ТипыФайлов.Вставить(".ogv","video/ogg");               //Ogg Video
	ТипыФайлов.Вставить(".ogx","application/ogg");               //Ogg
	ТипыФайлов.Вставить(".onetoc","application/onenote");               //Microsoft OneNote
	ТипыФайлов.Вставить(".opf","application/oebps-package+xml");               //Open eBook Publication Structure
	ТипыФайлов.Вставить(".org","application/vnd.lotus-organizer");               //Lotus Organizer
	ТипыФайлов.Вставить(".osf","application/vnd.yamaha.openscoreformat");               //Open Score Format
	ТипыФайлов.Вставить(".osfpvg","application/vnd.yamaha.openscoreformat.osfpvg+xml");               //OSFPVG
	ТипыФайлов.Вставить(".otc","application/vnd.oasis.opendocument.chart-template");               //OpenDocument Chart Template
	ТипыФайлов.Вставить(".otf","application/x-font-otf");               //OpenType Font File
	ТипыФайлов.Вставить(".otg","application/vnd.oasis.opendocument.graphics-template");               //OpenDocument Graphics Template
	ТипыФайлов.Вставить(".oth","application/vnd.oasis.opendocument.text-web");               //Open Document Text Web
	ТипыФайлов.Вставить(".oti","application/vnd.oasis.opendocument.image-template");               //OpenDocument Image Template
	ТипыФайлов.Вставить(".otp","application/vnd.oasis.opendocument.presentation-template");               //OpenDocument Presentation Template
	ТипыФайлов.Вставить(".ots","application/vnd.oasis.opendocument.spreadsheet-template");               //OpenDocument Spreadsheet Template
	ТипыФайлов.Вставить(".ott","application/vnd.oasis.opendocument.text-template");               //OpenDocument Text Template
	ТипыФайлов.Вставить(".oxt","application/vnd.openofficeorg.extension");               //Open Office Extension
	ТипыФайлов.Вставить(".p","text/x-pascal");               //Pascal Source File
	ТипыФайлов.Вставить(".p10","application/pkcs10");               //PKCS #10 - Certification Request Standard
	ТипыФайлов.Вставить(".p12","application/x-pkcs12");               //PKCS #12 - Personal Information Exchange Syntax Standard
	ТипыФайлов.Вставить(".p7b","application/x-pkcs7-certificates");               //PKCS #7 - Cryptographic Message Syntax Standard (Certificates)
	ТипыФайлов.Вставить(".p7m","application/pkcs7-mime");               //PKCS #7 - Cryptographic Message Syntax Standard
	ТипыФайлов.Вставить(".p7r","application/x-pkcs7-certreqresp");               //PKCS #7 - Cryptographic Message Syntax Standard (Certificate Request Response)
	ТипыФайлов.Вставить(".p7s","application/pkcs7-signature");               //PKCS #7 - Cryptographic Message Syntax Standard
	ТипыФайлов.Вставить(".p8","application/pkcs8");               //PKCS #8 - Private-Key Information Syntax Standard
	ТипыФайлов.Вставить(".par","text/plain-bas");               //BAS Partitur Format
	ТипыФайлов.Вставить(".paw","application/vnd.pawaafile");               //PawaaFILE
	ТипыФайлов.Вставить(".pbd","application/vnd.powerbuilder6");               //PowerBuilder
	ТипыФайлов.Вставить(".pbm","image/x-portable-bitmap");               //Portable Bitmap Format
	ТипыФайлов.Вставить(".pcf","application/x-font-pcf");               //Portable Compiled Format
	ТипыФайлов.Вставить(".pcl","application/vnd.hp-pcl");               //HP Printer Command Language
	ТипыФайлов.Вставить(".pclxl","application/vnd.hp-pclxl");               //PCL 6 Enhanced (Formely PCL XL)
	ТипыФайлов.Вставить(".pcurl","application/vnd.curl.pcurl");               //CURL Applet
	ТипыФайлов.Вставить(".pcx","image/x-pcx");               //PCX Image
	ТипыФайлов.Вставить(".pdb","application/vnd.palm");               //PalmOS Data
	ТипыФайлов.Вставить(".pdf","application/pdf");               //Adobe Portable Document Format
	ТипыФайлов.Вставить(".pfa","application/x-font-type1");               //PostScript Fonts
	ТипыФайлов.Вставить(".pfr","application/font-tdpfr");               //Portable Font Resource
	ТипыФайлов.Вставить(".pgm","image/x-portable-graymap");               //Portable Graymap Format
	ТипыФайлов.Вставить(".pgn","application/x-chess-pgn");               //Portable Game Notation (Chess Games)
	ТипыФайлов.Вставить(".pgp","application/pgp-encrypted");               //Pretty Good Privacy
	ТипыФайлов.Вставить(".pgp","application/pgp-signature");               //Pretty Good Privacy - Signature
	ТипыФайлов.Вставить(".pic","image/x-pict");               //PICT Image
	ТипыФайлов.Вставить(".pjpeg","image/pjpeg");               //JPEG Image (Progressive)
	ТипыФайлов.Вставить(".pki","application/pkixcmp");               //Internet Public Key Infrastructure - Certificate Management Protocole
	ТипыФайлов.Вставить(".pkipath","application/pkix-pkipath");               //Internet Public Key Infrastructure - Certification Path
	ТипыФайлов.Вставить(".plb","application/vnd.3gpp.pic-bw-large");               //3rd Generation Partnership Project - Pic Large
	ТипыФайлов.Вставить(".plc","application/vnd.mobius.plc");               //Mobius Management Systems - Policy Definition Language File
	ТипыФайлов.Вставить(".plf","application/vnd.pocketlearn");               //PocketLearn Viewers
	ТипыФайлов.Вставить(".pls","application/pls+xml");               //Pronunciation Lexicon Specification
	ТипыФайлов.Вставить(".pml","application/vnd.ctc-posml");               //PosML
	ТипыФайлов.Вставить(".png","image/png");               //Portable Network Graphics (PNG)
	ТипыФайлов.Вставить(".png","image/x-citrix-png");               //Portable Network Graphics (PNG) (Citrix client)
	ТипыФайлов.Вставить(".png","image/x-png");               //Portable Network Graphics (PNG) (x-token)
	ТипыФайлов.Вставить(".pnm","image/x-portable-anymap");               //Portable Anymap Image
	ТипыФайлов.Вставить(".portpkg","application/vnd.macports.portpkg");               //MacPorts Port System
	ТипыФайлов.Вставить(".potm","application/vnd.ms-powerpoint.template.macroenabled.12");               //Microsoft PowerPoint - Macro-Enabled Template File
	ТипыФайлов.Вставить(".potx","application/vnd.openxmlformats-officedocument.presentationml.template");               //Microsoft Office - OOXML - Presentation Template
	ТипыФайлов.Вставить(".ppam","application/vnd.ms-powerpoint.addin.macroenabled.12");               //Microsoft PowerPoint - Add-in file
	ТипыФайлов.Вставить(".ppd","application/vnd.cups-ppd");               //Adobe PostScript Printer Description File Format
	ТипыФайлов.Вставить(".ppm","image/x-portable-pixmap");               //Portable Pixmap Format
	ТипыФайлов.Вставить(".ppsm","application/vnd.ms-powerpoint.slideshow.macroenabled.12");               //Microsoft PowerPoint - Macro-Enabled Slide Show File
	ТипыФайлов.Вставить(".ppsx","application/vnd.openxmlformats-officedocument.presentationml.slideshow");               //Microsoft Office - OOXML - Presentation (Slideshow)
	ТипыФайлов.Вставить(".ppt","application/vnd.ms-powerpoint");               //Microsoft PowerPoint
	ТипыФайлов.Вставить(".pptm","application/vnd.ms-powerpoint.presentation.macroenabled.12");               //Microsoft PowerPoint - Macro-Enabled Presentation File
	ТипыФайлов.Вставить(".pptx","application/vnd.openxmlformats-officedocument.presentationml.presentation");               //Microsoft Office - OOXML - Presentation
	ТипыФайлов.Вставить(".prc","application/x-mobipocket-ebook");               //Mobipocket
	ТипыФайлов.Вставить(".pre","application/vnd.lotus-freelance");               //Lotus Freelance
	ТипыФайлов.Вставить(".prf","application/pics-rules");               //PICSRules
	ТипыФайлов.Вставить(".psb","application/vnd.3gpp.pic-bw-small");               //3rd Generation Partnership Project - Pic Small
	ТипыФайлов.Вставить(".psd","image/vnd.adobe.photoshop");               //Photoshop Document
	ТипыФайлов.Вставить(".psf","application/x-font-linux-psf");               //PSF Fonts
	ТипыФайлов.Вставить(".pskcxml","application/pskc+xml");               //Portable Symmetric Key Container
	ТипыФайлов.Вставить(".ptid","application/vnd.pvi.ptid1");               //Princeton Video Image
	ТипыФайлов.Вставить(".pub","application/x-mspublisher");               //Microsoft Publisher
	ТипыФайлов.Вставить(".pvb","application/vnd.3gpp.pic-bw-var");               //3rd Generation Partnership Project - Pic Var
	ТипыФайлов.Вставить(".pwn","application/vnd.3m.post-it-notes");               //3M Post It Notes
	ТипыФайлов.Вставить(".pya","audio/vnd.ms-playready.media.pya");               //Microsoft PlayReady Ecosystem
	ТипыФайлов.Вставить(".pyv","video/vnd.ms-playready.media.pyv");               //Microsoft PlayReady Ecosystem Video
	ТипыФайлов.Вставить(".qam","application/vnd.epson.quickanime");               //QuickAnime Player
	ТипыФайлов.Вставить(".qbo","application/vnd.intu.qbo");               //Open Financial Exchange
	ТипыФайлов.Вставить(".qfx","application/vnd.intu.qfx");               //Quicken
	ТипыФайлов.Вставить(".qps","application/vnd.publishare-delta-tree");               //PubliShare Objects
	ТипыФайлов.Вставить(".qt","video/quicktime");               //Quicktime Video
	ТипыФайлов.Вставить(".qxd","application/vnd.quark.quarkxpress");               //QuarkXpress
	ТипыФайлов.Вставить(".ram","audio/x-pn-realaudio");               //Real Audio Sound
	ТипыФайлов.Вставить(".rar","application/x-rar-compressed");               //RAR Archive
	ТипыФайлов.Вставить(".ras","image/x-cmu-raster");               //
	ТипыФайлов.Вставить(".rcprofile","application/vnd.ipunplugged.rcprofile");               //IP Unplugged Roaming Client
	ТипыФайлов.Вставить(".rdf","application/rdf+xml");               //Resource Description Framework
	ТипыФайлов.Вставить(".rdz","application/vnd.data-vision.rdz");               //RemoteDocs R-Viewer
	ТипыФайлов.Вставить(".rep","application/vnd.businessobjects");               //BusinessObjects
	ТипыФайлов.Вставить(".res","application/x-dtbresource+xml");               //Digital Talking Book - Resource File
	ТипыФайлов.Вставить(".rgb","image/x-rgb");               //Silicon Graphics RGB Bitmap
	ТипыФайлов.Вставить(".rif","application/reginfo+xml");               //
	ТипыФайлов.Вставить(".rip","audio/vnd.rip");               //Hit'n'Mix
	ТипыФайлов.Вставить(".rl","application/resource-lists+xml");               //XML Resource Lists
	ТипыФайлов.Вставить(".rlc","image/vnd.fujixerox.edmics-rlc");               //EDMICS 2000
	ТипыФайлов.Вставить(".rld","application/resource-lists-diff+xml");               //XML Resource Lists Diff
	ТипыФайлов.Вставить(".rm","application/vnd.rn-realmedia");               //
	ТипыФайлов.Вставить(".rmp","audio/x-pn-realaudio-plugin");               //Real Audio Sound
	ТипыФайлов.Вставить(".rms","application/vnd.jcp.javame.midlet-rms");               //Mobile Information Device Profile
	ТипыФайлов.Вставить(".rnc","application/relax-ng-compact-syntax");               //Relax NG Compact Syntax
	ТипыФайлов.Вставить(".rp9","application/vnd.cloanto.rp9");               //RetroPlatform Player
	ТипыФайлов.Вставить(".rpss","application/vnd.nokia.radio-presets");               //Nokia Radio Application - Preset
	ТипыФайлов.Вставить(".rpst","application/vnd.nokia.radio-preset");               //Nokia Radio Application - Preset
	ТипыФайлов.Вставить(".rq","application/sparql-query");               //SPARQL - Query
	ТипыФайлов.Вставить(".rs","application/rls-services+xml");               //XML Resource Lists
	ТипыФайлов.Вставить(".rsd","application/rsd+xml");               //Really Simple Discovery
	ТипыФайлов.Вставить(".rss, .xml","application/rss+xml");               //RSS - Really Simple Syndication
	ТипыФайлов.Вставить(".rtf","application/rtf");               //Rich Text Format
	ТипыФайлов.Вставить(".rtx","text/richtext");               //Rich Text Format (RTF)
	ТипыФайлов.Вставить(".s","text/x-asm");               //Assembler Source File
	ТипыФайлов.Вставить(".saf","application/vnd.yamaha.smaf-audio");               //SMAF Audio
	ТипыФайлов.Вставить(".sbml","application/sbml+xml");               //Systems Biology Markup Language
	ТипыФайлов.Вставить(".sc","application/vnd.ibm.secure-container");               //IBM Electronic Media Management System - Secure Container
	ТипыФайлов.Вставить(".scd","application/x-msschedule");               //Microsoft Schedule+
	ТипыФайлов.Вставить(".scm","application/vnd.lotus-screencam");               //Lotus Screencam
	ТипыФайлов.Вставить(".scq","application/scvp-cv-request");               //Server-Based Certificate Validation Protocol - Validation Request
	ТипыФайлов.Вставить(".scs","application/scvp-cv-response");               //Server-Based Certificate Validation Protocol - Validation Response
	ТипыФайлов.Вставить(".scurl","text/vnd.curl.scurl");               //Curl - Source Code
	ТипыФайлов.Вставить(".sda","application/vnd.stardivision.draw");               //
	ТипыФайлов.Вставить(".sdc","application/vnd.stardivision.calc");               //
	ТипыФайлов.Вставить(".sdd","application/vnd.stardivision.impress");               //
	ТипыФайлов.Вставить(".sdkm","application/vnd.solent.sdkm+xml");               //SudokuMagic
	ТипыФайлов.Вставить(".sdp","application/sdp");               //Session Description Protocol
	ТипыФайлов.Вставить(".sdw","application/vnd.stardivision.writer");               //
	ТипыФайлов.Вставить(".see","application/vnd.seemail");               //SeeMail
	ТипыФайлов.Вставить(".seed","application/vnd.fdsn.seed");               //Digital Siesmograph Networks - SEED Datafiles
	ТипыФайлов.Вставить(".sema","application/vnd.sema");               //Secured eMail
	ТипыФайлов.Вставить(".semd","application/vnd.semd");               //Secured eMail
	ТипыФайлов.Вставить(".semf","application/vnd.semf");               //Secured eMail
	ТипыФайлов.Вставить(".ser","application/java-serialized-object");               //Java Serialized Object
	ТипыФайлов.Вставить(".setpay","application/set-payment-initiation");               //Secure Electronic Transaction - Payment
	ТипыФайлов.Вставить(".setreg","application/set-registration-initiation");               //Secure Electronic Transaction - Registration
	ТипыФайлов.Вставить(".sfd-hdstx","application/vnd.hydrostatix.sof-data");               //Hydrostatix Master Suite
	ТипыФайлов.Вставить(".sfs","application/vnd.spotfire.sfs");               //TIBCO Spotfire
	ТипыФайлов.Вставить(".sgl","application/vnd.stardivision.writer-global");               //
	ТипыФайлов.Вставить(".sgml","text/sgml");               //Standard Generalized Markup Language (SGML)
	ТипыФайлов.Вставить(".sh","application/x-sh");               //Bourne Shell Script
	ТипыФайлов.Вставить(".shar","application/x-shar");               //Shell Archive
	ТипыФайлов.Вставить(".shf","application/shf+xml");               //S Hexdump Format
	ТипыФайлов.Вставить(".sis","application/vnd.symbian.install");               //Symbian Install Package
	ТипыФайлов.Вставить(".sit","application/x-stuffit");               //Stuffit Archive
	ТипыФайлов.Вставить(".sitx","application/x-stuffitx");               //Stuffit Archive
	ТипыФайлов.Вставить(".skp","application/vnd.koan");               //SSEYO Koan Play File
	ТипыФайлов.Вставить(".sldm","application/vnd.ms-powerpoint.slide.macroenabled.12");               //Microsoft PowerPoint - Macro-Enabled Open XML Slide
	ТипыФайлов.Вставить(".sldx","application/vnd.openxmlformats-officedocument.presentationml.slide");               //Microsoft Office - OOXML - Presentation (Slide)
	ТипыФайлов.Вставить(".slt","application/vnd.epson.salt");               //SimpleAnimeLite Player
	ТипыФайлов.Вставить(".sm","application/vnd.stepmania.stepchart");               //StepMania
	ТипыФайлов.Вставить(".smf","application/vnd.stardivision.math");               //
	ТипыФайлов.Вставить(".smi","application/smil+xml");               //Synchronized Multimedia Integration Language
	ТипыФайлов.Вставить(".snf","application/x-font-snf");               //Server Normal Format
	ТипыФайлов.Вставить(".spf","application/vnd.yamaha.smaf-phrase");               //SMAF Phrase
	ТипыФайлов.Вставить(".spl","application/x-futuresplash");               //FutureSplash Animator
	ТипыФайлов.Вставить(".spot","text/vnd.in3d.spot");               //In3D - 3DML
	ТипыФайлов.Вставить(".spp","application/scvp-vp-response");               //Server-Based Certificate Validation Protocol - Validation Policies - Response
	ТипыФайлов.Вставить(".spq","application/scvp-vp-request");               //Server-Based Certificate Validation Protocol - Validation Policies - Request
	ТипыФайлов.Вставить(".src","application/x-wais-source");               //WAIS Source
	ТипыФайлов.Вставить(".sru","application/sru+xml");               //Search/Retrieve via URL Response Format
	ТипыФайлов.Вставить(".srx","application/sparql-results+xml");               //SPARQL - Results
	ТипыФайлов.Вставить(".sse","application/vnd.kodak-descriptor");               //Kodak Storyshare
	ТипыФайлов.Вставить(".ssf","application/vnd.epson.ssf");               //QUASS Stream Player
	ТипыФайлов.Вставить(".ssml","application/ssml+xml");               //Speech Synthesis Markup Language
	ТипыФайлов.Вставить(".st","application/vnd.sailingtracker.track");               //SailingTracker
	ТипыФайлов.Вставить(".stc","application/vnd.sun.xml.calc.template");               //OpenOffice - Calc Template (Spreadsheet)
	ТипыФайлов.Вставить(".std","application/vnd.sun.xml.draw.template");               //OpenOffice - Draw Template (Graphics)
	ТипыФайлов.Вставить(".stf","application/vnd.wt.stf");               //Worldtalk
	ТипыФайлов.Вставить(".sti","application/vnd.sun.xml.impress.template");               //OpenOffice - Impress Template (Presentation)
	ТипыФайлов.Вставить(".stk","application/hyperstudio");               //Hyperstudio
	ТипыФайлов.Вставить(".stl","application/vnd.ms-pki.stl");               //Microsoft Trust UI Provider - Certificate Trust Link
	ТипыФайлов.Вставить(".str","application/vnd.pg.format");               //Proprietary P&G Standard Reporting System
	ТипыФайлов.Вставить(".stw","application/vnd.sun.xml.writer.template");               //OpenOffice - Writer Template (Text - HTML)
	ТипыФайлов.Вставить(".sub","image/vnd.dvb.subtitle");               //Close Captioning - Subtitle
	ТипыФайлов.Вставить(".sus","application/vnd.sus-calendar");               //ScheduleUs
	ТипыФайлов.Вставить(".sv4cpio","application/x-sv4cpio");               //System V Release 4 CPIO Archive
	ТипыФайлов.Вставить(".sv4crc","application/x-sv4crc");               //System V Release 4 CPIO Checksum Data
	ТипыФайлов.Вставить(".svc","application/vnd.dvb.service");               //Digital Video Broadcasting
	ТипыФайлов.Вставить(".svd","application/vnd.svd");               //SourceView Document
	ТипыФайлов.Вставить(".svg","image/svg+xml");               //Scalable Vector Graphics (SVG)
	ТипыФайлов.Вставить(".swf","application/x-shockwave-flash");               //Adobe Flash
	ТипыФайлов.Вставить(".swi","application/vnd.aristanetworks.swi");               //Arista Networks Software Image
	ТипыФайлов.Вставить(".sxc","application/vnd.sun.xml.calc");               //OpenOffice - Calc (Spreadsheet)
	ТипыФайлов.Вставить(".sxd","application/vnd.sun.xml.draw");               //OpenOffice - Draw (Graphics)
	ТипыФайлов.Вставить(".sxg","application/vnd.sun.xml.writer.global");               //OpenOffice - Writer (Text - HTML)
	ТипыФайлов.Вставить(".sxi","application/vnd.sun.xml.impress");               //OpenOffice - Impress (Presentation)
	ТипыФайлов.Вставить(".sxm","application/vnd.sun.xml.math");               //OpenOffice - Math (Formula)
	ТипыФайлов.Вставить(".sxw","application/vnd.sun.xml.writer");               //OpenOffice - Writer (Text - HTML)
	ТипыФайлов.Вставить(".t","text/troff");               //troff
	ТипыФайлов.Вставить(".tao","application/vnd.tao.intent-module-archive");               //Tao Intent
	ТипыФайлов.Вставить(".tar","application/x-tar");               //Tar File (Tape Archive)
	ТипыФайлов.Вставить(".tcap","application/vnd.3gpp2.tcap");               //3rd Generation Partnership Project - Transaction Capabilities Application Part
	ТипыФайлов.Вставить(".tcl","application/x-tcl");               //Tcl Script
	ТипыФайлов.Вставить(".teacher","application/vnd.smart.teacher");               //SMART Technologies Apps
	ТипыФайлов.Вставить(".tei","application/tei+xml");               //Text Encoding and Interchange
	ТипыФайлов.Вставить(".tex","application/x-tex");               //TeX
	ТипыФайлов.Вставить(".texinfo","application/x-texinfo");               //GNU Texinfo Document
	ТипыФайлов.Вставить(".tfi","application/thraud+xml");               //Sharing Transaction Fraud Data
	ТипыФайлов.Вставить(".tfm","application/x-tex-tfm");               //TeX Font Metric
	ТипыФайлов.Вставить(".thmx","application/vnd.ms-officetheme");               //Microsoft Office System Release Theme
	ТипыФайлов.Вставить(".tiff","image/tiff");               //Tagged Image File Format
	ТипыФайлов.Вставить(".tmo","application/vnd.tmobile-livetv");               //MobileTV
	ТипыФайлов.Вставить(".torrent","application/x-bittorrent");               //BitTorrent
	ТипыФайлов.Вставить(".tpl","application/vnd.groove-tool-template");               //Groove - Tool Template
	ТипыФайлов.Вставить(".tpt","application/vnd.trid.tpt");               //TRI Systems Config
	ТипыФайлов.Вставить(".tra","application/vnd.trueapp");               //True BASIC
	ТипыФайлов.Вставить(".trm","application/x-msterminal");               //Microsoft Windows Terminal Services
	ТипыФайлов.Вставить(".tsd","application/timestamped-data");               //Time Stamped Data Envelope
	ТипыФайлов.Вставить(".tsv","text/tab-separated-values");               //Tab Seperated Values
	ТипыФайлов.Вставить(".ttf","application/x-font-ttf");               //TrueType Font
	ТипыФайлов.Вставить(".ttl","text/turtle");               //Turtle (Terse RDF Triple Language)
	ТипыФайлов.Вставить(".twd","application/vnd.simtech-mindmapper");               //SimTech MindMapper
	ТипыФайлов.Вставить(".txd","application/vnd.genomatix.tuxedo");               //Genomatix Tuxedo Framework
	ТипыФайлов.Вставить(".txf","application/vnd.mobius.txf");               //Mobius Management Systems - Topic Index File
	ТипыФайлов.Вставить(".txt","text/plain");               //Text File
	ТипыФайлов.Вставить(".ufd","application/vnd.ufdl");               //Universal Forms Description Language
	ТипыФайлов.Вставить(".umj","application/vnd.umajin");               //UMAJIN
	ТипыФайлов.Вставить(".unityweb","application/vnd.unity");               //Unity 3d
	ТипыФайлов.Вставить(".uoml","application/vnd.uoml+xml");               //Unique Object Markup Language
	ТипыФайлов.Вставить(".uri","text/uri-list");               //URI Resolution Services
	ТипыФайлов.Вставить(".ustar","application/x-ustar");               //Ustar (Uniform Standard Tape Archive)
	ТипыФайлов.Вставить(".utz","application/vnd.uiq.theme");               //User Interface Quartz - Theme (Symbian)
	ТипыФайлов.Вставить(".uu","text/x-uuencode");               //UUEncode
	ТипыФайлов.Вставить(".uva","audio/vnd.dece.audio");               //DECE Audio
	ТипыФайлов.Вставить(".uvh","video/vnd.dece.hd");               //DECE High Definition Video
	ТипыФайлов.Вставить(".uvi","image/vnd.dece.graphic");               //DECE Graphic
	ТипыФайлов.Вставить(".uvm","video/vnd.dece.mobile");               //DECE Mobile Video
	ТипыФайлов.Вставить(".uvp","video/vnd.dece.pd");               //DECE PD Video
	ТипыФайлов.Вставить(".uvs","video/vnd.dece.sd");               //DECE SD Video
	ТипыФайлов.Вставить(".uvu","video/vnd.uvvu.mp4");               //DECE MP4
	ТипыФайлов.Вставить(".uvv","video/vnd.dece.video");               //DECE Video
	ТипыФайлов.Вставить(".vcd","application/x-cdlink");               //Video CD
	ТипыФайлов.Вставить(".vcf","text/x-vcard");               //vCard
	ТипыФайлов.Вставить(".vcg","application/vnd.groove-vcard");               //Groove - Vcard
	ТипыФайлов.Вставить(".vcs","text/x-vcalendar");               //vCalendar
	ТипыФайлов.Вставить(".vcx","application/vnd.vcx");               //VirtualCatalog
	ТипыФайлов.Вставить(".vis","application/vnd.visionary");               //Visionary
	ТипыФайлов.Вставить(".viv","video/vnd.vivo");               //Vivo
	ТипыФайлов.Вставить(".vsd","application/vnd.visio");               //Microsoft Visio
	ТипыФайлов.Вставить(".vsdx","application/vnd.visio2013");               //Microsoft Visio 2013
	ТипыФайлов.Вставить(".vsf","application/vnd.vsf");               //Viewport+
	ТипыФайлов.Вставить(".vtu","model/vnd.vtu");               //Virtue VTU
	ТипыФайлов.Вставить(".vxml","application/voicexml+xml");               //VoiceXML
	ТипыФайлов.Вставить(".wad","application/x-doom");               //Doom Video Game
	ТипыФайлов.Вставить(".wav","audio/x-wav");               //Waveform Audio File Format (WAV)
	ТипыФайлов.Вставить(".wax","audio/x-ms-wax");               //Microsoft Windows Media Audio Redirector
	ТипыФайлов.Вставить(".wbmp","image/vnd.wap.wbmp");               //WAP Bitamp (WBMP)
	ТипыФайлов.Вставить(".wbs","application/vnd.criticaltools.wbs+xml");               //Critical Tools - PERT Chart EXPERT
	ТипыФайлов.Вставить(".wbxml","application/vnd.wap.wbxml");               //WAP Binary XML (WBXML)
	ТипыФайлов.Вставить(".weba","audio/webm");               //Open Web Media Project - Audio
	ТипыФайлов.Вставить(".webm","video/webm");               //Open Web Media Project - Video
	ТипыФайлов.Вставить(".webp","image/webp");               //WebP Image
	ТипыФайлов.Вставить(".wg","application/vnd.pmi.widget");               //Qualcomm's Plaza Mobile Internet
	ТипыФайлов.Вставить(".wgt","application/widget");               //Widget Packaging and XML Configuration
	ТипыФайлов.Вставить(".wm","video/x-ms-wm");               //Microsoft Windows Media
	ТипыФайлов.Вставить(".wma","audio/x-ms-wma");               //Microsoft Windows Media Audio
	ТипыФайлов.Вставить(".wmd","application/x-ms-wmd");               //Microsoft Windows Media Player Download Package
	ТипыФайлов.Вставить(".wmf","application/x-msmetafile");               //Microsoft Windows Metafile
	ТипыФайлов.Вставить(".wml","text/vnd.wap.wml");               //Wireless Markup Language (WML)
	ТипыФайлов.Вставить(".wmlc","application/vnd.wap.wmlc");               //Compiled Wireless Markup Language (WMLC)
	ТипыФайлов.Вставить(".wmls","text/vnd.wap.wmlscript");               //Wireless Markup Language Script (WMLScript)
	ТипыФайлов.Вставить(".wmlsc","application/vnd.wap.wmlscriptc");               //WMLScript
	ТипыФайлов.Вставить(".wmv","video/x-ms-wmv");               //Microsoft Windows Media Video
	ТипыФайлов.Вставить(".wmx","video/x-ms-wmx");               //Microsoft Windows Media Audio/Video Playlist
	ТипыФайлов.Вставить(".wmz","application/x-ms-wmz");               //Microsoft Windows Media Player Skin Package
	ТипыФайлов.Вставить(".woff","application/x-font-woff");               //Web Open Font Format
	ТипыФайлов.Вставить(".wpd","application/vnd.wordperfect");               //Wordperfect
	ТипыФайлов.Вставить(".wpl","application/vnd.ms-wpl");               //Microsoft Windows Media Player Playlist
	ТипыФайлов.Вставить(".wps","application/vnd.ms-works");               //Microsoft Works
	ТипыФайлов.Вставить(".wqd","application/vnd.wqd");               //SundaHus WQ
	ТипыФайлов.Вставить(".wri","application/x-mswrite");               //Microsoft Wordpad
	ТипыФайлов.Вставить(".wrl","model/vrml");               //Virtual Reality Modeling Language
	ТипыФайлов.Вставить(".wsdl","application/wsdl+xml");               //WSDL - Web Services Description Language
	ТипыФайлов.Вставить(".wspolicy","application/wspolicy+xml");               //Web Services Policy
	ТипыФайлов.Вставить(".wtb","application/vnd.webturbo");               //WebTurbo
	ТипыФайлов.Вставить(".wvx","video/x-ms-wvx");               //Microsoft Windows Media Video Playlist
	ТипыФайлов.Вставить(".x3d","application/vnd.hzn-3d-crossword");               //3D Crossword Plugin
	ТипыФайлов.Вставить(".xap","application/x-silverlight-app");               //Microsoft Silverlight
	ТипыФайлов.Вставить(".xar","application/vnd.xara");               //CorelXARA
	ТипыФайлов.Вставить(".xbap","application/x-ms-xbap");               //Microsoft XAML Browser Application
	ТипыФайлов.Вставить(".xbd","application/vnd.fujixerox.docuworks.binder");               //Fujitsu - Xerox DocuWorks Binder
	ТипыФайлов.Вставить(".xbm","image/x-xbitmap");               //X BitMap
	ТипыФайлов.Вставить(".xdf","application/xcap-diff+xml");               //XML Configuration Access Protocol - XCAP Diff
	ТипыФайлов.Вставить(".xdm","application/vnd.syncml.dm+xml");               //SyncML - Device Management
	ТипыФайлов.Вставить(".xdp","application/vnd.adobe.xdp+xml");               //Adobe XML Data Package
	ТипыФайлов.Вставить(".xdssc","application/dssc+xml");               //Data Structure for the Security Suitability of Cryptographic Algorithms
	ТипыФайлов.Вставить(".xdw","application/vnd.fujixerox.docuworks");               //Fujitsu - Xerox DocuWorks
	ТипыФайлов.Вставить(".xenc","application/xenc+xml");               //XML Encryption Syntax and Processing
	ТипыФайлов.Вставить(".xer","application/patch-ops-error+xml");               //XML Patch Framework
	ТипыФайлов.Вставить(".xfdf","application/vnd.adobe.xfdf");               //Adobe XML Forms Data Format
	ТипыФайлов.Вставить(".xfdl","application/vnd.xfdl");               //Extensible Forms Description Language
	ТипыФайлов.Вставить(".xhtml","application/xhtml+xml");               //XHTML - The Extensible HyperText Markup Language
	ТипыФайлов.Вставить(".xif","image/vnd.xiff");               //eXtended Image File Format (XIFF)
	ТипыФайлов.Вставить(".xlam","application/vnd.ms-excel.addin.macroenabled.12");               //Microsoft Excel - Add-In File
	ТипыФайлов.Вставить(".xls","application/vnd.ms-excel");               //Microsoft Excel
	ТипыФайлов.Вставить(".xlsb","application/vnd.ms-excel.sheet.binary.macroenabled.12");               //Microsoft Excel - Binary Workbook
	ТипыФайлов.Вставить(".xlsm","application/vnd.ms-excel.sheet.macroenabled.12");               //Microsoft Excel - Macro-Enabled Workbook
	ТипыФайлов.Вставить(".xlsx","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");               //Microsoft Office - OOXML - Spreadsheet
	ТипыФайлов.Вставить(".xltm","application/vnd.ms-excel.template.macroenabled.12");               //Microsoft Excel - Macro-Enabled Template File
	ТипыФайлов.Вставить(".xltx","application/vnd.openxmlformats-officedocument.spreadsheetml.template");               //Microsoft Office - OOXML - Spreadsheet Template
	ТипыФайлов.Вставить(".xml","application/xml");               //XML - Extensible Markup Language
	ТипыФайлов.Вставить(".xo","application/vnd.olpc-sugar");               //Sugar Linux Application Bundle
	ТипыФайлов.Вставить(".xop","application/xop+xml");               //XML-Binary Optimized Packaging
	ТипыФайлов.Вставить(".xpi","application/x-xpinstall");               //XPInstall - Mozilla
	ТипыФайлов.Вставить(".xpm","image/x-xpixmap");               //X PixMap
	ТипыФайлов.Вставить(".xpr","application/vnd.is-xpr");               //Express by Infoseek
	ТипыФайлов.Вставить(".xps","application/vnd.ms-xpsdocument");               //Microsoft XML Paper Specification
	ТипыФайлов.Вставить(".xpw","application/vnd.intercon.formnet");               //Intercon FormNet
	ТипыФайлов.Вставить(".xslt","application/xslt+xml");               //XML Transformations
	ТипыФайлов.Вставить(".xsm","application/vnd.syncml+xml");               //SyncML
	ТипыФайлов.Вставить(".xspf","application/xspf+xml");               //XSPF - XML Shareable Playlist Format
	ТипыФайлов.Вставить(".xul","application/vnd.mozilla.xul+xml");               //XUL - XML User Interface Language
	ТипыФайлов.Вставить(".xwd","image/x-xwindowdump");               //X Window Dump
	ТипыФайлов.Вставить(".xyz","chemical/x-xyz");               //XYZ File Format
	ТипыФайлов.Вставить(".yaml","text/yaml");               //YAML Ain't Markup Language / Yet Another Markup Language
	ТипыФайлов.Вставить(".yang","application/yang");               //YANG Data Modeling Language
	ТипыФайлов.Вставить(".yin","application/yin+xml");               //YIN (YANG - XML)
	ТипыФайлов.Вставить(".zaz","application/vnd.zzazz.deck+xml");               //Zzazz Deck
	ТипыФайлов.Вставить(".zip","application/zip");               //Zip Archive
	ТипыФайлов.Вставить(".zir","application/vnd.zul");               //Z.U.L. Geometry
	ТипыФайлов.Вставить(".zmm","application/vnd.handheld-entertainment+xml");               //ZVUE Media Manager
	
	//ТипыФайлов.Вставить(".3dm","x-world/x-3dmf");
	//ТипыФайлов.Вставить(".3dmf","x-world/x-3dmf");
	//ТипыФайлов.Вставить(".a","application/octet-stream");
	//ТипыФайлов.Вставить(".aab","application/x-authorware-bin");
	//ТипыФайлов.Вставить(".aam","application/x-authorware-map");
	//ТипыФайлов.Вставить(".aas","application/x-authorware-seg");
	//ТипыФайлов.Вставить(".abc","text/vnd.abc");
	//ТипыФайлов.Вставить(".acgi","text/html");
	//ТипыФайлов.Вставить(".afl","video/animaflex");
	//ТипыФайлов.Вставить(".ai","application/postscript");
	//ТипыФайлов.Вставить(".aif","audio/aiff");
	//ТипыФайлов.Вставить(".aif","audio/x-aiff");
	//ТипыФайлов.Вставить(".aifc","audio/aiff");
	//ТипыФайлов.Вставить(".aifc","audio/x-aiff");
	//ТипыФайлов.Вставить(".aiff","audio/aiff");
	//ТипыФайлов.Вставить(".aiff","audio/x-aiff");
	//ТипыФайлов.Вставить(".aim","application/x-aim");
	//ТипыФайлов.Вставить(".aip","text/x-audiosoft-intra");
	//ТипыФайлов.Вставить(".ani","application/x-navi-animation");
	//ТипыФайлов.Вставить(".aos","application/x-nokia-9000-communicator-add-on-software");
	//ТипыФайлов.Вставить(".aps","application/mime");
	//ТипыФайлов.Вставить(".arc","application/octet-stream");
	//ТипыФайлов.Вставить(".arj","application/arj");
	//ТипыФайлов.Вставить(".arj","application/octet-stream");
	//ТипыФайлов.Вставить(".art","image/x-jg");
	//ТипыФайлов.Вставить(".asf","video/x-ms-asf");
	//ТипыФайлов.Вставить(".asm","text/x-asm");
	//ТипыФайлов.Вставить(".asp","text/asp");
	//ТипыФайлов.Вставить(".asx","application/x-mplayer2");
	//ТипыФайлов.Вставить(".asx","video/x-ms-asf");
	//ТипыФайлов.Вставить(".asx","video/x-ms-asf-plugin");
	//ТипыФайлов.Вставить(".au","audio/basic");
	//ТипыФайлов.Вставить(".au","audio/x-au");
	//ТипыФайлов.Вставить(".avi","application/x-troff-msvideo");
	//ТипыФайлов.Вставить(".avi","video/avi");
	//ТипыФайлов.Вставить(".avi","video/msvideo");
	//ТипыФайлов.Вставить(".avi","video/x-msvideo");
	//ТипыФайлов.Вставить(".avs","video/avs-video");
	//ТипыФайлов.Вставить(".bcpio","application/x-bcpio");
	//ТипыФайлов.Вставить(".bin","application/mac-binary");
	//ТипыФайлов.Вставить(".bin","application/macbinary");
	//ТипыФайлов.Вставить(".bin","application/octet-stream");
	//ТипыФайлов.Вставить(".bin","application/x-binary");
	//ТипыФайлов.Вставить(".bin","application/x-macbinary");
	//ТипыФайлов.Вставить(".bm","image/bmp");
	//ТипыФайлов.Вставить(".bmp","image/bmp");
	//ТипыФайлов.Вставить(".bmp","image/x-windows-bmp");
	//ТипыФайлов.Вставить(".boo","application/book");
	//ТипыФайлов.Вставить(".book","application/book");
	//ТипыФайлов.Вставить(".boz","application/x-bzip2");
	//ТипыФайлов.Вставить(".bsh","application/x-bsh");
	//ТипыФайлов.Вставить(".bz","application/x-bzip");
	//ТипыФайлов.Вставить(".bz2","application/x-bzip2");
	//ТипыФайлов.Вставить(".c","text/plain");
	//ТипыФайлов.Вставить(".c","text/x-c");
	//ТипыФайлов.Вставить(".c++","text/plain");
	//ТипыФайлов.Вставить(".cat","application/vnd.ms-pki.seccat");
	//ТипыФайлов.Вставить(".cc","text/plain");
	//ТипыФайлов.Вставить(".cc","text/x-c");
	//ТипыФайлов.Вставить(".ccad","application/clariscad");
	//ТипыФайлов.Вставить(".cco","application/x-cocoa");
	//ТипыФайлов.Вставить(".cdf","application/cdf");
	//ТипыФайлов.Вставить(".cdf","application/x-cdf");
	//ТипыФайлов.Вставить(".cdf","application/x-netcdf");
	//ТипыФайлов.Вставить(".cer","application/pkix-cert");
	//ТипыФайлов.Вставить(".cer","application/x-x509-ca-cert");
	//ТипыФайлов.Вставить(".cha","application/x-chat");
	//ТипыФайлов.Вставить(".chat","application/x-chat");
	//ТипыФайлов.Вставить(".class","application/java");
	//ТипыФайлов.Вставить(".class","application/java-byte-code");
	//ТипыФайлов.Вставить(".class","application/x-java-class");
	//ТипыФайлов.Вставить(".com","application/octet-stream");
	//ТипыФайлов.Вставить(".com","text/plain");
	//ТипыФайлов.Вставить(".conf","text/plain");
	//ТипыФайлов.Вставить(".cpio","application/x-cpio");
	//ТипыФайлов.Вставить(".cpp","text/x-c");
	//ТипыФайлов.Вставить(".cpt","application/mac-compactpro");
	//ТипыФайлов.Вставить(".cpt","application/x-compactpro");
	//ТипыФайлов.Вставить(".cpt","application/x-cpt");
	//ТипыФайлов.Вставить(".crl","application/pkcs-crl");
	//ТипыФайлов.Вставить(".crl","application/pkix-crl");
	//ТипыФайлов.Вставить(".crt","application/pkix-cert");
	//ТипыФайлов.Вставить(".crt","application/x-x509-ca-cert");
	//ТипыФайлов.Вставить(".crt","application/x-x509-user-cert");
	//ТипыФайлов.Вставить(".csh","application/x-csh");
	//ТипыФайлов.Вставить(".csh","text/x-script.csh");
	//ТипыФайлов.Вставить(".css","application/x-pointplus");
	//ТипыФайлов.Вставить(".css","text/css");
	//ТипыФайлов.Вставить(".cxx","text/plain");
	//ТипыФайлов.Вставить(".dcr","application/x-director");
	//ТипыФайлов.Вставить(".deepv","application/x-deepv");
	//ТипыФайлов.Вставить(".def","text/plain");
	//ТипыФайлов.Вставить(".der","application/x-x509-ca-cert");
	//ТипыФайлов.Вставить(".dif","video/x-dv");
	//ТипыФайлов.Вставить(".dir","application/x-director");
	//ТипыФайлов.Вставить(".dl","video/dl");
	//ТипыФайлов.Вставить(".dl","video/x-dl");
	//ТипыФайлов.Вставить(".doc","application/msword");
	//ТипыФайлов.Вставить(".dot","application/msword");
	//ТипыФайлов.Вставить(".dp","application/commonground");
	//ТипыФайлов.Вставить(".drw","application/drafting");
	//ТипыФайлов.Вставить(".dump","application/octet-stream");
	//ТипыФайлов.Вставить(".dv","video/x-dv");
	//ТипыФайлов.Вставить(".dvi","application/x-dvi");
	//ТипыФайлов.Вставить(".dwf","drawing/x-dwf (old)");
	//ТипыФайлов.Вставить(".dwf","model/vnd.dwf");
	//ТипыФайлов.Вставить(".dwg","application/acad");
	//ТипыФайлов.Вставить(".dwg","image/vnd.dwg");
	//ТипыФайлов.Вставить(".dwg","image/x-dwg");
	//ТипыФайлов.Вставить(".dxf","application/dxf");
	//ТипыФайлов.Вставить(".dxf","image/vnd.dwg");
	//ТипыФайлов.Вставить(".dxf","image/x-dwg");
	//ТипыФайлов.Вставить(".dxr","application/x-director");
	//ТипыФайлов.Вставить(".el","text/x-script.elisp");
	//ТипыФайлов.Вставить(".elc","application/x-bytecode.elisp (compiled elisp)");
	//ТипыФайлов.Вставить(".elc","application/x-elc");
	//ТипыФайлов.Вставить(".env","application/x-envoy");
	//ТипыФайлов.Вставить(".eps","application/postscript");
	//ТипыФайлов.Вставить(".es","application/x-esrehber");
	//ТипыФайлов.Вставить(".etx","text/x-setext");
	//ТипыФайлов.Вставить(".evy","application/envoy");
	//ТипыФайлов.Вставить(".evy","application/x-envoy");
	//ТипыФайлов.Вставить(".exe","application/octet-stream");
	//ТипыФайлов.Вставить(".f","text/plain");
	//ТипыФайлов.Вставить(".f","text/x-fortran");
	//ТипыФайлов.Вставить(".f77","text/x-fortran");
	//ТипыФайлов.Вставить(".f90","text/plain");
	//ТипыФайлов.Вставить(".f90","text/x-fortran");
	//ТипыФайлов.Вставить(".fdf","application/vnd.fdf");
	//ТипыФайлов.Вставить(".fif","application/fractals");
	//ТипыФайлов.Вставить(".fif","image/fif");
	//ТипыФайлов.Вставить(".fli","video/fli");
	//ТипыФайлов.Вставить(".fli","video/x-fli");
	//ТипыФайлов.Вставить(".flo","image/florian");
	//ТипыФайлов.Вставить(".flx","text/vnd.fmi.flexstor");
	//ТипыФайлов.Вставить(".fmf","video/x-atomic3d-feature");
	//ТипыФайлов.Вставить(".for","text/plain");
	//ТипыФайлов.Вставить(".for","text/x-fortran");
	//ТипыФайлов.Вставить(".fpx","image/vnd.fpx");
	//ТипыФайлов.Вставить(".fpx","image/vnd.net-fpx");
	//ТипыФайлов.Вставить(".frl","application/freeloader");
	//ТипыФайлов.Вставить(".funk","audio/make");
	//ТипыФайлов.Вставить(".g","text/plain");
	//ТипыФайлов.Вставить(".g3","image/g3fax");
	//ТипыФайлов.Вставить(".gif","image/gif");
	//ТипыФайлов.Вставить(".gl","video/gl");
	//ТипыФайлов.Вставить(".gl","video/x-gl");
	//ТипыФайлов.Вставить(".gsd","audio/x-gsm");
	//ТипыФайлов.Вставить(".gsm","audio/x-gsm");
	//ТипыФайлов.Вставить(".gsp","application/x-gsp");
	//ТипыФайлов.Вставить(".gss","application/x-gss");
	//ТипыФайлов.Вставить(".gtar","application/x-gtar");
	//ТипыФайлов.Вставить(".gz","application/x-compressed");
	//ТипыФайлов.Вставить(".gz","application/x-gzip");
	//ТипыФайлов.Вставить(".gzip","application/x-gzip");
	//ТипыФайлов.Вставить(".gzip","multipart/x-gzip");
	//ТипыФайлов.Вставить(".h","text/plain");
	//ТипыФайлов.Вставить(".h","text/x-h");
	//ТипыФайлов.Вставить(".hdf","application/x-hdf");
	//ТипыФайлов.Вставить(".help","application/x-helpfile");
	//ТипыФайлов.Вставить(".hgl","application/vnd.hp-hpgl");
	//ТипыФайлов.Вставить(".hh","text/plain");
	//ТипыФайлов.Вставить(".hh","text/x-h");
	//ТипыФайлов.Вставить(".hlb","text/x-script");
	//ТипыФайлов.Вставить(".hlp","application/hlp");
	//ТипыФайлов.Вставить(".hlp","application/x-helpfile");
	//ТипыФайлов.Вставить(".hlp","application/x-winhelp");
	//ТипыФайлов.Вставить(".hpg","application/vnd.hp-hpgl");
	//ТипыФайлов.Вставить(".hpgl","application/vnd.hp-hpgl");
	//ТипыФайлов.Вставить(".hqx","application/binhex");
	//ТипыФайлов.Вставить(".hqx","application/binhex4");
	//ТипыФайлов.Вставить(".hqx","application/mac-binhex");
	//ТипыФайлов.Вставить(".hqx","application/mac-binhex40");
	//ТипыФайлов.Вставить(".hqx","application/x-binhex40");
	//ТипыФайлов.Вставить(".hqx","application/x-mac-binhex40");
	//ТипыФайлов.Вставить(".hta","application/hta");
	//ТипыФайлов.Вставить(".htc","text/x-component");
	//ТипыФайлов.Вставить(".htm","text/html");
	//ТипыФайлов.Вставить(".html","text/html");
	//ТипыФайлов.Вставить(".htmls","text/html");
	//ТипыФайлов.Вставить(".htt","text/webviewhtml");
	//ТипыФайлов.Вставить(".htx","text/html");
	//ТипыФайлов.Вставить(".ice","x-conference/x-cooltalk");
	//ТипыФайлов.Вставить(".ico","image/x-icon");
	//ТипыФайлов.Вставить(".idc","text/plain");
	//ТипыФайлов.Вставить(".ief","image/ief");
	//ТипыФайлов.Вставить(".iefs","image/ief");
	//ТипыФайлов.Вставить(".iges","application/iges");
	//ТипыФайлов.Вставить(".iges","model/iges");
	//ТипыФайлов.Вставить(".igs","application/iges");
	//ТипыФайлов.Вставить(".igs","model/iges");
	//ТипыФайлов.Вставить(".ima","application/x-ima");
	//ТипыФайлов.Вставить(".imap","application/x-httpd-imap");
	//ТипыФайлов.Вставить(".inf","application/inf");
	//ТипыФайлов.Вставить(".ins","application/x-internett-signup");
	//ТипыФайлов.Вставить(".ip","application/x-ip2");
	//ТипыФайлов.Вставить(".isu","video/x-isvideo");
	//ТипыФайлов.Вставить(".it","audio/it");
	//ТипыФайлов.Вставить(".iv","application/x-inventor");
	//ТипыФайлов.Вставить(".ivr","i-world/i-vrml");
	//ТипыФайлов.Вставить(".ivy","application/x-livescreen");
	//ТипыФайлов.Вставить(".jam","audio/x-jam");
	//ТипыФайлов.Вставить(".jav","text/plain");
	//ТипыФайлов.Вставить(".jav","text/x-java-source");
	//ТипыФайлов.Вставить(".java","text/plain");
	//ТипыФайлов.Вставить(".java","text/x-java-source");
	//ТипыФайлов.Вставить(".jcm","application/x-java-commerce");
	//ТипыФайлов.Вставить(".jfif","image/jpeg");
	//ТипыФайлов.Вставить(".jfif","image/pjpeg");
	//ТипыФайлов.Вставить(".jfif-tbnl","image/jpeg");
	//ТипыФайлов.Вставить(".jpe","image/jpeg");
	//ТипыФайлов.Вставить(".jpe","image/pjpeg");
	//ТипыФайлов.Вставить(".jpeg","image/jpeg");
	//ТипыФайлов.Вставить(".jpeg","image/pjpeg");
	//ТипыФайлов.Вставить(".jpg","image/jpeg");
	//ТипыФайлов.Вставить(".jpg","image/pjpeg");
	//ТипыФайлов.Вставить(".jps","image/x-jps");
	//ТипыФайлов.Вставить(".js","application/x-javascript");
	//ТипыФайлов.Вставить(".js","application/javascript");
	//ТипыФайлов.Вставить(".js","application/ecmascript");
	//ТипыФайлов.Вставить(".js","text/javascript");
	//ТипыФайлов.Вставить(".js","text/ecmascript");
	//ТипыФайлов.Вставить(".jut","image/jutvision");
	//ТипыФайлов.Вставить(".kar","audio/midi");
	//ТипыФайлов.Вставить(".kar","music/x-karaoke");
	//ТипыФайлов.Вставить(".ksh","application/x-ksh");
	//ТипыФайлов.Вставить(".ksh","text/x-script.ksh");
	//ТипыФайлов.Вставить(".la","audio/nspaudio");
	//ТипыФайлов.Вставить(".la","audio/x-nspaudio");
	//ТипыФайлов.Вставить(".lam","audio/x-liveaudio");
	//ТипыФайлов.Вставить(".latex","application/x-latex");
	//ТипыФайлов.Вставить(".lha","application/lha");
	//ТипыФайлов.Вставить(".lha","application/octet-stream");
	//ТипыФайлов.Вставить(".lha","application/x-lha");
	//ТипыФайлов.Вставить(".lhx","application/octet-stream");
	//ТипыФайлов.Вставить(".list","text/plain");
	//ТипыФайлов.Вставить(".lma","audio/nspaudio");
	//ТипыФайлов.Вставить(".lma","audio/x-nspaudio");
	//ТипыФайлов.Вставить(".log","text/plain");
	//ТипыФайлов.Вставить(".lsp","application/x-lisp");
	//ТипыФайлов.Вставить(".lsp","text/x-script.lisp");
	//ТипыФайлов.Вставить(".lst","text/plain");
	//ТипыФайлов.Вставить(".lsx","text/x-la-asf");
	//ТипыФайлов.Вставить(".ltx","application/x-latex");
	//ТипыФайлов.Вставить(".lzh","application/octet-stream");
	//ТипыФайлов.Вставить(".lzh","application/x-lzh");
	//ТипыФайлов.Вставить(".lzx","application/lzx");
	//ТипыФайлов.Вставить(".lzx","application/octet-stream");
	//ТипыФайлов.Вставить(".lzx","application/x-lzx");
	//ТипыФайлов.Вставить(".m","text/plain");
	//ТипыФайлов.Вставить(".m","text/x-m");
	//ТипыФайлов.Вставить(".m1v","video/mpeg");
	//ТипыФайлов.Вставить(".m2a","audio/mpeg");
	//ТипыФайлов.Вставить(".m2v","video/mpeg");
	//ТипыФайлов.Вставить(".m3u","audio/x-mpequrl");
	//ТипыФайлов.Вставить(".man","application/x-troff-man");
	//ТипыФайлов.Вставить(".map","application/x-navimap");
	//ТипыФайлов.Вставить(".mar","text/plain");
	//ТипыФайлов.Вставить(".mbd","application/mbedlet");
	//ТипыФайлов.Вставить(".mc$","application/x-magic-cap-package-1.0");
	//ТипыФайлов.Вставить(".mcd","application/mcad");
	//ТипыФайлов.Вставить(".mcd","application/x-mathcad");
	//ТипыФайлов.Вставить(".mcf","image/vasa");
	//ТипыФайлов.Вставить(".mcf","text/mcf");
	//ТипыФайлов.Вставить(".mcp","application/netmc");
	//ТипыФайлов.Вставить(".me","application/x-troff-me");
	//ТипыФайлов.Вставить(".mht","message/rfc822");
	//ТипыФайлов.Вставить(".mhtml","message/rfc822");
	//ТипыФайлов.Вставить(".mid","application/x-midi");
	//ТипыФайлов.Вставить(".mid","audio/midi");
	//ТипыФайлов.Вставить(".mid","audio/x-mid");
	//ТипыФайлов.Вставить(".mid","audio/x-midi");
	//ТипыФайлов.Вставить(".mid","music/crescendo");
	//ТипыФайлов.Вставить(".mid","x-music/x-midi");
	//ТипыФайлов.Вставить(".midi","application/x-midi");
	//ТипыФайлов.Вставить(".midi","audio/midi");
	//ТипыФайлов.Вставить(".midi","audio/x-mid");
	//ТипыФайлов.Вставить(".midi","audio/x-midi");
	//ТипыФайлов.Вставить(".midi","music/crescendo");
	//ТипыФайлов.Вставить(".midi","x-music/x-midi");
	//ТипыФайлов.Вставить(".mif","application/x-frame");
	//ТипыФайлов.Вставить(".mif","application/x-mif");
	//ТипыФайлов.Вставить(".mime","message/rfc822");
	//ТипыФайлов.Вставить(".mime","www/mime");
	//ТипыФайлов.Вставить(".mjf","audio/x-vnd.audioexplosion.mjuicemediafile");
	//ТипыФайлов.Вставить(".mjpg","video/x-motion-jpeg");
	//ТипыФайлов.Вставить(".mm","application/base64");
	//ТипыФайлов.Вставить(".mm","application/x-meme");
	//ТипыФайлов.Вставить(".mme","application/base64");
	//ТипыФайлов.Вставить(".mod","audio/mod");
	//ТипыФайлов.Вставить(".mod","audio/x-mod");
	//ТипыФайлов.Вставить(".moov","video/quicktime");
	//ТипыФайлов.Вставить(".mov","video/quicktime");
	//ТипыФайлов.Вставить(".movie","video/x-sgi-movie");
	//ТипыФайлов.Вставить(".mp2","audio/mpeg");
	//ТипыФайлов.Вставить(".mp2","audio/x-mpeg");
	//ТипыФайлов.Вставить(".mp2","video/mpeg");
	//ТипыФайлов.Вставить(".mp2","video/x-mpeg");
	//ТипыФайлов.Вставить(".mp2","video/x-mpeq2a");
	//ТипыФайлов.Вставить(".mp3","audio/mpeg3");
	//ТипыФайлов.Вставить(".mp3","audio/x-mpeg-3");
	//ТипыФайлов.Вставить(".mp3","video/mpeg");
	//ТипыФайлов.Вставить(".mp3","video/x-mpeg");
	//ТипыФайлов.Вставить(".mpa","audio/mpeg");
	//ТипыФайлов.Вставить(".mpa","video/mpeg");
	//ТипыФайлов.Вставить(".mpc","application/x-project");
	//ТипыФайлов.Вставить(".mpe","video/mpeg");
	//ТипыФайлов.Вставить(".mpeg","video/mpeg");
	//ТипыФайлов.Вставить(".mpg","audio/mpeg");
	//ТипыФайлов.Вставить(".mpg","video/mpeg");
	//ТипыФайлов.Вставить(".mpga","audio/mpeg");
	//ТипыФайлов.Вставить(".mpp","application/vnd.ms-project");
	//ТипыФайлов.Вставить(".mpt","application/x-project");
	//ТипыФайлов.Вставить(".mpv","application/x-project");
	//ТипыФайлов.Вставить(".mpx","application/x-project");
	//ТипыФайлов.Вставить(".mrc","application/marc");
	//ТипыФайлов.Вставить(".ms","application/x-troff-ms");
	//ТипыФайлов.Вставить(".mv","video/x-sgi-movie");
	//ТипыФайлов.Вставить(".my","audio/make");
	//ТипыФайлов.Вставить(".mzz","application/x-vnd.audioexplosion.mzz");
	//ТипыФайлов.Вставить(".nap","image/naplps");
	//ТипыФайлов.Вставить(".naplps","image/naplps");
	//ТипыФайлов.Вставить(".nc","application/x-netcdf");
	//ТипыФайлов.Вставить(".ncm","application/vnd.nokia.configuration-message");
	//ТипыФайлов.Вставить(".nif","image/x-niff");
	//ТипыФайлов.Вставить(".niff","image/x-niff");
	//ТипыФайлов.Вставить(".nix","application/x-mix-transfer");
	//ТипыФайлов.Вставить(".nsc","application/x-conference");
	//ТипыФайлов.Вставить(".nvd","application/x-navidoc");
	//ТипыФайлов.Вставить(".o","application/octet-stream");
	//ТипыФайлов.Вставить(".oda","application/oda");
	//ТипыФайлов.Вставить(".omc","application/x-omc");
	//ТипыФайлов.Вставить(".omcd","application/x-omcdatamaker");
	//ТипыФайлов.Вставить(".omcr","application/x-omcregerator");
	//ТипыФайлов.Вставить(".p","text/x-pascal");
	//ТипыФайлов.Вставить(".p10","application/pkcs10");
	//ТипыФайлов.Вставить(".p10","application/x-pkcs10");
	//ТипыФайлов.Вставить(".p12","application/pkcs-12");
	//ТипыФайлов.Вставить(".p12","application/x-pkcs12");
	//ТипыФайлов.Вставить(".p7a","application/x-pkcs7-signature");
	//ТипыФайлов.Вставить(".p7c","application/pkcs7-mime");
	//ТипыФайлов.Вставить(".p7c","application/x-pkcs7-mime");
	//ТипыФайлов.Вставить(".p7m","application/pkcs7-mime");
	//ТипыФайлов.Вставить(".p7m","application/x-pkcs7-mime");
	//ТипыФайлов.Вставить(".p7r","application/x-pkcs7-certreqresp");
	//ТипыФайлов.Вставить(".p7s","application/pkcs7-signature");
	//ТипыФайлов.Вставить(".part","application/pro_eng");
	//ТипыФайлов.Вставить(".pas","text/pascal");
	//ТипыФайлов.Вставить(".pbm","image/x-portable-bitmap");
	//ТипыФайлов.Вставить(".pcl","application/vnd.hp-pcl");
	//ТипыФайлов.Вставить(".pcl","application/x-pcl");
	//ТипыФайлов.Вставить(".pct","image/x-pict");
	//ТипыФайлов.Вставить(".pcx","image/x-pcx");
	//ТипыФайлов.Вставить(".pdb","chemical/x-pdb");
	//ТипыФайлов.Вставить(".pdf","application/pdf");
	//ТипыФайлов.Вставить(".pfunk","audio/make");
	//ТипыФайлов.Вставить(".pfunk","audio/make.my.funk");
	//ТипыФайлов.Вставить(".pgm","image/x-portable-graymap");
	//ТипыФайлов.Вставить(".pgm","image/x-portable-greymap");
	//ТипыФайлов.Вставить(".pic","image/pict");
	//ТипыФайлов.Вставить(".pict","image/pict");
	//ТипыФайлов.Вставить(".pkg","application/x-newton-compatible-pkg");
	//ТипыФайлов.Вставить(".pko","application/vnd.ms-pki.pko");
	//ТипыФайлов.Вставить(".pl","text/plain");
	//ТипыФайлов.Вставить(".pl","text/x-script.perl");
	//ТипыФайлов.Вставить(".plx","application/x-pixclscript");
	//ТипыФайлов.Вставить(".pm","image/x-xpixmap");
	//ТипыФайлов.Вставить(".pm","text/x-script.perl-module");
	//ТипыФайлов.Вставить(".pm4","application/x-pagemaker");
	//ТипыФайлов.Вставить(".pm5","application/x-pagemaker");
	//ТипыФайлов.Вставить(".png","image/png");
	//ТипыФайлов.Вставить(".pnm","application/x-portable-anymap");
	//ТипыФайлов.Вставить(".pnm","image/x-portable-anymap");
	//ТипыФайлов.Вставить(".pot","application/mspowerpoint");
	//ТипыФайлов.Вставить(".pot","application/vnd.ms-powerpoint");
	//ТипыФайлов.Вставить(".pov","model/x-pov");
	//ТипыФайлов.Вставить(".ppa","application/vnd.ms-powerpoint");
	//ТипыФайлов.Вставить(".ppm","image/x-portable-pixmap");
	//ТипыФайлов.Вставить(".pps","application/mspowerpoint");
	//ТипыФайлов.Вставить(".pps","application/vnd.ms-powerpoint");
	//ТипыФайлов.Вставить(".ppt","application/mspowerpoint");
	//ТипыФайлов.Вставить(".ppt","application/powerpoint");
	//ТипыФайлов.Вставить(".ppt","application/vnd.ms-powerpoint");
	//ТипыФайлов.Вставить(".ppt","application/x-mspowerpoint");
	//ТипыФайлов.Вставить(".ppz","application/mspowerpoint");
	//ТипыФайлов.Вставить(".pre","application/x-freelance");
	//ТипыФайлов.Вставить(".prt","application/pro_eng");
	//ТипыФайлов.Вставить(".ps","application/postscript");
	//ТипыФайлов.Вставить(".psd","application/octet-stream");
	//ТипыФайлов.Вставить(".pvu","paleovu/x-pv");
	//ТипыФайлов.Вставить(".pwz","application/vnd.ms-powerpoint");
	//ТипыФайлов.Вставить(".py","text/x-script.phyton");
	//ТипыФайлов.Вставить(".pyc","application/x-bytecode.python");
	//ТипыФайлов.Вставить(".qcp","audio/vnd.qcelp");
	//ТипыФайлов.Вставить(".qd3","x-world/x-3dmf");
	//ТипыФайлов.Вставить(".qd3d","x-world/x-3dmf");
	//ТипыФайлов.Вставить(".qif","image/x-quicktime");
	//ТипыФайлов.Вставить(".qt","video/quicktime");
	//ТипыФайлов.Вставить(".qtc","video/x-qtc");
	//ТипыФайлов.Вставить(".qti","image/x-quicktime");
	//ТипыФайлов.Вставить(".qtif","image/x-quicktime");
	//ТипыФайлов.Вставить(".ra","audio/x-pn-realaudio");
	//ТипыФайлов.Вставить(".ra","audio/x-pn-realaudio-plugin");
	//ТипыФайлов.Вставить(".ra","audio/x-realaudio");
	//ТипыФайлов.Вставить(".ram","audio/x-pn-realaudio");
	//ТипыФайлов.Вставить(".ras","application/x-cmu-raster");
	//ТипыФайлов.Вставить(".ras","image/cmu-raster");
	//ТипыФайлов.Вставить(".ras","image/x-cmu-raster");
	//ТипыФайлов.Вставить(".rast","image/cmu-raster");
	//ТипыФайлов.Вставить(".rexx","text/x-script.rexx");
	//ТипыФайлов.Вставить(".rf","image/vnd.rn-realflash");
	//ТипыФайлов.Вставить(".rgb","image/x-rgb");
	//ТипыФайлов.Вставить(".rm","application/vnd.rn-realmedia");
	//ТипыФайлов.Вставить(".rm","audio/x-pn-realaudio");
	//ТипыФайлов.Вставить(".rmi","audio/mid");
	//ТипыФайлов.Вставить(".rmm","audio/x-pn-realaudio");
	//ТипыФайлов.Вставить(".rmp","audio/x-pn-realaudio");
	//ТипыФайлов.Вставить(".rmp","audio/x-pn-realaudio-plugin");
	//ТипыФайлов.Вставить(".rng","application/ringing-tones");
	//ТипыФайлов.Вставить(".rng","application/vnd.nokia.ringing-tone");
	//ТипыФайлов.Вставить(".rnx","application/vnd.rn-realplayer");
	//ТипыФайлов.Вставить(".roff","application/x-troff");
	//ТипыФайлов.Вставить(".rp","image/vnd.rn-realpix");
	//ТипыФайлов.Вставить(".rpm","audio/x-pn-realaudio-plugin");
	//ТипыФайлов.Вставить(".rt","text/richtext");
	//ТипыФайлов.Вставить(".rt","text/vnd.rn-realtext");
	//ТипыФайлов.Вставить(".rtf","application/rtf");
	//ТипыФайлов.Вставить(".rtf","application/x-rtf");
	//ТипыФайлов.Вставить(".rtf","text/richtext");
	//ТипыФайлов.Вставить(".rtx","application/rtf");
	//ТипыФайлов.Вставить(".rtx","text/richtext");
	//ТипыФайлов.Вставить(".rv","video/vnd.rn-realvideo");
	//ТипыФайлов.Вставить(".s","text/x-asm");
	//ТипыФайлов.Вставить(".s3m","audio/s3m");
	//ТипыФайлов.Вставить(".saveme","application/octet-stream");
	//ТипыФайлов.Вставить(".sbk","application/x-tbook");
	//ТипыФайлов.Вставить(".scm","application/x-lotusscreencam");
	//ТипыФайлов.Вставить(".scm","text/x-script.guile");
	//ТипыФайлов.Вставить(".scm","text/x-script.scheme");
	//ТипыФайлов.Вставить(".scm","video/x-scm");
	//ТипыФайлов.Вставить(".sdml","text/plain");
	//ТипыФайлов.Вставить(".sdp","application/sdp");
	//ТипыФайлов.Вставить(".sdp","application/x-sdp");
	//ТипыФайлов.Вставить(".sdr","application/sounder");
	//ТипыФайлов.Вставить(".sea","application/sea");
	//ТипыФайлов.Вставить(".sea","application/x-sea");
	//ТипыФайлов.Вставить(".set","application/set");
	//ТипыФайлов.Вставить(".sgm","text/sgml");
	//ТипыФайлов.Вставить(".sgm","text/x-sgml");
	//ТипыФайлов.Вставить(".sgml","text/sgml");
	//ТипыФайлов.Вставить(".sgml","text/x-sgml");
	//ТипыФайлов.Вставить(".sh","application/x-bsh");
	//ТипыФайлов.Вставить(".sh","application/x-sh");
	//ТипыФайлов.Вставить(".sh","application/x-shar");
	//ТипыФайлов.Вставить(".sh","text/x-script.sh");
	//ТипыФайлов.Вставить(".shar","application/x-bsh");
	//ТипыФайлов.Вставить(".shar","application/x-shar");
	//ТипыФайлов.Вставить(".shtml","text/html");
	//ТипыФайлов.Вставить(".shtml","text/x-server-parsed-html");
	//ТипыФайлов.Вставить(".sid","audio/x-psid");
	//ТипыФайлов.Вставить(".sit","application/x-sit");
	//ТипыФайлов.Вставить(".sit","application/x-stuffit");
	//ТипыФайлов.Вставить(".skd","application/x-koan");
	//ТипыФайлов.Вставить(".skm","application/x-koan");
	//ТипыФайлов.Вставить(".skp","application/x-koan");
	//ТипыФайлов.Вставить(".skt","application/x-koan");
	//ТипыФайлов.Вставить(".sl","application/x-seelogo");
	//ТипыФайлов.Вставить(".smi","application/smil");
	//ТипыФайлов.Вставить(".smil","application/smil");
	//ТипыФайлов.Вставить(".snd","audio/basic");
	//ТипыФайлов.Вставить(".snd","audio/x-adpcm");
	//ТипыФайлов.Вставить(".sol","application/solids");
	//ТипыФайлов.Вставить(".spc","application/x-pkcs7-certificates");
	//ТипыФайлов.Вставить(".spc","text/x-speech");
	//ТипыФайлов.Вставить(".spl","application/futuresplash");
	//ТипыФайлов.Вставить(".spr","application/x-sprite");
	//ТипыФайлов.Вставить(".sprite","application/x-sprite");
	//ТипыФайлов.Вставить(".src","application/x-wais-source");
	//ТипыФайлов.Вставить(".ssi","text/x-server-parsed-html");
	//ТипыФайлов.Вставить(".ssm","application/streamingmedia");
	//ТипыФайлов.Вставить(".sst","application/vnd.ms-pki.certstore");
	//ТипыФайлов.Вставить(".step","application/step");
	//ТипыФайлов.Вставить(".stl","application/sla");
	//ТипыФайлов.Вставить(".stl","application/vnd.ms-pki.stl");
	//ТипыФайлов.Вставить(".stl","application/x-navistyle");
	//ТипыФайлов.Вставить(".stp","application/step");
	//ТипыФайлов.Вставить(".sv4cpio","application/x-sv4cpio");
	//ТипыФайлов.Вставить(".sv4crc","application/x-sv4crc");
	//ТипыФайлов.Вставить(".svg","image/svg+xml");
	//ТипыФайлов.Вставить(".svf","image/vnd.dwg");
	//ТипыФайлов.Вставить(".svf","image/x-dwg");
	//ТипыФайлов.Вставить(".svr","application/x-world");
	//ТипыФайлов.Вставить(".svr","x-world/x-svr");
	//ТипыФайлов.Вставить(".swf","application/x-shockwave-flash");
	//ТипыФайлов.Вставить(".t","application/x-troff");
	//ТипыФайлов.Вставить(".talk","text/x-speech");
	//ТипыФайлов.Вставить(".tar","application/x-tar");
	//ТипыФайлов.Вставить(".tbk","application/toolbook");
	//ТипыФайлов.Вставить(".tbk","application/x-tbook");
	//ТипыФайлов.Вставить(".tcl","application/x-tcl");
	//ТипыФайлов.Вставить(".tcl","text/x-script.tcl");
	//ТипыФайлов.Вставить(".tcsh","text/x-script.tcsh");
	//ТипыФайлов.Вставить(".tex","application/x-tex");
	//ТипыФайлов.Вставить(".texi","application/x-texinfo");
	//ТипыФайлов.Вставить(".texinfo","application/x-texinfo");
	//ТипыФайлов.Вставить(".text","application/plain");
	//ТипыФайлов.Вставить(".text","text/plain");
	//ТипыФайлов.Вставить(".tgz","application/gnutar");
	//ТипыФайлов.Вставить(".tgz","application/x-compressed");
	//ТипыФайлов.Вставить(".tif","image/tiff");
	//ТипыФайлов.Вставить(".tif","image/x-tiff");
	//ТипыФайлов.Вставить(".tiff","image/tiff");
	//ТипыФайлов.Вставить(".tiff","image/x-tiff");
	//ТипыФайлов.Вставить(".tr","application/x-troff");
	//ТипыФайлов.Вставить(".tsi","audio/tsp-audio");
	//ТипыФайлов.Вставить(".tsp","application/dsptype");
	//ТипыФайлов.Вставить(".tsp","audio/tsplayer");
	//ТипыФайлов.Вставить(".tsv","text/tab-separated-values");
	//ТипыФайлов.Вставить(".turbot","image/florian");
	//ТипыФайлов.Вставить(".txt","text/plain");
	//ТипыФайлов.Вставить(".uil","text/x-uil");
	//ТипыФайлов.Вставить(".uni","text/uri-list");
	//ТипыФайлов.Вставить(".unis","text/uri-list");
	//ТипыФайлов.Вставить(".unv","application/i-deas");
	//ТипыФайлов.Вставить(".uri","text/uri-list");
	//ТипыФайлов.Вставить(".uris","text/uri-list");
	//ТипыФайлов.Вставить(".ustar","application/x-ustar");
	//ТипыФайлов.Вставить(".ustar","multipart/x-ustar");
	//ТипыФайлов.Вставить(".uu","application/octet-stream");
	//ТипыФайлов.Вставить(".uu","text/x-uuencode");
	//ТипыФайлов.Вставить(".uue","text/x-uuencode");
	//ТипыФайлов.Вставить(".vcd","application/x-cdlink");
	//ТипыФайлов.Вставить(".vcs","text/x-vcalendar");
	//ТипыФайлов.Вставить(".vda","application/vda");
	//ТипыФайлов.Вставить(".vdo","video/vdo");
	//ТипыФайлов.Вставить(".vew","application/groupwise");
	//ТипыФайлов.Вставить(".viv","video/vivo");
	//ТипыФайлов.Вставить(".viv","video/vnd.vivo");
	//ТипыФайлов.Вставить(".vivo","video/vivo");
	//ТипыФайлов.Вставить(".vivo","video/vnd.vivo");
	//ТипыФайлов.Вставить(".vmd","application/vocaltec-media-desc");
	//ТипыФайлов.Вставить(".vmf","application/vocaltec-media-file");
	//ТипыФайлов.Вставить(".voc","audio/voc");
	//ТипыФайлов.Вставить(".voc","audio/x-voc");
	//ТипыФайлов.Вставить(".vos","video/vosaic");
	//ТипыФайлов.Вставить(".vox","audio/voxware");
	//ТипыФайлов.Вставить(".vqe","audio/x-twinvq-plugin");
	//ТипыФайлов.Вставить(".vqf","audio/x-twinvq");
	//ТипыФайлов.Вставить(".vql","audio/x-twinvq-plugin");
	//ТипыФайлов.Вставить(".vrml","application/x-vrml");
	//ТипыФайлов.Вставить(".vrml","model/vrml");
	//ТипыФайлов.Вставить(".vrml","x-world/x-vrml");
	//ТипыФайлов.Вставить(".vrt","x-world/x-vrt");
	//ТипыФайлов.Вставить(".vsd","application/x-visio");
	//ТипыФайлов.Вставить(".vst","application/x-visio");
	//ТипыФайлов.Вставить(".vsw","application/x-visio");
	//ТипыФайлов.Вставить(".w60","application/wordperfect6.0");
	//ТипыФайлов.Вставить(".w61","application/wordperfect6.1");
	//ТипыФайлов.Вставить(".w6w","application/msword");
	//ТипыФайлов.Вставить(".wav","audio/wav");
	//ТипыФайлов.Вставить(".wav","audio/x-wav");
	//ТипыФайлов.Вставить(".wb1","application/x-qpro");
	//ТипыФайлов.Вставить(".wbmp","image/vnd.wap.wbmp");
	//ТипыФайлов.Вставить(".web","application/vnd.xara");
	//ТипыФайлов.Вставить(".wiz","application/msword");
	//ТипыФайлов.Вставить(".wk1","application/x-123");
	//ТипыФайлов.Вставить(".wmf","windows/metafile");
	//ТипыФайлов.Вставить(".wml","text/vnd.wap.wml");
	//ТипыФайлов.Вставить(".wmlc","application/vnd.wap.wmlc");
	//ТипыФайлов.Вставить(".wmls","text/vnd.wap.wmlscript");
	//ТипыФайлов.Вставить(".wmlsc","application/vnd.wap.wmlscriptc");
	//ТипыФайлов.Вставить(".word","application/msword");
	//ТипыФайлов.Вставить(".wp","application/wordperfect");
	//ТипыФайлов.Вставить(".wp5","application/wordperfect");
	//ТипыФайлов.Вставить(".wp5","application/wordperfect6.0");
	//ТипыФайлов.Вставить(".wp6","application/wordperfect");
	//ТипыФайлов.Вставить(".wpd","application/wordperfect");
	//ТипыФайлов.Вставить(".wpd","application/x-wpwin");
	//ТипыФайлов.Вставить(".wq1","application/x-lotus");
	//ТипыФайлов.Вставить(".wri","application/mswrite");
	//ТипыФайлов.Вставить(".wri","application/x-wri");
	//ТипыФайлов.Вставить(".wrl","application/x-world");
	//ТипыФайлов.Вставить(".wrl","model/vrml");
	//ТипыФайлов.Вставить(".wrl","x-world/x-vrml");
	//ТипыФайлов.Вставить(".wrz","model/vrml");
	//ТипыФайлов.Вставить(".wrz","x-world/x-vrml");
	//ТипыФайлов.Вставить(".wsc","text/scriplet");
	//ТипыФайлов.Вставить(".wsrc","application/x-wais-source");
	//ТипыФайлов.Вставить(".wtk","application/x-wintalk");
	//ТипыФайлов.Вставить(".xbm","image/x-xbitmap");
	//ТипыФайлов.Вставить(".xbm","image/x-xbm");
	//ТипыФайлов.Вставить(".xbm","image/xbm");
	//ТипыФайлов.Вставить(".xdr","video/x-amt-demorun");
	//ТипыФайлов.Вставить(".xgz","xgl/drawing");
	//ТипыФайлов.Вставить(".xif","image/vnd.xiff");
	//ТипыФайлов.Вставить(".xl","application/excel");
	//ТипыФайлов.Вставить(".xla","application/excel");
	//ТипыФайлов.Вставить(".xla","application/x-excel");
	//ТипыФайлов.Вставить(".xla","application/x-msexcel");
	//ТипыФайлов.Вставить(".xlb","application/excel");
	//ТипыФайлов.Вставить(".xlb","application/vnd.ms-excel");
	//ТипыФайлов.Вставить(".xlb","application/x-excel");
	//ТипыФайлов.Вставить(".xlc","application/excel");
	//ТипыФайлов.Вставить(".xlc","application/vnd.ms-excel");
	//ТипыФайлов.Вставить(".xlc","application/x-excel");
	//ТипыФайлов.Вставить(".xld","application/excel");
	//ТипыФайлов.Вставить(".xld","application/x-excel");
	//ТипыФайлов.Вставить(".xlk","application/excel");
	//ТипыФайлов.Вставить(".xlk","application/x-excel");
	//ТипыФайлов.Вставить(".xll","application/excel");
	//ТипыФайлов.Вставить(".xll","application/vnd.ms-excel");
	//ТипыФайлов.Вставить(".xll","application/x-excel");
	//ТипыФайлов.Вставить(".xlm","application/excel");
	//ТипыФайлов.Вставить(".xlm","application/vnd.ms-excel");
	//ТипыФайлов.Вставить(".xlm","application/x-excel");
	//ТипыФайлов.Вставить(".xls","application/excel");
	//ТипыФайлов.Вставить(".xls","application/vnd.ms-excel");
	//ТипыФайлов.Вставить(".xls","application/x-excel");
	//ТипыФайлов.Вставить(".xls","application/x-msexcel");
	//ТипыФайлов.Вставить(".xlt","application/excel");
	//ТипыФайлов.Вставить(".xlt","application/x-excel");
	//ТипыФайлов.Вставить(".xlv","application/excel");
	//ТипыФайлов.Вставить(".xlv","application/x-excel");
	//ТипыФайлов.Вставить(".xlw","application/excel");
	//ТипыФайлов.Вставить(".xlw","application/vnd.ms-excel");
	//ТипыФайлов.Вставить(".xlw","application/x-excel");
	//ТипыФайлов.Вставить(".xlw","application/x-msexcel");
	//ТипыФайлов.Вставить(".xm","audio/xm");
	//ТипыФайлов.Вставить(".xml","application/xml");
	//ТипыФайлов.Вставить(".xml","text/xml");
	//ТипыФайлов.Вставить(".xmz","xgl/movie");
	//ТипыФайлов.Вставить(".xpix","application/x-vnd.ls-xpix");
	//ТипыФайлов.Вставить(".xpm","image/x-xpixmap");
	//ТипыФайлов.Вставить(".xpm","image/xpm");
	//ТипыФайлов.Вставить(".x-png","image/png");
	//ТипыФайлов.Вставить(".xsr","video/x-amt-showrun");
	//ТипыФайлов.Вставить(".xwd","image/x-xwd");
	//ТипыФайлов.Вставить(".xwd","image/x-xwindowdump");
	//ТипыФайлов.Вставить(".xyz","chemical/x-pdb");
	//ТипыФайлов.Вставить(".z","application/x-compress");
	//ТипыФайлов.Вставить(".z","application/x-compressed");
	//ТипыФайлов.Вставить(".zip","application/x-compressed");
	//ТипыФайлов.Вставить(".zip","application/x-zip-compressed");
	//ТипыФайлов.Вставить(".zip","application/zip");
	//ТипыФайлов.Вставить(".zip","multipart/x-zip");
	//ТипыФайлов.Вставить(".zoo","application/octet-stream");
	//ТипыФайлов.Вставить(".zsh","text/x-script.zsh");
	
	п = "."+нрег(Расширение);
	п = СтрЗаменить(п,"..",".");
	
	Возврат ТипыФайлов.Получить(п);
	
КонецФункции

Функция Подпись(Ключ, Данные)
	
	Возврат Base64Строка(HMACSHA256(Ключ, ПолучитьДвоичныеДанныеИзСтроки(Данные,"UTF-8")));	
	
КонецФункции // ()

Функция HMACSHA256(Знач Ключ, Знач Данные)
	
	Возврат HMAC(Ключ, Данные, ХешФункция.SHA256, 64);
	
КонецФункции

Функция HMAC(Знач Ключ, Знач Данные, Тип, РазмерБлока)
	
	Если Ключ.Размер() > РазмерБлока Тогда
		Ключ = Хеш(Ключ, Тип);
	КонецЕсли;
	
	Если Ключ.Размер() < РазмерБлока Тогда
		Ключ = ПолучитьHexСтрокуИзДвоичныхДанных(Ключ);
		Ключ = Лев(Ключ + ПовторитьСтроку("00", РазмерБлока), РазмерБлока * 2);
	КонецЕсли;
	
	Ключ = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(Ключ);
	
	ipad = ПолучитьБуферДвоичныхДанныхИзHexСтроки(ПовторитьСтроку("36", РазмерБлока));
	opad = ПолучитьБуферДвоичныхДанныхИзHexСтроки(ПовторитьСтроку("5c", РазмерБлока));
	
	ipad.ЗаписатьПобитовоеИсключительноеИли(0, Ключ);
	ikeypad = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(ipad);
	
	opad.ЗаписатьПобитовоеИсключительноеИли(0, Ключ);
	okeypad = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(opad);
	
	Возврат Хеш(СклеитьДвоичныеДанные(okeypad, Хеш(СклеитьДвоичныеДанные(ikeypad, Данные), Тип)), Тип);
	
КонецФункции

Функция Хеш(ДвоичныеДанные, Тип)
	
	Хеширование = Новый ХешированиеДанных(Тип);
	Хеширование.Добавить(ДвоичныеДанные);
	
	Возврат Хеширование.ХешСумма;
	
КонецФункции

Функция ПовторитьСтроку(Строка, Количество)
	
	Части = Новый Массив(Количество);
	Для к = 1 По Количество Цикл
		Части.Добавить(Строка);
	КонецЦикла;
	
	Возврат СтрСоединить(Части, "");
	
КонецФункции

Функция СклеитьДвоичныеДанные(ДвоичныеДанные1, ДвоичныеДанные2)
	
	МассивДвоичныхДанных = Новый Массив;
	МассивДвоичныхДанных.Добавить(ДвоичныеДанные1);
	МассивДвоичныхДанных.Добавить(ДвоичныеДанные2);
	
	Возврат СоединитьДвоичныеДанные(МассивДвоичныхДанных);
	
КонецФункции


Функция ПередатьФайлВХранилищеАЗУР(Контейнер,каталог,имяФайла,ДвоичныеДанныеФайла,рсш,Комм=Неопределено) Экспорт
	
	
	Прокси=ложь;
	ИмяРесурса="azureuttdiag";
	//Контейнер="viber";
	Протокол="https";
	Сервер="192.168.1.1";
	Ключ="JcYgsiaiGk1PPR1yOSXGpVooCtR2Vx+QuqEj71k+P+60P/OQ97ZEilpjQ+UzDv+q51YG5JkMFjnEjAYR4iXuWw==";
	Порт=80;
	
	//ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Адрес);;//Новый ДвоичныеДанные(ПутьКФайлу);
	
	ДанныеФайла=Base64Строка(ДвоичныеДанныеФайла);
	ПутьКФайлуНаСервере = "/"+Контейнер+"/"+Каталог+"/"+имяФайла;
	ПутьКФайлуНаСервереВЗапрос = "/"+ИмяРесурса+"/"+Контейнер+"/"+Каталог+"/"+имяФайла;
	
	Если Прокси Тогда 
		ИнтернетПрокси = Новый ИнтернетПрокси(Ложь);
		ИнтернетПрокси.Установить(Протокол,Сервер,Порт,,,Ложь);	
	Иначе
		ИнтернетПрокси = Новый ИнтернетПрокси(Истина);
	КонецЕсли;	
	
	Соединение = Новый HTTPСоединение(ИмяРесурса+".blob.core.windows.net",443,,,ИнтернетПрокси,,Новый ЗащищенноеСоединениеOpenSSL());	
	
	Дата=ТекущаяДатаGMT();                     
	Version=XMLСтрока("2015-04-05");
	Заголовки = Новый Соответствие;
	
	ContentType = ПолучитьMIMEФайла(рсш);			//; charset=UTF-8";
	РазмерФайла=XMLСтрока(ДвоичныеДанныеФайла.Размер());
	Заголовки.Вставить("Content-Length",РазмерФайла);
	Заголовки.Вставить("Content-Type",ContentType);
	Заголовки.Вставить("x-ms-blob-type",XMLСтрока("BlockBlob"));
	Заголовки.Вставить("x-ms-date",Дата);
	Заголовки.Вставить("x-ms-version",Version);
	
	ТекстЗапроса = "PUT
	|
	|
	|"+РазмерФайла+"
	|
	|"+ContentType+"
	|
	|
	|
	|
	|
	|
	|x-ms-blob-type:BlockBlob
	|x-ms-date:"+Дата+"
	|x-ms-version:"+Version+"
	|"+ПутьКФайлуНаСервереВЗапрос;
	
	ТекстЗапроса=XMLСтрока(ТекстЗапроса);
	
	
	КлючДвоичныеДанные=Base64Значение(Ключ);
	КлючЗапросаХМАК=Подпись(КлючДвоичныеДанные,ТекстЗапроса);
	
	Auth="SharedKey "+ИмяРесурса+":"+КлючЗапросаХМАК;
	Заголовки.Вставить("Authorization",Auth);	
	
	Запрос = Новый HTTPЗапрос(ПутьКФайлуНаСервере,Заголовки);
	Запрос.УстановитьТелоИзДвоичныхДанных(ДвоичныеДанныеФайла);
	
	Попытка
		Ответ = Соединение.Записать(Запрос);
		URL = Ответ.ПолучитьТелоКакСтроку();
		Если Ответ.КодСостояния=201 Тогда
	     	Комм = ""+Ответ.КодСостояния+". Удачно выполнен PUT запрос!"; 
			Возврат "https://azureuttdiag.blob.core.windows.net/"+Контейнер+"/"+каталог+"/"+ИмяФайла;
		Иначе	
			Комм = "Ошибка. "+Ответ.КодСостояния+" "+URL;
			Сообщить(Комм);
			Возврат Ложь;
		КонецЕсли;	
	Исключение
		Комм = ОписаниеОшибки();
		Сообщить(Комм);
		Возврат ЛожЬ;
	КонецПопытки;
	
КонецФункции



#КонецОбласти

Функция НайтиПодписчиков(emailИдФЛ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Subscriber.Код КАК Код,
	               |	Subscriber.ФИО КАК ФИО,
	               |	Subscriber.ссылка
	               |ИЗ
	               |	Справочник.Subscriber КАК Subscriber
	               |ГДЕ
	               |	Subscriber.email = &email или Subscriber.email1 = &email или Subscriber.идФЛ = &email";
	
	Запрос.УстановитьПараметр("email",emailИдФЛ);
	
	
	
	Возврат Запрос.Выполнить().Выгрузить();;
	
КонецФункции

Функция ОтправитьПоПочтовомуАдресуИлиИдФЛ(emailИдФЛ,ДвоичныеДанныеФайла=Неопределено,Заголовок,Текст,Лог="") Экспорт 
	
	
	ТБл =НайтиПодписчиков(emailИдФЛ);
	Если Тбл.Количество()=0 ТОгда 
		Лог = Лог+ "Viber: нет подписчиков с таким емайлом/идФЛ "+emailИдФЛ; 
		Возврат Ложь;
	Конецесли;
	
	Структура = Новый Структура();
	Структура.Вставить("sender",Новый Структура("name","urals bot"));
	
	
	Если ДвоичныеДанныеФайла<>Неопределено Тогда
		ИмяФайла = СокрЛП(Новый УникальныйИдентификатор())+".pdf";
		Каталог = "w"+Формат(НачалоНедели(ТекущаяДата()),"ДФ=yyyyMMdd");
		
		сс = ПередатьФайлВХранилищеАЗУР("viber",Каталог,имяФайла,ДвоичныеДанныеФайла,".pdf");
		Если сс=Ложь ТОгда
			Сообщить("Ошибка передачи файла в АЗУР");
			Лог = Лог+  "viber: Ошибка передачи файла в АЗУР";
			Возврат Ложь;
		КонецЕСЛИ;
		
		Структура.Вставить("type", "file");
		Структура.Вставить("media", сс);
		Структура.Вставить("size", ДвоичныеДанныеФайла.Размер());
		Структура.Вставить("file_name", ""+Заголовок+".pdf");
		
	Иначе	
		Структура.Вставить("type", "text");
		Структура.Вставить("text", СокрЛП(Заголовок+" "+Текст));
		
	КонецЕСЛИ;

	
	
	Для каждого Стр из ТБл Цикл
		Структура.Вставить("receiver", Стр.Код);
		глViber.ОтправитьЗапросНаСерверВайбера("send_message", Структура);
		Лог=Лог+"viber: файл отправлен "+Стр.ФИО+Символы.пс;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции