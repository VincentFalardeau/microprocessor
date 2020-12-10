library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
			branch, alusrc: out STD_LOGIC;
			regdst, regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR (1 downto 0);
			aluop: out STD_LOGIC_VECTOR (1 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(9 downto 0);
begin
process(op) begin
	case op is
		when "000000" => 
			if(funct = "001000") then controls <= "0000000010";--JR (see mips reference sheet for funct code)
			else controls <= "1100001000"; -- Rtyp
			end if;
		when "100011" => controls <= "1010010000"; -- LW
		when "101011" => controls <= "0010100000"; -- SW
		when "000100" => controls <= "0001000001"; -- BEQ
		when "001000" => controls <= "1010000000"; -- ADDI
		when "000010" => controls <= "0000001000"; -- J
		when others => controls <= "----------"; -- illegal op
	end case;
end process;

	regwrite <= controls(9);
	regdst <= controls(8);
	alusrc <= controls(7);
	branch <= controls(6);
	memwrite <= controls(5);
	memtoreg <= controls(4);
	aluop <= controls(3 downto 2);
	jump <= controls(1 downto 0);
	
end;