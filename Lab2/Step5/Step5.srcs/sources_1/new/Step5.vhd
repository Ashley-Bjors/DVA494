library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture arch_tb of tb is
    component DoubleFaultyALU is port(
        IA : in std_logic_vector( 3 downto 0);
        IB : in std_logic_vector( 3 downto 0);
        FaultLocation: in std_logic_vector (3 downto 0);
        Operation: in std_logic_vector (2 downto 0);
        
        Result0 : out std_logic_vector( 3 downto 0);
        Result1 : out std_logic_vector( 3 downto 0)
   );
end component;
 signal IA,IB,FaultLocation,Result0,Result1 : std_logic_vector (3 downto 0);
 signal Operation :std_logic_vector (2 downto 0);
 
begin
    DoubleFaultyALU0: DoubleFaultyALU port map(IA,IB,FaultLocation,Operation,Result0,Result1);
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
  
   Operation <= "101";
  wait for 10 ps;
  
  Operation <= "100";
  wait for 10 ps;
  ----------------------------- 10 st with error but look the same ------------
  IA <= "0110";
  IB <= "0001";
  Operation <= "000";
  FaultLocation <= "1010";
 wait for 10 ps;
 
  IA <= "0101";
  IB <= "0001";
  Operation <= "100";
  FaultLocation <= "1010";
 wait for 10 ps;
 
  IA <= "0000";
  IB <= "0011";
  Operation <= "111";
  FaultLocation <= "1001";
 wait for 10 ps;
 
  IA <= "0000";
  IB <= "1111";
  Operation <= "101";
  FaultLocation <= "1001";
 wait for 10 ps;
 
  IA <= "0101";
  IB <= "0000";
  Operation <= "111";
  FaultLocation <= "1000";
 wait for 10 ps;
 
  IA <= "0110";
  IB <= "0000";
  Operation <= "111";
  FaultLocation <= "1000";
 wait for 10 ps;
 
  IA <= "0100";
  IB <= "0000";
  Operation <= "110";
  FaultLocation <= "1000";
 wait for 10 ps;
 
  IA <= "1011";
  IB <= "1101";
  Operation <= "011";
  FaultLocation <= "1000";
 wait for 10 ps;
 
  IA <= "1011";
  IB <= "1101";
  Operation <= "010";
  FaultLocation <= "1000";
 wait for 10 ps;
 
  IA <= "1111";
  IB <= "1111";
  Operation <= "101";
  FaultLocation <= "0101";
 wait for 10 ps;
 
  IA <= "0010";
  IB <= "1101";
  Operation <= "111";
  FaultLocation <= "0010";
 wait for 10 ps;
  
  end process;
end;