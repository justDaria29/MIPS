library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_execute is
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
end instruction_execute;

architecture Behavioral of instruction_execute is

signal aux: std_logic;
signal control: std_logic_vector(3 downto 0);
signal alu_in2:std_logic_vector(15 downto 0);
signal alu_aux:std_logic_vector(15 downto 0);

begin

branch_addr <= pc + ext_imm;

with alu_src select
    alu_in2 <= rd2 when '0',
               ext_imm when others;

process(alu_op, func)
begin
    case alu_op is
        when "000"=>
            case func is
                when "000"=> control <= "0000";    
                when "001"=> control <= "0001";   
                when "010"=> control <= "0010";  
                when "011"=> control <= "0011";
                when "100"=> control <= "0100";   
                when "101"=> control <= "0101";   
                when "110"=> control <= "0110";    
                when "111"=> control <= "0111";    
                when others=> control <= "0000";   
            end case;
        when "001"=> control <= "0000";    
        when "010"=> control <= "0001";    
        when "101"=> control <= "0100";    
        when "110"=> control <= "0101";    
        when "111"=> control <= "1000";    
        when others=> control <= "0000";   
    end case;
end process;

process(control, rd1, alu_in2, sa)
begin
    case control is
        when "0000" => alu_aux <= rd1 + alu_in2;   
        when "0001" => alu_aux <= rd1 - alu_in2;   
        when "0010" =>                
            case sa is
                when '1' => alu_aux <= rd1(14 downto 0) & "0";
                when others => alu_aux <= rd1;   
            end case;
        when "0011" =>                
            case sa is
                when '1' => alu_aux <= "0" & rd1(15 downto 1);
                when others => alu_aux <= rd1;
            end case;
        when "0100" => alu_aux <= rd1 and alu_in2;       
        when "0101" => alu_aux <= rd1 or alu_in2;        
        when "0110" => alu_aux <= rd1 xor alu_in2;     
        when "0111" =>  
            if rd1 < alu_in2 then
                alu_aux <= X"0001";
            else
                alu_aux <= X"0000";
            end if;
        when "1000" => alu_aux <= X"0000";     
        when others => alu_aux <= X"0000";     
    end case;

    case alu_aux is                   
        when X"0000" => aux <= '1';
        when others => aux <= '0';
    end case;

end process;
end Behavioral;
