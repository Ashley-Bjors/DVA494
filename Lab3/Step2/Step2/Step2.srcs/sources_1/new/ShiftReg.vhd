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