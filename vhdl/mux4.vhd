library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mux4 is
   generic (width: integer := 32);
	port(d0, d1,
		 d2, d3:in  STD_LOGIC_VECTOR(width-1 downto 0);
		 s:     in  STD_LOGIC_VECTOR(1 downto 0);
		 y:     out STD_LOGIC_VECTOR(width-1 downto 0));
end;

--Un mux4 formé de 2 mux2, tel que vu dans les notes de cours

architecture struct of mux4 is
	component mux2 generic (width: integer := width);
		port(	d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
				s: in STD_LOGIC;
                y: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	signal low, high: STD_LOGIC_VECTOR(width-1 downto 0);
begin
	lowmux:   mux2 port map(d0, d1, s(0), low);
	highmux:  mux2 port map(d2, d3, s(0), high);
	finalmux: mux2 port map(low, high, s(1), y);
end;