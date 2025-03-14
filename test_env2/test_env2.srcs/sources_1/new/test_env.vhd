library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
Port ( clk : in  STD_LOGIC;
       btn : in  STD_LOGIC_VECTOR (3 downto 0);
       sw : in  STD_LOGIC_VECTOR (7 downto 0);
       led : out  STD_LOGIC_VECTOR (7 downto 0);
       an : out  STD_LOGIC_VECTOR (3 downto 0);
       cat : out  STD_LOGIC_VECTOR (6 downto 0);
       dp : out  STD_LOGIC);
end test_env;

architecture Behavioral of test_env is

signal reg_dst: std_logic;
signal ext_op: std_logic;
signal alu_src: std_logic;
signal branch: std_logic;
signal jump: std_logic;
signal alu_op: std_logic_vector(2 downto 0);
signal mem_write: std_logic;
signal mem_to_reg: std_logic;
signal reg_write: std_logic;
signal en: STD_LOGIC;   
signal reset: STD_LOGIC;	  
signal branch_addr:std_logic_vector(15 downto 0);  	   
signal jump_addr:std_logic_vector(15 downto 0); 		  
signal ssd : std_logic_vector(15 downto 0):=X"0000";  
signal instruction: std_logic_vector(15 downto 0);			    
signal pc: std_logic_vector(15 downto 0);				  	 
signal alu_res: std_logic_vector(15 downto 0);			  
signal zero: std_logic;										
signal rd1: std_logic_vector(15 downto 0);					
signal rd2: std_logic_vector(15 downto 0);					
signal ext_imm : std_logic_vector(15 downto 0);				
signal func :std_logic_vector(2 downto 0);					
signal sa : std_logic;												
signal mem_data: std_logic_vector(15 downto 0);				
signal alu_res2: std_logic_vector(15 downto 0);			
signal wd_reg: std_logic_vector(15 downto 0);		
signal pc_src:std_logic;	
					 
component decode_instruction is
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
end component;


component RAM is
Port(clk: in std_logic;
     en: in std_logic;
     mem_write: in std_logic;
	 alu_res : in std_logic_vector(15 downto 0);
	 wd: in std_logic_vector(15 downto 0);		
	 mem_data:out std_logic_vector(15 downto 0);
	 alu_res2 :out std_logic_vector(15 downto 0)
	);
end component;

component SSD2 is
port(clk:in std_logic ;
     digits: in std_logic_vector(15 downto 0);
	 an: out std_logic_vector(3 downto 0);
	 cat: out std_logic_vector(6 downto 0));
end component;

component control_unit is
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
end component;

component fetch_instruction is
Port (we : in std_logic;
	  reset : in std_logic;
      clk: in std_logic;
	  jump : in std_logic;
	  pc_src : in std_logic;
	  branch_addr : in std_logic_vector(15 downto 0);
	  jump_addr : in std_logic_vector(15 downto 0);
	  instruction : out std_logic_vector(15 downto 0);
	  pc : out std_logic_vector(15 downto 0):=X"0000");
end component;

component instruction_execute is
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
end component;

component mpg is
Port ( btn: in std_logic;
	   clk: in std_logic;
	   en: out std_logic);
end component;

begin

dp <= '0';

id : decode_instruction port map (
    clk => clk,
    instruction => instruction,
    wd => wd_reg,
    reg_write => reg_write,
    reg_write2 => reg_write,
    reg_dst => reg_dst,
    ext_op => ext_op,
    rd1 => rd1,
    rd2 => rd2,
    ext_imm => ext_imm,
    func => func,
    sa => sa
);

mem : RAM port map (
    clk => clk,
    alu_res => alu_res,
    wd => wd_reg,
    mem_write => mem_write,
    en => en,
    mem_data => mem_data,
    alu_res2 => alu_res2
    
);

ssd1 : SSD2 port map (
    clk => clk,
    digits => ssd,
    an => an,
    cat => cat
);

cu : control_unit port map (
    instruction => instruction(15 downto 13),
    reg_dst => reg_dst,
    ext_op => ext_op,
    alu_src => alu_src,
    branch => branch,
    jump => jump,
    alu_op => alu_op,
    mem_write => mem_write,
    mem_to_reg => mem_to_reg,
    reg_write => reg_write
);

fi : fetch_instruction port map (
    we => en,
    reset => reset,
    clk => clk,
    jump => jump,
    pc_src => pc_src,
    branch_addr => branch_addr,
    jump_addr => jump_addr,
    instruction => instruction,
    pc => pc
);

ie : instruction_execute port map (
    pc => pc,
    RD1 => RD1,
    RD2 => RD2,
    Ext_Imm => Ext_Imm,
    Func => Func,
    SA => SA,
    alu_src => alu_src,
    alu_op => alu_op,
    branch_addr => branch_addr,
    alu_res => alu_res,
    zero => zero
);

MPG1 : MPG port map (
    btn => btn(0),
    clk => clk,
    en => en
);

MPG2 : MPG port map (
    btn => btn(1),
    clk => clk,
    en => reset
);

process(mem_to_reg, alu_res2, mem_data)
begin
    case mem_to_reg is
        when '1' =>
            wd_reg <= mem_data;
        when '0' =>
            wd_reg <= alu_res2;
        when others =>
            wd_reg<= wd_reg;
    end case;
end process;

pc_src <= zero and branch;
jump_addr <= pc(15 downto 14) & instruction(13 downto 0);

process(instruction,pc,rd1,rd2,ext_imm,alu_res,mem_data,wd_reg)
begin
    case sw(7 downto 5) is
        when "000"=>
            ssd <= instruction;
        when "001"=>
            ssd <= pc;
        when "010"=>
            ssd <= rd1;
        when "011"=>
            ssd <= rd2;
        when "100"=>
            ssd <= ext_imm;
        when "101" =>
            ssd <= alu_res;
        when "110"=>
            ssd <= mem_data;
        when "111"=>
            ssd <= wd_reg;
        when others =>
            ssd <= X"AAAA";
    end case;
end process;

process(reg_dst, ext_op, alu_src, branch, jump, mem_write, mem_to_reg, alu_op)
begin
    if sw(0) = '0' then
        led(7) <= reg_dst;
        led(6) <= ext_op;
        led(5) <= alu_src;
        led(4) <= branch;
        led(3) <= jump;
        led(2) <= mem_write;
        led(1) <= mem_to_reg;
        led(0) <= reg_write;
    else
        led(2 downto 0) <= alu_op(2 downto 0);
        led(7 downto 3) <= "00000";
    end if;
end process;

end Behavioral;
