library ieee;
use ieee.std_logic_1164.all;
entity Mux4To1 is
    port
    (
        i0:in std_logic;
        i1:in std_logic;
        i2:in std_logic;
        i3:in std_logic;
        s0:in std_logic;
        s1:in std_logic;
        o:out std_logic
    );
end;
architecture Arch_Mux4To1 of Mux4To1 is
    component Mux2To1 is
    port
    (
        i0:in std_logic;
        i1:in std_logic;
        s0:in std_logic;
        o:out std_logic
    );
    end component;
    signal Mux2To1_temp1:std_logic;
    signal Mux2To1_temp2:std_logic;
begin
    Mux2To1_1:Mux2To1 port map(i0,i1,s0,Mux2To1_temp1);
    Mux2To1_2:Mux2To1 port map(i2,i3,s0,Mux2To1_temp2);
    Mux2To1_3:Mux2To1 port map(Mux2To1_temp1,Mux2To1_temp2,s1,o);
end;
