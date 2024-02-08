library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
    CLK,reset,en : in std_logic := '0';
    counter_out: out integer 
    );
 end entity;
 
 architecture arh_counter of counter is 
 
 signal adder : integer := 0;
 
begin

-- up counter
 process(CLK) is
  begin
  if (CLK'event and (CLK = '0')) then
     if(reset='1') then
         adder <= 0;
     elsif(en = '1') then
         adder <= adder + 1;
     end if;
    end if;
  end process;

 counter_out <= adder;

end arh_counter;

--------------------------------- tb ----------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter is end;
architecture arch_tb_LFSR of tb_counter is 

component counter is
    port (
    CLK,reset,en : in std_logic;
    counter_out: out integer
    );
 end component;
 
 signal CLK,reset,en : std_logic := '0';
 signal counter_out : integer;
 
 begin
 count0 : counter port map(CLK,reset,en,counter_out);
 
  process is
  begin
  CLK <= not CLK;
  wait for 1ps;
 end process;
 
 process is
  begin
  
  en <= '1';
  wait for 50ps;
  
  reset <= '1';
  wait for 1ps;
  
  en <= '0';
  wait for 2ps;
  
  reset <= '0';
  wait for 2ps;
  
 end process;
 
 end architecture;
 
