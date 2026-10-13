# <img width="154" height="154" alt="image" src="https://github.com/user-attachments/assets/633edded-1ddc-4e99-bb3e-1850bf482c6a" /> Chiaki (PS Remote) for Anbernic RG 40XX H
AnChiaki - это переделанный форк [Сhiaki 2.2.0](https://git.sr.ht/~thestr4ng3r/chiaki), в котором за основу был взят репозиторий [Retro Chiaki](https://github.com/ed-жfruty/retro-chiaki#upstream-and-license), переписанный под устройство Anbernic RG 40XX H под две операционные системы кастомных прошивок [Mustard OS](https://muos.dev/release/current/2601_1#rg40xx-h) , а так же моей любимой [Stock Mod OS](https://github.com/cbepx-me/Anbernic-H700-RG-xx-StockOS-Modification)<sup>🚨</sup> .  
<sub><b>🚨</b> Этот проект не одобрен и не сертифицирован Sony Interactive Entertainment. Вам нужен собственный аккаунт PS4 или PS5 и PSN </sub>  

### 🛰️ Возможности программы:

👨🏾‍💻 Для StockMod OS были переписаны окна, под масштабы экрана системы   

🌐 Управление вашей Playstation из любой точки мира вашим карманным Anbernic RG40XX H<sup>🚨</sup>  
 <sub><b>🚨</b> Если у вас на роутере постоянный IP и открыты порты (инструкция далее)



## 💿 Установка:  
❗Заранее в Portmaster - Настройки - Менеджер среды исполнения - Скачать все❗  

❗Обновить Portmaster до последней версии ❗  

### 📁 Для MuOs: 

	1- mnt/mmc/ports/ - распаковываем папку chiaki из пути "Ваш диск и место куда вы распаковали архив"\AnChiaki 2.0-anbernic-RG40XXH-muOS-release\retro-chiaki-anbernic RG40XXH-Muos-release\ports  - на выходе имеем /mnt/mmc/ports/chiaki/

	2. /mnt/mmc/ROMS/Ports/ - распаковываем файл Chiaki.Sh \AnChiaki 2.0-anbernic-RG40XXH-muOS-release\retro-chiaki-anbernic RG40XXH-Muos-release\ROMS\Ports - на выходе путь: /mnt/mmc/ROMS/Ports/Chiaki.sh

	3. Папка MuOS - по желанию если нужно распаковать оригинальный значок для приложения


<sub><b>❗</b>или если вы ставите на вторую флешку, а не на системную то путь куда распаковывать каталог меняется на: mnt/sdcard/ports/</sub>

### 📁 Для StockMod Os:

	1. Распаковываем \AnChiaki-StockOS-MOD-release.zip\ports в папку /mnt/sdcard/roms/ports/ на выходе должно быть /mnt/sdcard/roms/ports/chiaki/
	
	2. Распаковываем \AnChiaki-StockOS-MOD-release.zip\ROMS\Ports\Chiaki.sh  в папку /mnt/sdcard/roms/ports/ на выходе /mnt/sdcard/roms/ports/Chiaki.sh

<sub><b>❗</b>или если вы ставите на первую sd (системную), то путь куда распаковывать каталог меняется на: /mnt/mmc/Roms/PORTS/</sub>


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

1. Регистрируем консоль в своем аккаунте, необходимый id BASE64, можно получить c помощью [PSNTOOLS](https://www.psntools.com/psn/checker)

2. Далее на ps включаем дистанционную игру и вводим в anbernic pin код, который нам дала ps.   

Примечание:  

⚙️ Кнопка Wake в меню Chiaki - отправляет на консоль пакет WakeUp, это позволяет разбудить консоль из интернета, находящаяся в режиме сна консоль - проснется.  

⚙️ Для подключения к приставке из интернета, необходимо открыть следующие порты на вашем роутере:  


<img width="250" height="290" alt="image" src="https://github.com/user-attachments/assets/d04274e5-3c74-433c-b2b2-bb5cb7289e11" />


❗а также иметь статичный (белый) IP❗ - который вы добавляте в поле host в приложении Chiaki  

## 📷 Скриншоты:  

<img width="500" height="250" alt="WhatsApp Image 2026-10-12 at 16 09 13" src="https://github.com/user-attachments/assets/ab3b6f50-95c0-407a-adee-d56334015a43" />    
	<img width="500" height="250" alt="WhatsApp Image 2026-10-12 at 16 09 13 (1)" src="https://github.com/user-attachments/assets/7a5a6ec7-4f6c-4d2b-8694-c8f8765f473b" />  
	<img width="500" height="250" alt="WhatsApp Image 2026-10-12 at 16 09 13 (2)" src="https://github.com/user-attachments/assets/3ad544e1-9208-4ceb-9acd-528c2f52c8ae" />  
	<img width="500" height="250" alt="WhatsApp Image 2026-10-12 at 16 09 13 (3)" src="https://github.com/user-attachments/assets/bd34d89f-6f6c-4150-8f57-fbdbd26a1e35" />  
	<img width="500" height="250" alt="WhatsApp Image 2026-10-12 at 16 09 13 (4)" src="https://github.com/user-attachments/assets/61d498f0-b125-4110-aff4-e00d0ebf5adb" />  
	<img width="500" height="250" alt="WhatsApp Image 2026-10-12 at 16 09 13 (8)" src="https://github.com/user-attachments/assets/5ee1c97f-7c5d-444c-a86d-ef9aad697fae" />






## 🧋 Подержка проекта 🧋 

Если вам понравилось приложение и вы ожидаете обновлений других интересных портов на Anberic RG40XXH, [поддержите](https://boosty.to/yamapsn/donate) нас 🤗  




