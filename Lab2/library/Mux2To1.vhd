library ieee;
use ieee.std_logic_1164.all;
entity Mux2To1 is
    port
    (
        i0:in std_logic;
        i1:in std_logic;
        s0:in std_logic;
        o:out std_logic
    );
end;
architecture Arch_Mux2To1 of Mux2To1 is
    signal Nots0:std_logic;
    signal And0:std_logic;
    signal And1:std_logic;
begin
    Nots0 <= not s0;
    And0 <= s0 and i0;
    And1 <= Nots0 and i1;
    o <= And0 or And1;
end;