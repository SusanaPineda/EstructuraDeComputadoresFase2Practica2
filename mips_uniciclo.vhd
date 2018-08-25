-------------------------------------------------------------
-- Archivo: mips_uniciclo.vhd
-------------------------------------------------------------
--
--  DESCRIPCIÓN
--    Modelo estructural del camino de datos y el control 
--    para el procesador MIPS uniciclo
--
--  Autor: Luis Rincón Córcoles
--
--  Versiones
--     01-12-2013: primera versión
--
-------------------------------------------------------------
--   COMPONENTES DEL MODELO
--     * UNIDAD DE CONTROL
--     * CIRCUITO DE CONTROL PARA OBTENER PCSrc
--     * PC
--     * UAL
--     * BANCO DE REGISTROS
--     * 2 SUMADORES
--     * EXTENSIÓN DE SIGNO
--     * EXTENSIÓN CON CEROS
--     * DESPLAZADOR DE 16 BITS A LA IZQUIERDA (ENTRADA DE 16 BITS)
--     * DESPLAZADOR DE 2 BITS A LA IZQUIERDA (ENTRADA DE 26 BITS)
--     * DESPLAZADOR DE 2 BITS A LA IZQUIERDA (ENTRADA DE 32 BITS)
--     * 1 MULTIPLEXOR DE 4:1 DE 5 BITS DE ANCHO
--     * 3 MULTIPLEXORES DE 4:1 DE 32 BITS DE ANCHO
-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_settings.all;


entity MIPS is
  port (clk            : in  std_logic;
        reset          : in  std_logic;
        MemRead        : out std_logic;
        MemWrite       : out std_logic;
        Halt           : out std_logic;
        Inst_Address   : out std_logic_vector (31 downto 0);  -- Dirección de instrucción
        Instruction    : in  std_logic_vector (31 downto 0);  -- Instruccion leída
        Data_Address   : out std_logic_vector (31 downto 0);  -- Dirección de datos
        Read_Data_Mem  : in  std_logic_vector (31 downto 0);  -- Dato leído
        Write_Data_Mem : out std_logic_vector (31 downto 0)); -- Dato para escribir
end entity MIPS;


-------------------------------------------------------------
-- ARQUITECTURA ESTRUCTURAL
-------------------------------------------------------------

architecture estructural of MIPS is

-- UNIDAD DE CONTROL
component unidad_control is
  generic (retardo_base: time := 1 ns);
  port    (Instruction: in  std_logic_vector(31 downto 0);
           ALUOp      : out std_logic_vector(2 downto 0);
           ALUSrc     : out std_logic_vector(1 downto 0);
           RegDst     : out std_logic_vector(1 downto 0);
           RegWrite   : out std_logic;
           MemtoReg   : out std_logic_vector(1 downto 0);
           MemRead    : out std_logic;
           MemWrite   : out std_logic;
           BranchEQ   : out std_logic;
           BranchNE   : out std_logic;
           Jump       : out std_logic;
           JumpReg    : out std_logic;
           Halt       : out std_logic);
end component unidad_control;

-- CIRCUITO DE CONTROL PARA OBTENER PCSrc
component next_PC is
  generic (retardo_base: time := 1 ns);
  port    (BranchEQ : in  std_logic;
           BranchNE : in  std_logic;
           Jump     : in  std_logic;
           JumpReg  : in  std_logic;
           Zero     : in  std_logic;
           PCSrc    : out std_logic_vector (1 downto 0));
end component next_PC;

-- PC
component registro is
  generic (ancho      :  integer := 32;
           valor_reset: integer := 16#40000000#;
           retardo    : time := 1 ns);
  port    (clk:     in STD_LOGIC; 
           reset:   in STD_LOGIC;
           enable:  in STD_LOGIC;
           entrada: in STD_LOGIC_VECTOR(ancho-1 downto 0);
           salida:  out STD_LOGIC_VECTOR(ancho-1 downto 0));
end component registro;

-- UAL
component ALU32 is
  generic (retardo_base : time := 1 ns);
  port    (ALU_Src1     : in  std_logic_vector(31 downto 0); 
           ALU_Src2     : in  std_logic_vector(31 downto 0); 
           ALU_Operation: in  std_logic_vector(2 downto 0);
           ALU_Result   : out std_logic_vector(31 downto 0);
           Zero         : out std_logic;
           Overflow     : out std_logic);
end component ALU32;

-- BANCO DE REGISTROS
component banco_registros is
  generic (retardo       : time := 2 ns);
  port    (clk           : in std_logic; 
           reset         : in std_logic;
           RegWrite      : in std_logic;
           Read_Register1: in std_logic_vector (4 DOWNTO 0); 
           Read_Register2: in std_logic_vector (4 DOWNTO 0);
           Write_Register: in std_logic_vector (4 DOWNTO 0);
           Read_Data1    : out std_logic_vector (31 DOWNTO 0); 
           Read_Data2    : out std_logic_vector (31 DOWNTO 0);
           Write_Data    : in std_logic_vector (31 DOWNTO 0));
end component banco_registros;

-- 2 SUMADORES
component sumadorN is
  generic (ancho:   integer := 32;
           retardo_base: time := 1 ns);
  port    (a, b:    in  std_logic_vector(ancho-1 downto 0);
           z:       out std_logic_vector(ancho-1 downto 0));
end component sumadorN;

-- EXTENSIÓN DE SIGNO
component extension_signo is
  generic (ancho_entrada: integer := 16;
           ancho_salida:  integer := 32);
  port    (a:             in  STD_LOGIC_VECTOR(ancho_entrada-1 downto 0);
           z:             out STD_LOGIC_VECTOR(ancho_salida-1 downto 0));
end component extension_signo;

-- EXTENSIÓN CON CEROS
component extension_ceros is
  generic (ancho_entrada: integer := 16;
           ancho_salida:  integer := 32);
  port    (a:             in  STD_LOGIC_VECTOR(ancho_entrada-1 downto 0);
           z:             out STD_LOGIC_VECTOR(ancho_salida-1 downto 0));
end component extension_ceros;

-- DESPLAZADOR DE 16 BITS A LA IZQUIERDA (ENTRADA DE 16 BITS)
-- DESPLAZADOR DE 2 BITS A LA IZQUIERDA (ENTRADA DE 26 BITS)
-- DESPLAZADOR DE 2 BITS A LA IZQUIERDA (ENTRADA DE 32 BITS)
component desplazador_izquierda is -- shift left by 2
  generic (ancho_entrada: integer := 16;
           longitud     : integer := 2;
           ancho_salida : integer := 32);
  port    (a: in  STD_LOGIC_VECTOR(ancho_entrada-1 downto 0);
           z: out STD_LOGIC_VECTOR(ancho_salida-1 downto 0));
end component desplazador_izquierda;

-- 1 MULTIPLEXOR DE 4:1 DE 5 BITS DE ANCHO
-- 3 MULTIPLEXORES DE 4:1 DE 32 BITS DE ANCHO
component mux_4xn is
  generic (ancho_datos:  integer := 32;
           retardo_base: time := 1 ns);
  port    (d0, d1,
           d2, d3: in  STD_LOGIC_VECTOR(ancho_datos-1 downto 0);
           s:      in  STD_LOGIC_VECTOR(1 downto 0);
           z:      out STD_LOGIC_VECTOR(ancho_datos-1 downto 0));
end component mux_4xn;

-- ESPECIFICACIONES DE CONFIGURACIÓN
--for all: next_PC use entity work.next_PC(comportamiento);
for all: next_PC use entity work.next_PC(estructural);
for all: ALU32 use entity work.ALU32(comportamiento);
--for all: ALU32 use entity work.ALU32(estructural);
--for all: sumadorN use entity work.sumadorN(comportamiento);
for all: sumadorN use entity work.sumadorN(estructural);
--for all: mux_4xn use entity work.mux_4xn(comportamiento);
for all: mux_4xn use entity work.mux_4xn(estructural);
for all: registro use entity work.registro(comportamiento);
for all: banco_registros use entity work.banco_registros(comportamiento);
for all: extension_signo use entity work.extension_signo(estructural);
for all: extension_ceros use entity work.extension_ceros(estructural);
for all: desplazador_izquierda use entity work.desplazador_izquierda(estructural);
for all: unidad_control use entity work.unidad_control(comportamiento);

-- DECLARACIÓN DE SEÑALES
-- Señales de control de la unidad de control
signal ALUOp      : std_logic_vector(2 downto 0);
signal ALUSrc     : std_logic_vector(1 downto 0);
signal RegDst     : std_logic_vector(1 downto 0);
signal RegWrite   : std_logic;
signal MemtoReg   : std_logic_vector(1 downto 0);
signal BranchEQ   : std_logic;
signal BranchNE   : std_logic;
signal Jump       : std_logic;
signal JumpReg    : std_logic;
-- Posibles valores del PC y señales relacionadas
signal PC         : std_logic_vector(31 downto 0);
signal cuatro     : std_logic_vector(31 downto 0);
signal PCplus4    : std_logic_vector(31 downto 0);
signal PCbranch   : std_logic_vector(31 downto 0);
signal PCjump     : std_logic_vector(31 downto 0);
signal nextPC     : std_logic_vector(31 downto 0);
signal destinox4  : std_logic_vector(27 downto 0);
signal PCSrc      : std_logic_vector(1 downto 0);
-- Entradas y salidas de datos del banco de registros
signal Write_Data : std_logic_vector(31 downto 0);
signal Read_Data1 : std_logic_vector(31 downto 0);
signal Read_Data2 : std_logic_vector(31 downto 0);
-- Identificador de escritura en el banco de registros
signal Write_Reg  : std_logic_vector (4 downto 0);
-- Inmediato extendido
signal inm_ES     : std_logic_vector(31 downto 0);
signal inm_ES_SL2 : std_logic_vector(31 downto 0);
signal inm_EZ     : std_logic_vector(31 downto 0);
signal inm_SL16   : std_logic_vector(31 downto 0);
-- Entradas y salidas de la UAL
signal ALU_Src2   : std_logic_vector(31 downto 0);
signal ALU_Result : std_logic_vector(31 downto 0);
signal Zero       : std_logic;
signal Overflow   : std_logic;
-- Campos de la instrucción
--alias codigo_operacion : std_logic_vector(5 downto 0) is Instruction(31 downto 26);
--alias funcion : std_logic_vector(5 downto 0) is Instruction(5 downto 0);
alias rs : std_logic_vector(4 downto 0) is Instruction(25 downto 21);
alias rt : std_logic_vector(4 downto 0) is Instruction(20 downto 16);
alias rd : std_logic_vector(4 downto 0) is Instruction(15 downto 11);
alias inmediato : std_logic_vector(15 downto 0) is Instruction(15 downto 0);
alias destino : std_logic_vector(25 downto 0) is Instruction(25 downto 0);

begin
-- UNIDAD DE CONTROL
uc:    unidad_control
       generic map (retardo_base => retardo_puerta)
       port    map (Instruction, ALUOp, ALUSrc, RegDst, RegWrite, MemtoReg,
                    MemRead, MemWrite, BranchEQ, BranchNE, Jump, JumpReg, Halt);
-- CIRCUITO DE CONTROL PARA OBTENER PCSrc
nPC:   next_PC
       generic map (retardo_base => retardo_puerta)
       port    map (BranchEQ, BranchNE, Jump, JumpReg, Zero, PCSrc);
-- PC
regPC: registro
       generic map (ancho => 32, valor_reset => PCinicial, 
                    retardo => retardo_registro)
       port    map (clk, reset, '1', nextPC, PC);
-- UAL
UAL:   ALU32
       generic map (retardo_base => retardo_puerta)
       port    map (Read_Data1, ALU_Src2, ALUOp, ALU_Result, Zero, Overflow);
-- BANCO DE REGISTROS
br:    banco_registros
       generic map (retardo => retardo_banco_registros)
       port    map (clk, reset, RegWrite, rs, rt, Write_Reg,
                    Read_Data1, Read_Data2, Write_Data);
-- 2 SUMADORES
-- Sumador para incrementar el PC
sum4:  sumadorN
       generic map (ancho => 32, retardo_base => retardo_puerta)
       port    map (PC, cuatro, PCplus4);
cuatro <= std_logic_vector(to_signed(4,32));

-- Sumador para calcular la dirección de ramificación
sumR:  sumadorN
       generic map (ancho => 32, retardo_base => retardo_puerta)
       port    map (PCplus4, inm_ES_SL2, PCbranch);

-- EXTENSIÓN DE SIGNO
es32:  extension_signo
       generic map (ancho_entrada => 16, ancho_salida => 32)
       port    map (inmediato, inm_ES);

-- EXTENSIÓN CON CEROS
ez32:  extension_ceros
       generic map (ancho_entrada => 16, ancho_salida => 32)
       port    map (inmediato, inm_EZ);

-- DESPLAZADOR DE 16 BITS A LA IZQUIERDA (ENTRADA DE 16 BITS)
sl16:  desplazador_izquierda
       generic map (ancho_entrada => 16, longitud => 16, ancho_salida => 32)
       port    map (inmediato, inm_SL16);

-- DESPLAZADOR DE 2 BITS A LA IZQUIERDA (ENTRADA DE 26 BITS)
sl2:   desplazador_izquierda
       generic map (ancho_entrada => 26, longitud => 2, ancho_salida => 28)
       port    map (destino, destinox4);

-- DESPLAZADOR DE 2 BITS A LA IZQUIERDA (ENTRADA DE 32 BITS)
sl32:  desplazador_izquierda
       generic map (ancho_entrada => 32, longitud => 2, ancho_salida => 32)
       port    map (inm_ES, inm_ES_SL2);

PCjump <= PCplus4 (31 downto 28) & destinox4;

-- 1 MULTIPLEXOR DE 4:1 DE 5 BITS DE ANCHO
-- Multiplexor para seleccionar el registro de escritura
muxWR: mux_4xn
       generic map (ancho_datos => 5, retardo_base => retardo_puerta)
       port    map (rt, rd, "11111", "00000", RegDst, Write_Reg);

-- 3 MULTIPLEXORES DE 4:1 DE 32 BITS DE ANCHO
-- Multiplexor para seleccionar el dato de escritura en el banco de registros
muxWD: mux_4xn
       generic map (ancho_datos => 32, retardo_base => retardo_puerta)
       port    map (ALU_Result, Read_Data_Mem, PCplus4, std_logic_vector(to_unsigned(0,32)), 
                    MemtoReg, Write_Data);

-- Multiplexor para seleccionar el segundo operando de la UAL
muxAS: mux_4xn
       generic map (ancho_datos => 32, retardo_base => retardo_puerta)
       port    map (Read_Data2, inm_ES, inm_EZ, inm_SL16, ALUSrc, ALU_Src2);

-- Multiplexor para seleccionar el próximo valor del PC
muxPC: mux_4xn
       generic map (ancho_datos => 32, retardo_base => retardo_puerta)
       port    map (PCplus4, PCbranch, PCJump, Read_Data1, PCSrc, nextPC);

-- Salidas del circuito
Inst_Address <= PC;
Write_Data_Mem <= Read_Data2;
Data_Address <= ALU_Result;

end architecture estructural;

