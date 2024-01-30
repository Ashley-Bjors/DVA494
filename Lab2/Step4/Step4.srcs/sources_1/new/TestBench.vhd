library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture arch_tb of tb is
    component FaultyALU is port(
        IA : in std_logic_vector( 3 downto 0);
        IB : in std_logic_vector( 3 downto 0);
        FaultLocation: in std_logic_vector (3 downto 0);
        Operation: in std_logic_vector (2 downto 0);
        
        Result : out std_logic_vector( 3 downto 0)
   );
end component;
 signal IA,IB,FaultLocation,Result0,Result1 : std_logic_vector (3 downto 0);
 signal Operation :std_logic_vector (2 downto 0);
 
begin
    FaultyALU0: FaultyALU port map(IA,IB,FaultLocation,Operation,Result0);
    FaultyALU1: FaultyALU port map(IA,IB,"1111",Operation,Result1);
  process is 

  begin
   
  IA <= "0000";
  IB <= "0010";
  Operation <= "000";
  FaultLocation <= "0000"; -- fault in a
 wait for 10 ps;
 
 FaultLocation <= "0001"; -- fault in a
 wait for 10 ps;
 
 FaultLocation <= "0010"; -- fault in a
 wait for 10 ps;
 
  FaultLocation <= "0011"; -- fault in a
 wait for 10 ps;
 
  FaultLocation <= "0100"; -- fault in b
 wait for 10 ps;
 
  FaultLocation <= "1000"; -- fault in operation
 wait for 10 ps;
 
  FaultLocation <= "1100"; -- no fault
 wait for 10 ps;
 
  Operation <= "010";
  wait for 10 ps;
  
  Operation <= "100";
  wait for 10 ps;
  
  end process;
end;

--library ieee;
--use ieee.std_logic_1164.all;
--entity tb1 is end;
--architecture arch_tb1 of tb1 is
--    component Fault_Inject is
--     port
--    (
--       IA : in std_logic_vector( 3 downto 0);
--         IB : in std_logic_vector( 3 downto 0);
--         FaultLocation: in std_logic_vector (3 downto 0);
--         Operation: in std_logic_vector (2 downto 0);
         
--         FA : out std_logic_vector( 3 downto 0);
--         FB : out std_logic_vector( 3 downto 0);
--         FOperation: out std_logic_vector (2 downto 0)
--    );

--end component;
-- signal IA,IB,FaultLocation,FA,FB : std_logic_vector (3 downto 0);
-- signal FOperation,Operation :std_logic_vector (2 downto 0);
 
--begin
-- Fault_Inject_temp0: Fault_Inject port map(IA,IB,FaultLocation,Operation,FA,FB,FOperation);
--  process is 
--    begin
--IA <= "0000";
--IB <= "0010";
--Operation <= "000";
--FaultLocation <= "0000"; -- fault in a
-- wait for 10 ps;
 
-- FaultLocation <= "0001"; -- fault in a
-- wait for 10 ps;
 
-- FaultLocation <= "0010"; -- fault in a
-- wait for 10 ps;
 
--  FaultLocation <= "0011"; -- fault in a
-- wait for 10 ps;
 
--  FaultLocation <= "0100"; -- fault in b
-- wait for 10 ps;
 
--  FaultLocation <= "1000"; -- fault in operation
-- wait for 10 ps;
 
 
--  FaultLocation <= "1100"; -- no fault
-- wait for 10 ps;
 
--  Operation <= "010";
--  wait for 10 ps;
  
--  Operation <= "100";
--  wait for 10 ps;
  
--    end process;
--end;