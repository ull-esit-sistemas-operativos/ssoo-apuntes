# Apuntes de "Sistemas Operativos"
Copyright 2005-2020 Jesús Torres \<jmtorres@ull.es\>

## Requisitos

Para la generación de la documentación en HTML es necesario instalar las siguientes gemas:

 * asciidoctor
 * rouge

Para las versiones en PDF y EPUB:

 * asciidoctor-pdf
 * asciidoctor-epub (actualmente en pre-release en RubyGems.org)

Y para los tests:

 * html-proofer

Todas las dependencias se pueden instalar fácilmente con *Bundle*:

~~~~
$ bundle install
~~~~

o a mano con *Gem*:

~~~
$ sudo gem install asciidoctor rouge
$ sudo gem install asciidoctor-pdf asciidoctor-epub3 --pre
$ sudo gem install html-proofer
~~~ 

Algunas gemas son extensiones nativas, así que es necesario instalar previamente los paquetes nativos de los que dependen:

 * ruby-dev
 * libxml2-dev
 * libxslt-dev
 * zlib1g-dev

Por ejemplo, en distribuciones derivadas de Debian:

~~~
$ sudo apt install ruby-dev libxml2-dev libxslt-dev zlib1g-dev
~~~
