#RSSReader - простое iOS приложение, созданное как тестовое задание

Реализовать простое приложение реализующие функцию просмотра новостей с пользовательским предпочтениями.

1. Приложение визуально должно иметь:
а) главный список новостей (+ дочерний экран деталей новости)
б) экран аккаунта
в) переключение между ними по вкладкам внизу экрана

2. Список новостей:
а) Использовать любой RSS источник данных, например http://habrahabr.ru/rss/hubs/ , для отображения в списке данных.
б) Разобрать и сохранить данные списка новостей в локальное хранилище (после перезапуска приложения в списке новостей должен отображаться последний сохраненный успешно вариант при отсутствии подключения к Интернет).
в) Отобразить данные ленты в виде списка, в котором в каждой строке должны отображаться заголовок, дата записи, не более 5 строк начала текста новости. Данные должны быть упорядочены по дате в порядке убывания.
г) Реализовать автоподстройку размера ячейки под размер контента но показывать не более 5 строк новости.
д) Обновление данных по Pull to Refresh сверху таблицы.
е) При тапе на конкретную запись открыть полную запись по полученной ссылке на отдельном экране деталей во внедренном в экран браузере
ж) По долгому тапу на новости в списке либо нажатию action-кнопки на экране деталей, открывать action sheet с вариантами: сохранить в избранное/либо убрать если оно уже там. Должно работать, если пользователь авторизован.

3. Аккаунт
а) На экране аккаунта, в случае отсутствия авторизации должно предлагаться авторизоваться (по простому - захардкодить логин/пароль).
б) В случае если пользователь уже авторизован на экране должно быть: кнопка выхода, кнопка избранного, в котором отображаются избранные новости в том же виде что и на главной странице.

Технические требования:
- Приложение должно поддерживать iOS 9 и выше
- Проект должен быть написан с использованием ARC
- Проект должен быть написан на Swift и Objective C одновременно (преимущественно Swift).
- Хранение данных должно быть организовано с использованием Core Data.
- Обновление данных (включая запись) должно производиться не в основном потоке.
- Верстка экранов должна быть реализована с использованием storyboard, size classes, autolayout.

