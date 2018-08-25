-------------------------------------------------------------
-- Archivo: unidad_control.vhd
-------------------------------------------------------------
--  
--  DESCRIPCIÓN
--    Unidad de control para el procesador MIPS uniciclo
--
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

entity unidad_control is
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
end entity unidad_control;

architecture comportamiento of unidad_control is
  alias opcode : std_logic_vector(5 downto 0) is Instruction(31 downto 26);
  alias funct  : std_logic_vector(5 downto 0) is Instruction(5 downto 0);
begin
  process (Instruction)
  begin
    -- Asignacion de valores por defecto a las señales
    ALUOp    <= "000"; ALUSrc  <= "00"; RegDst   <= "00"; RegWrite <= '0';
    MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
case opcode is
      when "000000" => -- Operación tipo R
	ALUOp    <= "000"; ALUSrc  <= "00"; RegDst   <= "01"; RegWrite <= '1';
            	MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
        case funct is
          when "000000" => -- nop
            NULL;
	  when "001000" => --jr
		RegWrite <= '0'; JumpReg  <= '1'; 
	  when "001001" => --jalr
 		MemtoReg <= "10"; JumpReg  <= '1'; 
	  when "001100" => --Syscall
		RegWrite <= '0'; Halt     <= '1';
	  when "001101" => --break
		RegWrite <= '0'; Halt     <= '1';
	  when "100000" => --Add
		ALUOp    <= "100";
	  when "100001" => -- Addu
		ALUOp    <= "100";
	  when "100010" => --Sub
		 ALUOp    <= "101";
	  when "100011" => --Subu
		 ALUOp    <= "101";	
        	  when "100100" => --And
	  when "100101" => --Or
		 ALUOp    <= "001";
	  when "100110" => --xor
		 ALUOp    <= "010";
          	  when "100111" => --nor
		 ALUOp    <= "011";
	  when "101010" => --slt
		ALUOp    <= "110";
	  when "101011" => --sltu
		ALUOp    <= "111"; 
	  when others   => -- Instrucción no implementada
          	  NULL;
	  end case;
      when "000010" => -- j
	ALUOp    <= "000"; ALUSrc  <= "00"; RegDst   <= "00"; RegWrite <= '0';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '1'; JumpReg  <= '0'; Halt     <= '0';  
      when "000011" => -- jal
	ALUOp    <= "000"; ALUSrc  <= "00"; RegDst   <= "10"; RegWrite <= '1';
        MemtoReg <= "10"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';  
	BranchNE <= '0'; Jump    <= '1'; JumpReg  <= '0'; Halt     <= '0';
      when "000100" => --beq
	ALUOp    <= "101"; ALUSrc  <= "00"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '1'; --memtoreg 00
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "000101" => --bne
	ALUOp    <= "101"; ALUSrc  <= "00"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '1'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001000" => --Addi
	ALUOp    <= "100"; ALUSrc  <= "10"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001001" => --Addiu
	ALUOp    <= "100"; ALUSrc  <= "01"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001010" => --slti
	ALUOp    <= "110"; ALUSrc  <= "01"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001011" => --sltiu
	ALUOp    <= "111"; ALUSrc  <= "01"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001100" => --Andi
        ALUOp    <= "000"; ALUSrc  <= "10"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001101" => --Ori
        ALUOp    <= "001"; ALUSrc  <= "10"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001110" => --Xori
        ALUOp    <= "010"; ALUSrc  <= "10"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "001111" => --Lui
	ALUOp    <= "100"; ALUSrc  <= "11"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "00"; MemRead <= '0'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "100011" => --lw
	ALUOp    <= "100"; ALUSrc  <= "01"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "01"; MemRead <= '1'; MemWrite <= '0'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';
      when "101011" => --sw
        ALUOp    <= "100"; ALUSrc  <= "01"; RegDst   <= "00"; RegWrite <= '1';
        MemtoReg <= "01"; MemRead <= '0'; MemWrite <= '1'; BranchEQ <= '0';
	BranchNE <= '0'; Jump    <= '0'; JumpReg  <= '0'; Halt     <= '0';

       when others   => -- Instrucción no implementada
          NULL;

    end case;
    
  end process;     
end architecture comportamiento;

