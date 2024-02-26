library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wrapper_push_led is
  Port (clk : inout std_logic;
        switch16_i : in std_logic_vector(15 downto 0);
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
  );
end wrapper_push_led;

architecture Behavioral of wrapper_push_led is

 constant C_RST_SCALE_FACTOR : integer :=1000000; -- this value results to 10ms with 10ns period of clk signal

 signal rst_n : std_logic;
 signal s_led : std_logic_vector(15 downto 0); 
 signal s_counter : unsigned(20 downto 0):=(others => '0');


component seconds_counter is
  generic(scaler : integer := 100e6; resetval : integer := 9);
    port(
     clk           : inout std_logic;
     rst_n,en_i: in std_logic;                           
     seconds_o: out  std_logic_vector(3 downto 0)
    );
end component;

component seg7_ctler  is
-- 1000,000 generates 10ms refresh rates with 100Mhz (10 ns ) clock freq
  generic ( G_REFRESH_SCALE_FACTOR : integer:= 1000000); 
  Port ( 
        clk : inout std_logic :='1';
        rst_n : in std_logic :='0';
        switch16_i : in std_logic_vector(15 downto 0);
        common_anode_o : out std_logic_vector(3 downto 0);
        seg7_cathode_o : out std_logic_vector(6 downto 0)
  );
end component;

begin
process
begin
     clk<= not clk;
     wait for 1ps;
end process;
-- reset generator 
process(clk)
    begin
    if (s_counter >= to_unsigned(C_RST_SCALE_FACTOR, 21)) then -- counts up to 10 ms, then assers the reset
        rst_n <= '1';
    else 
        rst_n <= '0';
        s_counter <= s_counter + 1;
    end if;  
end process;

sec_1: seconds_counter 
generic map(100000000,9)
    Port map( 
        clk => clk,
        rst_n => rst_n,
        en_i => '1',
        seconds_o => s_led(3 downto 0)
    );
inst_seg7 : seg7_ctler generic map(10000) port map(clk,'1',s_led,an,seg);

--led(15 downto 1) <= (others=> '0');

end Behavioral;
