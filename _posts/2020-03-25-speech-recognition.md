---
title: "Spelen met de Speech Recognition API: Laat je browser terugpraten."
layout: post
date: 2020-03-25 12:00:00
categories: experiment
tags: API Browser Chrome Javascript
color: white
image: /assets/post/speech-recognition/header.jpg
---

Eigenlijk heb ik nooit zoveel aandacht gehad voor browser API's. Een van de redenen is Internet Explorer waar veel
browser specifieke geintjes in zaten. Klanten zien dat gebeuren en willen dat ook, maar het moet wel
op [alle browser](https://caniuse.com/speech-recognition) exact zo werken. Iets wat soms wel lukt maar meestal niet, en
achteraf altijd een drama is. Fast forward naar nu, want de Speech Recognition API is te leuk om te laten liggen. Het
werkt dan wel niet in alle browsers, maar who cares!

De Speech Recognition API is best tof, maar is nog steeds experimenteel. Voor dit project heb ik gebruik gemaakt van de
Google Chrome versie. Deze versie van de API verstuurt de spraak naar zijn eigen servers om het te verwerken. In
principe krijg is het dus de [Cloud Speech-to-Text](https://cloud.google.com/speech-to-text) zonder API Key. Er zit wel
een limiet op het aantal requests, maar die ben ik tot op heden nog niet tegengekomen.

## De basis van de code

Ook al maak ik gebruik van Chrome houden we de eer aan ons zelf en maken we het nog wel future-proof. Dus in het geval
van het ontbreken van de `SpeechRecognition` functie vallen we terug op `webkitSpeechRecognition` functie. Verder geven
expliciet aan dat we de Nederlandse taal hanteren. Een interessant detail is de `continuous` parameter. Hierdoor krijg
je ook tussentijdse resultaten terug. Buiten dat het mooi is om te zien hoe hij de spraak verwerkt, levert het ook een
stukje snelheid op. De onderstaande code geeft elk stukje resultaat terug in de console.

```javascript
let SpeechRecognition = SpeechRecognition || webkitSpeechRecognition;
let recognition = new webkitSpeechRecognition();
recognition.continuous = true;
recognition.lang = 'nl';
recognition.onresult = function (event) {
    let result = event.results[event.results.length - 1][0].transcript;
    console.debug(result);
}
recognition.start();
```

## De uitwerking in een geweldige Web App

Alle code voor dit project is te vinden op mijn
Github [robotjoosen/speech-recognition-webapp](https://github.com/robotjoosen/speech-recognition-webapp). De code is
niet super goed gedocumenteerd maar zou je in ieder geval de goede richting op moeten sturen. Omdat de code op Github
niet genoeg is heb ik er uiteraard een video over gemaakt. Veel kijk plezier.

<div class="post__video--container">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/sKUY-iHkAX0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>
</div>