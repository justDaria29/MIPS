library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM is
Port(clk: in std_logic;
     en: in std_logic;
     mem_write: in std_logic;
	 alu_res : in std_logic_vector(15 downto 0);
	 wd: in std_logic_vector(15 downto 0);		
	 mem_data:out std_logic_vector(15 downto 0);
	 alu_res2 :out std_logic_vector(15 downto 0)
	);
end RAM;

architecture Behavioral of RAM is

signal add: std_logic_vector(3 downto 0);

type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM:ram_type:=(
		X"000A",
		X"000B",
		X"000C",
		X"000D",
		X"000E",
		X"000F",
		X"0009",
		X"0008",
		others =>X"0000");

begin

add<=alu_res(3 downto 0);

process(clk) 			
begin
	if(rising_edge(clk)) then
		if en='1' then
			if mem_write='1' then
				RAM(conv_integer(add))<=wd;			
			end if;
		end if;	
	end if;
	mem_data<=RAM(conv_integer(add));
end process;

alu_res2<=alu_res;

end Behavioral;
