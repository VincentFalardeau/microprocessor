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
			aluop: out STD_LOGIC_VECTOR (2 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(13 downto 0);
begin
process(op) begin
	case op is
		when "000000" => controls <= "00101000000100"; -- Rtyp
		when "100011" => controls <= "00100010010000"; -- LW
		when "101011" => controls <= "00000010100000"; -- SW
		when "000100" => controls <= "00000001000001"; -- BEQ
        when "001000" => controls <= "00100010000000"; -- ADDI
        when "001101" => controls <= "00100100000011"; -- ORI
        when "000010" => controls <= "00000000001000"; -- J
        when "001100" => controls <= "00100100000010"; --Andi
		  when "000011" => controls <= "10111000001000";--JAL
        when "100100" => controls <= "10011111000000"; -- BNAL
		when others => controls <= "--------------"; -- illegal op
    end case;
    case funct is
        when "001000" => controls <= "01101000001100"; -- JR
		  	when others => controls <= controls; -- illegal funct
    end case;
end process;

	dataSrc <= controls(13);
    jumpReg <= controls(12);
	regwrite <= controls(11);
	regdst <= controls(10 downto 9);
	alusrc <= controls(8 downto 7);
	branch <= controls(6);
	memwrite <= controls(5);
	memtoreg <= controls(4);
	jump <= controls(3);
	aluop <= controls(2 downto 0);
end;