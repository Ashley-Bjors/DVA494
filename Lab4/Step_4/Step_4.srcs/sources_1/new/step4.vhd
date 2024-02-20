
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity seconds_counter is
  generic(scaler : integer := 4; resetval : integer := 9);
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
    if(rst_n = '0') then -- reset if reset is activ low
           sec <= (others => '0'); 
           counter <= (others => '0');
           
    elsif(rising_edge(clk)) then -- in clk is activ high
       counter <= counter + 1; -- increment counter
      if(counter >= to_unsigned(C_ONE_SECOND_SCALE_FACTOR, 28)) then  -- if we have ticked for 1 sec
       counter <=  (others => '0'); -- reset counter
            if(sec >= to_unsigned(resetval,28)) then -- increment sec
            sec <= (others => '0');
            else
              sec <= sec + 1; -- sec is below max value
            end if;
      end if;
    end if;
end process;

 seconds_o <= std_logic_vector(sec);

end arch_seconds_counter;

------------------------- copy paste step 2 -----------------------------

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2022 10:40:58 PM
-- Author: Farnam Maybodi 
----------------------------------------------------------------------------------

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity clock_divider is
    generic (G_DIVISION : integer:= 249999);
    port(
     clk: in std_logic;                           
     clk_slow: out std_logic
    );
end clock_divider;

architecture Behavioral of clock_divider is

signal counter: unsigned(27 downto 0):=(others => '0');

begin

process(clk)
begin
    if(rising_edge(clk)) then
       counter <= counter + 1;
      if(counter>= to_unsigned(G_DIVISION, 28)) then  
       counter <=  (others => '0');
      end if;
    end if;
end process;

 clk_slow <= '1' when (counter = to_unsigned(G_DIVISION, 28)) else '0';

end Behavioral;

--------------------- clk divider -------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity timer is
    generic(sec_delay : integer := 1000000); -- amount of tick/sec
    port(
      clk,rst_n,en_i: in std_logic;                           
      bcd_sec_ones_o,bcd_sec_tens_o,
    bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
    );
end timer;

architecture arch_timer of timer is
  component seconds_counter is
  -- scaler = amount of tick inbetween each increment, resetvalue = each value to reset after
  generic(scaler : integer := 4; resetval : integer := 4); 
    port(
    clk,rst_n,en_i: in std_logic;                           
     seconds_o: out  std_logic_vector(3 downto 0)
    );
  end component;
  
  component clock_divider is
    generic (G_DIVISION : integer:= 249999);
    port(
     clk: in std_logic;                           
     clk_slow: out std_logic
    );
end component;

-- clk signals for each signal exept sec
signal clk_sec_tens,clk_min_ones,clk_min_tens : std_logic := '0';

begin
 sec_tens_divider : clock_divider generic map(9) port map(clk,clk_sec_tens); -- 9th tick inbetween each tick (9sec / tenth sec)
 min_ones_divider : clock_divider generic map(59) port map(clk,clk_min_ones); -- 59th tick inbetween each tick (59sec / min)
 min_tens_divider : clock_divider generic map(599) port map(clk,clk_min_tens); -- 599th tick inbetween each tick (599 sec/ tent min)
 
  sec_ones : seconds_counter generic map(sec_delay,9) port map( clk,rst_n,en_i,bcd_sec_ones_o);
  sec_tens : seconds_counter generic map(sec_delay,5) port map( clk_sec_tens,rst_n,en_i,bcd_sec_tens_o);
  min_ones : seconds_counter generic map(sec_delay,9) port map( clk_min_ones,rst_n,en_i,bcd_mins_ones_o);
  min_tens : seconds_counter generic map(sec_delay,5) port map( clk_min_tens,rst_n,en_i,bcd_mins_tens_o);

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

-- step 3
component timer is
    generic(sec_delay : integer := 1000000); -- amount of tick/sec
    port(
      clk,rst_n,en_i: in std_logic;                           
      bcd_sec_ones_o,bcd_sec_tens_o,
    bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
    );
end component;

-- copy past from zip file
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

signal mm_ss_temp : std_logic_vector (15 downto 0) := (others => '0'); -- 4st 4 bit to 1 16 bit
signal rst_n : std_logic := '1'; -- reset value
signal s_counter : unsigned(20 downto 0):=(others=>'0'); -- reset counter

begin
-- generic map(x) = amount of tick inbetween increment, en_i always 1 => '1' 
inst_timer : timer generic map(20) port map(clk,rst_n,'1',mm_ss_temp(3 downto 0),mm_ss_temp(7 downto 4),mm_ss_temp(11 downto 8),mm_ss_temp(15 downto 12));  
-- generic map(x) = amount of tick inbetween increment
inst_seg7 : seg7_ctler generic map(2) port map(clk,rst_n,mm_ss_temp,an,seg);

-- reset generator
process(clk)
begin
    if (s_counter = to_unsigned(C_RST_SCALE_FACTOR, 21)) then -- counts up to 10 ms, then assers the reset
        s_counter <= (others =>'0'); 
        rst_n <= '0'; -- active low
    elsif rising_edge (clk) then -- increment
        rst_n <= '1'; -- active low
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
inst_wrapper : wrapper_timer_7seg generic map(5000) port map (clk,seg,an); -- reset after 5k ticks
    

  clk <= not clk after 1ps;

end arch_tb_wrapper_timer_7seg;