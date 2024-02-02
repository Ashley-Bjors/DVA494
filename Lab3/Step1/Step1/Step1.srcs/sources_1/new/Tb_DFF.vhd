library ieee;
use ieee.std_logic_1164.all;
entity tb_DFF is end;
architecture arch_tb_DFF of tb_DFF is
    component DFF is
        port(
        CLK: in std_logic;
        D: in std_logic;
        Q: out std_logic
    );
    end component;
signal CLK,D,Q: std_logic;
begin
    DFF_0 : DFF port map(CLK,D,Q);

    process is
        begin

        CLK <= '1';
        D <= '1';
        wait for 1 ps;
        D <= '0';
        CLK <= '0';
        wait for 1 ps;
        
        CLK <= '1';
        D <= '0';
        wait for 1 ps;
        CLK <= '0';
        wait for 1 ps;

    
    end process;
end;