library IEEE; use IEEE.STD_LOGIC_1164.all;

entity proc_mips is -- single cycle MIPS processor
	port (clk, reset: in STD_LOGIC;
			pc: out STD_LOGIC_VECTOR (31 downto 0);
			instr: in STD_LOGIC_VECTOR (31 downto 0);
			memwrite: out STD_LOGIC;
			aluout, writedata: out STD_LOGIC_VECTOR (31 downto 0);
			readdata: in STD_LOGIC_VECTOR (31 downto 0));
end;

architecture struct of proc_mips is
	component controller
		port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
				zero: in STD_LOGIC;
				memtoreg, memwrite: out STD_LOGIC;
				pcsrc: out STD_LOGIC;
				alusrc: out STD_LOGIC_VECTOR(1 downto 0);
				regdst: out STD_LOGIC_VECTOR (1 downto 0);
				regwrite: out STD_LOGIC;
				jump, jumpReg, dataSrc: out STD_LOGIC;
				bnal: out STD_LOGIC;
				alucontrol: out STD_LOGIC_VECTOR (5 downto 0);
				writeSignal: out STD_LOGIC);
	end component;
	component datapath
		port (clk, reset: in STD_LOGIC;
				memtoreg, pcsrc: in STD_LOGIC;
				alusrc: in STD_LOGIC_VECTOR(1 downto 0);
				regdst: in STD_LOGIC_VECTOR (1 downto 0);
				writeSignal, jump, jumpReg, dataSrc: in STD_LOGIC;
				bnal: out STD_LOGIC;
				alucontrol: in STD_LOGIC_VECTOR (5 downto 0);
				zero: out STD_LOGIC;
				pc: buffer STD_LOGIC_VECTOR (31 downto 0);
				instr: in STD_LOGIC_VECTOR (31 downto 0);
				aluout, writedata: buffer STD_LOGIC_VECTOR (31 downto 0);
				readdata: in STD_LOGIC_VECTOR (31 downto 0));
	end component;
	signal memtoreg: STD_LOGIC;
	signal alusrc: STD_LOGIC_VECTOR(1 downto 0);
	signal regdst: STD_LOGIC_VECTOR (1 downto 0);
	signal regwrite, writeSignal, jump, jumpReg, dataSrc, pcsrc: STD_LOGIC; 
	signal zero: STD_LOGIC;
	signal alucontrol: STD_LOGIC_VECTOR (5 downto 0);
	signal bnal: STD_LOGIC;
begin
	cont: controller port map (instr (31 downto 26), instr(5 downto 0), zero, memtoreg, 
										memwrite, pcsrc, alusrc, regdst, regwrite, jump, jumpReg, dataSrc, bnal, alucontrol);
	dp: datapath port map (	clk, reset, memtoreg, pcsrc, alusrc,regdst, writeSignal, jump, jumpReg, dataSrc, bnal,
									alucontrol, zero, pc, instr, aluout, writedata, readdata);
end;