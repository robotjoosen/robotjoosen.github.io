---
title: "Een LEMP stack opzetten met Docker"
layout: post
date: 2020-03-31 12:00:00
categories: project
tags: Docker LEMP LINUX MySQL NGINX PHP Server
color: cyan
image: /assets/post/lemp-stack-docker/header.jpg
---

Een lange tijd heb ik gebruik gemaakt van XAMP, MAMP en daarna AMPPS. Die eerste twee heb ik het grootste deel van mijn
carrière gebruikt. Deze werken goed, maar het moment dat ik met domeinnamen moest gaan goochelen werd het een probleem.
Vanaf dat moment ben ik overgestapt naar AMPPS. Het heeft de belangrijkste onderdelen van MAMP en je kunt eigen
domeinnamen instellen per website. Superhandig! Enige probleem is dat zij alleen een 32-bit versie hebben, en met oog op
de toekomst zal AMPPS op een gegeven moment niet meer werken. Buiten de compatibiliteitsproblemen was het toevoegen van
modules zoals Image Magick een drama. Een goed moment om mij te richten op Docker.

Docker kun je voor veel doeleinde inzetten, ik gebruik het als development omgeving. In deze tutorial laat ik zien hoe
ook jij dit voor elkaar kan krijgen. Voor deze tutorial richten je een server in met de LEMP stack. Mocht je het nog
niet door hebben LEMP staat voor Linux, NGINX, MySQL, PHP. Laat we maar gewoon beginnen.

## Docker

Het eerste wat je nodig hebt, is Docker for Mac of Windows. Dit is je Docker omgeving waarin je straks je containers laat
draaien. Zodra je dit gedaan hebt en Docker hebt draaien kun je vervolgens in je terminal kijken of alles naar behoren
werkt met het onderstaande commando.

```shell
docker --version                             
Docker version 19.03.8, build afacb8b
```

## Eigen domeinnamen met nginx-proxy

Docker heeft geen ingebouwde manier om domeinnamen te verwijzen naar jouw Docker container. Om dit wel te kunnen doen
maken we gebruik van `nginx-proxy`. Dit is een reverse proxy server die zich bindt aan poort 80. Hij verwijst vervolgens 
de verzoeken op poort 80 door naar de juiste container. Dit is een over versimpelde uitleg, maar ik hoop dat het voor nu
even duidelijk is.

Het opzetten van nginx-proxy doe je op de volgende wijze.

```shell
docker network create nginx-proxy
docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker network connect nginx-proxy nginx-proxy
```

Met deze drie commando's heb je een nieuw netwerk gecreëerd, de nginx-proxy container gestart, en deze uiteindelijk
gekoppeld aan het netwerk. Dit nieuwe netwerk kunnen we straks gebruiken om onze Docker containers aan te koppelen.

## Docker Compose

Het is mogelijk om alle containers via de command line aan te maken en te laten draaien. Dit kost echter tijd en veel
handelingen. Elke dienst die wij gaan gebruiken is namelijk een eigen container. Deze webserver heeft straks 3
containers nodig. Om alles zo eenvoudig mogelijk te houden en herbruikbaar maken we gebruiken van `docker-compose`.

De [Compose tool](https://docs.docker.com/compose/) maakt voor zijn configuratie gebruik van een `YAML` bestand genaamd 
`docker-compose.yml`. We beginnen met het aanmaken van dit bestand.

```yaml
version: "3.1"

services:
networks:
```

## Netwerk toevoegen

De volgende handeling is het toevoegen van het eerder gemaakte netwerk. Deze plaatsen wij aan het einde van het bestand.

```yaml
networks:
  default:
    external:
      name: nginx-proxy
```

## De Webserver Container

Vanaf hier gaan wij 3 services toevoegen, de eerste hiervan is de webserver. Hiervoor maken we gebruik van 
`nginx:alpine` image. Deze NGINX image maakt gebruik van [Alpine Linux](https://www.alpinelinux.org). Dit is een 
lichtgewicht Linux versie perfect voor het gebruik in Docker containers.

Het is belangrijk om de container een unieke naam te geven in de `container_name` parameter. Wanneer je dit niet doet
krijg je conflicten. Ik gebruik voor mij eigen project vaak de volgende benaming `company-project-service`

Vervolgens binden wij de huidige folder aan de `/application` folder binnen de container via `volumes`. Dit zorgt ervoor 
dat wij vrij buiten de container kunnen werken, maar de bestanden wel gebruikt kunnen worden door de container. Dit 
zelfde geldt voor het configuratie bestand `nginx.conf`.

Uiteindelijk koppelen we een `VIRTUAL_HOST` aan onze container. Dit is straks de domeinnaam van jouw project. Vergeet 
ook niet poort 80 te exposen voor nginx-proxy.

Dit ziet er vervolgens als volgt uit.

```yaml
webserver:
  image: nginx:alpine
  container_name: 'company-project-webserver'
  working_dir: /application
  volumes:
    - .:/application
    - ./docker/nginx/nginx.conf:/etc/nginx/conf.d/default.conf
  environment:
    VIRTUAL_HOST: 'local.projectname.tld'
  expose:
    - 80
```

## NGINX configuratie bestand

Zoals eerder genoemd maakt deze container gebruik van een externe configuratie bestand voor NGINX. Voor goede lezers
onder ons bevindt deze zich in de folder `docker/nginx/` met de naam `nginx.conf`.

In dit configuratie bestand stellen we Fastcgi in voor alle PHP bestanden. En belangrijker nog, we vertellen waar de
server zijn root bevind. In mijn geval gebruik ik altijd `root /application/public_html`. Dit is voor mij handig omdat
mijn host de `public_html` benaming gebruikt. En andere veel voorkomende naam is `www` of `htdocs`.

Als extra zetten we een rewrite naar index.php voor het gebruik van FURL's. Omdat ik zelf vaak MODX gebruik staat deze "
aan". Het is verstandig om voor je zelf de juiste instellingen voor jouw CMS te zoeken (als je er eentje gebruikt).

Maak de folder en het bestand aan en voeg hier de volgende regels aan toe.

```nginx configuration
server {
listen 80 default;

    client_max_body_size 108M;

    access_log /var/log/nginx/application.access.log;

    root /application/public_html;
    index index.php;

    # modx friendly url
    if (!-e $request_filename) {
        rewrite ^/(.*)$ /index.php?q=$1 last;
    }

    # wordpress friendly url
    #location / {
    #    try_files $uri $uri/ /index.php?$args ;
    #}

    location ~ \.php$ {
        fastcgi_pass php-fpm:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PHP_VALUE "error_log=/var/log/nginx/application_php_errors.log";
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        include fastcgi_params;
    }
}
```

## PHP FastCGI Process Manager

Nu we klaar zijn met de webserver kunnen we verder gaan met de PHP Container. Voor deze container maken we gebruik van
`php-fpm`. In tegenstelling tot de webserver maken we hier gebruik van de `build` parameter. Dit is een pad dat verwijst
naar een Dockerfile. In dit geval is dat `docker/php-fpm`.

Net zoals de webserver container geven we deze een unieke naam. Hier gebruik ik dezelfde naamgevingstijl voor als bij de
webserver.

Ook hier koppelen we de huidige folder. Als extra maken we ook een bestand aan voor php-ini overrides. Dit bestand
bevindt zich vervolgens ook in de `docker/php-fpm` folder met de naam `php-ini-overrides.ini`. In mijn geval staan er in 
dit bestand de volgende regels.

```ini
upload_max_filesize = 100M
post_max_size = 108M
```

De onderstaande configuratie plaats je direct onder de webserver service in de `docker-compose.yml`. Let overigens op 
dat de indents goed staan en deze configuratie onder services valt.

```yaml
php-fpm:
  build: docker/php-fpm
  container_name: 'company-project-php-fpm'
  working_dir: /application
  volumes:
    - .:/application
    - ./docker/php-fpm/php-ini-overrides.ini:/etc/php/7.4/fpm/conf.d/99-overrides.ini
```

Nu we onze Docker configuratie geplaatst hebben gaan we over op de Dockerfile. Maak hiervoor het volgende bestand aan
`docker/php-fpm/Dockerfile`. Dit is een instructie bestand voor het opzetten van een Docker Image.

In onze Dockerfile geven we aan dat de `phpdockerio/php74-fpm` image gebruikt moet worden. En vervolgens vertellen we dat
er een aantal extensies voor PHP geïnstalleerd moeten worden. Je kunt de extensies vrij uitbreiden met wat je zelf nodig
hebt. In deze configuratie installeren we als voorbeeld php-mysql en php-imagick.

```dockerfile
FROM phpdockerio/php74-fpm:latest

WORKDIR "/application"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# install php extensions
RUN apt-get update && apt-get -y --no-install-recommends install php7.4-mysql php-imagick \
&& apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# install locales
RUN apt-get clean && apt-get update && apt-get install -y locales \
&& locale-gen en_US.UTF-8 \
&& locale-gen nl_NL.UTF-8
```

## MySQL Database toevoegen

We hebben nu een webserver met PHP, maar nog geen database. Voor deze stap hoeven we gelukkig alleen maar een service
toe te voegen. Hoewel deze stap eenvoudig is heeft het wel een aantal nadelen.

Als eerste hebben we de poort publiek maken. Het openzetten van poort 80 is relatief onschuldig. Maar dit met je
database poort doen betekent dat iedereen je database kan bekijken.
Het is om deze reden extreem belangrijk een goed wachtwoord te gebruiken. `root:mysql` is geen goed wachtwoord. Gebruik
bijvoorbeeld een [wachtwoord generator](https://1password.com/password-generator).

Ook voor deze container geldt hetzelfde, gebruik een unieke naam. Plaats de onderstaande configuratie onder de services.

```yaml
mysql:
  image: mysql:5.7
  container_name: company-project-mysql
  working_dir: /application
  volumes:
    - .:/application
  environment:
    - MYSQL_ROOT_PASSWORD=root_password
    - MYSQL_DATABASE=database_name
    - MYSQL_USER=username
    - MYSQL_PASSWORD=password
  ports:
    - "9002:3306"
```

## Klaar om te bouwen

Nu we onze `docker-compose.yml` helemaal op orde hebben en alle andere bestanden op hun plek hebben staan kunnen we over
gaan tot het bouwen van de containers. Open de Terminal of je Console en laten we gaan bouwen!

Met het commando `docker-compose up -d` start je het bouwen van de containers. De `-d` zorgt er voor dat het proces zich
in de achtergrond afspeelt (detached) en je de terminal gerust kan sluiten.

Als je klaar bent met je project kun je `docker-compose stop` gebruiken om de container te stoppen. En mocht je de
volgende dag weer willen beginnen gebruik je `docker-compose start`.

Dat is ongeveer alles wat je nodig hebt om je eigen LEMP-server met Docker op te zetten. Als je denkt, hier heb ik geen
zin in kun je altijd [phpdocker.io](https://phpdocker.io) gebruiken om een Docker omgeving te configureren. Of als je
een MODX-project hebt kan je ook gebruik maken van mijn
repository [https://github.com/robotjoosen/Docker-MODX-Setup](https://github.com/robotjoosen/Docker-MODX-Setup)