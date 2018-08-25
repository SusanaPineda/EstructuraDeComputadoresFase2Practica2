-------------------------------------------------------------
-- Archivo: nextPC.vhd
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
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity next_PC is
  generic (retardo_base: time := 1 ns);
  port    (BranchEQ : in  std_logic;
           BranchNE : in  std_logic;
           Jump     : in  std_logic;
           JumpReg  : in  std_logic;
           Zero     : in  std_logic;
           PCSrc    : out std_logic_vector (1 downto 0));
end entity next_PC;

architecture comportamiento of next_PC is
begin
  process (BranchEQ, BranchNE, Jump, JumpReg, Zero)
    variable salida: std_logic_vector (1 downto 0);
  begin

    if JumpReg = '1' then
      salida := "11";
    elsif Jump = '1'    then
      salida := "10";
    elsif (BranchEQ = '1' and BranchNE = '0' and Zero = '1') then
      salida := "01";
    elsif (BranchEQ = '0' and BranchNE = '1' and Zero = '0') then
      salida := "01";
    else salida := "00";
    end if;
    PCSrc <= salida after retardo_base * 2;
  end process;
end architecture comportamiento;

-------------------------------------------------------------
--
-- Arquitectura que será rellenada por el grupo de prácticas
--
-------------------------------------------------------------

architecture estructural of next_PC is
signal not_JumpReg, not_Jump, not_BranchEQ, not_BranchNE, not_Zero: std_logic;
signal s1, s2, s3, s4, s5 : std_logic;

begin
inv0: entity work.not1 port map (JumpReg, not_JumpReg); --inversor JumpReg
inv1: entity work.not1 port map (Jump, not_Jump); --inversor Jump
inv2: entity work.not1 port map (BranchEQ, not_BranchEQ); --BranchEQ
inv3: entity work.not1 port map (JumpReg, not_JumpReg); --JumpReg
and0: entity work.and2 port map (not_JumpReg, Jump, s1); -- J*not_JR
--and1: entity work.and2 port map (not_Jump, BranchEQ, s2);
--and2: entity work.and2 port map (not_Jump, BranchNE, s3);
--and3: entity work.and2 port map (s4, not_JumpReg, s5);
--or1:  entity work.or2  port map (s2, s3, s4);
and1: entity work.and3 port map (not_Jump, BranchEQ, not_JumpReg, s2);
and2: entity work.and3 port map (not_Jump, BranchNE, not_JumpReg, s3);
or1:  entity work.or3  port map (s2, s3, JumpReg, PCSrc(0));
or0:  entity work.or2  port map (JumpReg, s1, PCSrc(1));
--or3:  entity work.or2  port map (s5, JumpReg, PCSrc(1));
end architecture estructural;