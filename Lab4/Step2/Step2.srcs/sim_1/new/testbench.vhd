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
rst_n <= '1';
wait for 1ps;
en_i <= '1';
wait for 200ps;
rst_n <= '0';
wait for 1ps;
rst_n <= '1';
wait for 10ps;
en_i <= '0';
wait for 5ps;
en_i <='1';
wait for 10ps;
end process;


end architecture ;