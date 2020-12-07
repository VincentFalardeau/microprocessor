library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
    port (op: in STD_LOGIC_VECTOR (5 downto 0);
            funct: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
            branch out STD_LOGIC;
            alusrc: out STD_LOGIC_VECTOR (1 downto 0);
			regdst, regwrite: out STD_LOGIC;
            jump: out STD_LOGIC;
            jumpReg: out STD_LOGIC;
			aluop: out STD_LOGIC_VECTOR (1 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(8 downto 0);
begin
process(op, funct) begin
	case op is
		when "000000" => controls <= "01100000010"; -- Rtyp
		when "100011" => controls <= "01001001000"; -- LW
		when "101011" => controls <= "00001010000"; -- SW
		when "000100" => controls <= "00000100001"; -- BEQ
		when "001000" => controls <= "01001000000"; -- ADDI
        when "000010" => controls <= "00000000100"; -- J
        when "001100" => controls <= "01010000100"; --Andi
		when others => controls <= "---------"; -- illegal op
    end case;
    case funct is
        when "001000" => controls <= "1110000010"; -- JR
    end case;
end process;

    jumpReg <= controls(10);
	regwrite <= controls(9);
	regdst <= controls(8);
	alusrc <= controls(7 downto 6);
	branch <= controls(5);
	memwrite <= controls(4);
	memtoreg <= controls(3);
	jump <= controls(2);
	aluop <= controls(1 downto 0);
end;