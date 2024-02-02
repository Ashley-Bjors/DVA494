library ieee;
use ieee.std_logic_1164.all;
entity DoubleFaultyALU is 
  port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0);
         
         Result0 : out std_logic_vector( 3 downto 0);
         Result1 : out std_logic_vector( 3 downto 0)
    );
end;
architecture arch_DoubleFaultyALU of DoubleFaultyALU is
    component FaultyALU is port(
        IA : in std_logic_vector( 3 downto 0);
        IB : in std_logic_vector( 3 downto 0);
        FaultLocation: in std_logic_vector (3 downto 0);
        Operation: in std_logic_vector (2 downto 0);
        
        Result : out std_logic_vector( 3 downto 0)
   );
end component;
 
begin
    FaultyALU0: FaultyALU port map(IA,IB,FaultLocation,Operation,Result0);
    FaultyALU1: FaultyALU port map(IA,IB,"1111",Operation,Result1);
end;