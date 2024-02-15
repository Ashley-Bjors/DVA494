
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned;

entity seconds_counter is
    port(
        clk,rst_n,en_i: in std_logic;
        seconds_o: out std_logic_vector(3 downto 0)
    );
end seconds_counter;

architecture Arch_seconds_counter of seconds_counter is 

constant C_ONE_SECOND_SCALE_FACTOR : integer := 1;
signal s_counter,seconds : unsigned(3 downto 0) := (others => '0');

begin


process (clk) is
begin   
   if(en_i = '1')  then
       if (clk'event and (clk = '1')) then
           s_counter <= s_counter + 1;
          if(s_counter>= to_unsigned(C_ONE_SECOND_SCALE_FACTOR, 4)) then  
               s_counter <=  (others => '0');
               seconds <= seconds +1;
            end if;
      end if;
   elsif(en_i = '0') then
    s_counter <=  (others => '0');
   end if;
end process;

 process (rst_n) is
    begin
        if (rising_edge(rst_n)) then
           s_counter <= (others => '0');
           seconds <= (others => '0');
    end if;
end process;


seconds_o <= std_logic_vector(seconds);


end Arch_seconds_counter;

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
en_i <= '1';
wait for 100ps;
rst_n <= '1';
wait for 1ps;

en_i <= '1';
wait for 10ps;
en_i <= '0';
wait for 2ps;
end process;


end architecture ;