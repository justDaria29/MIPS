library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity reg_file is
Port (	clk : in std_logic;
		ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
		wa : in std_logic_vector (2 downto 0);
		wd : in std_logic_vector (15 downto 0);
		regWrite : in std_logic;
		mpgEn: in std_logic;
		rd1 : out std_logic_vector (15 downto 0);
		rd2 : out std_logic_vector (15 downto 0));
end reg_file;

architecture Behavioral of reg_file is

type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array:=(
		X"0000",
		X"0001",
		X"0002",
		X"0003",
		X"0004",
		X"0005",
		X"0006",
		X"0007",
		others => X"0000");
begin

rd1 <= reg_file(conv_integer(ra1));	
rd2 <= reg_file(conv_integer(ra2));	

process(clk,mpgEn)			
begin
	if mpgEn='1' then
		if rising_edge(clk) and regWrite='1' then
			reg_file(conv_integer(wa))<=wd;		
		end if;
	end if;
end process;		

end Behavioral;
