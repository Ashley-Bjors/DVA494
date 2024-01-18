library ieee;
use ieee.std_logic_1164.all;
entity hello_and is
    port(
        in1     : in std_logic;
        in2     : in std_logic;
        result  : out std_logic
        );
end;
architecture rtl of hello_and is
    signal temp: std_logic;
begin
    temp <= in1 and in2;
    result <= temp;
end;

library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture tb_arch of tb is
    component hello_and is 
        port(
        in1     : in std_logic;
        in2     : in std_logic;
        result  : out std_logic
        );
    end component;
    signal in1 : std_logic;
    signal in2 : std_logic ;
    signal result : std_logic;
begin
    entity_instance_1: hello_and
        port map(in1, in2, result);
    process is
    begin
        in1 <= '0';
        in2 <= '0';
        wait for 10 ps;  
        
        in1 <= '0';
        in2 <= '1';
        wait for 10 ps;  
        
        in1 <= '1';
        in2 <= '0';
        wait for 10 ps;
        
        in1 <= '1';
        in2 <= '1';
        wait for 10 ps;
    end process;
end;