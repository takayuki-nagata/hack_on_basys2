library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sseg_decoder is
	Port (
		HEX :  in std_logic_vector (3 downto 0);
		LED : out std_logic_vector (6 downto 0)
	);
end sseg_decoder;

architecture Behavioral of sseg_decoder is
begin
	process(HEX) begin
		case HEX is
			when "0000" => LED <= "0000001"; -- 0
			when "0001" => LED <= "1001111"; -- 1
			when "0010" => LED <= "0010010"; -- 2
			when "0011" => LED <= "0000110"; -- 3
			when "0100" => LED <= "1001100"; -- 4
			when "0101" => LED <= "0100100"; -- 5
			when "0110" => LED <= "0100000"; -- 6
			when "0111" => LED <= "0001111"; -- 7
			when "1000" => LED <= "0000000"; -- 8
			when "1001" => LED <= "0000100"; -- 9
			when "1010" => LED <= "0001000"; -- A
			when "1011" => LED <= "1100000"; -- b
			when "1100" => LED <= "0110001"; -- C
			when "1101" => LED <= "1000010"; -- d
			when "1110" => LED <= "0110000"; -- E
			when "1111" => LED <= "0111000"; -- F
			when others => LED <= "XXXXXXX";
		end case;
	end process;
end Behavioral;