-- Copyright 2020 Takayuki Nagata All Rights Reserved.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY soc_test IS
END soc_test;
 
ARCHITECTURE behavior OF soc_test IS  
	COMPONENT soc
	Port ( mclk : in STD_LOGIC;
			seg : out STD_LOGIC_VECTOR (6 downto 0);
			an : out STD_LOGIC_VECTOR (3 downto 0);
			Led : out STD_LOGIC_VECTOR (7 downto 0);
			sw : in STD_LOGIC_VECTOR (7 downto 0);
			btn : in STD_LOGIC_VECTOR (3 downto 0));
	END COMPONENT;
	constant clk_period : time := 10ns;
	signal mclk : STD_LOGIC;
	signal seg : STD_LOGIC_VECTOR (6 downto 0);
	signal an : STD_LOGIC_VECTOR (3 downto 0);
	signal Led : STD_LOGIC_VECTOR (7 downto 0);
	signal sw : STD_LOGIC_VECTOR (7 downto 0);
	signal btn : STD_LOGIC_VECTOR (3 downto 0);
BEGIN
	uut: soc PORT MAP (mclk, seg, an, Led, sw, btn);
	clk_process :process
   begin
		mclk <= '0';
		wait for clk_period/2;
		mclk <= '1';
		wait for clk_period/2;
   end process;
	stim_proc: process
	begin
		btn(0) <= '1';
      wait for 30 ns;
		btn(0) <= '0';
		loop
			wait;
		end loop;
	end process;
END;