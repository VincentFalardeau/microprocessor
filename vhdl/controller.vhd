library IEEE; use IEEE.STD_LOGIC_1164.all;
entity controller is -- single cycle control decoder
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			zero: in STD_LOGIC;
			neg: in STD_LOGIC;
			memtoreg: out STD_LOGIC_VECTOR (1 downto 0);
			memwrite: out STD_LOGIC;
			pcsrc: out STD_LOGIC;
			alusrc: out STD_LOGIC_VECTOR (1 downto 0);
			regdst: out STD_LOGIC_VECTOR (1 downto 0);
			regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR (1 downto 0);
			alucontrol: out STD_LOGIC_VECTOR (5 downto 0));
end;

architecture struct of controller is
	component maindec
		port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
				memtoreg: out STD_LOGIC_VECTOR (1 downto 0);
				memwrite: out STD_LOGIC;
				branch: out STD_LOGIC;
				alusrc: out STD_LOGIC_VECTOR (1 downto 0);
				regdst: out STD_LOGIC_VECTOR (1 downto 0);
				regwrite: out STD_LOGIC;
				jump: out STD_LOGIC_VECTOR (1 downto 0);
				aluop: out STD_LOGIC_VECTOR (2 downto 0);
				bnal: out STD_LOGIC);
	end component;
	component aludec
		port (funct: in STD_LOGIC_VECTOR (5 downto 0);
				aluop: in STD_LOGIC_VECTOR (2 downto 0);
				alucontrol: out STD_LOGIC_VECTOR (5 downto 0));
	end component;
	signal aluop: STD_LOGIC_VECTOR (2 downto 0);
	signal branch, bnal, regwriteSignal: STD_LOGIC;
	signal pcsrc1, pcsrc2: STD_LOGIC;
	component mux2simple
		port(	d0, d1: in STD_LOGIC;
				s: in STD_LOGIC;
				y: out STD_LOGIC);
	end component;
begin
	
	md: maindec port map (op, funct, memtoreg, memwrite, branch, alusrc, regdst, regwriteSignal, jump, aluop);
	ad: aludec port map (funct, aluop, alucontrol);
	rwmux: mux2simple port map(regwriteSignal, neg, bnal, regwrite);
	pcsrc1 <= branch and zero;
	pcsrc2 <= bnal and neg;
	pcsrc <= pcsrc1 or pcsrc2;
end;