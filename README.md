# de_challenge

## 05.02.2023 Hackathon
### Загрузка данных из S3

* Лог-файл по действиям пользователей скачивается из S3-хранилища с помощью 
* Далее, мы пушим данный файл в HDFS, с которого в дальнейшем будет считывать spark
* Данную таблицу, мы загружаем в Staging-слой нашего хранилища.


 В хранилище 3 слоя : staging, dds (снежинка), cdm.
 Дашборды строятся на слое CDM , который одновременно является reporting слоем.
 Данные в слое DDS обновляются посредством Postgres operator. Идемпотентность обеспечивается ограничением уникальности натуральных ключей и через UPSERT.

 Так как ivent type не объявлен в исходных данных, взяли тип события по url_path
