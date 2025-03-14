library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fetch_instruction is
Port (we : in std_logic;
	  reset : in std_logic;
      clk: in std_logic;
	  jump : in std_logic;
	  pc_src : in std_logic;
	  branch_addr : in std_logic_vector(15 downto 0);
	  jump_addr : in std_logic_vector(15 downto 0);
	  instruction : out std_logic_vector(15 downto 0);
	  pc : out std_logic_vector(15 downto 0):=X"0000");
end fetch_instruction;

architecture Behavioral of fetch_instruction is
        
signal next_addr:std_logic_vector(15 downto 0):=X"0000";
signal counter:std_logic_vector(15 downto 0):=X"0000";
signal sign:std_logic_vector(15 downto 0):=X"0000";
signal aux:std_logic_vector(15 downto 0):=X"0000";

--This program calculates the Fibonacci sequence by initially loading 0 and 1 into 2 registers.
--Memory writing is performed at 2 different addresses and then reading from the same addresses to verify the accuracy.
--The calculation of the sequence elements is done in a loop using the jump instruction.

type rom_type is array(0 to 255) of std_logic_vector(15 downto 0);
signal ROM: rom_type := (
        B"001_000_001_0000000",  --X"2080"	--addi $1,$0,0
		B"001_000_010_0000001",	 --X"2101"	--addi $2,$0,1	
		B"001_000_011_0000000",	 --X"2180"	--addi $3,$0,0	
		B"001_000_100_0000001",	 --X"2201"	--addi $4,$0,1
		B"011_011_001_0000000",  --X"6C80"  --sw $1,0($3)
		B"011_100_010_0000000",  --X"7100"  --sw $2,0($4)
		B"010_011_001_0000000",  --X"4C80"  --lw $1,0($3)
		B"010_100_010_0000000",  --X"5100"  --lw $2,0($4)
		B"000_001_010_101_0_000",--X"0550"  --add $5,$1,$2
		B"000_000_010_001_0_000",--X"0110"  --add $1,$0,$2
		B"000_000_101_010_0_000",--X"02A0"  --add $2,$0,$5
		B"111_0000000001000",    --X"E008"  --j 8
        others => X"0000");

begin

process(pc_src,aux,branch_addr)
begin
	case (pc_src) is 
		when '0' => sign <= aux;
		when '1' => sign<=branch_addr;
		when others => sign<=X"0000";
	end case;
end process;

process(jump,sign,jump_addr)
begin
	case(jump) is
		when '0' => next_addr <= sign;
		when '1' => next_addr <= jump_addr;
		when others => next_addr <= X"0000";
	end case;
end process;

process(clk,reset)
begin
	if reset='1' then
		counter<=X"0000";
	else if rising_edge(clk) and we='1' then
		counter<=next_addr;
		end if;
		end if;
end process;

instruction<=ROM(conv_integer(counter(7 downto 0)));
aux<=counter+'1';
pc<=aux;

end Behavioral;
