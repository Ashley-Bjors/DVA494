library ieee;
use ieee.std_logic_1164.all;
entity flipflop is
    port(
        d,clk: in std_logic;
        q: out std_logic
    );
end;
architecture arch_flipflop of flipflop is
begin
    process(clk)
    begin
    if clk = '1' then
        q <= d;
    end if;
      
  end process;
end architecture;

--------------------------------------- flip flop done -----------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity Reg is
    generic(n: natural);
    port(
    d:in std_logic_vector (n-1 downto 0);
    clk:in std_logic ;
    q: out std_logic_vector (n-1 downto 0)
    );
end entity;
  
 architecture arch_Reg of Reg is
 component flipflop is
        port(
        d,clk: in std_logic;
        q: out std_logic
);  
end component;
begin 
    props: for i in n - 1 downto 0 generate 
        inst_i :flipflop port map(d(i),clk,q(i));
    end generate ;
end architecture;


--------------------------------------- shift register done -----------------------------------------

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

------------------------------------ multiplexer done ------------------------

library ieee;
use ieee.std_logic_1164.all;
entity LFSR is
    generic (Registersize: natural);
    port(
        Seed_in: in std_logic;
        Seed_en: in std_logic;
        CLK: in std_logic;
        data_out: inout std_logic_vector(Registersize-1 downto 0)
    );
end;

architecture arch_LFSR of LFSR is

component Reg is 
  generic(n: natural);
    port(
    d:in std_logic_vector (n-1 downto 0);
    clk:in std_logic ;
    q: out std_logic_vector (n-1 downto 0)
    );
end component ;

component Mux2To1 is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        s0      :in std_logic;
        out0    :out std_logic
    );
end component ;
signal temp0,d: std_logic;
begin

d <= data_out(Registersize-2) xor data_out(Registersize-1);

mux: Mux2To1 port map(Seed_in,temp0,Seed_en,d);
inst_i : Reg generic map(Registersize,clk,Registersize,data_out);

end architecture ;

--library ieee;
--use ieee.std_logic_1164.all;
--entity LFSR is
--    generic (Registersize: natural:=2);
--    port(
--        Seed_in: in std_logic;
--        Seed_en: in std_logic;
--        CLK: in std_logic;
--        Q_Vector: inout std_logic_vector(Registersize-1 downto 0)
--    );
--end;

--architecture Arch_LFSR of LFSR is
--    component ShiftReg is
--        generic (NrOfBits: natural:=2);
--        port(
--            CLK: in std_logic;
--            Bit_Input: in std_logic;
--            Q_vector: inout std_logic_vector(NrOfBits-1 downto 0)
--        );  
--    end component;
--    component Mux2To1 is
--        port
--        (
--            i0:in std_logic;
--            i1:in std_logic;
--            s0:in std_logic;
--            o:out std_logic
--        );
--    end component;
--    signal PostXor:std_logic;
--    signal Bit_Input:std_logic;
--begin
--    Mux : Mux2To1 port map(PostXor,Seed_in,Seed_en,Bit_Input);
--    ShiftReg_0 : ShiftReg generic map(Registersize) port map(CLK,Bit_Input,Q_Vector);
--    process (CLK) is
--        begin
--        if (CLK'event and (CLK = '1')) then
--            PostXor <= Q_Vector(0) xor Q_Vector(1);
--        end if;
--    end process;
--end Arch_LFSR;