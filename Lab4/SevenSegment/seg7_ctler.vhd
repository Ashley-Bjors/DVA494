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
    
entity seg7_ctler is
-- 1000,000 generates 10ms refresh rates with 100Mhz (10 ns ) clock freq
  generic ( G_REFRESH_SCALE_FACTOR : integer:= 1000000); 
  Port ( 
        clk, rst_n : in std_logic;
        switch16_i : in std_logic_vector(15 downto 0);
        common_anode_o : out std_logic_vector(3 downto 0);
        seg7_cathode_o : out std_logic_vector(6 downto 0)
  );
end seg7_ctler;

architecture Behavioral of seg7_ctler is

signal s_switch16_debounced : std_logic_vector(15 downto 0):=(others=>'0');
 
signal s_bcd_value : std_logic_vector(3 downto 0):=(others=>'0');
signal s_seg7_led_scanner : unsigned(1 downto 0):=(others=>'0');
signal s_refresh_counter : unsigned(31 downto 0):=(others=>'0');

component key_debouncer is
port(
     key_in: in std_logic;
     clk: in std_logic;
     key_debounced: out std_logic
);
end component;

component bcd_to_7seg_decoder is
  Port (bcd_i : in std_logic_vector(3 downto 0);
        seg7_cathode_o : out std_logic_vector(6 downto 0)
        );
end component;

begin

-- 16-bit debouncer for generate instantiation
gen_debounce_16bit : for i in 0 to 15 generate
    i_key_debouncer : key_debouncer 
        port map (
        key_in => switch16_i(i),
        clk => clk,
        key_debounced => s_switch16_debounced(i)
        );
end generate gen_debounce_16bit;

-- process to refresh the 7-SEG LEDs (scan over 4-digit 7-seg)
process(clk, rst_n)
begin
    if (rst_n = '0') then 
        s_refresh_counter <= (others=>'0');
        s_seg7_led_scanner <= (others=>'0');
    elsif rising_edge(clk) then
        if (s_refresh_counter = to_unsigned (G_REFRESH_SCALE_FACTOR, 32)) then
            s_refresh_counter <= (others=>'0');
            s_seg7_led_scanner <= s_seg7_led_scanner + 1;
        else 
            s_refresh_counter <= s_refresh_counter + 1; 
        end if;        
    end if;
end process;

process(s_seg7_led_scanner)
begin
    case s_seg7_led_scanner is
    when "00" =>
        common_anode_o <= "0111"; 
        -- LED0 activated (rest off)
        s_bcd_value <= s_switch16_debounced(3 downto 0);
        -- sw0 
    when "01" =>
        common_anode_o <= "1011"; 
         -- LED1 activated (rest off)
        s_bcd_value <= s_switch16_debounced(7 downto 4);
        -- sw0 
    when "10" =>
        common_anode_o <= "1101"; 
        -- LED2 activated (rest off)
        s_bcd_value <= s_switch16_debounced(11 downto 8);
        -- sw0 
    when "11" =>
        common_anode_o <= "1110"; 
        -- LED3 activated (rest off)
        s_bcd_value <= s_switch16_debounced(15 downto 12);
        -- sw0 
    when others =>    
    end case;
end process;

i_bcd_to_7seg : bcd_to_7seg_decoder 
  Port map (bcd_i => s_bcd_value,
            seg7_cathode_o => seg7_cathode_o 
            );


end Behavioral;
