#Использовать "../../core"

Перем Лог;

// Заполняет описание команды для библиотеки cli
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Настраиваемая команда
//
Процедура ОписаниеКоманды(КомандаПриложения) Экспорт
	
	КомандаПриложения.Опция("name", "", "Синоним (алиас) устанавливаемой версии для последущего использования в ovm use")
		.ТСтрока()
		.ВОкружении("OVM_INSTALL_NAME");

	КомандаПриложения.Опция("clean c", Ложь, "Полностью очищать каталог установки (включая установленные библиотеки)")
		.ВОкружении("OVM_INSTALL_CLEAN");

	КомандаПриложения.Аргумент("VERSION", , "Устанавливаемая версия (версии) OneScript. Допустимо использовать трехномерные версии (1.0.17, 1.0.18), stable, dev. Может быть передано несколько значений")
					.ТМассивСтрок()
					.ВОкружении("OVM_INSTALL_VERSION");
	
КонецПроцедуры

// Обработчик выполнения команды
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Выполняемая команда
//
Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
	
	МассивВерсийКУстановке = КомандаПриложения.ЗначениеАргумента("VERSION");
	АлиасВерсии = КомандаПриложения.ЗначениеОпции("name");
	ОчищатьКаталогУстановки = КомандаПриложения.ЗначениеОпции("clean");
	
	Если ЗначениеЗаполнено(АлиасВерсии) И МассивВерсийКУстановке.Количество() > 1 Тогда
		ВызватьИсключение "Опция <--name> может быть задана только при установке одной версии OneScript";
	КонецЕсли;
	
	УстановщикOneScript = Новый УстановщикOneScript();
	
	Для Каждого ВерсияКУстановке Из МассивВерсийКУстановке Цикл
		УстановщикOneScript.УстановитьOneScript(ВерсияКУстановке, АлиасВерсии, ОчищатьКаталогУстановки);
	КонецЦикла;
	
	Если МассивВерсийКУстановке.Количество() > 0 Тогда
		Лог.Информация(
			"Для начала использования версии OneScript, выполните команду:
			|ovm use %1",
			?(ЗначениеЗаполнено(АлиасВерсии), АлиасВерсии, МассивВерсийКУстановке[МассивВерсийКУстановке.ВГраница()])
		);
	КонецЕсли;

КонецПроцедуры

Лог = ПараметрыOVM.ПолучитьЛог();
