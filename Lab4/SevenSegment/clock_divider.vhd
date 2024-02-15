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
      if(counter = to_unsigned(G_DIVISION, 28)) then  
       counter <=  (others => '0');
      end if;
    end if;
end process;

 clk_slow <= '1' when (counter = to_unsigned(G_DIVISION, 28)) else '0';

end Behavioral;

 