library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
    port (op: in STD_LOGIC_VECTOR (5 downto 0);
            funct: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
            branch: out STD_LOGIC;
            alusrc: out STD_LOGIC_VECTOR (1 downto 0);
				regdst: out STD_LOGIC_VECTOR (1 downto 0);
				regwrite: out STD_LOGIC;
            jump: out STD_LOGIC;
            jumpReg: out STD_LOGIC;
				dataSrc: out STD_LOGIC;
			aluop: out STD_LOGIC_VECTOR (1 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(12 downto 0);
begin
process(op) begin
	case op is
		when "000000" => controls <= "0010100000010"; -- Rtyp
		when "100011" => controls <= "0010001001000"; -- LW
		when "101011" => controls <= "0000001010000"; -- SW
		when "000100" => controls <= "0000000100001"; -- BEQ
		when "001000" => controls <= "0010001000000"; -- ADDI
        when "000010" => controls <= "0000000000100"; -- J
        when "001100" => controls <= "0010010000010"; --Andi
        when "100100" => controls <= "1001111100000"; -- BNAL
		when others => controls <= "-------------"; -- illegal op
    end case;
    case funct is
        when "001000" => controls <= "0110100000100"; -- JR
		  	when others => controls <= controls; -- illegal funct
    end case;
end process;

	dataSrc <= controls(12);
   jumpReg <= controls(11);
	regwrite <= controls(10);
	regdst <= controls(9 downto 8);
	alusrc <= controls(7 downto 6);
	branch <= controls(5);
	memwrite <= controls(4);
	memtoreg <= controls(3);
	jump <= controls(2);
	aluop <= controls(1 downto 0);
end;