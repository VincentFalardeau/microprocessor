library IEEE; use IEEE.STD_LOGIC_1164.all; use
IEEE.STD_LOGIC_ARITH.all;

entity datapath is -- MIPS datapath
	port(	clk, reset: in STD_LOGIC;
            memtoreg, pcsrc: in STD_LOGIC;
            alusrc: in STD_LOGIC_VECTOR (1 downto 0);
			regdst: in STD_LOGIC_VECTOR (1 downto 0);
			writeSignal, jump, jumpReg, dataSrc, bnal: in STD_LOGIC;
			alucontrol: in STD_LOGIC_VECTOR (5 downto 0);
            zero, overflow: out STD_LOGIC;
            nal: out STD_LOGIC;
			pc: buffer STD_LOGIC_VECTOR (31 downto 0);
			instr: in STD_LOGIC_VECTOR(31 downto 0);
			aluout, writedata: buffer STD_LOGIC_VECTOR (31 downto 0);
			readdata: in STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of datapath is
	component alu
		port(	a, b: in STD_LOGIC_VECTOR(31 downto 0);
				f: in STD_LOGIC_VECTOR (5 downto 0);
				z, o : out STD_LOGIC;
				y: buffer STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component regfile
		port(	clk: in STD_LOGIC;
				we3: in STD_LOGIC;
				ra1, ra2, wa3: in STD_LOGIC_VECTOR (4 downto 0);
				wd3: in STD_LOGIC_VECTOR (31 downto 0);
				rd1, rd2: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component adder
		port(	a, b: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component sl2
		port(	a: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component signext
		port(	a: in STD_LOGIC_VECTOR (15 downto 0);
                y: out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component zeroext
                port(	a: in STD_LOGIC_VECTOR (15 downto 0);
                        y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component flopr generic (width: integer);
		port(	clk, reset: in STD_LOGIC;
				d: in STD_LOGIC_VECTOR (width-1 downto 0);
				q: out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;
	component mux2 generic (width: integer);
		port(	d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
				s: in STD_LOGIC;
                y: out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;
	 component mux2simple
		port(	d0, d1: in STD_LOGIC;
				s: in STD_LOGIC;
                y: out STD_LOGIC);
    end component;
    component mux4 generic (width: integer);
        port(	d0, d1, d2, d3: in STD_LOGIC_VECTOR (width-1 downto 0);
                s: in  STD_LOGIC_VECTOR(1 downto 0);
                y: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	signal writereg: STD_LOGIC_VECTOR (4 downto 0);
	signal pcjump, pcnext, pcnextbr, pcnextjr, pcplus4, pcbranch: STD_LOGIC_VECTOR (31 downto 0);
    signal signimm, signimmsh: STD_LOGIC_VECTOR (31 downto 0);
    signal zeroimm: STD_LOGIC_VECTOR (31 downto 0);
	signal srca, srcb, result: STD_LOGIC_VECTOR (31 downto 0);
	signal zerob: STD_LOGIC_VECTOR (31 downto 0);
	signal foo: STD_LOGIC_VECTOR(4 downto 0);
	signal dataReg: STD_LOGIC_VECTOR (31 downto 0);
	
begin
-- next PC logic
   zerob <= X"00000000";
	pcjump <= pcplus4 (31 downto 28) & instr (25 downto 0) & "00";
	pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);
	pcadd1: adder port map(pc, X"00000004", pcplus4);
	immsh: sl2 port map(signimm, signimmsh);
   pcadd2: adder port map(pcplus4, signimmsh, pcbranch);
   pcjrmux: mux2 generic map(32) port map(pcplus4, result, jumpReg, pcnextjr);
   pcbrmux: mux2 generic map(32) port map(pcnextjr, pcbranch, pcsrc, pcnextbr);
	pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext);
	
-- register file logic
	rf: regfile port map(clk, writeSignal, instr(25 downto 21),instr(20 downto 16), writereg, dataReg, srca, writedata);
	wrmux: mux4 generic map(5) port map(instr(20 downto 16),instr(15 downto 11),foo,"11111", regdst, writereg);
	wrdatamux: mux2 generic map(32) port map(result, pcPlus4, dataSrc, dataReg);
	resmux: mux2 generic map(32) port map(aluout, readdata, memtoreg, result);
   se: signext port map(instr(15 downto 0), signimm);
   ze: zeroext port map(instr(15 downto 0), zeroimm);
-- ALU logic
	srcbmux: mux4 generic map(32) port map(writedata, signimm, zeroimm, zerob, alusrc, srcb);
	mainalu: alu port map(srca, srcb, alucontrol, zero, overflow, aluout);
end;