library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
			branch: out STD_LOGIC;
			alusrc: out STD_LOGIC_VECTOR (1 downto 0);
			regdst, regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR (1 downto 0);
			aluop: out STD_LOGIC_VECTOR (2 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(11 downto 0);
begin
process(op) begin
	case op is
		when "000000" => 
			if(funct = "001000") then controls <= "000000000010";--JR (see mips reference sheet for funct code)
			else controls <= "110000001000"; -- Rtyp
			end if;
		when "100011" => controls <= "100100100000"; -- LW
		when "101011" => controls <= "000101000000"; -- SW
		when "000100" => controls <= "000010000100"; -- BEQ
		when "001000" => controls <= "100100000000"; -- ADDI
		when "000010" => controls <= "000000000001"; -- J
		when "001100" => controls <= "101000001100"; -- ANDI
		when "001101" => controls <= "101000010000"; -- ORI
		when others => controls <= "------------"; -- illegal op
	end case;
end process;

	regwrite <= controls(11);
	regdst <= controls(10);
	alusrc <= controls(9 downto 8);
	branch <= controls(7);
	memwrite <= controls(6);
	memtoreg <= controls(5);
	aluop <= controls(4 downto 2);
	jump <= controls(1 downto 0);
	
end;