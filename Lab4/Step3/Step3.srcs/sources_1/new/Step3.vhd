
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

----------------------------------- tb -------------------------

library ieee;
use ieee.std_logic_1164.all;
entity tb_timer is end;
architecture arch_tb_timer of tb_timer is 

component timer is
  port(
    clk,rst_n,en_i: in std_logic;                           
    bcd_sec_ones_o,bcd_sec_tens_o,
  bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
  );
end component;

signal clk,rst_n,en_i: std_logic := '0';
signal bcd_sec_ones_o,bcd_sec_tens_o,bcd_mins_ones_o,bcd_mins_tens_o: std_logic_vector (3 downto 0);

begin 
 inst_0 : timer port map(clk,rst_n,en_i,bcd_sec_ones_o,bcd_sec_tens_o,bcd_mins_ones_o,bcd_mins_tens_o);

 
  process is
 begin
 clk <= not clk;
 wait for 1ps;
 end process;
 
 process is
 begin
  en_i <= '1';
 wait for 2000ps;
 
 rst_n <= '1';
 wait for 2ps; 

 en_i <= '0';
 wait for 2ps;

 rst_n <= '0';
 wait for 2ps;
 
 end process;
 
 
end architecture;