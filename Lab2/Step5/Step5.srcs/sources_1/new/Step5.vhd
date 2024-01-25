library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity RedundantALU is end;
component FaultyALU is
    port
    (
        signal A,B,FaultLocation: in std_logic_vector (3 downto 0);
        signal Operation: in std_logic_vector (2 downto 0);
        signal Result: out std_logic_vector (3 downto 0)
    );
end component;

signal A,B,FaultLocation: std_logic_vector (3 downto 0);
signal Operation: std_logic_vector (2 downto 0);
signal Result1,Result2: std_logic_vector (3 downto 0);

begin
FaultyALU_1 : FaultyALU port map(A,B,FaultLocation,Operation,Result1);
FaultyALU_2 : FaultyALU port map(A,B,"1111",Operation,Result2);
process is
    begin
        --ENTER BIG PHAT LUNA CODE
    end process
end;