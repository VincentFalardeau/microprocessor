library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg: out STD_LOGIC_VECTOR (1 downto 0);
			memwrite: out STD_LOGIC;
			branch: out STD_LOGIC;
			alusrc: out STD_LOGIC_VECTOR (1 downto 0);
			regdst: out STD_LOGIC_VECTOR (1 downto 0);
			regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR (1 downto 0);
			aluop: out STD_LOGIC_VECTOR (2 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(13 downto 0);
begin
process(op) begin
	case op is
		when "000000" => 
			if(funct = "001000") then controls <= "00000000000010";--JR (see mips reference sheet for funct code)
			else controls <= "10100000001000"; -- Rtyp
			end if;
		when "100011" => controls <= "10001000100000"; -- LW
		when "101011" => controls <= "00001010000000"; -- SW
		when "000100" => controls <= "00000100000100"; -- BEQ
		when "001000" => controls <= "10001000000000"; -- ADDI
		when "000010" => controls <= "00000000000001"; -- J
		when "001100" => controls <= "10010000001100"; -- ANDI
		when "000011" => controls <= "11000001000001"; -- JAL
		when "001101" => controls <= "10010000010000"; -- ORI
		when others => controls <= "--------------"; -- illegal op
	end case;
end process;

	regwrite <= controls(13);
	regdst <= controls(12 downto 11);
	alusrc <= controls(10 downto 9);
	branch <= controls(8);
	memwrite <= controls(7);
	memtoreg <= controls(6 downto 5);
	aluop <= controls(4 downto 2);
	jump <= controls(1 downto 0);
	
end;