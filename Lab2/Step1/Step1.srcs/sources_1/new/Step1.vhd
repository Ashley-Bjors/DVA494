library ieee;
use ieee.std_logic_1164.all;
entity Mux8to1 is
    port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        i2:in std_logic_vector (3 downto 0);
        i3:in std_logic_vector (3 downto 0);
        i4:in std_logic_vector (3 downto 0);
        i5:in std_logic_vector (3 downto 0);
        i6:in std_logic_vector (3 downto 0);
        i7:in std_logic_vector (3 downto 0);
        sel:in std_logic_vector (2 downto 0);
        o:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_Mux8To1 of Mux8To1 is
    component Mux4To1 is
        port
        (
            i0:in std_logic_vector (3 downto 0);
            i1:in std_logic_vector (3 downto 0);
            i2:in std_logic_vector (3 downto 0);
            i3:in std_logic_vector (3 downto 0);
            s0:in std_logic_vector (2 downto 0);
            o:out std_logic_vector (3 downto 0)
        );
    end component;
    component Mux2To1 is
        port
        (
            i0:in std_logic_vector (3 downto 0);
            i1:in std_logic_vector (3 downto 0);
            s0:in std_logic_vector (2 downto 0);
            o:out std_logic_vector (3 downto 0)
        );
    end component;
    signal Mux4To1_Temp1:std_logic_vector (3 downto 0);
    signal Mux4To1_Temp2:std_logic_vector (3 downto 0);
    signal TempS0:std_logic_vector (1 downto 0);
    signal TempS1:std_logic;
begin
    TempS0 <= sel(1) & sel(2);
    TempS1 <= sel(0);
    Mux4To1_1:Mux4To1 port map(i0,i1,i2,i3,TempS0,Mux4To1_Temp1);
    Mux4To1_2:Mux4To1 port map(i4,i5,i6,i7,TempS0,Mux4To1_Temp2);
    Mux2To1_1:Mux2To1 port map(Mux4To1_Temp1,Mux4To1_Temp2,TempS1,o);
end process;
end;


