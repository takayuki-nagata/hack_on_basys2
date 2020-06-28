-- Copyright 2020 Takayuki Nagata All Rights Reserved.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity soc is
	Port ( mclk : in STD_LOGIC;
			seg : out STD_LOGIC_VECTOR (6 downto 0);
			an : out STD_LOGIC_VECTOR (3 downto 0);
			Led : out STD_LOGIC_VECTOR (7 downto 0);
			sw : in STD_LOGIC_VECTOR (7 downto 0);
			btn : in STD_LOGIC_VECTOR (3 downto 0));
end soc;

architecture Behavioral of soc is
	component cpu
		Port ( inM : in STD_LOGIC_VECTOR (15 downto 0);
				instruction : in STD_LOGIC_VECTOR (15 downto 0);
				reset : in STD_LOGIC;
				outM : out STD_LOGIC_VECTOR (15 downto 0);
				writeM : out STD_LOGIC;
				addressM : out STD_LOGIC_VECTOR (14 downto 0);
				pc : out STD_LOGIC_VECTOR (14 downto 0);
				clk : in STD_LOGIC);
	end component;
	component main_ram
		Port ( clka : in STD_LOGIC;
				wea : in STD_LOGIC_VECTOR (0 downto 0);
				addra : in STD_LOGIC_VECTOR (11 downto 0);
				dina : in STD_LOGIC_VECTOR (15 downto 0);
				douta : out STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component prog_rom
		Port ( clka : in STD_LOGIC;
				addra : in STD_LOGIC_VECTOR (9 downto 0);
				douta : out STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component sseg_driver
		port ( CLK  :  in std_logic;
				RST  :  in std_logic;
				HEX  :  in std_logic_vector (15 downto 0);
				AN   : out std_logic_vector ( 3 downto 0);
				LED  : out std_logic_vector ( 6 downto 0));
	end component;
	signal inM : STD_LOGIC_VECTOR (15 downto 0);
	signal instruction : STD_LOGIC_VECTOR (15 downto 0);
	signal reset : STD_LOGIC;
	signal outM : STD_LOGIC_VECTOR (15 downto 0);
	signal writeM : STD_LOGIC_VECTOR (0 downto 0);
	signal addressM : STD_LOGIC_VECTOR (14 downto 0);
	signal pc : STD_LOGIC_VECTOR (14 downto 0);
	signal ram_out : STD_LOGIC_VECTOR (15 downto 0);
	signal sseg_data : STD_LOGIC_VECTOR (15 downto 0);
	signal led_data : STD_LOGIC_VECTOR (7 downto 0);
	signal memclk : STD_LOGIC;
begin
	reset <= btn(0);
	memclk <= not mclk;
	soc_prog_rom : prog_rom port map(memclk, pc(9 downto 0), instruction);
	soc_cpu : cpu port map(inM, instruction, reset, outM, writeM(0), addressM, pc, mclk);
	soc_main_ram : main_ram port map(memclk, writeM, addressM(11 downto 0), outM, ram_out);
	-- Output
	process(mclk, reset, writeM, addressM) begin
		if mclk'event and mclk = '1' then
			if (reset = '1') then
				sseg_data <= "0000000000000000";
				led_data <= "00000000";
			elsif writeM(0) = '1' then
				if addressM = "100000000000000" then -- 0x4000 SSEG out
					sseg_data <= outM;
				elsif addressM = "100000000000001" then -- 0x4001 LED out
					led_data <= outM(7 downto 0);
				end if;
			end if;
		end if;
	end process;
	soc_sseg_driver : sseg_driver port map(mclk, reset, sseg_data, an, seg);
	LED <= led_data;
	-- Input
	process(addressM, sw, btn(3 downto 1), ram_out) begin
		if addressM = "110000000000000" then -- 0x6000 SW in
			inM(7 downto 0) <= sw;
			inM(15 downto 8) <= "00000000";
		elsif addressM = "110000000000001" then -- 0x6001 BTN in
			inM(2 downto 0) <= btn(3 downto 1);
			inM(15 downto 3) <= "0000000000000";
		else
			inM <= ram_out;
		end if;
	end process;
end Behavioral;