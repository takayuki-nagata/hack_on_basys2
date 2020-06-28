library IEEE;
use ieee.std_logic_1164.all;

entity sseg_driver is
	port (
		CLK  :  in std_logic;
		RST  :  in std_logic;
		HEX  :  in std_logic_vector (15 downto 0);
		AN   : out std_logic_vector ( 3 downto 0);
		LED  : out std_logic_vector ( 6 downto 0)
	);
end sseg_driver;

architecture Behavioral of sseg_driver is
	component sseg_an_selector
		Port (
			CLK  :  in std_logic;
			RST  :  in std_logic;
			DIG0 :  in std_logic_vector (3 downto 0);
			DIG1 :  in std_logic_vector (3 downto 0);
			DIG2 :  in std_logic_vector (3 downto 0);
			DIG3 :  in std_logic_vector (3 downto 0);
			AN   : out std_logic_vector (3 downto 0);
			DIG  : out std_logic_vector (3 downto 0)
		);
	end component;
	component sseg_decoder
		Port (
			HEX :  in std_logic_vector (3 downto 0);
			LED : out std_logic_vector (6 downto 0)
		);
	end component;
	signal DIG  : std_logic_vector (3 downto 0);
begin
	an_selector: sseg_an_selector port map(
		CLK  => CLK,
		RST  => RST,
		DIG0 => HEX(3 downto 0),
		DIG1 => HEX(7 downto 4),
		DIG2 => HEX(11 downto 8),
		DIG3 => HEX(15 downto 12),
		AN   => AN,
		DIG  => DIG
	);
	decoder: sseg_decoder port map(
		HEX => DIG,
		LED => LED
	);
end Behavioral;

