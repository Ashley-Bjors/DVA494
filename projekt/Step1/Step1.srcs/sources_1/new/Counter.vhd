library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    port(
    CLK,reset,en : in std_logic := '0';
    counter_out: out std_logic_vector (3 downto 0)
    );
 end entity;
 
 architecture arh_counter of counter is 
 
signal counter_up: std_logic_vector(3 downto 0) := "0000";

begin
-- up counter
process(CLK)
begin
 if (CLK'event and (CLK = '1')) then
    if(reset='1') then
         counter_up <= "0000";
    else
        counter_up <= counter_up + "1";
    end if;
 end if;
end process;

 counter_out <= counter_up;

end architecture ;

--------------------------------- tb ----------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_counter is end;
architecture arch_tb_LFSR of tb_counter is 
component counter is
    port (
    CLK,reset,en : in std_logic;
    counter_out: out std_logic_vector (3 downto 0)
    );
 end component;
 
 signal CLK,reset,en : std_logic := '0';
 signal counter_out : std_ulogic_vector(3 downto 0);
 begin
 
  process is
  begin
  CLK <= not CLK;
  wait for 1ps;
 end process;
 
 process is
  begin
  reset <= '1';
  wait for 50ps;
 end process;
 
 end architecture;
 
