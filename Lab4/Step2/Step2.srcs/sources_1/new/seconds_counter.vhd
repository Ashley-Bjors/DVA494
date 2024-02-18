
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity seconds_counter is
    port(
    clk,rst_n,en_i: in std_logic;                           
     seconds_o: out  std_logic_vector(3 downto 0)
    );
end seconds_counter;

architecture arch_seconds_counter of seconds_counter is
signal C_ONE_SECOND_SCALE_FACTOR : integer := 4;
signal counter: unsigned(27 downto 0):=(others => '0');
signal sec :  unsigned(3 downto 0) := "0000";

begin

process(clk,rst_n)
begin
    if(rising_edge(rst_n) and rst_n = '1') then
           sec <= (others => '0');
           counter <= (others => '0');
           
    elsif(rising_edge(clk)) then
       counter <= counter + 1;
      if(counter>= to_unsigned(C_ONE_SECOND_SCALE_FACTOR, 28)) then  
       counter <=  (others => '0');
            if(sec >= "1001") then
            sec <= (others => '0');
            else
              sec <= sec + 1;
            end if;
      end if;
    end if;
end process;

 seconds_o <= std_logic_vector(sec);

end arch_seconds_counter;

----------------------------------- test bench ----------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_seconds_counter is end;

architecture arch_tb_seconds_counter of tb_seconds_counter is

component seconds_counter is
    port(
        clk,rst_n,en_i: in std_logic;
        seconds_o: out std_logic_vector(3 downto 0)
    );
end component;

signal clk,rst_n,en_i : std_logic := '0';
signal seconds_o :std_logic_vector(3 downto 0) := "0000";

begin

temp_seconds_counter : seconds_counter port map(clk,rst_n,en_i,seconds_o);

process
begin
clk <= not clk;
wait for 1ps;
end process;

process
begin
rst_n <= '0';
wait for 1ps;
en_i <= '1';
wait for 110ps;
rst_n <= '1';
wait for 1ps;

en_i <= '1';
wait for 10ps;
en_i <= '0';
wait for 2ps;
end process;


end architecture ;