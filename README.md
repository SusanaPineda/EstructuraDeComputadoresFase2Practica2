# Diseño de un camino de datos uniciclo para MIPS en VHDL
Diseño de un camino de datos uniciclo para MIPS en VHDL

# 1. INTRODUCCIÓN
En esta práctica se diseñarán diversos elementos de un camino de datos uniciclo capaz de ejecutar un
subconjunto del repertorio de instrucciones MIPS de 32 bits. Para ello se empleará el lenguaje VHDL.
Como material básico, se proporciona un modelo VHDL de tipo funcional del camino de datos. Los pasos
para la realización de la práctica serán los siguientes:

1. En primer lugar, el grupo de prácticas deberá diseñar la unidad de control que gobernará el camino
de datos. Para ello se podrá utilizar cualquier tipo de descripción, si bien se recomienda realizar una
descripción funcional.
2. En segundo lugar, el grupo de prácticas diseñará un modelo estructural del circuito de cálculo de la
señal de selección del próximo valor del PC (llamada PCSrc) que reemplazará al modelo funcional
proporcionado en el material básico.
3. En tercer lugar, el grupo de prácticas diseñará un modelo estructural de un multiplexor de 4
entradas de n bits de ancho (siendo n un ancho genérico) que reemplazará al modelo funcional
proporcionado para los multiplexores 4x32 y 4x5 presentes en el camino de datos.
4. En cuarto lugar, el grupo de prácticas diseñará un modelo estructural de un sumador de n bits que
reemplazará al modelo funcional proporcionado para los dos sumadores del camino de datos.
5. En quinto lugar, el grupo de prácticas diseñará un modelo estructural para la UAL que reemplazará
al modelo funcional proporcionado.
6. En sexto y último lugar, el grupo de prácticas presentará los resultados de la simulación de un caso
de prueba original sobre el modelo de camino de datos uniciclo, incorporando los modelos
estructurales creados en las partes 2 a 5, y analizará el cronograma resultante.
La primera parte es obligatoria, mientras que las otras cinco son opcionales. Para optar a obtener la nota
máxima, será preciso realizar la práctica completa.

# 1.1. DESCRIPCIÓN DEL CAMINO DE DATOS UNICICLO
El camino de datos presentado en esta práctica es muy similar al camino de datos estudiado en la parte de
teoría de la asignatura. La figura 1 presenta la estructura del mismo. Las principales diferencias que
presenta este modelo frente al estudiado en la parte de teoría se encuentran en la información que se 
puede escribir en el banco de registros, en el segundo operando de la UAL, en las operaciones realizadas
por ésta y en el valor escrito en el PC para seleccionar la dirección de la próxima instrucción. La unidad de
control además es capaz de generar una señal de control que detendrá al procesador (Halt). 

# 1.2. DESCRIPCIÓN DEL CÓDIGO DE APOYO EN VHDL
El modelo de camino de datos uniciclo proporcionado es una descripción en VHDL del circuito de la figura 1.
Se trata de un modelo jerárquico, y se encuentra dividido en varios archivos:
sistema.vhd
Contiene la entidad de nivel superior de la jerarquía, y es a partir de esta entidad y arquitectura
desde la que deberá efectuarse la simulación. El modelo contiene instanciaciones del procesador, la
memoria de instrucciones y la memoria de datos, así como un proceso para el reloj y un proceso
para realizar un reset inicial.

mips_uniciclo.vhd
Contiene un modelo estructural del camino de datos del procesador, sin incluir las memorias. Los
componentes del camino de datos se encuentran descritos en otros ficheros.

mips_settings.vhd
Contiene un paquete con definiciones importantes del modelo (duración del ciclo de reloj, retardos
de los módulos, direcciones base y tamaños de las memorias de instrucciones y datos, valor inicial
del PC, etc).

memoria.vhd
Contiene los modelos funcionales de las memorias de instrucciones y datos. Ambas memorias se
organizan en modo little-endian, y deberán ser dotadas de contenidos iniciales a través de sendos
ficheros que pueden generarse mediante el entorno MARS de desarrollo y simulación de
programas en ensamblador de MIPS. La generación de estos ficheros se describirá en el apéndice B.

nextPC.vhd
Contiene un modelo funcional del circuito combinacional que genera la señal PCSrc, y, por tanto,
decide cuál será el próximo valor del PC.

aritmeticos.vhd
Contiene modelos funcionales de los sumadores utilizados en el camino de datos.

puertas_logicas.vhd
Contiene modelos funcionales para distintos tipos de puertas lógicas. El grupo de prácticas podrá
incorporar otros modelos al realizar las partes 2 y 3, con la condición de que incorporen un
parámetro genérico de retardo, cuyo valor por defecto será de 1 ns.

combinacionales.vhd
Contiene módulos combinacionales con descripciones de tipo funcional.

unidad_control.vhd
Este archivo contiene un esqueleto del modelo de la unidad de control del procesador. Este fichero
deberá ser completado por el grupo de prácticas al realizar la parte 1.

ALU.vhd
Contiene un modelo funcional de la unidad aritmético-lógica del procesador.

registros.vhd
Contiene modelos funcionales de biestables y registros, así como el del banco de registros de MIPS.

test.vhd
Contiene diversos bancos de pruebas para diferentes módulos.

# 2. REALIZACIÓN DE LA PRÁCTICA
La práctica consta de seis partes:
1. Diseño de la unidad de control (puntuación máxima: 6 puntos).
2. Diseño estructural del circuito de cálculo de la señal PCSrc (puntuación máxima: 0,5 puntos).
3. Diseño estructural del multiplexor de 4 entradas de n bits de ancho (puntuación máxima: 0,5
puntos).
4. Diseño estructural del sumador de n bits de ancho (puntuación máxima: 0,5 puntos).
5. Diseño estructural de la UAL (puntuación máxima: 2 puntos).
6. Análisis del comportamiento del camino de datos uniciclo incorporando los modelos estructurales
realizados en los pasos del 2 al 5 (puntuación máxima: 0,5 puntos).

De acuerdo con las puntuaciones, para aprobar la práctica es condición necesaria (pero no suficiente)
realizar la primera parte. Las restantes partes no son obligatorias. Sin embargo, es recomendable
realizarlas también para tratar de asegurar el aprobado, y son necesarias para optar a la nota máxima.


# PARTE 1: DISEÑO DE LA UNIDAD DE CONTROL
El grupo de prácticas deberá implementar la arquitectura de la unidad de control. En el fichero
unidad_control.vhd se incluye la descripción de la entidad de la misma, que no debe ser modificada bajo
ningún concepto. La arquitectura pedida se incluirá dentro de dicho fichero. Se da libertad al grupo de
prácticas a la hora de elegir un tipo de descripción u otro para la arquitectura, aunque se recomienda
realizar una descripción de tipo funcional, por ser la más sencilla y la que se acerca más al propósito de la
práctica. En el propio fichero se ofrece un esqueleto para una arquitectura funcional.
La unidad de control del camino uniciclo es un circuito combinacional. Por ello, el esqueleto de
arquitectura funcional propone su descripción mediante un proceso sensible a la señal Instruction, que
contiene la última instrucción leída de la memoria de instrucciones. Este proceso no es sensible a la señal
de reloj.
Para que el modelo de unidad de control sea realmente un circuito combinacional, al principio del proceso
sería conveniente asignar a todas las señales un valor “inocuo” por defecto, de modo que así no nos
olvidaremos de dar un valor a cada señal (evitando que el circuito tenga “memoria”). Este valor “inocuo”
no deberá producir ninguna modificación del estado del sistema, impidiendo la escritura en el banco de
registros y en la memoria de datos.
Después, el proceso podría contener una estructura case sobre el código de operación. Así, cada rama se
referiría a una única instrucción, y en ella se indicarían los valores de las señales de control que no deban
adquirir el “valor por defecto” en la instrucción correspondiente.
Excepcionalmente, en el caso de las instrucciones de tipo R, dentro de la opción when debe ir otra
estructura case para determinar el valor de las señales dependiendo del campo de función de la
instrucción.
Instrucciones que deben implementarse
El modelo de computador MIPS presentado es capaz de ejecutar un subconjunto de las instrucciones del
repertorio MIPS32. Este subconjunto está descrito en el apéndice A de este enunciado, que además
contiene información relevante a la hora de realizar la implementación de las distintas instrucciones. El
grupo de prácticas tendrá que implementar el control de las instrucciones que figuran en dicho apéndice, a
razón de 0,15 puntos por cada instrucción correctamente implementada, hasta un máximo total de 4,5
puntos.
El grupo de prácticas tendrá que implementar obligatoriamente el control de las instrucciones siguientes:
add, addiu, sub, slt, and, or, nor, j, beq, bne, lui, ori, lw, sw nop y syscall. La implementación de las
restantes instrucciones queda a discreción del grupo de prácticas, que deberá echar cuentas para calcular
la puntuación máxima que podría obtener en función de las instrucciones cuyo control decida realizar.
Generación de casos de prueba y comprobación de la solución
Para comprobar el funcionamiento del modelo, es preciso incluir casos de prueba. Cada caso se introducirá
en la simulación a través de dos ficheros:
• Memoria_Instrucciones.txt: contendrá el código binario del programa, que se cargará en la
memoria de instrucciones.
• Memoria_Datos.txt: contendrá los datos iniciales que se cargarán en la memoria de datos.
Estos ficheros pueden ser generados a partir de la herramienta MARS, utilizada en la práctica de
programación en ensamblador. En el apéndice B se indica cómo se deberán generar dichos ficheros, y se
dan consejos acerca de cómo crear los casos de prueba.
En el material de apoyo para la realización de la práctica se incluyen dos ejemplos con el código fuente y
los ficheros de código y datos generados. Antes de simular el modelo con cada caso de prueba, será
preciso copiar la pareja de ficheros de datos y de instrucciones en el directorio raíz del proyecto.
Para verificar que las instrucciones funcionan correctamente en el modelo VHDL, será preciso ejecutarlo
en la herramienta de simulación. Se deberán analizar las formas de onda generadas por el simulador,
seleccionando las señales presentadas en los cronogramas y colocándolas ordenadamente para facilitar su
interpretación. En el apéndice B se dan ciertas indicaciones acerca de cómo hacer más cómoda la
simulación y cómo presentar los resultados obtenidos en la memoria de la práctica.
En este apartado se entregarán 2 casos de prueba originales, que se denominarán caso1.asm y caso2.asm.
Cada uno de ellos valdrá como máximo 0,5 puntos, y entre ambos deberán permitir probar todas las
instrucciones implementadas por el grupo de prácticas. En la memoria se presentará el cronograma de
ejecución de caso1.asm junto con un análisis del mismo. Este análisis valdrá como mucho 0,5 puntos. En
total, los casos de prueba junto con el análisis permitirán obtener en este apartado un máximo de 1,5
puntos.
Nótese que caso2.asm se utilizará en el paso 6 de la práctica para verificar el funcionamiento de los
modelos estructurales creados en los pasos 2 al 5.
Información que debe incorporarse en la memoria para el paso 1 y material entregado
En la memoria de la práctica se incluirán las siguientes informaciones:
• Enumeración de las instrucciones implementadas por el grupo de prácticas, indicando los valores
de las señales de control en cada una de ellas.
• Código ensamblador de caso1.asm y caso2.asm. Para ambos hay que indicar cuántos ciclos duran, y
presentar captura de pantalla del contenido final de los registros y las variables de memoria
utilizadas.
• Cronograma completo de ejecución de caso1.asm, debidamente analizado y comentado,
comprobando que los resultados coinciden con los de la simulación de caso1.asm con MARS.
En este punto se entregarán los siguientes ficheros:
• unidad_control.vhd con la arquitectura de la unidad de control.
• caso1.asm y sus correspondientes volcados Memoria_Instrucciones.txt y Memoria_Datos.txt.
• caso2.asm y sus correspondientes volcados Memoria_Instrucciones.txt y Memoria_Datos.txt.
• memoria2_1.pdf: memoria para este apartado, incluyendo la información solicitada.


# PARTE 2: DISEÑO DEL CIRCUITO DE CÁLCULO DE PCSrc
El grupo de prácticas deberá implementar una versión estructural de la arquitectura del circuito llamado
nextPC, que, tomando como entradas las señales BranchEQ, BranchNE, Jump y JumpReg, generadas por la
unidad de control, más la señal Zero, generada por la UAL, calcula la señal PCSrc, que gobierna el
multiplexor cuya salida se grabará en el PC. La tabla de verdad del circuito se muestra en el apartado 1.1 de
este enunciado.
En el fichero nextPC.vhd se incluyen la entidad del circuito y una arquitectura de comportamiento del
mismo. El grupo de prácticas deberá incorporar en este fichero una arquitectura estructural del circuito,
apoyándose en las puertas lógicas y componentes definidos en los ficheros puertas_logicas.vhd y
combinacionales.vhd.
En principio, para la realización de la arquitectura pedida debería bastar con las puertas lógicas del fichero
puertas_logicas.vhd. De cualquier modo, el grupo puede incorporar en el fichero combinacionales.vhd
nuevos modelos de circuitos combinacionales estándares, con la condición de que las correspondientes
arquitecturas sean de tipo estructural y estén definidas a nivel de puerta lógica. Además, dichas entidades
incorporarán un parámetro genérico retardo_base, cuyo valor por defecto será de 1 ns. Las instanciaciones
de los módulos definidos en los modelos estructurales requeridos aplicarán a dicho parámetro genérico el
valor retardo_puerta correspondiente a la constante definida a tal efecto en mips_settings.vhd.
La arquitectura pedida puede probarse mediante el bancos de pruebas incorporado en el archivo test.vhd.
Dicho banco de pruebas permite comprobar el modelos funcional frente al estructural, y así comprobar si
éste último se comporta correctamente (obsérvese que puede haber algunas pequeñas diferencias en los
retardos de las distintas arquitecturas). Si el grupo de prácticas ha incorporado algún módulo nuevo en
combinacionales.vhd, deberá incorporar asimismo el correspondiente banco de pruebas en test.vhd.
En resumen, en este apartado se realizarán las siguientes tareas:

1. Escribir una arquitectura estructural para el circuito nextPC, preferentemente usando puertas
lógicas.
2. Probar dicha arquitectura estructural con el banco de pruebas test_nextPC.
3. Si el grupo de prácticas ha creado algún otro módulo combinacional nuevo, incorporará su
descripción y arquitectura estructural (y opcionalmente también una arquitectura funcional) en
combinacionales.vhd, e incluirá los bancos de pruebas pertinentes en test.vhd.
Información que debe incorporarse en la memoria para el paso 2
• Descripción del proceso de diseño del circuito nextPC, incluyendo la ecuación booleana resultante y
el dibujo del circuito final.
• Cronograma completo de ejecución del banco de pruebas test_nextPC, debidamente comentado.


# PARTE 3: DISEÑO DE UN MULTIPLEXOR DE 4 ENTRADAS DE n BITS
Los multiplexores son circuitos combinacionales que reciben 2k entradas de datos de 1 bit y k bits de
selección, y tienen una única salida de 1 bit. El dato presentado en dicha salida es el bit de datos cuyo
ordinal corresponde con el número binario representado por los bits de selección.
En el camino de datos uniciclo de esta práctica hay varios multiplexores de 4 entradas de datos. Sin
embargo, cada dato tiene varios bits de ancho (5 en el multiplexor controlado por RegDst y 32 en los
restantes). La salida también tiene un ancho de varios bits, tantos como cada una de sus entradas de datos.
Estos multiplexores de 4 entradas de n bits son redes de n multiplexores de 4 a 1. En conjunto, la salida de
la red ofrece una de las entradas de n bits al completo según el valor de los bits de selección, que son
comunes a todos los multiplexores individuales. La figura 2 muestra la estructura de un multiplexor de 2
entradas de 32 bits como una red de 32 multiplexores de 2 a 1.

Figura 2. Multiplexor de 2 entradas de 32 bits y una salida de 32 bits construido como una red de multiplexores de 2 a 1.
En este apartado, el grupo de prácticas deberá implementar una arquitectura estructural de un
multiplexor de 4 entradas de ancho genérico. La entidad del circuito se llama mux_4xn, y está incorporada
en el fichero combinacionales.vhd, donde además se presenta una arquitectura funcional del mismo.
La arquitectura estructural pedida se construirá como una red de multiplexores de 4 a 1. Para ello se creará
una nueva arquitectura estructural de un multiplexor de 4 a 1 cuya entidad, llamada mux_4x1, está
definida en combinacionales.vhd, donde también encontramos su correspondiente arquitectura de
comportamiento.
También se realizará en este apartado un modelo estructural de un multiplexor de 2 a 1, cuya entidad se
llama mux_2x1 y se encuentra en el fichero combinacionales.vhd, junto con la correspondiente
arquitectura de comportamiento. Este multiplexor será probablemente utilizado en algún paso posterior
de la práctica.
Ambas arquitecturas pueden probarse mediante los bancos de pruebas incorporados en el archivo
test.vhd. De nuevo, dichos bancos de pruebas permiten comprobar los modelos funcionales frente a los
estructurales.

En resumen, en este apartado se realizarán las siguientes tareas:
1. Escribir una arquitectura estructural para el multiplexor de 2 entradas de 1 bit mux_2x1 utilizando
puertas lógicas, e incluirla en el fichero combinacionales.vhd.
2. Probar la arquitectura estructural de mux_2x1 con el banco de pruebas test_mux_2x1.
3. Escribir una arquitectura estructural para el multiplexor de 4 entradas de 1 bit mux_4x1 utilizando
puertas lógicas, e incluirla en el fichero combinacionales.vhd.
4. Probar la arquitectura estructural de mux_4x1 con el banco de pruebas test_mux_4x1.
5. Escribir una arquitectura estructural para el multiplexor de 4 entradas de n bits mux_4xn que
utilice la arquitectura estructural de mux_4x1, e incluirla en el fichero combinacionales.vhd.
6. Probar la arquitectura estructural de mux_4xn con el banco de pruebas test_mux_4xn.
Información que debe incorporarse en la memoria para el paso 3
• Descripción del proceso de diseño del circuito mux_4x1, incluyendo la ecuación booleana
resultante y el dibujo del circuito final.
• Cronograma completo de ejecución del banco de pruebas test_mux_4x1, debidamente comentado.
• Cronograma completo de ejecución del banco de pruebas test_mux_4xn, debidamente comentado.


# PARTE 4: DISEÑO DE UN SUMADOR DE DOS NÚMEROS DE n BITS
El grupo de prácticas deberá implementar una versión estructural de la arquitectura de un sumador de dos
números de n bits (ancho genérico). En el fichero aritmeticos.vhd se encuentran la entidad del mismo
(llamada sumadorN) junto con una arquitectura de comportamiento, y es en ese mismo fichero donde el
grupo de prácticas incluirá la arquitectura estructural pedida.
Se recomienda crear el sumador como una red de n sumadores elementales completos. En el fichero
aritmeticos.vhd se cuenta con una entidad llamada sumador para el sumador elemental completo, junto
con una arquitectura de comportamiento. El grupo de prácticas incorporará en este fichero una
arquitectura estructural para esta entidad, construida directamente mediante puertas lógicas, o bien
mediante semisumadores y puertas lógicas.
En aritmeticos.vhd también encontramos la entidad semisumador y la pertinente arquitectura de
comportamiento. Si el grupo de prácticas decide construir el sumador elemental usando semisumadores,
deberá incluir en este fichero la correspondiente arquitectura estructural del semisumador.
Será preciso comprobar el funcionamiento de todas las arquitecturas estructurales realizadas. Para ello se
utilizarán los bancos de pruebas incluidos en test.vhd.
En resumen, en este apartado se realizarán las siguientes tareas:
1. (Opcional) Escribir una arquitectura estructural para el semisumador e incluirla en el fichero
aritmeticos.vhd.
2. (Opcional) Probar dicha arquitectura estructural con el banco de pruebas test_semisumador.
3. Escribir una arquitectura estructural para el sumador elemental completo e incluirla en el fichero
aritmeticos.vhd.
4. Probar dicha arquitectura estructural con el banco de pruebas test_sumador.
5. Escribir una arquitectura estructural para el sumador de dos números de n bits sumadorN e
incluirla en el fichero aritmeticos.vhd.
6. Probar dicha arquitectura estructural con el banco de pruebas test_sumadorN.

Información que debe incorporarse en la memoria para el paso 4
• (Opcional) Descripción del proceso de diseño del circuito semisumador, incluyendo las ecuaciones
booleanas resultantes y el dibujo del circuito final.
• (Opcional) Cronograma completo de ejecución del banco de pruebas test_semisumador,
debidamente comentado.
• Descripción del proceso de diseño del circuito sumador, incluyendo las ecuaciones booleanas
resultantes y el dibujo del circuito final.
• Cronograma completo de ejecución del banco de pruebas test_sumador, debidamente comentado.
• Dibujo del circuito sumadorN como red de sumadores elementales completos.
• Cronograma completo de ejecución del banco de pruebas test_sumadorN, debidamente
comentado.


# PARTE 5: DISEÑO DE UNA UNIDAD ARITMÉTICO LÓGICA DE 32 BITS
El grupo de prácticas deberá implementar una versión estructural de la arquitectura de una unidad
aritmético lógica de 32 bits que realice las operaciones indicadas en la tabla correspondiente del apartado
1.1 para la UAL del camino de datos uniciclo.
En el fichero ALU.vhd se encuentra la entidad del circuito (denominada ALU32), junto con una arquitectura
de comportamiento. En este fichero el grupo de prácticas incorporará el modelo estructural pedido.
La arquitectura estructural para la UAL de 32 bits se construirá como una red iterativa cuyo módulo básico
lo constituirá una celda ALU de 1 bit. La entidad de esta celda elemental se llama ALU1, y está en el fichero
ALU.vhd, junto con un modelo funcional de la misma. Las entradas de la UAL elemental son las siguientes:
• a: entrada para el primer operando fuente.
• b: entrada para el segundo operando fuente.
• less: entrada para las operaciones slt y sltu.
• c_in: entrada para el acarreo.
• ALU_Operation: señales de selección de operación.
• c_out: acarreo de salida.
• z: salida para el bit de resultado.
La arquitectura estructural de ALU1 podrá realizarse mediante puertas lógicas y/o sumadores,
multiplexores, etc., para los cuales se utilizarán las versiones estructurales de sus arquitecturas. Se da
absoluta libertad a la hora de organizar la solución, si bien se recomienda hacer por separado las partes
lógica (operaciones and, or, nor y xor) y aritmética (suma, resta, slt y sltu) y luego unir los resultados
mediante un multiplexor.
La arquitectura estructural de ALU32 incorporará 32 instancias de ALU1 que serán exactamente iguales.
ALU32 genera las señales de resultado nulo (Zero) y de desbordamiento (Overflow), pero éstas no se
calcularán dentro de ninguna celda elemental de ALU1, sino con circuitos adicionales incorporados dentro
de la propia arquitectura estructural de ALU32.
En resumen, en este apartado se realizarán las siguientes tareas:
1. Escribir una arquitectura estructural para ALU1 e incluirla en el fichero ALU.vhd.
2. Probar dicha arquitectura estructural con el banco de pruebas test_ALU1.
3. Escribir una arquitectura estructural para ALU32 e incluirla en el fichero ALU.vhd.
4. Probar dicha arquitectura estructural con el banco de pruebas test_ALU32.

Información que debe incorporarse en la memoria para el paso 5
• Descripción del proceso de diseño de la celda ALU1, incluyendo el dibujo del circuito final.
• Cronograma completo de ejecución del banco de pruebas test_ALU1, debidamente comentado.
• Dibujo del circuito ALU32 como red de módulos ALU1 más los elementos adicionales necesarios.
• Cronograma completo de ejecución del banco de pruebas test_ALU32, debidamente comentado.
Cómo realizar las operaciones slt y sltu
Es evidente que las entradas de primer y segundo operando para las instancias de ALU1 serán los bits a(i) y
b(i) de los operandos de entrada. También es evidente que la entrada less(i) será ‘0’ para las celdas 1 a 31.
Sin embargo, para saber cuál debe ser el valor de la entrada less(0) para la celda 0 es preciso realizar una
serie de consideraciones adicionales.
Dado que las operaciones slt y sltu son comparaciones entre dos operandos, implican una resta del primer
operando menos el segundo. Sin embargo, el resultado obtenido se descartará, y únicamente se utilizarán
las características del mismo (desbordamiento, signo, acarreo superior) para conocer si efectivamente el
primer operando es menor que el segundo o no lo es.
El caso de la operación slt, que compara datos en complemento a 2, ha sido ya analizado en la parte
teórica del tema 5 de la asignatura, dedicado al estudio de los circuitos aritméticos del computador.
Llamaremos Set1 al resultado de la comparación. Recordando que es precisamente el valor de Set1 el que
deberíamos introducir en este caso por la entrada less(0), entonces Set1 = less(0) = z(31) ⊕ Overflow,
siendo z(31) el bit más significativo del resultado.
En cuando a sltu, se trata de una comparación entre dos datos sin signo representados en binario puro. En
tal caso es evidente que, si el primer operando es menor que el segundo, el acarreo superior de la resta
debe ser igual a 1. Sin embargo, cuando realizamos restas de números en binario puro mediante la suma
del minuendo con el complementario del sustraendo, el bit de acarreo sale al revés, y en tal caso sería
preciso complementarlo para obtener su valor correcto. Entonces, si llamamos Set2 al resultado de la
comparación y tenemos en cuenta que en este caso Set2 = less(0), resulta que Set2 = less(0) = ~c(32), es
decir, que por less(0) deberíamos introducir el acarreo superior negado.
Por tanto, por la entrada less de la celda menos significativa será preciso introducir Set1 o Set2,
dependiendo de si la UAL está realizando la operación slt o la operación sltu. Estas señales se generarán y
manipularán mediante circuitos adicionales incluidos dentro de la propia arquitectura estructural de
ALU32.



# PARTE 6: INCORPORACIÓN DE LOS MODELOS ESTRUCTURALES AL
CAMINO DE DATOS UNICICLO
En este apartado, el grupo de prácticas analizará el comportamiento del camino de datos para el caso de
prueba caso2.asm, pero incorporando los modelos estructurales realizados en los pasos 2 al 5 de esta
práctica en sustitución de los correspondientes modelos funcionales utilizados en el apartado 1.
Para ello, se tomará el fichero mips_uniciclo.vhd y se observará la parte declarativa de la arquitectura del
procesador. Mediante una serie de especificaciones de configuración, en ella se indica qué arquitecturas se
emplean en la simulación para cada uno de los módulos del modelo. Pero además se observa que hay una
serie de especificaciones de configuración que están comentadas y que se refieren a las arquitecturas
12

estructurales desarrolladas en los pasos 2 a 5. Entonces, para realizar la simulación del conjunto utilizando
las arquitecturas estructurales, será suficiente con poner como líneas de comentario las líneas con las
especificaciones de configuración correspondientes a las arquitecturas de comportamiento y
“descomentar” las líneas correspondientes a las especificaciones de configuración de las arquitecturas
estructurales, tras lo cual se procederá a la compilación del proyecto y su posterior simulación.
Si los modelos estructurales son correctos, los resultados finales de las simulaciones deben ser iguales a los
producidos por las simulaciones del apartado 1, aunque puede haber algunas diferencias en los
cronogramas a causa de los transitorios debidos a los retardos de los módulos, pero que no deberán
afectar al resultado final de la ejecución de las instrucciones del programa.
En resumen, en este apartado se realizarán las siguientes tareas:
1. Modificar la arquitectura del procesador en el fichero mips_uniciclo.vhd tal como se ha indicado.
2. Probar el camino de datos uniciclo con la arquitectura modificada del procesador, utilizando los
archivos Memoria_Instrucciones.txt y Memoria_Datos.txt correspondientes a caso2.asm.
Información que debe incorporarse en la memoria para el paso 6
En la memoria de la práctica se incluirá el cronograma completo de ejecución de caso2.asm con la nueva
arquitectura del procesador, debidamente analizado y comentado. Se compararán los resultados finales
con los obtenidos en la simulación del programa con MARS.
