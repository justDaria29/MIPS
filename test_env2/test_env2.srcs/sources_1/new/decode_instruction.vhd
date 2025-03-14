library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decode_instruction is
Port ( clk: in std_logic;
       reg_write: in std_logic;
	   reg_write2: in std_logic;
	   reg_dst: in std_logic;
	   ext_op: in std_logic;
	   instruction: in std_logic_vector(15 downto 0);
	   wd: in std_logic_vector(15 downto 0);
       rd1: out std_logic_vector(15 downto 0);
	   rd2: out std_logic_vector(15 downto 0);
	   ext_imm : out std_logic_vector(15 downto 0);
	   func : out std_logic_vector(2 downto 0);
	   sa : out std_logic);
end decode_instruction;

architecture Behavioral of decode_instruction is

signal ra1: std_logic_vector(2 downto 0);
signal ra2: std_logic_vector(2 downto 0);
signal wa: std_logic_vector(2 downto 0):="000";
signal imm: std_logic_vector(15 downto 0);

component reg_file is
Port (	clk : in std_logic;
		ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
		wa : in std_logic_vector (2 downto 0);
		wd : in std_logic_vector (15 downto 0);
		regWrite : in std_logic;
		mpgEn: in std_logic;
		rd1 : out std_logic_vector (15 downto 0);
		rd2 : out std_logic_vector (15 downto 0));
end component;

begin

process(reg_dst,instruction)--mux selction(rt/rd)	
begin
	case (reg_dst) is
		when '0' => wa<=instruction(9 downto 7);
		when '1'=>wa<=instruction(6 downto 4);
		when others=>wa<=wa;
	end case;
end process;

process(ext_op,instruction)--sign extend   
begin
	case (ext_op) is
		when '1' => 	
				case (instruction(6)) is
					when '0' => imm <= B"000000000" & instruction(6 downto 0);
					when '1' =>  imm <=	B"111111111" & instruction(6 downto 0);
					when others => imm <= imm;
				end case;
		when others => imm <= B"000000000" & instruction(6 downto 0);
	end case;
end process;

func<=instruction(2 downto 0);
sa<=instruction(3);
ext_imm<=imm;
ra1<=instruction(12 downto 10);--rs
ra2<=instruction(9 downto 7);--rt

label1: reg_file port map (
    clk => clk,
    ra1 => ra1,
    ra2 => ra2,
    wa => wa,
    wd => wd,
    regWrite => reg_write,
    mpgEn => reg_write2,
    rd1 => rd1,
    rd2 => rd2
);

end Behavioral;
