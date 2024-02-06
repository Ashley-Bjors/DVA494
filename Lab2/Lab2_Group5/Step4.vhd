-- FaultInjector --
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

--Arithlogic --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity ArithLogic is
    port
    (
        A,
        B:in std_logic_vector (3 downto 0);
        AplusB,
        AandB,
        AxorB,
        AnandB,
        APlusOne,
        Ao,
        Bo,
        AllZero:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_ArithLogic of ArithLogic is
    begin
    AplusB <= A + B;
    AandB <= A and B;
    AxorB <= A xor B;
    AnandB <= A nand B;
    APlusOne <= A + "0001";
    Ao <= A;
    Bo <= B;
    AllZero <= "0000";
end;

-- Max4Bit8to1 --

--Max 4 Bit 2to1

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity Max4Bit2To1 is
    port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        s0:in std_logic;
        o:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_Max4Bit2To1 of Max4Bit2To1 is
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

-- Max 4 bit 4to1

library ieee;
use ieee.std_logic_1164.all;
entity Max4Bit4To1 is
    port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        i2:in std_logic_vector (3 downto 0);
        i3:in std_logic_vector (3 downto 0);
        s0:in std_logic_vector (1 downto 0);
        o:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_Max4Bit4To1 of Max4Bit4To1 is
    component Max4Bit2To1 is
    port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        s0:in std_logic;
        o:out std_logic_vector (3 downto 0)
    );
    end component;
    signal Max4Bit2To1_temp1:std_logic_vector (3 downto 0);
    signal Max4Bit2To1_temp2:std_logic_vector (3 downto 0);
begin

    Max4Bit2To1_1:Max4Bit2To1 port map(i0,i1,s0(0),Max4Bit2To1_temp1);
    Max4Bit2To1_2:Max4Bit2To1 port map(i2,i3,s0(0),Max4Bit2To1_temp2);
    Max4Bit2To1_3:Max4Bit2To1 port map(Max4Bit2To1_temp1,Max4Bit2To1_temp2,s0(1),o);
end;

-- Max 4 bit 8to1

library ieee;
use ieee.std_logic_1164.all;
entity Max4Bit8To1 is
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
        s0:in std_logic_vector (2 downto 0);
        o:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_Max4Bit8To1 of Max4Bit8To1 is
    component Max4Bit4To1 is
        port
        (
            i0:in std_logic_vector (3 downto 0);
            i1:in std_logic_vector (3 downto 0);
            i2:in std_logic_vector (3 downto 0);
            i3:in std_logic_vector (3 downto 0);
            s0:in std_logic_vector (1 downto 0);
            o:out std_logic_vector (3 downto 0)
        );
    end component;
    component Max4Bit2To1 is
        port
        (
            i0:in std_logic_vector (3 downto 0);
            i1:in std_logic_vector (3 downto 0);
            s0:in std_logic;
            o:out std_logic_vector (3 downto 0)
        );
    end component;
    signal Max4Bit4To1_Temp1:std_logic_vector (3 downto 0);
    signal Max4Bit4To1_Temp2:std_logic_vector (3 downto 0);
begin

    Max4Bit4To1_1:Max4Bit4To1 port map(i7,i6,i5,i4,s0(1 downto 0),Max4Bit4To1_Temp1);
    Max4Bit4To1_2:Max4Bit4To1 port map(i3,i2,i1,i0,s0(1 downto 0),Max4Bit4To1_Temp2);
    Max4Bit2To1_1:Max4Bit2To1 port map(Max4Bit4To1_Temp1,Max4Bit4To1_Temp2,s0(2),o);
end;

-- FaultyALU --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity FaultyALU is
    port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0);
         
         Result : out std_logic_vector( 3 downto 0)
    );
end;

architecture archFaultyALU of FaultyALU is
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
component ArithLogic is
    port
    (
        A:in std_logic_vector (3 downto 0);
        B:in std_logic_vector (3 downto 0);
        AplusB,
        AandB,
        AxorB,
        AnandB,
        APlusOne,
        Ao,
        Bo,
        AllZero:out std_logic_vector (3 downto 0)
    );
end component;
component Max4Bit8To1 is
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
        s0:in std_logic_vector (2 downto 0);
        o:out std_logic_vector (3 downto 0)
    );
end component;
--Global Inputs
--signal IA,IB,FaultLocation: std_logic_vector (3 downto 0);
--signal Operation: std_logic_vector (2 downto 0);
--Fault Injector Outputs
signal FaultyA,FaultyB: std_logic_vector (3 downto 0);
signal FaultyOp: std_logic_vector (2 downto 0);
--ArithLogic Outputs
signal AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero: std_logic_vector (3 downto 0);
--Max4Bit8To1 Outputs
--signal Result: std_logic_vector (3 downto 0);

begin   
Fault_Inject_1 : Fault_Inject port map(IA,IB,FaultLocation,Operation,FaultyA,FaultyB,FaultyOp);
ArithLogic_1 : ArithLogic port map (FaultyA,FaultyB,AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero);
Max4Bit8To1_1 : Max4Bit8To1 port map (AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero,FaultyOp,Result);
end;

-- Testbench --

library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture arch_tb of tb is
    component FaultyALU is 
      port(
        IA : in std_logic_vector( 3 downto 0);
        IB : in std_logic_vector( 3 downto 0);
        FaultLocation: in std_logic_vector (3 downto 0);
        Operation: in std_logic_vector (2 downto 0);
        
        Result : out std_logic_vector( 3 downto 0)
   );
end component;
 signal IA,IB,FaultLocation,Result0 : std_logic_vector (3 downto 0);
 signal Operation :std_logic_vector (2 downto 0);
 
begin
    FaultyALU0: FaultyALU port map(IA,IB,FaultLocation,Operation,Result0);
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
  
  end process;
end;