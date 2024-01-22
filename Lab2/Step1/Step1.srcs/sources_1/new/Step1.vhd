library ieee;
use ieee.std_logic_1164.all;
entity Mux8to1 is
    port
    (
        i0:in std_logic;
        i1:in std_logic;
        i2:in std_logic;
        i3:in std_logic;
        i4:in std_logic;
        i5:in std_logic;
        i6:in std_logic;
        i7:in std_logic;
        s0:in std_logic;
        s1:in std_logic;
        s2:in std_logic;
        o:out std_logic
    );
end;
architecture Arch_Mux8To1 of Mux8To1 is
    component Mux4To1 is
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
    end component;
    component Mux2To1 is
        port
        (
            i0:in std_logic;
            i1:in std_logic;
            s0:in std_logic;
            o:out std_logic
        );
    end component;
    signal Mux4To1_Temp1:std_logic;
    signal Mux4To1_Temp2:std_logic;
begin
    Mux4To1_1:Mux4To1 port map(i0,i1,i2,i3,s0,s1,Mux4To1_Temp1);
    Mux4To1_2:Mux4To1 port map(i4,i5,i6,i7,s0,s1,Mux4To1_Temp2);
    Mux2To1_1:Mux2To1 port map(Mux4To1_Temp1,Mux4To1_Temp2,s2,o);
end;