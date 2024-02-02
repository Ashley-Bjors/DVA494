library ieee;
use ieee.std_logic_1164.all;
entity LFSR is
    port(
        Seed_in: in std_logic;
        Seed_en: in std_logic;
        CLK: in std_logic;
        Data_out: out std_logic(n downto 0)
    );
end;

architecture Arch_LFSR of LFSR is
    component DFF is
    port(
        CLK: in std_logic;
        D: in std_logic;
        Q: out std_logic
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
    signal PostMux:std_logic;
begin
    Mux : Mux port map(PostXor,Seed_in,Seed_en,PostMux);
    DFF_4Bit: for i in n to 0 
        if i /= n generate
            DFF_i : DFF
            port map(CLK,Data_out(i+1),Data_out(i));
        else generate
            DFF_i : DFF
            port map(CLK,PostMux,Data_out(i));
        end if;
    end loop;
    process (CLK) is
        begin
        if (CLK'event and (CLK = '1')) then
            PostXor <= Data_out(0) xor Data_out(1);
            
        end if;
    end process;
end Arch_LFSR;