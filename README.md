# <img width="154" height="154" alt="image" src="https://github.com/user-attachments/assets/633edded-1ddc-4e99-bb3e-1850bf482c6a" /> Chiaki (PS Remote) for Anbernic RG 40XX H
AnChiaki - это переделанный форк [Сhiaki 2.2.0](https://git.sr.ht/~thestr4ng3r/chiaki), в котором за основу был взят [репозиторий Retro Chiaki](https://github.com/ed-fruty/retro-chiaki#upstream-and-license), переписанный под устройство Anbernic RG 40XX H под две операционные системы кастомных прошивок [Mustard OS](https://muos.dev/release/current/2601_1#rg40xx-h) , а так же моей любимой [Stock Mod OS](https://github.com/cbepx-me/Anbernic-H700-RG-xx-StockOS-Modification)<sup>[!]</sup> .  
<sub><b>[!]</b> Этот проект не одобрен и не сертифицирован Sony Interactive Entertainment. Вам нужен собственный аккаунт PS4 или PS5 и PSN </sub>  

### Возможности:
Для StockMod OS были переписаны окна под масштабы системы  
Управление вашей Playstation из любой точки мира вашим карманным Anbernic RG40XX H



## 💿 Установка:
### 📁 Для MuOs: 

	1- mnt/mmc/ports/ - распаковываем папку chiaki из пути "Ваш диск и место куда вы распаковали архив"\AnChiaki 2.0-anbernic-RG40XXH-muOS-release\retro-chiaki-anbernic RG40XXH-Muos-release\ports  - на выходе имеем /mnt/mmc/ports/chiaki/

	2. /mnt/mmc/ROMS/Ports/<sup>[*]</sup> - распаковываем файл Chiaki.Sh \AnChiaki 2.0-anbernic-RG40XXH-muOS-release\retro-chiaki-anbernic RG40XXH-Muos-release\ROMS\Ports - на выходе путь: /mnt/mmc/ROMS/Ports/Chiaki.sh

	3. Папка MuOS - по желанию если нужно распаковать оригинальный значок для приложения


<sub><b>❗</b>или если вы ставите на вторую флешку, а не на системную то путь куда распаковывать каталог меняется на: mnt/sdcard/ports/</sub>

### 📁 Для StockMod Os:

	1. Распаковываем \AnСhiaki-v2.0-RG40XXH-StockOS-MOD-release.zip\ports в папку /mnt/sdcard/roms/ports/ на выходе должно быть /mnt/sdcard/roms/ports/chiaki/
	
	2. Распаковываем \AnСhiaki-v2.0-RG40XXH-StockOS-MOD-release.zip\ROMS\Ports\Chiaki.sh  в папку /mnt/sdcard/roms/ports/ на выходе /mnt/sdcard/roms/ports/Chiaki.sh

<sub><b>❗</b>или если вы ставите на первую системную, то путь куда распаковывать каталог меняется на: /mnt/mmc/Roms/PORTS/</sub>


## 🕹️➡️🎮 Управление:
### Все клавиши сделаны как можно ближе к джойстику PS:		
	
	 Anberic           Playstation  
	   🎮                 🎮
		B        ➡️        ✕ 
		Y        ➡️        □
		X        ➡️        △
		A        ➡️        ○
		R1       ➡️        R1
		R2       ➡️        R2
		R3       ➡️        R3
		L1       ➡️        L1
		L2       ➡️        L2
		L3       ➡️        L3
		D-Pad    ➡️       D-Pad
		M        ➡️      Сенсорная панель
		SE       ➡️      Кнопка PS
		ST       ➡️      Кнопка Option

❗Выйти из приложения/стрима - М + Start

## ⚙️ Настройка: 
1.Регистрируем консоль в своем аккаунте, необходимый id BASE64, можно получить c помощью [PSNTOOLS](https://www.psntools.com/psn/checker)

2.Далее на ps включаем дистанционную игру и вводим в anbernic pin код, который нам дала ps.   

Примечание:  

⚙️ Кнопка Wake в меню Chiaki - отправляет на консоль пакет WakeUp, эта кнопка специально была добавлена, если вы далее будете подключатся не во wifi сети, а с помощью хоста, ваша приставка находящаяся в режиме сна проснется.  

⚙️ Для подключения к приставки вне сети в которой она находится, необходимо открыть порты на вашем роутере:  


<img width="250" height="290" alt="image" src="https://github.com/user-attachments/assets/d04274e5-3c74-433c-b2b2-bb5cb7289e11" />


❗а также иметь статичный (белый) IP❗ - который вы добавляте в поле host в приложении Chiaki


## 🧋 Подержка проекта 🧋 

Если вам понравилось приложение и вы ожидаете обновлений других интересных портов на Anberic RG40XXH, [поддержите проект](https://boosty.to/yamapsn/donate)  




