# Apuntes de "Sistemas Operativos"
Copyright 2005-2021 Jesús Torres \<jmtorres@ull.es\>

## Requisitos

Todas las gemas requeridas para generar la documentación se indican en `Gemfile`.
Algunas de estas gemas son nativas o dependen de librerías o programas externos que deben instalarse previamente.
En distribuciones derivadas de Debian GNU/Linux y Ubuntu se pueden instalar así:

~~~
sudo apt install ruby-dev libxml2-dev libxslt-dev pkg-config

# asciidoctor-mathematical
sudo apt install bison flex libffi-dev libxml2-dev libgdk-pixbuf2.0-dev libcairo2-dev libpango1.0-dev fonts-lyx cmake
~~~

Después las gemas se pueden instalar fácilmente con *Bundle*:

~~~~
bundle config set build.nokogiri --use-system-libraries
bundle config set without epub3
bundle install
~~~~

## Generación de la documentación

Para automatizar la generación de la documentación se utiliza *Rake*.
Para listar las tareas del proyecto basta con ejecutar:

~~~
rake -T
~~~

## Solución de problemas

### Problemas con mathematical

En caso de tener problemas porque `mathematical.so` no encuentra `liblasem.so`, puede deberse a haber instalado los paquetes con `bundle install` de forma global, para todo el sistema.
Si *Bundle* no puede escribir en el directorio donde se instalan las gemas, lo hace en un directorio temporal, donde también compila las extensiones, y después pide permiso para ejecutar `sudo` y copiar los archivos a su ubicación definitiva.
En ese caso, la ruta donde `mathematical.so` espera encontrar `liblasem.so` —indicada en RUNPATH en `mathematical.so`— puede que ya no sirva.

La solución más sencilla es desinstalar y volver a instalar nuevamente *mathematical* usando *Gem*:

~~~
sudo gem uninstall mathematical
sudo gem install mathematical
~~~

## Ejemplos

El código de los ejemplos está disponible en [ull-esit-sistemas-operativos/ssoo-ejemplos](https://github.com/ull-esit-sistemas-operativos/ssoo-ejemplos).

## Estilos

Para ayudar a mantener un estilo consistente a lo largo del tiempo en los diferentes artículos y secciones, se han establecido unas reglas sobre los estilos a aplicar en distintos casos:

 * *\_Aplicación\_*.
 * **\*Elemento de la GUI\***: **\*Etiqueta\***, **\*Menú\***, **\*Submenú\***, **\*Botón\***, **\*Icono\***, **\*Ventana\*** o **\*Interfaz\***.
 * `` `nombre_de_archivo` ``, `` `ruta` ``, `` `VARIABLE_DE_ENTORNO` ``, `` `comando` `` o `` `--argumento` ``.
 * Entrada de teclado: `kbd:[Tecla1+Tecla2+...]`.

Estas reglas están basadas en la guía de GNOME para escribir documentación de software.
Respecto a las referencias bibliográficas se sigue la norma APA, si bien las citas se hacen de forma numérica, ya que _Asciidoctor_ no facilita otra forma sin utilizar extensiones adicionales.

 * [GNOME Handbook of Writing Software Documentation — 4. DocBook Basics](https://developer.gnome.org/gdp-handbook/stable/docbook.html.en).
 * [APA Style — Reference Examples](https://apastyle.apa.org/style-grammar-guidelines/references/examples).
