# Apuntes de "Sistemas Operativos"
Excepto donde se indique lo contrario, esta obra está sujeta a la licencia
[Creative Commons Atribución 4.0 Internacional](https://creativecommons.org/licenses/by/4.0/deed.es).

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
bundle config set --local path vendor/bundle
bundle config set --local build.nokogiri --use-system-libraries
bundle config set --local without epub3
bundle install
~~~~

## Generación de la documentación

Para automatizar la generación de la documentación se utiliza *Rake*.
Para listar las tareas del proyecto basta con ejecutar:

~~~
bundle exec rake -T
~~~

Luego se puede ejecutar cualquier tarea con:

~~~
bundle exec rake <tarea>
~~~

## Solución de problemas

### Problemas con mathematical

En caso de tener problemas porque `mathematical.so` no encuentra `liblasem.so`, puede deberse a haber instalado los paquetes con `bundle install` de forma global, para todo el sistema.
Esto no debería ocurrir con los pasos indicados anteriormente porque son para una instalación local al proyecto.

Si *Bundle* no puede escribir en el directorio donde se instalan las gemas, lo hace en un directorio temporal, donde también compila las extensiones, y después pide permiso para ejecutar `sudo` y copiar los archivos a su ubicación definitiva.
En ese caso, la ruta donde `mathematical.so` espera encontrar `liblasem.so` —indicada en RUNPATH en `mathematical.so`— puede que ya no sirva.

La solución más sencilla es desinstalar y volver a instalar nuevamente *mathematical* usando *Gem*:

~~~
sudo gem uninstall mathematical
sudo gem install mathematical
~~~

### Fuente Ink Free

Ink Free es la fuente usada en los diagramas de estilo informal que imitan estar dibujados a mano.
Viene incluida con Windows 10 y Office, pero también se puede descargar en distintos formatos desde sitios como [onlinewebfonts.com](https://www.onlinewebfonts.com/download/0801c08e5412f54e4b4e9ad146d83a12).

Para usarla con [diagrams.net](http://diagrams.net) para crear los diagramas primero debe añadirse como *Web Fonts* con nombre "Ink Free" y URL `https://ull-esit-sistemas-operativos.github.io/ssoo-apuntes/fonts/InkFree.woff`.

### SVG: _Viewer does not support full SVG 1.1_

En el estilo de los textos de los diagramas creados con [diagrams.net](http://diagrams.net) deben estar desmarcados *Word Wrap* y *Formatted Text*, para que los SVG incrustados en el PDF no se muestren con el mensaje _Viewer does not support full SVG 1.1_. 

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
