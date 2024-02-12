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
    generic(n: natural := 4)
  port (
    in1,in2: in std_logic_vector (n-1 downto 0);
    CLK,reset : in std_logic := '0';
    o: out integer;
  ) ;
end InequalityCounter;

architecture arch_InequalityCounter of InequalityCounter is
  component Comparator is
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
  component InequalityCounter is
    port (
      in1,in2: in std_logic_vector (n-1 downto 0);
      CLK,reset : in std_logic := '0';
      o: out std_logic;
    );
  end component;

  signal post_cmp: std_logic;

begin

Comparator_0 : Comparator port map(in1,in2,post_cmp);
counter_0 : counter port map(CLK,reset,post_cmp,o);

end architecture ; -- arch