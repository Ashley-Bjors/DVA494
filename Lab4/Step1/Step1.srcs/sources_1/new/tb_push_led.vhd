library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_push_led is end;

architecture arch_tb_push_led of tb_push_led is
  component push_led
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
    process
        begin
        clk <= not clk after 10ps;
    end process;
    
    process
        begin
        wait for 200ps;
        push_cmd_i <= '1';
        wait for 200ps;
        push_cmd_i <= '0';
 
    end process;
end architecture;