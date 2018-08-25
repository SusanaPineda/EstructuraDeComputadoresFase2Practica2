-------------------------------------------------------------
-- Archivo: aritmeticos.vhd
-------------------------------------------------------------
--  
--  DESCRIPCIÓN
--    Unidad aritmético-lógica para MIPS
--
-------------------------------------------------------------
--
-- ALUMNO 1
--    Identificador de usuario: g.melendezm
--    Apellidos y nombre: Guillermo Meléndez Morales
--
--  ALUMNO 2
--    Identificador de usuario: s.pinedad
--    Apellidos y nombre: Susana Pineda De Luelmo
--
-- Alumnos del doble grado de Diseño y Desarrollo de Videojuegos e
-- Ingenieria de Computadores
-------------------------------------------------------------

-------------------------------------------------------------
-- SEMISUMADOR ELEMENTAL
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity semisumador is
  generic (retardo_base: time := 1 ns);
  port    (a, b:     in  std_logic;
           c_out, z: out std_logic);
end entity semisumador;

architecture comportamiento of semisumador is
  signal salida, op1, op2: unsigned (1 downto 0);
begin
  op1 <= '0' & a;
  op2 <= '0' & b;
  salida <= op1 + op2;
  c_out <= salida(1);
  z <= salida(0);
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of semisumador is

begin
xor1: entity work.xor2 port map (a, b, z);
and1: entity work.and2 port map (a, b, c_out);
end estructural;


-------------------------------------------------------------
-- SUMADOR ELEMENTAL COMPLETO
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity sumador is
  generic (retardo_base: time := 1 ns);
  port    (a, b, c_in: in  std_logic;
           c_out, z:   out std_logic);
end entity sumador;

architecture comportamiento of sumador is
  signal salida, op1, op2, op3: unsigned (1 downto 0);
begin
  op1 <= '0' & a;
  op2 <= '0' & b;
  op3 <= '0' & c_in;
  salida <= op1 + op2 + op3;
  c_out <= salida(1);
  z <= salida(0);
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of sumador is
signal a1, a2, a3: std_logic;
begin
xor1: entity work.xor3 port map (a, b, c_in, z);
and1: entity work.and2 port map (a, b, a1);
and2: entity work.and2 port map (a, c_in, a2);
and3: entity work.and2 port map (b, c_in, a3);
or1: entity work.or3 port map (a1, a2, a3, c_out);
end estructural;


-------------------------------------------------------------
-- SUMADOR COMPLETO DE N BITS DE ANCHO
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity sumadorN is
  generic (ancho:   integer := 32;
           retardo_base: time := 1 ns);
  port    (a, b:    in  std_logic_vector(ancho-1 downto 0);
           z:       out std_logic_vector(ancho-1 downto 0));
end entity sumadorN;

architecture comportamiento of sumadorN is
begin
  z <= std_logic_vector(signed(a) + signed(b)) after retardo_base*ancho;
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of sumadorN is
component sumador is
  generic (retardo_base: time := 1 ns);
  port    (a, b, c_in: in  std_logic;
           c_out, z:   out std_logic);
end component sumador;
signal c: std_logic_vector (ancho downto 1);
BEGIN
sumador1:
component sumador
	port map (a => a(0),
		  b => b(0),
		  c_in => '0',
		  z => z(0),
		  c_out => c (1));
sumadorn: for n in 1 to ancho-1 generate
sum: sumador
port map (a => a (n),
	  b => b (n),
	  c_in => c (n),
	  z => z (n),
	  c_out => c (n+1));	  
end generate sumadorn;
end architecture estructural;