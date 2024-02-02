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
