library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sseg_an_selector is
	Port (
		CLK  :  in std_logic; -- 50MHz
		RST  :  in std_logic;
		DIG0 :  in std_logic_vector (3 downto 0);
		DIG1 :  in std_logic_vector (3 downto 0);
		DIG2 :  in std_logic_vector (3 downto 0);
		DIG3 :  in std_logic_vector (3 downto 0);
		AN   : out std_logic_vector (3 downto 0);
		DIG  : out std_logic_vector (3 downto 0)
	);
end sseg_an_selector;

architecture Behavioral of sseg_an_selector is
	signal CLKCNT : std_logic_vector (31 downto 0);
	signal    DIV : std_logic_vector ( 1 downto 0);
	signal    SEL : std_logic_vector ( 1 downto 0);
begin
	process(CLK, RST)
	begin
		if(RST = '1') then
			CLKCNT <= "00000000000000000000000000000000";
			DIV <= "00";
		elsif(CLK'event and CLK = '1') then
			if(CLKCNT = 50000) then -- 1kHz=1ms
				CLKCNT <= "00000000000000000000000000000000";
				DIV <= DIV + 1;
			else
				CLKCNT <= CLKCNT + '1';
			end if;
		end if;
	end process;
	
	SEL <= DIV;
	
	process(SEL, DIG0, DIG1, DIG2, DIG3)
	begin	
		case SEL is
			when "00" => AN <= "1110"; DIG <= DIG0;
			when "01" => AN <= "1101"; DIG <= DIG1;
			when "10" => AN <= "1011"; DIG <= DIG2;
			when "11" => AN <= "0111"; DIG <= DIG3;
			when others => AN <= "1111"; DIG <= "XXXX";
		end case;
	end process;
end Behavioral;