-------------------------------------------------------------
-- Archivo: ALU.vhd
-------------------------------------------------------------
--  
--  DESCRIPCIÓN
--    Unidad aritmético-lógica para MIPS
--
-------------------------------------------------------------
--
--  ALUMNO 1
--    Identificador de usuario: g.melendezm
--    Apellidos y nombre: Guillermo Mélendez Morales
--
--  ALUMNO 2
--    Identificador de usuario: s.pinedad
--    Apellidos y nombre: Susana Pineda De Luelmo
--
-- Alumnos del doble grado de Diseño y Desarrollo de Videojuegos e
-- Ingenieria de computadores 
-------------------------------------------------------------

-------------------------------------------------------------
-- UAL DE 1 BIT
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU1 is
  generic (retardo_base : time := 1 ns);
  port    (a     : in  std_logic; 
           b     : in  std_logic;
           less  : in  std_logic;
           c_in  : in  std_logic;
           ALU_Operation: in  std_logic_vector(2 downto 0);
           c_out : out std_logic;
           z     : out std_logic);
end entity ALU1;


architecture comportamiento of ALU1 is
begin
  process (ALU_Operation, a, b, less, c_in)
    variable res, ac: std_logic;
    variable res_suma, op1, op2, op3: signed (1 downto 0);
  begin
    res := '0';
    ac  := '0';
    case ALU_Operation is
      when "000" => res := a and b;
      when "001" => res := a or b;
      when "010" => res := a xor b;
      when "011" => res := a nor b;
      when "100" =>
        op1 := '0' & a;
        op2 := '0' & b;
        op3 := '0' & c_in;
        res_suma := op1 + op2 + op3;
        ac := res_suma(1);
        res := res_suma(0);
      when "101" =>
        op1 := '0' & a;
        op2 := '0' & not b;
        op3 := '0' & c_in;
        res_suma := op1 + op2 + op3;
        ac := res_suma(1);
        res := res_suma(0);
      when "110"  | "111" =>
        op1 := '0' & a;
        op2 := '0' & not b;
        op3 := '0' & c_in;
        res_suma := op1 + op2 + op3;
        ac := res_suma(1);
        res := less;
      when others => NULL;
    end case;
    z <= res AFTER retardo_base * 3;
    c_out <= ac AFTER retardo_base * 2;
  end process;
end architecture comportamiento;


-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of ALU1 is

signal not_b, not_ALU_Operation0, not_ALU_Operation1, not_ALU_Operation2, not_cin, not_cout: std_logic;
signal c1, c2, c3, c4, c5, c6, cout, ac, not_d6, not_c6: std_logic;
signal d1, d2, d3, d4, d5, d6: std_logic; -- c_out
signal s1, s2, s3, s4, s5, s6, s7, s8, s9, s10: std_logic;
signal e1, e2, e3, e4, e5, e6, e7, e8, e9, e10: std_logic; -- c_out
begin

inv2:		entity work.not1	port map (ALU_Operation (0), not_ALU_Operation0);
inv3:		entity work.not1	port map (ALU_Operation (1), not_ALU_Operation1);
inv4:		entity work.not1	port map (ALU_Operation (2), not_ALU_Operation2);
inv5:		entity work.not1	port map (c_in, not_cin);

-- And (Aluop => 000)
and1:		entity work.and2 	port map (a, b, c1);
-- Or  (Aluop => 001)
or1:    	entity work.or2		port map (a, b, c2);
-- Xor (Aluop => 010)
xor1:		entity work.xor2 	port map (a, b, c3);
-- Nor (Aluop => 011)
nor1:		entity work.nor2 	port map (a, b, c4);
-- Add (Aluop => 100)
add1:		entity work.sumador 	port map (a, b, c_in, ac, c5);
add1c:		entity work.sumador 	port map (a, b, c_in, d5, ac);
-- Sub (Aluop => 101)
ca2:		entity work.xor2	port map (b, '1', not_b);
sub1:		entity work.sumador 	port map (a, not_b, not_cin, ac, c6);
sub1c:		entity work.sumador 	port map (a, not_b, c_in, d6, ac);
inver:		entity work.not1	port map (c6, not_c6);
d1 <= ALU_Operation (2);
d2 <= ALU_Operation (2);
d3 <= ALU_Operation (2);
d4 <= ALU_Operation (2);

-- Multiplexor
and000:		entity work.and4	port map (c1, not_ALU_Operation2, not_ALU_Operation1, not_ALU_Operation0, s1);
and000c:	entity work.and4	port map (d1, not_ALU_Operation2, not_ALU_Operation1, not_ALU_Operation0, e1);

and001:		entity work.and4	port map (c2, not_ALU_Operation2, not_ALU_Operation1, ALU_Operation (0), s2);
and001c:	entity work.and4	port map (d2, not_ALU_Operation2, not_ALU_Operation1, ALU_Operation (0), e2);

and010:		entity work.and4	port map (c3, not_ALU_Operation2, ALU_Operation (1), not_ALU_Operation0, s3);
and010c:	entity work.and4	port map (d3, not_ALU_Operation2, ALU_Operation (1), not_ALU_Operation0, e3);

and011:		entity work.and4	port map (c4, not_ALU_Operation2, ALU_Operation (1), ALU_Operation (0), s4);
and011c:	entity work.and4	port map (d4, not_ALU_Operation2, ALU_Operation (1), ALU_Operation (0), e4);

and100:		entity work.and4	port map (c5, ALU_Operation (2), not_ALU_Operation1, not_ALU_Operation0, s5);
and100c:	entity work.and4	port map (d5, ALU_Operation (2), not_ALU_Operation1, not_ALU_Operation0, e5);

and101:		entity work.and4	port map (not_c6, ALU_Operation (2), not_ALU_Operation1, ALU_Operation (0), s6);
and101c:	entity work.and4	port map (d6, ALU_Operation (2), not_ALU_Operation1, ALU_Operation (0), e6);

and110:		entity work.and4	port map (less, ALU_Operation (2), ALU_Operation (1), not_ALU_Operation0, s7);
and110c:	entity work.and4	port map (d6, ALU_Operation (2), ALU_Operation (1), not_ALU_Operation0, e7);

and111:		entity work.and4	port map (less, ALU_Operation (2), ALU_Operation (1), ALU_Operation (0), s8);
and111c:	entity work.and4	port map (d6, ALU_Operation (2), ALU_Operation (1), ALU_Operation (0), e8);

orfin1: 	entity work.or4		port map ( s1, s2, s3, s4, s9);
orfin1c: 	entity work.or4		port map ( e1, e2, e3, e4, e9);

orfin2:		entity work.or4		port map ( s5, s6, s7, s8, s10);
orfin2c:	entity work.or4		port map ( e5, e6, e7, e8, e10);
orfinal:	entity work.or2		port map (s9, s10, z);
orfinalc:	entity work.or2		port map (e9, e10, c_out);
end architecture estructural;
-------------------------------------------------------------
-- UAL DE 32 BITS
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU32 is
  generic (retardo_base : time := 1 ns);
  port    (ALU_Src1     : in  std_logic_vector(31 downto 0); 
           ALU_Src2     : in  std_logic_vector(31 downto 0); 
           ALU_Operation: in  std_logic_vector(2 downto 0);
           ALU_Result   : out std_logic_vector(31 downto 0);
           Zero         : out std_logic;
           Overflow     : out std_logic);
end entity ALU32;


architecture comportamiento of ALU32 is
begin
  process (ALU_Operation, ALU_Src1, ALU_Src2)
    variable res, op1, op2: signed (31 downto 0);
    variable ov : std_logic;
  begin
    op1 := signed(ALU_Src1);
    op2 := signed(ALU_Src2);
    ov  := '0';
    case ALU_Operation is
      when "000" => res := op1 and op2;
      when "001" => res := op1 or op2;
      when "010" => res := op1 xor op2;
      when "011" => res := op1 nor op2;
      when "100" =>
        res := op1 + op2;
        ov  := (op1(31) and op2(31) and not res(31)) or
               (not op1(31) and not op2(31) and res(31));
      when "101" =>
        res := op1 - op2;
        ov  := (op1(31) and not op2(31) and not res(31)) or
               (not op1(31) and op2(31) and res(31));
      when "110" =>
        if (op1 < op2) then res := (0 => '1', others => '0');
        else res := (others => '0');
        end if;
      when "111" =>
        if (unsigned(op1) < unsigned(op2)) then res := (0 => '1', others => '0');
        else res := (others => '0');
        end if;
      when others =>
    end case;
    ALU_Result <= std_logic_vector(res) AFTER retardo_base * 34;
    if res = 0 then Zero <= '1' AFTER retardo_base * 33;
    else            Zero <= '0' AFTER retardo_base * 33;
    end if;
    Overflow <= ov AFTER retardo_base * 33;
  end process;
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of ALU32 is

	component ALU1 is
  	generic (retardo_base : time := 1 ns);
 	 port    (a     : in  std_logic; 
 	          b     : in  std_logic;
 	          less  : in  std_logic;
  	          c_in  : in  std_logic;
         	  ALU_Operation: in  std_logic_vector	(2 downto 0);
         	  c_out : out std_logic;	
        	   z     : out std_logic);
	end component ALU1;
signal c: std_logic_vector (32 downto 1);
signal 	Result, b, not_ALU_Src2, not_Result, ze, not_ALU_Result31, not_ALU_Result0: std_logic;
BEGIN

resta:		entity work.not1 port map (ALU_Src2 (31), not_ALU_Src2);
resta1:		entity work.semisumador port map (ALU_Src1(31) , not_ALU_Src2, b, Result);
inv10:		entity work.not1 port map (Result, not_Result);

ALUo:
component ALU1
	port map (a => ALU_Src1 (0),
		  b => ALU_Src2 (0),
		  less => not_Result ,
	          c_in => '0',
		  ALU_Operation => ALU_Operation,
		  c_out => c (1),
		  z => ALU_Result (0));
ALU31: for n in 1 to 31 generate
ALU30: ALU1
	port map (a => ALU_Src1 (n),
		  b => ALU_Src2 (n),
		  less => '0',
		  c_in => c (n),
		  ALU_Operation => ALU_Operation,
		  c_out => c (n+1),
		  z => ALU_Result (n));
end generate ALU31;
inv11:		entity work.not1 port map (ALU_Result (31), not_ALU_Result31);
inv12:		entity work.not1 port map (ALU_Result (0), not_ALU_Result0);
and22:		entity work.and2 port map (not_ALU_Result31, not_ALU_Result0, ze);
Zero <= ze;
Overflow <= '0';
end architecture estructural;