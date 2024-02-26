
library ieee;
use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
entity TMR is 
    generic(n : integer := 3);
    port(
        tmr_in1,tmr_in2,tmr_in3 : in std_logic_vector(n-1 downto 0);
        tmr_out : out std_logic_vector(n-1 downto 0)
    );
end entity;
architecture arch_TMR of TMR is 

signal equal : std_logic_vector(n-1 downto 0) := (others => '0');

begin

process (tmr_in1,tmr_in2,tmr_in3)

begin
    if(tmr_in1 = tmr_in2) then
    equal <= tmr_in1;
    elsif(tmr_in1 = tmr_in3) then
     equal <= tmr_in1;
    elsif(tmr_in2 = tmr_in3) then
     equal <= tmr_in2;
    else
     equal <= tmr_in1;
    end if;

tmr_out <= equal;
end process;

end arch_TMR;

-------------------------------------- tb ---------------------------------

library ieee;
use ieee.std_logic_1164.all;
    use IEEE.numeric_std.all;
entity tb_TMR is end;
architecture arch_tb_TMR of tb_TMR is 

component TMR is
    generic(n : integer := 3);
    port(
        tmr_in1,tmr_in2,tmr_in3 : in std_logic_vector(n-1 downto 0);
        tmr_out : out std_logic_vector(n-1 downto 0)
    );
end component;

signal in1,in2,in3,o : std_logic_vector(2 downto 0) := (others => '0');
begin

tmr0 : TMR generic map(3) port map(in1,in2,in3,o);

process 
begin

in1 <= "001";
in2 <= "010";
in3 <= "100";
wait for 1ps;

in1 <= "010";
in2 <= "100";
in3 <= "001";
wait for 1ps;

in1 <= "100";
in2 <= "100";
in3 <= "010";
wait for 1ps;

in3 <= "100";
wait for 1ps;

in1 <= "000";
wait for 1ps;

end process;


end architecture;