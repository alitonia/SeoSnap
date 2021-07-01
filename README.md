![logo](https://github.com/experius/SeoSnap/raw/master/assets/logo.png)

Setup for the whole seosnap stack including dashboard, cache server and cache warmer used for prerendering and full page
caching PWA's.

Original version at: https://github.com/experius/SeoSnap

This repo illustrates how you can install and run __SeoSnap__
at [this commit](https://github.com/experius/SeoSnap/commit/a5281e22ff458eda90fc9f352296a0815f1669a2).

## Installation

Requirement:

* make (if you install with code)
* docker, docker-compose

### With code:

#### Step 1: Get code

    git clone https://github.com/experius/SeoSnap.git
    cd SeoSnap
    git checkout develop

#### Step 2: Fix code

* Go to __seosnap-dashboard/dev/commands/install.sh__, change content of the file to:

        #!/bin/sh
        if [ -f ".env" ]; then
        echo 'Generating new secret key'
        # export NEW_SECRET="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c50)";
        export NEW_SECRET="$(head /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c60)";
        
        sed -i.bak "s/https\:\/\/miniwebtool.com\/django-secret-key-generator\//${NEW_SECRET}/g" .env;
        
        echo 'Setting new admin user login'
        read -p 'Username [snaptron]: ' ADMIN_NAME
        read -p 'Email [snaptron@snap.tron]: ' ADMIN_EMAIL
        read -sp 'Password [Sn@ptron1337]: ' ADMIN_PASS
        sed -i.bak "s/snaptron$/${ADMIN_NAME:-snaptron}/g" .env;
        sed -i.bak "s/snaptron@snap.tron/${ADMIN_EMAIL:-snaptron@snap.tron}/g" .env;
        sed -i.bak "s/Sn@ptron1337/${ADMIN_PASS:-Sn@ptron1337}/g" .env;
        fi

* At root folder, run: `make install`
* At root folder, run: `make up`

### Built version

#### Step 1: Get code

* Download [this](https://github.com/experius/SeoSnap/releases/download/latest/release.zip).
* Extract it
* `cd release`

#### Step 2: Fix code

* Change content of __install.sh__ to:

        #!/bin/sh
        if [ -f ".env" ]; then
        echo 'Generating new secret key'
        # export NEW_SECRET="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c50)";
        export NEW_SECRET="$(head /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c60)";
        
        sed -i.bak "s/https\:\/\/miniwebtool.com\/django-secret-key-generator\//${NEW_SECRET}/g" .env;
        
        echo 'Setting new admin user login'
        read -p 'Username [snaptron]: ' ADMIN_NAME
        read -p 'Email [snaptron@snap.tron]: ' ADMIN_EMAIL
        read -sp 'Password [Sn@ptron1337]: ' ADMIN_PASS
        sed -i.bak "s/snaptron$/${ADMIN_NAME:-snaptron}/g" .env;
        sed -i.bak "s/snaptron@snap.tron/${ADMIN_EMAIL:-snaptron@snap.tron}/g" .env;
        sed -i.bak "s/Sn@ptron1337/${ADMIN_PASS:-Sn@ptron1337}/g" .env;
        fi

* Run:

      chmod u+x install.sh
      ./install.sh
      docker-compose up

## How to set up

#### Step 1: set up a page

* Visit dashboard at __localhost:80__, you will see [this](https://imgur.com/a/f3drS3j) if the project is installed
  successfully


* Enter username and password to login. If you don't remember, see __ADMIN_NAME__ and __ADMIN_PASS__ in `.env` file


* Dashboard looks like [this](https://imgur.com/a/DUlHDAN). Try adding a page by press __add__ in __Website__.

* Fill:
    * __name__ with a name.
    * __domain__ with your site's domain (ex: google.com).
    * __sitemap__ with your page's [sitemap](https://developers.google.com/search/docs/advanced/sitemaps/overview). This
      is usually stored at _your_domain_/sitemap.xml (
      ex: [https://www.google.com/sitemap.xml](https://www.google.com/sitemap.xml))

* Save your settings.

* Try visiting __localhost:5000/render/_your_domain___ to see the site.

#### Step 2: crawl (indexing the domain in cache)

* To crawl a website, you need to know its ID. Usually, the id increments from 1 (ex: if https://www.google.com is the
  first website that you add, it will have id 1. The next website has id 2. If you delete a website, its it still
  exists). Therefore, if you haven't delete any website, or have a small amount of websites, you can count it manually.


* If you can't find the id this way, try getting the id from the database:
    * Exec into database container: `docker exec -it seosnap_stack_db /bin/bash`
    * Get id from
      database: `mysql --user snaptron_db --host db --database seosnap_dashboard -e "SELECT id from seosnap_website where name = 'your_website_name'";' --password`
      . Your default password is snaptron_db


* To test if your id is correct:
    * go to http://localhost:8080/docs/
    * In [__website > read__](https://imgur.com/a/Hgn1wdk), press `Interact`
    * fill version: v1 , id with your page id. Press __Send Request__ to see if you guessed correctly.


* Crawl your website:
    * `docker-compose run cachewarmer cache your_website_id`. Might take some time if site is big.
    * Other options to crawl with: https://github.com/experius/SeoSnap-Cache-Warmer#commands


* Visit __http://localhost:8080/seosnap/website/your_website_id/pages/__ to see
  the [result](https://imgur.com/a/yd7Z3Em). 
  
