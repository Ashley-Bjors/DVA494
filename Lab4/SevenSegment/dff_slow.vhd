

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    
entity dff_slow is
port(
     clk: in std_logic;
     clk_slow: in std_logic;
     D: in std_logic;
     Q: out std_logic:='0'
);
end dff_slow;
architecture Behavioral of dff_slow is
begin
process(clk)
begin
 if(rising_edge(clk)) then
  if(clk_slow='1') then
   Q <= D;
  end if;
 end if;
end process;
end Behavioral;