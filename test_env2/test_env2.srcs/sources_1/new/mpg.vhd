library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
Port ( btn: in std_logic;
	   clk: in std_logic;
	   en: out std_logic);
end mpg;

architecture Behavioral of mpg is

signal reg1: std_logic;
signal reg2: std_logic;
signal reg3: std_logic;
signal regEn: std_logic;
signal count: std_logic_vector(15 downto 0):= x"0000";

begin

process(clk)
begin
	if rising_edge(clk) then
		count<=count+1;
	end if;
end process;

regEn <= '1' when count(15 downto 0)=x"FFFF" else '0';

process(clk)
begin
	if rising_edge(clk) and regEn='1' then
		reg1<=btn;
	end if;
end process;

process(clk)
begin
	if rising_edge(clk) then
		reg2<=reg1;
		reg3<=reg2;
	end if;
end process;

en<= reg2 and not(reg3);

end Behavioral;
