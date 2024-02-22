----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2022 10:40:58 PM
-- Author: Farnam Maybodi 
----------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    
entity bcd_to_7seg_decoder is
  Port (bcd_i : in std_logic_vector(3 downto 0);
        seg7_cathode_o : out std_logic_vector(6 downto 0)
        );
end bcd_to_7seg_decoder;

architecture Behavioral of bcd_to_7seg_decoder is

begin

process(bcd_i)
begin
    case bcd_i is
    when "0000" => seg7_cathode_o <= "1000000"; -- "0"  "1000000"    0000001
    when "0001" => seg7_cathode_o <= "1111001"; -- "1"  "1111001" 1001111
    when "0010" => seg7_cathode_o <= "0100100"; -- "2"  "0100100" 0010010
    when "0011" => seg7_cathode_o <= "0110000"; -- "3"  "0110000" 0000110
    when "0100" => seg7_cathode_o <= "0011001"; -- "4"  "0011001" 1001100
    when "0101" => seg7_cathode_o <= "0010010"; -- "5"  "0010010" 0100100
    when "0110" => seg7_cathode_o <= "0000010"; -- "6"  "0000010" 0100000 
    when "0111" => seg7_cathode_o <= "1111000"; -- "7"  "1111000" 0001111
    when "1000" => seg7_cathode_o <= "0000000"; -- "8"  "0000000"  0000000  
    when "1001" => seg7_cathode_o <= "0010000"; -- "9"  "0010000" 0000100
    when "1010" => seg7_cathode_o <= "0100000"; -- a    "0100000" 0000010
    when "1011" => seg7_cathode_o <= "0000011"; -- b    "0000011" "1100000"
    when "1100" => seg7_cathode_o <= "1000110"; -- C    "1000110" "0110001"
    when "1101" => seg7_cathode_o <= "0100001"; -- d    "0100001" "1000010"
    when "1110" => seg7_cathode_o <= "0000110"; -- E    "0000110" "0110000"
    when "1111" => seg7_cathode_o <= "0001110"; -- F    "0001110" "0111000"
    when others => 
    end case;
end process;

end Behavioral;
