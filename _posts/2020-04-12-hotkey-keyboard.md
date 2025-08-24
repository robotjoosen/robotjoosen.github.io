---
title: "Maak een hotkeys keyboard met de Digispark"
layout: post
date:   2020-04-12 12:00:00
categories: project
tags: donut cookie rockets ATTiny85
color: cyan
image: /assets/post/hotkey-keyboard/header.jpg
---

Deze hotkey keyboard is het lieve broertje van de keystroke injector. Het meest belangrijke verschil is dat deze je
gegevens niet probeert te jatten. Vorig jaar heb ik mij bezig gehouden met PEN testing apparaten en wat ze nou precies
doen. Nu ben ik verre van een expert, maar ben mij wel verder gaan verdiepen in keystroke injectors. Bekende voorbeelden
zijn bijvoorbeeld de [Bash Bunny][bash-bunny] en [USB Rubber Ducky][rubber-duckey] van [Hak5][hak5]. Deze laatste is 
bijvoorbeeld gebruikt in de serie [Mr. Robot][mr-robot]. In tegenstelling tot deze apparaten met de mogelijkheid om 
wachtwoorden te stelen van je computer of een reverse shell op te zetten, heb ik de vriendelijke variant gemaakt; Hotkey
Keyboard, de vriend in het huishouden.

> Als je je eigen Digispark clone wilt maken volg dan de tutorial Micronucleus op de ATTiny85 schrijven.

Dit keyboard heeft als doel handeling te automatiseren en hiermee mijn leven een stuk simpeler te maken.
De benodigdheden zijn eenvoudig. Voor dit project maak ik gebruik van een `Digispark` (clone), een ADS1115, en 4
drukknoppen met pull-down resistor.

De handelingen worden "hard" geprogrammeerd in de code. Ze kunnen natuurlijk altijd overschreven worden met een nieuw
programma. Dit betekent alleen dat het niet geschikt is voor "iedereen". Niet dat iedereen een keystroke injector wilt
hebben, maar toch.

## Twee manieren, zelfde resultaat

Voor dit project heb ik twee versies uitgeprobeerd. De eerste was met de `CD4051` Multiplexer de andere met de `ADS1115`
ADC. Beide werkte even goed, uiteindelijk heb ik toch gekozen voor de ADS1115. Één van de redenen was de eenvoud van het
gebruik. Voor de multiplexer was er een kleine bit shift function nodig en voor de ADC was een bibliotheek beschikbaar.

Wat is dan het grote verschil tussen deze twee? De CD4051 heeft 8 analoge poorten. Omdat bij de CD4051 multiplexer je
aangeeft welke poort je wilt uitlezen heb je 3 poorten nodig op jouw MCU, 1 om het analoge signaal te lezen, de andere
drie om tussen poorten te schakelen. Had ik al gezegd dat ik een Digispark clone heb waar je 1 poort minder tot je
beschikking had? Zo niet, je komt 1 poort te kort om alle 8 de poorten te kunnen lezen. Omdat je maar twee poorten kunt
gebruiken kan je er maar 4 uitlezen. Dat is voor dit project geen probleem. Misschien alleen zonde van de chip om maar
voor de helft te gebruiken. Het aansluiten van de multiplexer ziet er als volgt uit.

![hotkey keyboard with cd4051 breadboard](/assets/post/hotkey-keyboard/Hotkey-Keyboard_CD4051_bb.jpg)

De uiteindelijk gekozen variant is de versie met een ADS1115. Het grote voordeel hiervan is dat hij gebruik maakt van
I2C om data te communiceren. Dit zorgt ervoor dat je uiteindelijk 4 van deze modules aan met elkaar kan koppelen met
maar twee kabels. Dit komt uiteindelijk neer op 16 analoge poorten. Dat is best veel. Buiten de eenvoud van de code, is
het aansluiten ook een stuk makkelijker. Kijk maar.

![hotkey keyboard with ADS1115 breadboard](/assets/post/hotkey-keyboard/Hotkey-Keyboard_bb.jpg)

## Wat kan je er nou uiteindelijk mee?

Je hebt de elektronica maar daarmee is het op z'n minst een leuk attribuut voor op je bureau. Hoe laat je hem dingen
doen. Laten we beginnen met de basis. Voor de eenvoud heb ik de code op mijn Github Gist geplaatst [Hotkey keyboard
ADS1115 Gist][ADS1115-gist].

Het uitvoeren van een serie van toetsaanslagen is nu mogelijk om met één druk op de knop. Je kunt bijvoorbeeld je
computer hallo laten zeggen. De meest eenvoudig aanpak is ervoor te zorgen dat je de `Terminal` geopend word en vervolgens
het `say` commando gebruikt word. Dat ziet er ongeveer zo uit.

```cpp
DigiKeyboard.sendKeyStroke(KEY_SPACE, MOD_GUI_LEFT);
DigiKeyboard.delay(250);
DigiKeyboard.print("terminal");
DigiKeyboard.sendKeyStroke(KEY_ENTER);
DigiKeyboard.delay(250);
DigiKeyboard.println("say hello");
```

Wat je hier ziet is dat in het geval van Mac OS `CMD + spatie` in gedrukt worden om `spotlight` te openen. Vervolgens
wachten we even en typen we daarna `terminal` en drukken we op `enter`. Hiermee wordt de terminal geopend. Na een korte
wacht periode typen we `say hello` en door de `println` functie geeft hij automatisch een `enter` mee.

Er zijn natuurlijk nog veel meer dingen mogelijk zoals het aanroepen van [IFTTT][ifttt] Webhooks. Dit kan
je doen via het `curl` maar dat is iets voor een andere keer.

Mocht je mijn laatste video nog niet gezien hebben waar ik de Hotkey Keyboard laat zien raad ik je dat zeker aan om te
kijken. En anders tot de volgende keer.

[bash-bunny]: https://shop.hak5.org/products/bash-bunny
[rubber-ducky]: https://shop.hak5.org/collections/physical-access/products/usb-rubber-ducky-deluxe
[hak5]: https://shop.hak5.org/
[mr-robot]: https://www.hak5.org/blog/15-second-password-hack-mr-robot-style
[ADS1115-gist]: https://gist.github.com/robotjoosen/505a3f32c91e67c0bf71fe3ee3ea6126
[ifttt]: https://ifttt.com/

<div class="post__video--container">
    <iframe width="560" height="315" src="https://youtube.com/embed/ci4wRP0_cw0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>
</div>