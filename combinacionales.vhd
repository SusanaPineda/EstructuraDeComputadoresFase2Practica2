-------------------------------------------------------------
-- Archivo: combinacionales.vhd
-------------------------------------------------------------
--
--  ALUMNO 1
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
-- MULTIPLEXOR DE N ENTRADAS DE 1 BIT DE ANCHO
-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_2_nx1 is
  generic (ancho_sel:     integer := 1;
           retardo_base:  time := 1 ns);
  port    (datos:     in  std_logic_vector(2**ancho_sel-1 downto 0);
           seleccion: in  std_logic_vector(ancho_sel-1 downto 0);
           y:         out std_logic);
end entity mux_2_nx1;

architecture comportamiento of mux_2_nx1 is
begin
  y <= datos(to_integer(unsigned(seleccion))) AFTER retardo_base*2;
end architecture comportamiento;


-------------------------------------------------------------
-- MULTIPLEXOR DE 2 ENTRADAS DE 1 BIT DE ANCHO
-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 

entity mux_2x1 is
  generic (retardo_base: time := 1 ns);
  port    (d0, d1: in  std_logic;
           s:      in  std_logic;
           z:      out std_logic);
end entity mux_2x1;

architecture comportamiento of mux_2x1 is
begin
  z <= d1 when s = '1' else d0 AFTER retardo_base*2;
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of mux_2x1 is
signal not_s: std_logic;
signal a1, a2: std_logic;
begin	
inv0: entity work.not1 port map (s, not_s);
and1: entity work.and2 port map (d0, not_s, a1);
and2: entity work.and2 port map (d1, s, a2);
or1: entity work.or2 port map (a1, a2, z);
end architecture estructural;


-------------------------------------------------------------
-- MULTIPLEXOR DE 2 ENTRADAS DE N BITS DE ANCHO
-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 

entity mux_2xn is
  generic (ancho_datos:  integer := 32;
           retardo_base: time := 1 ns);
  port    (d0, d1: in  std_logic_vector(ancho_datos-1 downto 0);
           s:      in  std_logic;
           z:      out std_logic_vector(ancho_datos-1 downto 0));
end entity mux_2xn;

architecture comportamiento of mux_2xn is
begin
  z <= d1 AFTER retardo_base*2 when s = '1' else
       d0 AFTER retardo_base*3;
end architecture comportamiento;

architecture estructural of mux_2xn is
  component mux_2x1 is
    generic (retardo_base: time := 1 ns);
    port    (d0, d1: in  std_logic;
             s:      in  std_logic;
             z:      out std_logic);
  end component mux_2x1;
begin
  -- Generación de los multiplexores individuales
  mux_n: for i in 0 to ancho_datos-1 generate
  begin
    mux_i : mux_2x1 generic map (retardo_base)
                    port    map (d0(i),d1(i),s,z(i));
  end generate mux_n;
end architecture estructural;


-------------------------------------------------------------
-- MULTIPLEXOR DE 4 ENTRADAS DE 1 BIT DE ANCHO
-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 

entity mux_4x1 is
  generic (retardo_base: time := 1 ns);
  port    (d0, d1,
           d2, d3: in  std_logic;
           s:      in  std_logic_vector(1 downto 0);
           z:      out std_logic);
end entity mux_4x1;

architecture comportamiento of mux_4x1 is
begin
  z <= d0 AFTER retardo_base*3 when s = "00" else
       d1 AFTER retardo_base*3 when s = "01" else
       d2 AFTER retardo_base*3 when s = "10" else
       d3 AFTER retardo_base*2;
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of mux_4x1 is
signal not_s0, not_s1: std_logic;
signal a1, a2, a3, a4: std_logic;
begin
inv0: entity work.not1 port map (s(0), not_s0);
inv1:  entity work.not1 port map (s(1),  not_s1);
and1: entity work.and3 port map (d0, not_s0, not_s1, a1);
and2: entity work.and3 port map (d1, not_s1, s(0), a2);
and3: entity work.and3 port map (d2,  s(1), not_s0, a3);
and4: entity work.and3 port map (d3, s(0), s(1), a4);
or1: entity work.or4 port map (a1, a2, a3, a4, z);
end architecture estructural;


-------------------------------------------------------------
-- MULTIPLEXOR DE 4 ENTRADAS DE N BITS DE ANCHO
-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4xn is
  generic (ancho_datos:  integer := 32;
           retardo_base: time := 1 ns);
  port    (d0, d1,
           d2, d3: in  std_logic_vector(ancho_datos-1 downto 0);
           s:      in  std_logic_vector(1 downto 0);
           z:      out std_logic_vector(ancho_datos-1 downto 0));
end entity mux_4xn;

architecture comportamiento of mux_4xn is
begin
  z <= d0 AFTER retardo_base*2 when s = "00" else
       d1 AFTER retardo_base*2 when s = "01" else
       d2 AFTER retardo_base*2 when s = "10" else
       d3 AFTER retardo_base*2;
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------
-- mux_4xn
architecture estructural of mux_4xn is
	component mux_4x1 is
 	generic (retardo_base: time := 1 ns);
 	 port    (d0, d1,
   	        d2, d3: in  std_logic;
  	        s:      in  std_logic_vector(1 downto 0);
   	        z:      out std_logic);
	end component mux_4x1;
BEGIN
mux_4xn:
for n in 0 to ancho_datos-1 generate
mux: mux_4x1
port map (d0 => d0 (n), 
	  d1 => d1 (n),
	  d2 => d2 (n),
	  d3 => d3 (n),
	  z  => z  (n),
	  s  => s);
end generate mux_4xn;
end architecture estructural;


-------------------------------------------------------------
-- DESPLAZADOR A LA IZQUIERDA DE LONGITUD CONSTANTE
-------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity desplazador_izquierda is -- shift left by 2
  generic (ancho_entrada: integer := 16;
           longitud     : integer := 2;
           ancho_salida : integer := 32);
  port    (a: in  STD_LOGIC_VECTOR(ancho_entrada-1 downto 0);
           z: out STD_LOGIC_VECTOR(ancho_salida-1 downto 0));
end entity desplazador_izquierda;

architecture estructural of desplazador_izquierda is
  signal ceros: STD_LOGIC_VECTOR(longitud-1 downto 0);
  signal aux: STD_LOGIC_VECTOR(ancho_entrada+longitud-1 downto 0);
begin
  ceros <= (others => '0');
  aux <= a(ancho_entrada-1 downto 0) & ceros;
  z <= aux (ancho_salida-1 downto 0);
end architecture estructural;


-------------------------------------------------------------
-- CIRCUITO PARA EXTENSIÓN DE SIGNO
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity extension_signo is
  generic (ancho_entrada: integer := 16;
           ancho_salida:  integer := 32);
  port    (a:             in  STD_LOGIC_VECTOR(ancho_entrada-1 downto 0);
           z:             out STD_LOGIC_VECTOR(ancho_salida-1 downto 0));
end entity extension_signo;

architecture estructural of extension_signo is
  signal signo: STD_LOGIC_VECTOR(ancho_salida-ancho_entrada-1 downto 0);
begin
  signo <= (others => a(ancho_entrada-1));
  z <= signo & a; 
end architecture estructural;


-------------------------------------------------------------
-- CIRCUITO PARA EXTENSIÓN CON CEROS
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity extension_ceros is
  generic (ancho_entrada: integer := 16;
           ancho_salida:  integer := 32);
  port    (a:             in  STD_LOGIC_VECTOR(ancho_entrada-1 downto 0);
           z:             out STD_LOGIC_VECTOR(ancho_salida-1 downto 0));
end entity extension_ceros;

architecture estructural of extension_ceros is
  signal ceros: STD_LOGIC_VECTOR(ancho_salida-ancho_entrada-1 downto 0);
begin
  ceros <= (others => '0');
  z <= ceros & a; 
end architecture estructural;


