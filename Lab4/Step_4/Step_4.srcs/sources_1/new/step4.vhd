
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity seconds_counter is
  generic(scaler : integer := 4; resetval : integer := 4);
    port(
    clk,rst_n,en_i: in std_logic;                           
     seconds_o: out  std_logic_vector(3 downto 0)
    );
end seconds_counter;

architecture arch_seconds_counter of seconds_counter is
signal C_ONE_SECOND_SCALE_FACTOR : integer := scaler;
signal counter: unsigned(27 downto 0):=(others => '0');
signal sec :  unsigned(3 downto 0) := (others => '0');

begin

process(clk,rst_n)
begin
    if(rising_edge(rst_n)) then
           sec <= (others => '0');
           counter <= (others => '0');
           
    elsif(rising_edge(clk)) then
       counter <= counter + 1;
      if(counter >= to_unsigned(C_ONE_SECOND_SCALE_FACTOR, 28)) then  
       counter <=  (others => '0');
            if(sec >= to_unsigned(resetval,4)) then
            sec <= (others => '0');
            else
              sec <= sec + 1;
            end if;
      end if;
    end if;
end process;

 seconds_o <= std_logic_vector(sec);

end arch_seconds_counter;

------------------------- copy paste step 2 -----------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity timer is
    port(
      clk,rst_n,en_i: in std_logic;                           
      bcd_sec_ones_o,bcd_sec_tens_o,
    bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
    );
end timer;

architecture arch_timer of timer is
  component seconds_counter is
  generic(scaler : integer := 4; resetval : integer := 4);
    port(
    clk,rst_n,en_i: in std_logic;                           
     seconds_o: out  std_logic_vector(3 downto 0)
    );
  end component;

begin

  sec_ones : seconds_counter generic map(0,9) port map( clk,rst_n,en_i,bcd_sec_ones_o);
  sec_tens : seconds_counter generic map(9,5) port map( clk,rst_n,en_i,bcd_sec_tens_o);
  min_ones : seconds_counter generic map(59,9) port map( clk,rst_n,en_i,bcd_mins_ones_o);
  min_tens : seconds_counter generic map(599,5) port map( clk,rst_n,en_i,bcd_mins_tens_o);

end architecture;

----------------------------------- copy paste step 3 -------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity wrapper_timer_7seg is
    generic(C_RST_SCALE_FACTOR : integer:= 200);
    port(
       clk : in std_logic;
       seg : out std_logic_vector(6 downto 0);
       an : out std_logic_vector(3 downto 0)
    );
end wrapper_timer_7seg;

architecture arch_wrapper_timer_7seg of wrapper_timer_7seg is

component timer is
    port(
      clk,rst_n,en_i: in std_logic;                           
      bcd_sec_ones_o,bcd_sec_tens_o,bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
    );
end component;

component seg7_ctler is
-- 1000,000 generates 10ms refresh rates with 100Mhz (10 ns ) clock freq
  generic ( G_REFRESH_SCALE_FACTOR : integer:= 1000000); 
  Port ( 
        clk, rst_n : in std_logic;
        switch16_i : in std_logic_vector(15 downto 0);
        common_anode_o : out std_logic_vector(3 downto 0);
        seg7_cathode_o : out std_logic_vector(6 downto 0)
  );
end component;

signal mm_ss_temp : std_logic_vector (15 downto 0) := (others => '0');
signal rst_n : std_logic := '0';
signal s_counter : unsigned(20 downto 0):=(others=>'0'); 

begin
inst_timer : timer port map(clk,rst_n,'1',mm_ss_temp(3 downto 0),mm_ss_temp(7 downto 4),mm_ss_temp(11 downto 8),mm_ss_temp(15 downto 12));    
inst_seg7 : seg7_ctler generic map(2) port map(clk,rst_n,mm_ss_temp,an,seg);

process(clk)
begin
    if (s_counter = to_unsigned(C_RST_SCALE_FACTOR, 21)) then -- counts up to 10 ms, then assers the reset
        s_counter <= (others =>'0'); 
        rst_n <= '1';
    elsif rising_edge (clk) then
        rst_n <= '0';
        s_counter <= s_counter + 1;
    end if;
end process;


end architecture;

------------------------------------------ tb ------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity tb_wrapper_timer_7seg is end;
architecture arch_tb_wrapper_timer_7seg of tb_wrapper_timer_7seg is 

component wrapper_timer_7seg is
    generic(C_RST_SCALE_FACTOR : integer:= 1000000);
    port(
       clk : in std_logic;
       seg : out std_logic_vector(6 downto 0);
       an : out std_logic_vector(3 downto 0)
    );
end component;

signal clk : std_logic := '0';
signal seg : std_logic_vector(6 downto 0);
signal an : std_logic_vector(3 downto 0);

begin
inst_wrapper : wrapper_timer_7seg generic map(200) port map (clk,seg,an);
    
    process
    begin
        clk <= not clk;
        wait for 1ps;
    end process;

end arch_tb_wrapper_timer_7seg;