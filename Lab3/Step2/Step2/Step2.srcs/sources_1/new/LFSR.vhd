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
            o:out std_logic
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