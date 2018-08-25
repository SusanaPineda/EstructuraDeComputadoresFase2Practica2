# Tecnologia De Computadores Practica 2
Diseño VHDL de sistemas secuenciales

Se desea diseñar un circuito secuencial que tiene una entrada de datos X, de 1 bit, además de
una entrada de reset y una entrada de reloj. El sistema tiene una salida Z de 1 bit, que vale ‘1’
cuando los últimos 5 bits recibidos en X son 10011.

El circuito se diseñará de diversas maneras, y para cada una de ellas se hará una descripción en
VHDL . Cada una de las descripciones en VHDL será una arquitectura asociada a la siguiente
entidad:
entity practica_2 is
port (clk, rst, x: in std_logic;
z: out std_logic);
end practica_2;


Para las distintas descripciones que se deben hacer se proporcionan modelos de los flip-flops
en el archivo “flip-flops.vhd” y un modelo de un decodificador de 4 a 16 en el archivo
“deco4a16.vhd”.

Se pide hacer lo siguiente:
a) Obtener el diagrama de estados del sistema, y la tabla de transición de estados del
sistema, implementado como máquina de estados de Moore.

b) Implementar el sistema utilizando flip-flops tipo D además de puertas lógicas
auxiliares. Describir el circuito obtenido en VHDL utilizando los flip-flops D
proporcionados en el archivo “flip-flops.vhd”, y puertas lógicas o expresiones
concurrentes auxiliares. El nombre de esta arquitectura debe ser estructural_D.

c) Implementar el sistema utilizando flip-flops tipo JK además de puertas lógicas
auxiliares. Describir el circuito obtenido en VHDL utilizando los flip-flops JK
proporcionados en el archivo “flip-flops.vhd”, y puertas lógicas o expresiones
concurrentes auxiliares. El nombre de esta arquitectura debe ser estructural_JK.

d) Implementar el sistema utilizando flip-flops tipo T, un decodificador de 4 a 16 y las
puertas lógicas que sean necesarias. Describir el circuito obtenido en VHDL utilizando
los flip-flops T proporcionados en el archivo “flip-flops.vhd”, el decodificador
porporcionado en el archivo “deco4a16.vhd” y puertas lógicas o expresiones
concurrentes auxiliares. El nombre de esta arquitectura debe ser estructural_T.

e) Describir en VHDL el sistema mediante una descripción funcional con dos procesos,
uno para la parte combinacional y otro para la parte secuencial. El nombre de esta
arquitectura debe ser fsm_funcional. (Transparencias finales del tema 8).

f) Utilizando el test-bench que se proporciona en el archivo test_multiple_practica2.vhd
simular simultáneamente los distintos circuitos de los apartados b) a e). Si no se ha
realizado alguno de los apartados anteriores se debe comentar la línea
correspondiente en el archivo test_multiple_practica2.vhd para que no de error. Es
importante que en los apartados anteriores se respeten los nombres propuestos para
las arquitecturas con el fin de que el test-bench no de errores.
