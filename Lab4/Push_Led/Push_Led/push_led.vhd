----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2022 10:40:58 PM
-- Author: Farnam Maybodi 
----------------------------------------------------------------------------------


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

architecture Behavioral of push_led is

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
end Behavioral;
