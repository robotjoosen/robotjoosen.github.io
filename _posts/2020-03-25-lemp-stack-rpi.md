---
title: "Een LEMP Server installeren op de Raspberry PI"
layout: post
date: 2020-03-25 12:00:00
categories: project
tags: LEMP LINUX MySQL NGINX PHP Raspberry PI Server
color: white
image: /assets/post/lemp-stack-rpi/header.jpg
---

Als je net zoals mij een [Raspberry PI](https://www.raspberrypi.org) hebt gekocht kan het zo zijn dat je niet weet wat je er mee moet doen. Een goede oefening is het opzetten van een LEMP Server. Veel servers maken gebruik van de Debian architectuur zo ook de RPI. Dit geeft je de mogelijkheid om dingen uit te proberen zonder al te veel risico. Zoals het platleggen van een productie server.

In deze tutorial leg ik uit hoe je een LEMP Server kunt installeren op de Raspberry PI. LEMP staat voor Linux, NGINX, MySQL en PHP. Een vaker voorkomende configuratie is LAMP, waar de A voor Apache staat. De keuze voor NGINX boven Apache is voornamelijk gebaseerd op snelheid van de engine. Buiten dat, ben ik geen fan van het configureren van htaccess.

## De Raspberry PI klaar maken

Voor deze opzet kiezen we voor een basis installatie van [Raspbian Desktop](https://www.raspberrypi.com/software/) zonder alle software. Je kunt nog verder gaan en de Lite versie installeren. Maar deze tutorial is voortgekomen uit het Laser Challenge project waar ik de Desktop versie nodig had. Kies dus wat je nodig hebt. De installatie van de Raspberry PI is verder het standaard verhaal dat je hier kunt vinden: [Raspberry PI: Installing operating system images](https://www.raspberrypi.com/documentation/computers/getting-started.html)

Zodra je Raspberry PI klaar is, kun je beginnen met het updaten en upgraden van het system. Vanaf nu speelt alles zich af in de Console. Open je Console en type de volgende regels:

```shell
sudo apt-get update
sudo apt-get upgrade
```

### 1. NGINX Installeren en configureren

Om te beginnen installeren we de webserver. Zoals eerder gezegd maken we gebruik van [NGINX](https://nginx.org). Dit spreek je uit als [Engine X](https://en.wikipedia.org/wiki/Nginx), niet als Enginks. Waarbij de voornaamste redenen eenvoud en snelheid zijn. We beginnen dus netjes met de installatie.

Instaleer nginx

```shell
sudo apt install nginx
```

Nu je NGINX hebt geïnstalleerd kun je met het commando nginx -v kun je zien of alles naar behoren werkt. Als het goed werkt zie je het versie nummer van de NGINX server.

Omdat we straks PHP gaan gebruiken als basis van de website moeten we nog wat aanpassen in de configuratie van de server. Hiervoor gaan we gebruiken van nano om aanpassingen te doen aan het configuratie bestand.

```shell
sudo nano /etc/nginx/sites-enabled/default
```

In het configuratie bestand moet je de volgende regels aanpassen.

Ook al hebben we nog geen PHP geïnstalleerd verwijzen we wel alvast de index naar index.php. Ga op zoek naar de regelindex `index.html` `index.htm` en voeg `index.php` toe. Dit zorgt er voor dat hij straks eerst zoekt naar index.php en daarna pas index.html en daarna index.htm. dit ziet er als volgt uit.

```
index index.php index.html index.htm
```

Als laatste voegen we FastCGI toe. Zoek in het configuratie bestand de volgende regel `# location ~ \.php$ {`. Zoals je aan de `#` ziet is dit uit gecommentarieerd. Deze gaan we verwijderen zodat FastCGI gebruikt gaat worden. Het zal er ongeveer zo uit komen te zien

```nginx configuration
location ~ \.php$ {
include snippets/fastcgi-php.conf;

    # With php-fpm (or other unix sockets):
    fastcgi_pass unix:/run/php/php7.3-fpm.sock;
}
```

Nu je alles hebt aangepast druk je op `ctrl + x` op de vraag of je de aanpassingen wilt opslaan kies je `Y` ook wel Yes. En vervolgens druk je op `enter` om het bestand te overschrijven met de aanpassingen.

### 2. PHP installeren

### 3. Misschien wel de minst spectaculair stap, maar wel een belangrijke. De volgende stap is het installeren van PHP FPM (FastCGI Process Manager). In de Console type je het volgende.

sudo apt install php-fpm
Nu je PHP hebt geïnstalleerd kunnen kan je de webserver starten en kijken of alles werkt. Overigens is het verstandig om alles te testen voor dat je de config aanpast, maar "living on the edge". Elke keer dat je ene wijzigingen doet aan de configuratie moet je de server opnieuw starten. Met de volgende commando's ben je heer en meester over je webserver.

```shell
# start webserver
sudo /etc/init.d/nginx start

# stop webserver
sudo /etc/init.d/nginx stop

# restart webserver
sudo /etc/init.d/nginx restart
```

Als je de server start kun je in de browser naar http://localhost gaan. Je zult een tekst zien met Welcome to nginx!.

### 3. MySQL installeren en configureren

De laatste stap voor je eigen full blown LEMP Stack webserver is het installeren en configureren van MySQL. De installatie is net zo simpel als PHP, het configureren is wat meer werk.

Inplaats van MySQL gebruiken we MariaDB, ze zijn redelijk compatible met elkaar maar MariaDB is een stukje sneller.

```shell
sudo apt install mariadb-server
```

De volgende stap is belangrijk, en dat is MySQL voorzien van een wachtwoord. Ook al werk je lokaal voorzie het van een goed wachtwoord. Met het volgende commando kun je het proces beginnen.

```shell
sudo mysql_secure_installation
```

Nu je MySQL hebt voorzien van een wachtwoord kunnen we een gebruiker en database opzetten. Als eerst log je in op de MySQL server en vervolgens voeren we een serie commando's in voor het aanmaken van de database, een gebruiker en zijn rechten tot de database.

```shell
#log in op mysql server
sudo mysql -u root -p

# database aanmaken
CREATE DATABASE database_name;

# gebruiker aanmaken
CREATE USER 'user_name'@'localhost' IDENTIFIED BY 'password';

# gebruiker toevoegen aan database
GRANT ALL PRIVILEGES ON database_name.* TO 'user_name'@'localhost';

# ververs rechten
FLUSH PRIVILEGES;
```

## Webserver gebruiken

Nu je de Raspberry PI hebt ingesteld als webserver kun je hem gaan gebruiken voor je webprojecten. In de folder /var/www/html kun je de project bestanden plaatsen. Je kunt bijvoorbeeld MODX of Wordpress installeren.