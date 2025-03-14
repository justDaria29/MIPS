library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
Port (
    instruction : in std_logic_vector(2 downto 0);
    reg_dst : out std_logic;
    ext_op : out std_logic;
    alu_src : out std_logic;
    branch : out std_logic;
    jump : out std_logic;
    alu_op : out std_logic_vector(2 downto 0);
    mem_write : out std_logic;
    mem_to_reg : out std_logic;
    reg_write : out std_logic
 );
end control_unit;

architecture Behavioral of control_unit is

begin

process(instruction)
begin
    case instruction is
        when "000" => reg_dst <= '1';         --R type instructions
                      ext_op<='0';--x
                      alu_src<='0';
                      branch<='0';
                      alu_op<="000";
                      mem_write<='0';
                      mem_to_reg<='0';
                      reg_write <= '1';
                      jump <= '0';
        when "001" => reg_dst <= '0';        --ADDI
                      ext_op<='1';
                      alu_src<='1';
                      branch<='0';
                      alu_op<="001";
                      mem_write<='0';
                      mem_to_reg<='0';
                      reg_write <= '1';
                      jump <= '0';
        when "010" => reg_dst <= '0';        --LW
        --101
                      ext_op<='1';
                      alu_src<='1';
                      branch<='0';
                      alu_op<="001";--101
                      mem_write<='0';
                      mem_to_reg<='1';
                      reg_write <= '1';
                      jump <= '0';
        when "011" => reg_dst <= 'X';       --SW
        --100         
                      ext_op<='1';
                      alu_src<='1';
                      branch<='0';
                      alu_op<="001";--100
                      mem_write<='1';
                      mem_to_reg<='X';
                      reg_write <= '0';
                      jump <= '0';
        when "100" => reg_dst <= 'X';        --BEQ
        --110
                      ext_op<='1';
                      alu_src<='0';
                      branch<='1';
                      alu_op<="010";--110
                      mem_write<='0';
                      mem_to_reg<='X';
                      reg_write <= '0';
                      jump <= '0';
        when "101" => reg_dst <= '0';        --ANDI
                      ext_op<='1';
                      alu_src<='1';
                      branch<='0';
                      jump <= '0';
                      alu_op<="101";
                      mem_write<='0';
                      mem_to_reg<='0';
                      reg_write <= '1';
        when "110" => reg_dst <= '0';        --ORI
                      ext_op<='1';
                      alu_src<='1';
                      branch<='0';
                      alu_op<="110";
                      mem_write<='0';
                      mem_to_reg<='0';
                      reg_write <= '1';
                      jump <= '0';
        when "111" => jump <='1';            --JUMP
                      reg_dst <= 'X';  
                      ext_op<='1';--x
                      alu_src<='X';
                      branch<='0';
                      alu_op<="111";--xxx
                      mem_write<='0';
                      mem_to_reg<='X';
                      reg_write <= '0';
        when others => branch <= '0';
                       reg_dst <= 'X'; --0       
                       ext_op<='X';--0
                       alu_src<='X';--0
                       jump<='0';
                       alu_op<="000";
                       mem_write<='0';
                       mem_to_reg<='0';
                       reg_write <= '0';
    end case;
end process;

end Behavioral;
