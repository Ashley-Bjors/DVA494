library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Fault_Inject is
    port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0);
         
         FA : out std_logic_vector( 3 downto 0);
         FB : out std_logic_vector( 3 downto 0);
         FOperation: out std_logic_vector (2 downto 0)
    );
end;

architecture Arch_Fault_Inject of Fault_Inject is 

signal temp : std_logic_vector(3 downto 0) := "0000";
signal ID : integer range 0 to 3;
begin

ID <=  TO_INTEGER(unsigned(FaultLocation(1 downto 0)));

temp <= (ID => '1', others => '0');

FA <= IA xor temp when (FaultLocation(3 downto 2) = "00") else IA; 
FB <= IB xor temp when (FaultLocation(3 downto 2) = "01") else IB; 
FOperation <= Operation xor temp(2 downto 0) when (FaultLocation(3 downto 2) = "10") else Operation; 
end Arch_Fault_Inject;