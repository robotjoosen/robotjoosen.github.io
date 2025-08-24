---
title: "Plant Vriend - Flora monitor met gevoel"
layout: post
date: 2020-03-25 12:00:00
categories: project
tags: DIY Electronics ESP8266
color: cyan
image: /assets/post/plant-friend/header.jpg
---

Soms heb je een project dat je op een kladpapiertje hebt geschreven en er vervolgens heel langs niets mee doet. Plant
Vriend is zo'n project. Het begon als een planten project video en is uit eindelijk een vierdelige "video serie"
geworden verspreid over ongeveer een half jaar tijd.

Met Plant Vriend wilde ik de staat van een plant een gezicht geven. Door dat de bodemvochtigheid wordt vertaalt naar "
emotie" helpt het de staat van de plant beter te begrijpen. Dit is schijnbaar nodig voor mij, want ik begrijp niet dat
droge grond betekent dat hij water nodig heeft.

In dit artikel vertel ik het hoe, wat, waar over Plant Vriend. Ik hoop dat je onderweg hier ook nog iets van opsteekt,
en misschien ooit je eigen plant vriend kan maken.

## De hardware achter Plant Vriend.

> - NodeMCU V2
> - I2C Oled Display
> - Soil moisture sensor
> - Push button breakout
> - LDR breakout

Voor dit project heb ik gebruik gemaakt van een `NodeMCU v2`. En microcontroller gebaseerd op de `ESP8266`. Een
belangrijke reden voor deze keuze is omdat ik deze al in huis had. Verder waren was het formaat en de analoge inputs een
reden om niet te kiezen voor een Arduino UNO of ESP32.

Het scherm dat ik hiervoor heb gebruikt is een klein goedkoop `0.96" OLED-scherm`. Een fijne bijkomstigheid is dat er
een hoop bibliotheken te vinden zijn die code hiervoor aanbieden. Iets wat ik bij de aanschaf overigens nooit had
bekeken.

Voor het meten van de bodemvochtigheid heb ik gebruik gemaakt van een sensor waar je op AliExpress ongeveer 3 varianten
van kan vinden. Ik heb gekozen voor die ene die je bijna nergens tegenkomt. En ik raad verder ook niemand aan deze te
kopen. Ze kunnen namelijk heel slecht tegen vocht, en die van mij is tijdens het project ook nog eens stuk gegaan. Een
capacitieve `bodemvochtigheidssensor` is waarschijnlijk een beter keuzen.

Verder heb ik een `Push Button` en `LDR` op een breakout board gebruikt. Had ik vroeger ervoor gekozen het circuit zelf
in elkaar te zetten met het nodige debug werk. Kies ik tegenwoordig voor gemak en koop ik breakout boards. Helaas is het
wel zo dat de goedkope borden wel eens verkeerd gelabeld zijn en je deze alsnog moet debuggen.

![Plant Friend Schematic](/assets/post/plant-friend/circuit.jpg)

## Alles aansluiten

Zoals je hierboven ziet heb ik een mooi schema gemaakt voor het aansluiten van het geheel. Belangrijk om te weten is dat
je niet alles zomaar kan in pluggen. Zo moet je de `SDA` `D1` `GPIO5` en `SCL` `D2` `GPIO4` voor de I2C aansluiten op de
juiste pin.

Bij het gebruik van een breakout board wijst alles zichzelf. Helaas had ik in Fritzing geen breakout boards dus heb ik
voor beide sensoren en pull-down resistor gebruikt. Het nut hiervan is dat je "zwevende" waardes voorkomt op je input.
Met een pull-down resistor verbind je hem met ground en is het standaard nul. Zodra de sensor een spanning doorlaat zal
deze direct doorstromen naar de input. Spanning is lui en kiest altijd de weg van de minste weerstand.

Hieronder staan alle verbindingen in een "handig" overzicht:

| NodeMCU V2           | 3V3 | GND | D1  | D2  | D5 | D6 | D8  |
|----------------------|-----|-----|-----|-----|----|----|-----|
| SSD1306              | VCC | GND | SDA | SCL |    |    |     |
| LDR                  | V   | G   |     |     |    | S  |
| Push Button          | V   | G   |     |     | S  |    |     | 
| Soil Moisture Sensor | VCC | GND |     |     |    |    | SIG |

## De code

Voor dat ik ga uitleggen hoe de code werkt wil ik je eerst verwijzen naar de Plant Vriend
Repository https://github.com/robotjoosen/PlantFriend. Hier kun je alle code vinden die gebruikt is voor dit project,
plus er zit de nodige documentatie bij. Aangezien ik in niete al teveel detail treedt zal ik het maken van sprites kort
uitleggen.

### XBM codes genereren voor de SSD1306

Om afbeeldingen te kunnen plaatsen op het OLED scherm kun je BMP bestanden omzetten naar XBM. Een XBM-bestand bevat een
unsigned char array iets wat super handig is voor het gebruik in C++. Het kosten mij even om er achter te komen hoe ik
een goede XBM kon genereren. Aangezien ik geen Windows bak heb en dus LCD Assistant niet kon gebruiken. Hiervoor moest
ik dus een andere manier vinden.

Gelukkig bestaat er zoiets als Image Magick en is dat super makkelijk te installeren, als je Homebrew hebt. Zo niet
begin daar dan eerst mee via https://brew.sh/. Installeer vervolgens Image Magick met de volgende
formule https://formulae.brew.sh/formula/imagemagick.

installeer homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

installeer image magick

```shell
brew install imagemagick
```

Magick is een handig stuk software voor het maken, bewerken en omzetten van afbeeldingen. En dat allemaal via de command
line. In dit geval gebruik je het voor het omzetten van een BMP naar een XBM. Het volgende commando creëert nieuwe XBM's
op basis van alle BMP's in de folder.

```shell 
magick mogrify -format xbm *.bmp
```

Wanneer je een van de XBM bestanden opent zie je de array met de nodige HEX code. Dit kun je vervolgens gebruiken in je
project.

Misschien ook goed om te weten is dat de afbeelding niet de grote hoeft te hebben van je scherm. Je kunt namelijk ook
kleine delen van het scherm updaten zoals ik met Plant Vriend heb gedaan. Het hergebruiken van sprites zorgt er namelijk
voor dat je straks minder ruimte in beslag neemt op de MCU, en meer ruimte overhoudt voor andere code.

## Plant Vriend is af!

In een kleine vogel vlucht heb ik je door het project genomen. Ik had waarschijnlijk veel meer onderdelen kunnen
uitlichten alleen blijft er dan niets meer over voor andere artikelen. I andere aankomende Blogs, Experimenten,
Tutorials zal dit in detail behandeld worden. Voor nu is het project afgerond en volledig werkend te zien in de video
**The Rise of Plant Friend**.

<div class="post__video--container">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/XayU6SnrVsE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>
</div>