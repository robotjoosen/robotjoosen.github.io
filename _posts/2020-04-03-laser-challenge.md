---
title: "Laser Challenge - oud speelgoed nieuw leven inblazen"
layout: post
date:   2020-04-03 12:00:00
categories: project
tags: Arduino DIY ESP8266 Javascript Server
color: yellow
image: /assets/post/laser-challenge/header.jpg
---

Een project dat al sinds 1997 in de maak is, is eindelijk af! Het klinkt misschien vreemd maar het is toch een klein beetje waar. Het begon allemaal toen ik het laserschietspel Laser Challenge kreeg. Maar helaas ontbrak het belangrijkste onderdeel hiervan. De borstplaat met alle intelligentie. Sindsdien heeft het eigenlijk altijd in de kast gelegen en sinds een paar jaar in de berging.

## Altijd bij een plan gebleven

Het plan om er iets van de maken is er altijd geweest, ik wist alleen niet hoe. Wel wist ik dat het een soort van schiettent idee moest worden. Een van de plannen was een beamer samen met een infraroodcamera zodat deze kon zien waar er geschoten werd. Helaas had ik beide niet dus ging het plan niet door. Op deze manier zijn heel wat ideeën gesneuveld.
Afgelopen januari had ik mij zelf als doel gesteld om het project af te ronden. Een probleem met mijn plannen is dat het vaak in m'n hoofd blijft rondzweven, maar het uitvoeren is altijd een drempel. Alleen dit jaar moest het gebeuren en wilde ik geen stap terug doen.

## Van plan naar uitvoering

Het nieuwe idee, wat haalbaar moet zijn, was een op tijd gebaseerd parcour-laserschietspel. De spullen voor een eerste test had ik in huis dus dat kon mij niet tegenhouden. De opzet was simpel. Je neemt een aantal NodeMCU microcontrollers met een infrarood sensor, deze verbind je met elkaar en zodra zij geraakt worden communiceren ze met een centrale computer. Wanneer alles geraakt is stop de timer.

Helaas kwam hier het eerste probleem kijken. Om alle controllers synchroon te laten werken wilde ik een mesh netwerk opzetten. Ik dacht dat zo'n netwerk opzetten met de ESP8266 makkelijk was. Er waren tenslotte twee bibliotheken beschikbaar. De praktijk was anders. De geleverde code werkte, maar zodra ik deze aanpaste werkte deze niet meer. Hierbij kwam ook nog eens kijken dat door achterstallige software updates en verkeerde instellingen ik twee weken lang tegen alleen maar onverklaarbare problemen aan liep.

> TIP. Controleer altijd je software, is alles up-to-date, zijn je instellingen juist?

Het moest dus anders. Na alles geüpdatet te hebben en de juiste configuratie bepaalde had kon ik een andere aanpak bedenken. Deze keer op basis van dingen die ik al eerder heb gebruikt, en weet dat het werkt. Een belangrijke beslissing was het loslaten van synchrone timing. De latency van de connectie was het niet waard om de rest van het project te laten vallen.
De nieuwe opzet was een stuk meer basis maar betrouwbaar. De controllers verbinden met het 2.4GHZ wifi netwerk en praten direct met een webserver. Het moment dat de server een request ontvangt wordt deze opgeslagen in de database. De server tijd is hierbij leidend. Als een request vertraagd is heb je gewoon pech.

Het registreren van een infraroodsignaal met de Arduino was erg simpel, bijna eng. De gebruikte bibliotheek deed alles wat het moest doen. Dit uiteindelijk combineren met de wifibibliotheek was kinderspel. Als dingen zo makkelijk gaan vraag ik me altijd af of het wel goed is.

_* Tot op vandaag werkt het extreem betrouwbaar, dus dat zal dan goed zitten._

## Een eind er aan breien

> Bekijk de tutorial. [LEMP server installeren op de Raspberry PI]()

De techniek werkte, de controller communiceerde met de server, en de server deed dat ook terug. In eerste instantie was de server mijn laptop. Dit is uiteindelijk verplaatst naar een Raspberry PI met touchscreen zodat het bijwijze van spreken over al neergezet kan worden.

Om er een echt spel van te maken bevat het een front-end website waarbij het spel gestart kan worden, de score ingezien kan worden, en hoeveel apparaten verbonden zijn. Hiermee werkt het "standalone" en is het plug&play.

Wil je zien hoe het geworden is? Bekijk de video en ik hoor graag wat jij ervan vind. Wil je dit zelf maken? De code vind je op mijn Github [github.com/robotjoosen/LaserChallenge](github.com/robotjoosen/LaserChallenge).

<div class="post__video--container">
    <iframe width="560" height="315" src="https://youtube.com/embed/zddo93FXOU0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>
</div>