library ieee;
use ieee.std_logic_1164.all;
entity Mux2To1 is
    port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        s0:in std_logic;
        o:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_Mux2To1 of Mux2To1 is
    signal TempS:std_logic_vector (3 downto 0);
    signal Nots0:std_logic_vector (3 downto 0);
    signal And0:std_logic_vector (3 downto 0);
    signal And1:std_logic_vector (3 downto 0);
begin    
    TempS <= s0 & s0 & s0 & s0;
    Nots0 <= not TempS;
    And1 <= TempS and i0;
    And0 <= Nots0 and i1;
    o <= And0 or And1;
end;