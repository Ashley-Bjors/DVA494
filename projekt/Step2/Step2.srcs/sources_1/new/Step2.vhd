
library ieee;
use ieee.std_logic_1164.all;
entity Comparator is
    generic (Size: natural:=4);
    port(
        cmp_in1,cmp_in2: in std_logic_vector(Size-1 downto 0);
        cmp_out : out std_logic 
    );
end entity;

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

----------------------------------- test bench ----------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_Comparator is end;

architecture arch_tb_Comparator of tb_Comparator is

component Comparator is
    generic (Size: natural :=4);
    port(
        cmp_in1,cmp_in2: in std_logic_vector(Size-1 downto 0);
        cmp_out : out std_logic 
    );
end component;

 signal cmp_in1,cmp_in2 : std_logic_vector(3 downto 0);
 signal cmp_out : std_logic; 
  
  begin 
  
  comp0 : Comparator generic map(4) port map(cmp_in1,cmp_in2,cmp_out);
  
  process is
  begin
  
  cmp_in1 <= "1111";
  cmp_in2 <= "1110";
  wait for 1ps;
  
  cmp_in1 <= "1101";
  cmp_in2 <= "1100";
  wait for 1ps;
 
  cmp_in1 <= "1000";
  cmp_in2 <= "0000";
  wait for 1ps;
  
  cmp_in1 <= "1111";
  cmp_in2 <= "1111";
  wait for 2ps;
  
  end process;

end architecture;
