

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
    generic (Registersize: natural:=2);
    port(
        Seed_in: in std_logic;
        Seed_en: in std_logic;
        CLK: in std_logic;
        Q_Vector: inout std_logic_vector(Registersize-1 downto 0)
    );
end;

architecture Arch_LFSR of LFSR is
    component ShiftReg is
        generic (NrOfBits: natural:=2);
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

--------------------------------------------- tb -------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity tb_LFSR is end;
architecture arch_tb_LFSR of tb_LFSR is 

component LFSR is
    generic (Registersize: natural);
    port(
        Seed_in: in std_logic;
        Seed_en: in std_logic;
        CLK: in std_logic;
        Q_Vector: inout std_logic_vector(Registersize-1 downto 0)
    );
end component;

signal Seed_in,Seed_en,CLK : std_logic := '0';
signal data_out : std_logic_vector(5 downto 0); -- 8 bit

begin 
 inst_0 : LFSR generic map (6) port map(Seed_in,Seed_en,CLK,data_out);

 
  process is
 begin
 clk <= not clk;
 wait for 1ps;
 end process;
 
 process is
 begin
 Seed_en <= '1';
 wait for 2ps;
 
 Seed_in <= '1';
 wait for 2ps;

 Seed_en <= '0';
 wait for 2ps;

 Seed_in <= '0';
 wait for 2ps;
 
 end process;
 
 
end architecture;

