-------------DFF Slow---------------

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

------------------Clock Divider-------------------------

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity clock_divider is
    generic (G_DIVISION : integer:= 249999);
    port(
     clk: in std_logic;                           
     clk_slow: out std_logic
    );
end clock_divider;

architecture Behavioral_clock_divider of clock_divider is

signal counter: unsigned(27 downto 0):=(others => '0');

begin

process(clk)
begin
    if(rising_edge(clk)) then
       counter <= counter + 1;
      if(counter>= to_unsigned(G_DIVISION, 28)) then  
       counter <=  (others => '0');
      end if;
    end if;
end process;

 clk_slow <= '1' when (counter = to_unsigned(G_DIVISION, 28)) else '0';

end Behavioral_clock_divider;

---------------Key Debouncer--------------------------

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity key_debouncer is
port(
     key_in: in std_logic;
     clk: in std_logic;
     key_debounced: out std_logic
);
end key_debouncer;

architecture Behavioral_key_debouncer of key_debouncer is

 
constant G_DIVISION : integer:= 4;   
--constant G_DIVISION : integer:= 249999; 


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

 Q2_bar <= not Q2;
 key_debounced <= Q1 and Q2_bar;

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
end Behavioral_key_debouncer;

------------------------Push Led-----------------------------

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
entity push_led is
    Port ( 
        clk, rst_n : in std_logic;
        push_cmd_i : in std_logic;
        led_o : out std_logic_vector(15 downto 0) 
    );
end push_led;

architecture Behavioral_push_led of push_led is

signal s_key_pulse : std_logic;
signal s_led : std_logic_vector(15 downto 0);
--signal s_key_pulse_reg1 : std_logic;

component key_debouncer is
port(
     key_in: in std_logic;
     clk: in std_logic;
     key_debounced: out std_logic
);
end component;
 
begin

i_key_debouncer: key_debouncer 
PORT MAP 
      ( key_in => push_cmd_i,
        clk => clk,
        key_debounced => s_key_pulse
      ); 
      
process(clk, rst_n)
begin 
   if (rst_n = '0') then
--        s_key_pulse_reg1 <= '0';
        s_led <= (others=>'0');
   elsif rising_edge(clk) then
--        s_key_pulse_reg1 <= s_key_pulse;
        if (s_key_pulse='1') then
            s_led <=  not s_led;
        end if;
   end if;  
end process;     

led_o <= s_led;
--led_o <= '1' when (s_key_pulse='1' and s_key_pulse_reg1='0') else '0';  
end Behavioral_push_led;

--------------------Wrapper Push Led-------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wrapper_push_led is
  Port (clk : in std_logic;
        btnC : in std_logic;
        led : out std_logic_vector(15 downto 0)
  );
end wrapper_push_led;

architecture Behavioral_wrapper of wrapper_push_led is

 constant C_RST_SCALE_FACTOR : integer :=1000000; -- this value results to 10ms with 10ns period of clk signal

 signal rst_n : std_logic;
 signal s_led : std_logic_vector(15 downto 0); 
 signal s_counter : unsigned(20 downto 0):=(others => '0');


component push_led is
    Port ( 
        clk, rst_n : in std_logic;
        push_cmd_i : in std_logic;
        led_o : out std_logic_vector(15 downto 0)
    );
end component;


begin

-- reset generator 
process(clk)
begin
    if (s_counter >= to_unsigned(C_RST_SCALE_FACTOR, 21)) then -- counts up to 10 ms, then assers the reset
        rst_n <= '1';
    else 
        rst_n <= '0';
        s_counter <= s_counter + 1;
    end if;
end process;


i_push_led: push_led 
    Port map( 
        clk => clk,
        rst_n => rst_n,
        push_cmd_i => btnC,
        led_o => s_led
    );
 
led <= s_led;
--led(15 downto 1) <= (others=> '0');

end Behavioral_wrapper;

--------------Testbench--------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_push_led is end;

architecture arch_tb_push_led of tb_push_led is
  component push_led is
      Port ( 
          clk, rst_n : in std_logic;
          push_cmd_i : in std_logic;
          led_o : out std_logic_vector(15 downto 0) 
      );
  end component;
  
  signal clk, rst_n: std_logic := '0';
  signal push_cmd_i: std_logic := '0';
  signal led_o: std_logic_vector(15 downto 0);
  
begin
    btn_test : push_led port map(clk,rst_n,push_cmd_i,led_o);
   
    process
        begin
        clk <= not clk ;
        wait for 10ps;
    end process;
    
    process
        begin
        rst_n <= '1';
        push_cmd_i <= '1';
        wait for 200ps;
        push_cmd_i <= '0';
        wait for 200ps;
 
    end process;
end architecture;