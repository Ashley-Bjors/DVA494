-------------------------------------- Mux 2 TO 1 ------------------------
library ieee;
use ieee.std_logic_1164.all;
entity Mux2To1 is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        s0      :in std_logic;
        out0    :out std_logic
    );
end;
architecture Arch_Mux2To1 of Mux2To1 is 
    signal tempS : std_logic;
    signal temp0 : std_logic;
    signal temp1 : std_logic;
begin
   tempS <= not s0;
   temp0 <= i0 and temps;
   temp1 <= i1 and s0;
   out0 <= temp0 or temp1;
   
end; 



--------------------------------------Shift Register----------------

library ieee;
use ieee.std_logic_1164.all;
entity ShiftReg is
    generic (NrOfBits: natural:=2);
    port(
        CLK: in std_logic;
        Bit_Input: in std_logic;
        Q_vector: inout std_logic_vector(NrOfBits-1 downto 0)
    );
end;

architecture arch_ShiftReg of ShiftReg is
    component ShiftReg is
        port(
            CLK: in std_logic;
            Bit_Input: inout std_logic;
            Q_vector: inout std_logic_vector(NrOfBits-1 downto 0)
        );
    end component;
    component DFF is
        port(
        CLK: in std_logic;
        D: in std_logic;
        Q: out std_logic
    );
    end component; 
begin
    DFF_bit_MSB : DFF port map(CLK,Bit_Input,Q_Vector(NrOfBits-1));
    DFF_Gen: for i in NrOfBits-2 downto 0 generate
        DFF_Bit: DFF port map(CLK,Q_vector(i+1),Q_vector(i));
    end generate;
end arch_ShiftReg;


-------------------------------------- D flip flop ------------------------
library ieee;
use ieee.std_logic_1164.all;
entity DFF is
    port(
        CLK: in std_logic;
        D: in std_logic;
        Q: out std_logic
    );
end;

architecture Arch_DFF of DFF is
begin
    process (CLK) is
        begin
        if (CLK'event and (CLK = '1')) then
            Q <= D;
        end if;
    end process;
end Arch_DFF;

-------------------------------------- multiplexer ------------------------
--Mulitplexer
library ieee;
use ieee.std_logic_1164.all;
entity Mux2To1 is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        s0      :in std_logic;
        out0    :out std_logic
    );
end;
architecture Arch_Mux2To1 of Mux2To1 is 
    signal tempS : std_logic;
    signal temp0 : std_logic;
    signal temp1 : std_logic;
begin
   tempS <= not s0;
   temp0 <= i0 and temps;
   temp1 <= i1 and s0;
   out0 <= temp0 or temp1;
   
end; 

------------------------------------------- LFSR -------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
entity LFSR is
    generic (Registersize: natural:=8);
    port(
        Seed_in: in std_logic;
        Seed_en: in std_logic;
        CLK: in std_logic;
        Q_Vector: inout std_logic_vector(Registersize-1 downto 0)
    );
end;

architecture Arch_LFSR of LFSR is
    component ShiftReg is
        generic (NrOfBits: natural:=8);
        port(
            CLK: in std_logic;
            Bit_Input: in std_logic;
            Q_vector: inout std_logic_vector(NrOfBits-1 downto 0)
        );  
    end component;
    component Mux2To1 is
        port
        (
            i0:in std_logic;
            i1:in std_logic;
            s0:in std_logic;
            out0:out std_logic
        );
    end component;
    signal PostXor:std_logic;
    signal Bit_Input:std_logic;
begin
    Mux : Mux2To1 port map(PostXor,Seed_in,Seed_en,Bit_Input);
    ShiftReg_0 : ShiftReg generic map(Registersize) port map(CLK,Bit_Input,Q_Vector);
    process (CLK) is
        begin
        if (CLK'event and (CLK = '1')) then
            PostXor <= Q_Vector(0) xor Q_Vector(1);
        end if;
    end process;
end Arch_LFSR;

---------------------------------FLG-----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity FLG is
    generic (fault_probability : real; seed : positive);
    port (
        clk             : in std_logic;
        fault_location  : out std_logic_vector (3 downto 0)
    );
end;

architecture arch of FLG is
begin
    process (clk)
        variable seed1, seed2 : positive;
        variable rand : real;
    begin
        if (clk = '1') then
            seed1 := seed1 + seed;
            seed2 := seed2 + 2 * seed + 1;
            uniform(seed1, seed2, rand);
            if (rand < fault_probability) then
                seed1 := seed1 + seed;
                seed2 := seed2 + 2 * seed + 1;
                uniform(seed1, seed2, rand);
                fault_location <= std_logic_vector(TO_UNSIGNED(integer(floor(rand * real(11))), 4));
            else
                fault_location <= "1111";
            end if;
        end if;
    end process;
end;

-----------------------------------------Max 4 bit 8 to 1 ----------------------------
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

-- Max 4 Bit 4to1

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

-- Max 4 Bit 8to1

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

------------------------------------------ ALU --------------------------------------
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

------------------------------------------ Fault Inject ----------------------------
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
--temp(ID) <= '1';

temp <= (ID => '1', others => '0');

FA <= IA xor temp when (FaultLocation(3 downto 2) = "00") else IA; 
FB <= IB xor temp when (FaultLocation(3 downto 2) = "01") else IB; 
FOperation <= Operation xor temp(2 downto 0) when (FaultLocation(3 downto 2) = "10") else Operation; 
end Arch_Fault_Inject;



------------------------------------------Faulty ALU--------------------------------

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
--Fault Injector Outputs
signal FaultyA,FaultyB: std_logic_vector (3 downto 0);
signal FaultyOp: std_logic_vector (2 downto 0);
--ArithLogic Outputs
signal AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero: std_logic_vector (3 downto 0);

begin   
Fault_Inject_1 : Fault_Inject port map(IA,IB,FaultLocation,Operation,FaultyA,FaultyB,FaultyOp);
ArithLogic_1 : ArithLogic port map (FaultyA,FaultyB,AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero);
Max4Bit8To1_1 : Max4Bit8To1 port map (AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero,FaultyOp,Result);
end;


-----------------------------------Inequality Counter--------------------------

--Comparator
library ieee;
use ieee.std_logic_1164.all;
entity Comparator is
    generic (Size: natural:=4);
    port(
        cmp_in1,cmp_in2: in std_logic_vector(Size-1 downto 0);
        cmp_out : out std_logic 
    );
end entity;
--Comparator Architecture
architecture Arch_Comparator of Comparator is
signal o:std_logic := '0';
begin
    process(cmp_in1,cmp_in2)
    begin
        if (cmp_in1 /= cmp_in2) then
         o <= '1';
        else
        o <='0';
        end if;
    end process;
cmp_out <= o;
end Arch_Comparator;
--Counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
    CLK,reset,en : in std_logic := '0';
    counter_out: out integer 
    );
 end entity;
--Counter Architecture
 architecture arh_counter of counter is 
 
 signal adder : integer := 0;
 
begin

-- up counter
 process(CLK) is
  begin
  if (CLK'event and (CLK = '0')) then
     if(reset='1') then
         adder <= 0;
     elsif(en = '1') then
         adder <= adder + 1;
     end if;
    end if;
  end process;

 counter_out <= adder;

end arh_counter;
--Inequality Counter

library ieee;            
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InequalityCounter is
    generic(n: natural := 4);
  port (
    in1,in2: in std_logic_vector (n-1 downto 0);
    CLK,reset : in std_logic := '0';
    o: out integer
  ) ;
end InequalityCounter;

architecture arch_InequalityCounter of InequalityCounter is
  component Comparator is
    generic(Size: natural := 4);
    port(
      cmp_in1,cmp_in2: in std_logic_vector(Size-1 downto 0);
      cmp_out : out std_logic 
    );
  end component;
  component counter is
    port(
      CLK,reset,en : in std_logic := '0'; 
      counter_out: out integer 
    );
  end component;

  signal post_cmp: std_logic;

begin

Comparator_0 : Comparator port map(in1,in2,post_cmp);
counter_0 : counter port map(CLK,reset,post_cmp,o);

end architecture ; -- arch


-----------------------------Faulty ALU Tester-----------------------------
library ieee;            
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Faulty_ALU_Tester is
    generic (fault_probability : real);
    port (
        faults  : out integer
    );
end;

architecture arch_Faulty_ALU_Tester of Faulty_ALU_Tester is
    component LFSR is
        generic (Registersize: natural:=8);
        port(
            Seed_in: in std_logic;
            Seed_en: in std_logic;
            CLK: in std_logic;
            Q_Vector: inout std_logic_vector(Registersize-1 downto 0)
        );
    end component;
    component FLG is
        generic (fault_probability : real; seed : positive);
        port (
            clk             : in std_logic;
            fault_location  : out std_logic_vector (3 downto 0)
        );
    end component;
    component FaultyALU is
        port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0);
         
         Result : out std_logic_vector( 3 downto 0)
        );
    end component;
    component InequalityCounter is
        generic(n: natural := 4);
        port (
            in1,in2: in std_logic_vector (n-1 downto 0);
            CLK,reset : in std_logic := '0';
            o: out integer
        );
    end component;
    
    signal Seed_in              : std_logic := '1';
    signal Seed_en              : std_logic := '1';
    signal clk                  : std_logic := '0';
    signal counter              : integer := 0;
    signal LFSR_Out             : std_logic_vector (10 downto 0);
    signal Fault_Location       : std_logic_vector (3 downto 0);
    signal ALU0_Out, ALU1_Out   : std_logic_vector (3 downto 0);
    
    begin
    LFSR0               : LFSR generic map (11) port map (Seed_in, Seed_en, clk, LFSR_Out);
    FLG0                : FLG generic map (fault_probability, 1) port map (clk, Fault_Location);
    Faulty_ALU0         : FaultyALU port map(LFSR_Out(10 downto 7), LFSR_Out(6 downto 3), Fault_Location, LFSR_Out(2 downto 0), ALU0_Out);
    Faulty_ALU1         : FaultyALU port map(LFSR_Out(10 downto 7), LFSR_Out(6 downto 3), "1111", LFSR_Out(2 downto 0), ALU1_Out);
    Inequality_Counter0 : InequalityCounter generic map (4) port map (ALU0_Out, ALU1_Out, clk, '0', faults);
    
    process is
    begin
    if  (counter > 11) then
        Seed_en <= '0';
    elsif (clk = '1') then
        counter <= counter + 1;
    end if;
    clk <= not clk;
    wait for 1ps;
    end process;

end architecture ;

---------------------------------TB------------------------------------

library ieee;            
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb is end;

architecture arch_tb of tb is

    component Faulty_ALU_Tester is
        generic (fault_probability : real);
        port (
            faults  : out integer
    );
    end component;
    
    signal out0 : integer := 0;
    
    
    begin
        tester : Faulty_ALU_Tester generic map(0.2) port map(out0);
        
    
end;
    