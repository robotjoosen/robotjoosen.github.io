---
title: "Zelf een Smartwatch bouwen met WIFI functies"
layout: post
date: 2020-05-29 12:00:00
categories: project
tags: Arduino DIY Electronics ESP8266
color: yellow
image: /assets/post/smartwatch/header.jpg
---

Je zou kunnen denken, is deze titel misleidend? Natuurlijk is hij dat want hij heeft veel meer dan alleen WIFI. Het is
alleen zo dat er standaard WIFI op een ESP8266 zit. Dit was misschien een beetje flauw dus laten welke toffe dingen er
nog meer opzitten.

Even terug naar het begin. Een tijd geleden had ik besloten zoveel mogelijk sensoren, die ik in huis had liggen, te
gebruiken. Ik ben geen verzamelaar tenslotte. Met het maken van een smartwatch zorg je er gelijk voor dat je een hele
bulk sensoren in kan zetten. Als ik sensoren zeg bedoel ik eigenlijk gewoon modules. Er zijn uiteindelijk maar 3
sensoren in verwerkt en 2 modules.

In het verleden heb ik vaak gekozen voor eenvoudige sensoren zoals een `LDR` of `Push button`. Deze sluit je aan met een
`pull-up of -down resistor` en sluit hem vervolgen aan op een analoge of digitale pin. Deze keer ben ik volledig gegaan
voor I²C modules. De keuze hiervoor was voornamelijk om dat ik hoopte dit alles op een Digispark te krijgen, maar door
de grote van de code was dit uiteindelijk niet realistisch. Wel is het mogelijk om het op de kleinste ESP8266 variant te
krijgen, de ESP-01. Door het beperkte aantal poorten moet je er zo efficiënt mogelijk mee omgaan. Omdat je met I²C maar
2 poorten nodig hebt en daarop meerdere modules kan aansluiten is dit ideaal in deze gevallen.

Voor dit project heb ik echter gekozen voor de grotere ESP8266 de `NodeMCU Lolin`. Dit om de eenvoudige reden dat hier
minder beperkingen op zitten, en tijdens een prototype fase ik geen zin had in nog meer drempels. Gelukkig blijven
mijn "producten" in de prototype fase dus hoef ik mij later ook geen zorgen te maken dat dit veranderd moet worden.

## I²C is eenvoudig maar heeft zijn uitdagingen

Zoals ik al schreef kun je op `I²C` meerdere modules aansluiten met het gebruik van maar 2 poorten. Dit is natuurlijk
superhandig en heb je niet perse veel poorten nodig. Hierdoor ontstaat er een uitdaging en dat zijn adressen. Elke I²C
module heeft zijn eigen adres deze staan over het algemeen vast. Gelukkig hebben sommige modules de mogelijkheid om hun
adres te wijzigen door bijvoorbeeld een pin te verbinden met zijn `Vin` of `Gnd` pin. Een adres kan bijvoorbeeld het HEX
getal `0x68` zijn of `0x50`. Op de website van Adafruit
staat [een mooie lijst](https://learn.adafruit.com/i2c-addresses/the-list)
met de verschillende adressen.

Ik merkte dat niet alle adressen goed terug te vinden waren in de lijst. Door gebruik te maken van de
[I2c_scanner](https://playground.arduino.cc/Main/I2cScanner/) code kun je eenvoudig zien welke modules aangesloten zijn.
En voor mij begon hier een klein stukje van de ellende. Het zit namelijk zo. De `Gyroscope` maakt gebruik van adres
`0x68`
wat geen probleem is natuurlijk. Echter, maakt de `TinyRTC` gebruik van `0x68` en `0x50`. Iets wat geen probleem is als
je
beide los gebruikt. Samen is het een puinhoop die op te lossen is. Wat gebeurde er nu. Ik sloot de Gyroscoop aan en had
verbinding, vervolgens sloot ik de TinyRTC aan en werkte het niet meer, en soms werkte het wel. De eerste gedachte was
dat ik te weinig ampere had, dit bleek niet het geval. Na 2 uur zoeken kwam ik er achter dat de TinyRTC twee adressen
had en één overeen kwam met die van de Gyroscoop. Gelukkig heeft deze laatste de mogelijkheid om zijn adres te
veranderen door de `ADR` pin te verbinden met de `Vin` pin en het adres `0x69` wordt. vier uur later en het probleem is
opgelost!

## Wat kan deze smartwatch eigenlijk?

Je kent nu de uitdagingen, maar weet nog helemaal niet wat er gemaakt is. Laten we daar maar snel in duiken. De
Smartwatch heeft als basis de ESP8266 in de NodeMCU V3 Lolin variant. Hierop zijn vervolgens
de [ADS1115]((https://www.adafruit.com/product/1085)) met een
Joystick, [MPU6050](https://www.tinytronics.nl/nl/sensoren/accelerometer-gyro/mpu-6050-accelerometer-en-gyroscope-3-axis-module-3.3v-5v)
Gyroscope, [MAX30105](https://nl.aliexpress.com/w/wholesale-MAX30105.html) Heartrate
sensor, [DS1307](https://www.tinytronics.nl/nl/sensoren/tijd/open-smart-ds1307-rtc-module-i2c-incl.-batterij) TinyRTC,
en een [SSD1306](https://nl.aliexpress.com/w/wholesale-ssd1306-oled.html) Oled Display. Dankzij al deze modules is het
nu mogelijk om beweging te detecteren, de tijd en datum bij te houden, je hartslag te meten en alle informatie te tonen
op een scherm. Hoe geweldig is dat?! Weet je wat nog beter is? Het filmpje zodat je ook ziet dat het echt werkt!

<div class="post__video--container">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/YIbEhayBxiE?si=OS7Opu4htkVLKANT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>