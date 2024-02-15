 

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity key_debouncer is
port(
     key_in: in std_logic;
     clk: in std_logic;
     key_debounced: out std_logic
);
end key_debouncer;

architecture Behavioral of key_debouncer is

constant G_DIVISION : integer:= 4; 
--constant G_DIVISION : integer:= 4; 

signal clk_slow: std_logic;
signal Q1,Q2,Q2_bar,Q0: std_logic;


component clock_divider is
    generic (G_DIVISION : integer:= 249999);
    port(
     clk: in std_logic;                           
     clk_slow: out std_logic
    );
end component;

component dff_slow is
port(
     clk: in std_logic;
     clk_slow: in std_logic;
     D: in std_logic;
     Q: out std_logic:='0'
);
end component;

begin

-- Q2_bar <= not Q2;
 key_debounced <= Q1 and Q2 and Q0;

i_slowed_clock: clock_divider 
      GENERIC MAP (G_DIVISION => G_DIVISION)
      PORT MAP 
      ( clk => clk,
        clk_slow => clk_slow
      );
      
debounce0: dff_slow PORT MAP 
      ( clk => clk,
        clk_slow => clk_slow,
        D => key_in,
        Q => Q0
      ); 

debounce1: dff_slow PORT MAP 
      ( clk => clk,
        clk_slow => clk_slow,
        D => Q0,
        Q => Q1
      );   
         
debounce2: dff_slow PORT MAP 
      ( clk => clk,
        clk_slow => clk_slow,
        D => Q1,
        Q => Q2
      ); 
      

 
end Behavioral;