library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fault_Inject is
    port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0); -- 3 bit
         
         FA : out std_logic_vector( 3 downto 0);
         FB : out std_logic_vector( 3 downto 0);
         FOperation: out std_logic_vector (2 downto 0)
    );
end;

architecture Arch_Fault_Inject of Fault_Inject is 
signal swich : std_logic_vector (1 downto 0);
signal ID: integer range 0 to 3;

begin
 swich <= FaultLocation(3 downto 2);
 ID <= TO_INTEGER(signed(FaultLocation(1 downto 0)));

 FA(ID) <= NOT IA(ID) when (swich = "00") else  IA(ID);
 FB(ID) <= NOT IB(ID) when (swich = "00") else  IB(ID);
 FOperation(ID) <= NOT Operation(ID)when (swich = "10") else  Operation(ID);
 
end;


library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture arch_tb of tb is
component Fault_Inject is
    port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0);
         
         FA : out std_logic_vector( 3 downto 0);
         FB : out std_logic_vector( 3 downto 0);
         FOperation: out std_logic_vector (2 downto 0)
    );
end component;

 signal IA,IB,FA,FB,FaultLocation : std_logic_vector (3 downto 0);
 signal Operation,FOperation :std_logic_vector (2 downto 0);
 
 begin
   Fault_Inject_0 : Fault_Inject port map(IA,IB,FaultLocation,Operation,FA,FB,FOperation);
 
   process is
   begin
  IA <= "0000";
  IB <= "0001";
  FaultLocation <= "0000"; -- fault first bit A
  Operation <= "010";
  wait for 10ps;
  
 FaultLocation <= "0001"; -- fault second bit A
  wait for 10ps;
  FaultLocation <= "0011";-- fault third bit A
  wait for 10ps;
  FaultLocation <= "0101"; -- fault second bit B
  wait for 10ps;
  FaultLocation <= "1001"; -- fault second bit Operation
  wait for 10ps;
  FaultLocation <= "1101"; -- no fault
  wait for 10ps;
   end process;
   
end;
   