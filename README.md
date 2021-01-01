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
$ bundle config build.nokogiri --use-system-libraries
$ bundle install
~~~~

o a mano con *Gem*:

~~~
$ sudo gem install asciidoctor asciidoctor-pdf rouge
$ sudo gem install asciidoctor-epub3 --pre -- --use-system-libraries
$ sudo gem install html-proofer
~~~ 

Algunas gemas son extensiones nativas, así que es necesario instalar previamente los siguientes paquetes nativos de los que dependen:

 * ruby-dev
 * pkg-config
 * libxml2-dev
 * libxslt-dev

Por ejemplo, en distribuciones derivadas de Debian:

~~~
$ sudo apt install ruby-dev pkg-config libxml2-dev libxslt-dev
~~~

## Ejemplos

El código de los ejemplos está disponible en [ull-esit-sistemas-operativos/ssoo-ejemplos](https://github.com/ull-esit-sistemas-operativos/ssoo-ejemplos).

## Estilos

_Asciidoctor_ soporta varios estilos.
Para etiquetar semánticamente los elementos del contenido se pueden usar roles o macros en Ruby, pero por el momento no nos hemos puesto con eso.
Esto hace que sea difícil mantener un estilo consistente a lo largo del tiempo en los diferentes capítulos. 
Por eso es conveniente establecer unas reglas sobre los estilos a aplicar en cada caso y usarlas de forma consistente en todos los artículos de la web.

 * \_Aplicación\_.
 * \*Elemento de la GUI\*: \*Etiqueta\* \*Menú\* \*Submenú\* \*Botón\* \*Icono\* \*Ventana\* \*Interfaz\*.
 * \`nombre_de_archivo\`, \`ruta\`, \`VARIABLE_DE_ENTORNO\`, \`comando\` o \`--argumento\`.
 * Entrada de teclado: `kbd[Tecla1+Tecla2+...]`.

Algunas de estas reglas están basadas en:

 * [GNOME Handbook of Writing Software Documentation — 4. DocBook Basics](https://developer.gnome.org/gdp-handbook/stable/docbook.html.en).
