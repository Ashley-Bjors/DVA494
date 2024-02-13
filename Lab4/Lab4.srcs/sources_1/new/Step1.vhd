-- värt att läsa : Rad 92 , Rad 174


------------------------------ slow clk -----------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity slowClk is
    generic (G_DIVISION : integer);
    port(
        clk : in std_logic;
        clk_slow : out std_logic
    );
end slowClk;

architecture Arch_slowClk of slowClk is 

signal counter : unsigned(27 downto 0) :=(others => '0'); --28 bits = 268 435 456 ticks = 0.59 secs of Basys3(450 000 000 ticks/sec)

begin 
process(clk)
begin
    if(rising_edge(clk)) then
        counter <= counter +1;
        if(counter >= to_unsigned(G_DIVISION,28)) then -- when the counter is above a serten value 
            counter <= (others => '0');
        end if;
    end if;
end process;

 clk_slow <= '1' when (counter = to_unsigned(G_DIVISION,28)) else '0'; -- when counter hit whanted val -> set slow clk to high

end Arch_slowClk;


------------------------------------------------ DFF  --------------------------------------------

-- simple D flip flop
library ieee;
use ieee.std_logic_1164.all;
entity DFF is
    port(
        clk,D : in std_logic;
        Q : out std_logic
    );
end DFF;

architecture Arch_DFF of DFF is 

begin 
process(clk)
    begin
    if(clk'event and (clk = '1')) then
            Q <= D;
    end if;
end process;
end Arch_DFF;

--------------------------------------------------- debouncer  -----------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity key_debouncer is
    port(
        key_in,clk : in std_logic;
        key_debounced : out std_logic
    );
end key_debouncer;

architecture Arch_key_debouncer of key_debouncer is 

    component DFF is port(
            clk,D : in std_logic;
            Q : out std_logic
    );
    end component;

    component slowClk is
        generic (G_DIVISION : integer := 4);
        port(
            clk : in std_logic;
            clk_slow : out std_logic
        );
    end component;

  signal Q0,Q1,Q2,Q2_bar: std_logic := '0'; -- Q0 -> Q1 -> Q2 that means 3 dff -> 4delay points
  signal clk_slow : std_logic;
begin 

  slow_clk0 : slowCLK generic map(2) port map(clk,clk_slow); -- <== change generic map( amount of ticks befor slow clk is high) note: 
                                                            -- THIS VALUE IS FOR SIMULATION. FOR BASYS3 -> Valuse should be around 1 000 000 
  dff0 : DFF port map(clk_slow,key_in,Q0);
  dff1 : DFF port map(clk_slow,Q0,Q1);
  dff2 : DFF port map(clk_slow,Q1,Q2);


    --- from power point ---
    Q2_bar <= not Q2;
    key_debounced <= Q1 and Q2_bar;

  end Arch_key_debouncer;


--------------------------------------------------- push single led -----------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity push_led is
   Port(
    clk,rst_n,push_cmd_i : in std_logic;
    led_o : out std_logic
    );
end push_led;

architecture arch_push_led of push_led is

    signal s_key_pulse,s_led,s_key_pulse_reg1 : std_logic := '0';

    component key_debouncer is
        port(
            key_in,clk : in std_logic;
            key_debounced : out std_logic
        );
    end component;

begin

    i_key_debouncer: key_debouncer port map(
        key_in => push_cmd_i,
        clk => clk,
        key_debounced =>  s_key_pulse
    );

    process(clk, rst_n)
    begin
        if(rst_n = '1') then
            s_key_pulse_reg1 <= '0';
            s_led <= '0';
        elsif (clk'event and (clk = '1')) then
            s_key_pulse_reg1 <= s_key_pulse;
            if(s_key_pulse = '1' and s_key_pulse_reg1 = '0') then
                s_led <= not s_led;
            end if;
        end if;
    end process;
led_o <= s_led;

end arch_push_led;


--------------------------------------------------- push all led -----------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity wrapper_push_led is
    Port( clk,btnC : in std_logic ;
    led : out std_ulogic_vector (15 downto 0)
    );
end wrapper_push_led;

architecture arch_wrapper_push_led of wrapper_push_led is 

component push_led is
   Port(
    clk,rst_n,push_cmd_i : in std_logic;
    led_o : out std_logic
    );
end component;

constant C_RST_SCALE_FACTOR : integer := 80; -- resets input value

signal resetb,leds : std_logic ;
signal s_counter : unsigned (20 downto 0) :=(others => '0');

begin

push_led0 : push_led port map(clk,resetb,btnC,leds);

process(clk)
begin
    if(s_counter = TO_UNSIGNED(C_RST_SCALE_FACTOR,21)) then
        resetb <= '1';
        s_counter <= (others => '0');
    else 
         resetb <= '0';
         s_counter <= s_counter+1;
    end if;
 
end process;
    
led(15 downto 0) <= (others => leds);
end arch_wrapper_push_led;

--------------------------------------------- tb -------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity tb_push_led is end;
architecture arch_tb_push_led of tb_push_led is 

component wrapper_push_led is
  Port( clk,btnC : in std_logic ;
    led : out std_ulogic_vector (15 downto 0)
    );
end component;

signal clk,btnC : std_logic := '0';
signal led_0 : std_ulogic_vector (15 downto 0);

begin

wrapper_push_led0 : wrapper_push_led port map(clk,btnC,led_0);


 process is
 begin
 clk <= not clk;
 wait for 1ps;
 end process;
 
 process is
 begin
 
 btnC <= '0';
 wait for 20ps;
 btnC <= '1';
 wait for 120ps;
 
 end process;
 

end architecture;