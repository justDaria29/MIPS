library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity execution_unit is
Port(
	pc:in std_logic_vector(15 downto 0);
	rd1: in std_logic_vector(15 downto 0);
	rd2: in std_logic_vector(15 downto 0);
	ext_imm: in std_logic_vector(15 downto 0);
	func: in std_logic_vector(2 downto 0);
	sa: in std_logic;
	alu_src: in std_logic;
	alu_op: in std_logic_vector(2 downto 0);
	branch_addr: out std_logic_vector(15 downto 0);
	alu_res: out std_logic_vector(15 downto 0);
	zero: out std_logic);
end execution_unit;

architecture Behavioral of execution_unit is

begin


end Behavioral;
