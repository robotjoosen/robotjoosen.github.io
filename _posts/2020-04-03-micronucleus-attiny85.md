---
title: "Micronucleus op de ATTiny85 schrijven met een Arduino ISP"
layout: post
date: 2020-04-03 12:00:00
categories: tutorial
tags: Arduino ATTiny85 Digispark DIY
color: yellow
image: /assets/post/attiny85-arduinoisp/header.jpg
---

Als je net zoals mij nog een aantal ATTiny85 hebt rond liggen kan deze tutorial nog best handig zijn. Vorige jaar heb ik
enkele Digispark clone bordjes gekocht waaronder ook de DIP Socket versie. Deze worden namelijk niet gemaakt door
Digistump, vandaar de clone. De tutorial werkt overigens ook op de andere Digispark clone borden.

Het doel van deze tutorial is de `ATTiny85` te voorzien van de micronucleus bootloader zodat deze te gebruiken zijn als
Digispark. Hiervoor hebben we buiten een Digispark (stijl) bord, ook een `Arduino` nodig. Deze gaan we inzetten als
`In-System Programmer` ook wel `ISP`. Zelf heb ik gebruik gemaakt van een Duemilanove maar ik verwacht dat de meeste
mensen een UNO hebben.

## Arduino als ISP

Een ISP maakt het mogelijk om chips te kunnen programmeren. Het is zelfs mogelijk om met een Arduino een nieuwe ATMEGA
te programmeren. Hoe geweldig is dat!

Voor het programmeren van de Arduino als ISP open je de Arduino IDE. Vervolgens open je via het menu
`File > Examples > 11.ArduinoISP > ArduinoISP`. Deze code upload je vervolgens zoals je normaal ook zou doen.

### Verschil tussen Duemilanove en UNO

Tussen de Duemilanove en Uno zit een verschil in het gebruik als ISP. Waar de UNO een condensator nodig heeft, heeft de
Duemilanove een weerstand nodig.

De `UNO` het een `10uF condensator` tussen de `Reset` en `Ground` pin nodig. Let op dat je deze in de juiste richting
plaatst.

De `Duemilanove` maakt gebruik van een `110 Ohm t/m 124 Ohm weerstand` tussen de `Reset` en `5V`. Zelf heb ik bij gebrek
aan beter een 150 Ohm weerstand gebruikt. Dit werkte ook maar word niet geadviseerd.

![Arduino Duemilenove en Arduino Uno als ISP](/assets/post/attiny85-arduinoisp/arduino-duemilanove-uno.jpg)

## Digispark aansluiten op de Arduino ISP

Nu de `Arduino ISP` klaar is kun je beginnen met het aansluiten van de `Digispark` op de Arduino. Gebruik bij het
aansluiten verschillende kleuren. Dit kan je helpen met het overzicht houden. Verbinden alle pinnen zoals hier onder
beschreven staat.

| Digispark | Arduino |
|-----------|---------|
| 5V        | 5V      |
| GND       | GND     |
| P5        | 10      |
| P0        | 11      |
| P1        | 12      |
| P2        | 13      |

![ArduinoISP Digispark](/assets/post/attiny85-arduinoisp/arduinoisp-digispark.jpg)

## Bijna klaar om te programmeren

Wanneer je alles hebt aangesloten ben je bijna klaar om de ATTiny85 te voorzien van de Micronucleus bootloader. Eerst
moeten we nog avrdude installeren en de bootloader downloaden. Als eerst download je de laatste versie van Micronucleus.
Je kunt deze downloaden via Github of de repository kopiëren via de command line zoals hieronder beschreven staat.

```shell
git clone https://github.com/micronucleus/micronucleus.git
```

Het programmeren doen we met avrdude. Een snelle manier om dit te installeren op MacOS is via Homebrew. Hier maak je
gebruik van de avrdude formule.

```shell
brew install avrdude
```

## Klein controle

Voordat we beginnen met schrijven kijken we eerst of de ATTiny85 herkend wordt.

```shell
avrdude -P/dev/cu.usbserial-A600acOv -b19200 -cstk500v1 -pattiny85 -n
```

De output zal er ongeveer zo uit komen te zien.

```shell
avrdude: please define PAGEL and BS2 signals in the configuration file for part ATtiny85
avrdude: AVR device initialized and ready to accept instructions

Reading | ################################################## | 100% 0.02s

avrdude: Device signature = 0x1e930b

avrdude: safemode: Fuses OK

avrdude done. Thank you.
```

## Klaar om te programmeren!

Nu je klaar bent om te programmeren heb de volgende keuze. De meeste Digispark Clones worden geleverd met `P5` als
`Reset`
pin waardoor deze niet bruikbaar is. Bij de originele borden is configuratie zekering ingesteld waardoor de Reset pin
niet werkt. Dit heeft als gevolg dat het overschrijven van de bootloader alleen nog met een High Voltage ISP gedaan kan
worden.

Om te beginnen met programmeren open je de terminal en ga je naar de folder `micronucleus/firmware/releases`. Dit is
nodig zodat de verwijzing naar de juiste release goed gaat.

```shell
cd micronucleus/firmware/releases
```

### Programmeren met P5 als Reset pin

Met het volgende commando programmeer je de ATTiny85 met Micronucleus, maar je kunt dan geen gebruik maken van de P5.

```shell
avrdude -C/Applications/Arduino.app/Contents/Java/hardware/tools/avr/etc/avrdude.conf -v -pattiny85 -cstk500v1
-P/dev/cu.usbserial-A600acOv -b19200 -Uflash:w:t85_default.hex -U lfuse:w:0xF1:m -U hfuse:w:0xD5:m -U efuse:w:0xFE:m
````

### Programmeren met P5

Met het volgende commando programmeer je de ATTiny85 met Micronucleus zoals de originele Digispark. Het detail zit hem
in -U hfuse:w:0x55:m

```shell
avrdude -C/Applications/Arduino.app/Contents/Java/hardware/tools/avr/etc/avrdude.conf -v -pattiny85 -cstk500v1
-P/dev/cu.usbserial-A600acOv -b19200 -Uflash:w:t85_default.hex -U lfuse:w:0xF1:m -U hfuse:w:0x55:m -U efuse:w:0xFE:m
```

### Alleen de configuratie zekering instellen

Het is natuurlijk ook mogelijk om alleen de zekering in te stellen. Je hebt dan geen Micronucleus nodig. Je voert dan
alleen een memory operation uit op de zekering. Dit doe je bijvoorbeeld met een clone bord.

```shell
avrdude -C/Applications/Arduino.app/Contents/Java/hardware/tools/avr/etc/avrdude.conf -v -pattiny85 -cstk500v1
-P/dev/cu.usbserial-A600acOv -b19200 -U hfuse:w:0x55:m
```

### Legenda

| Option | 	Omschrijving         |
|--------|-----------------------|
| C      | 	Configuratie bestand |
| c      | 	Programmer ID        |
| b      | 	Baudrate             |
| v      | 	Verbose              |
| P      | 	Poort                |
| p      | 	Part no.             |
| U      | 	Memory Operation     |

* let op hoofdlettergevoelig