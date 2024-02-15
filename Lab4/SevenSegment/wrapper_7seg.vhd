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
    
entity wrapper_7seg is
  Port ( 
        clk : in std_logic;
        sw : in std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0); 
        an : out std_logic_vector(3 downto 0)
        );
        
end wrapper_7seg;

architecture Behavioral of wrapper_7seg is
component seg7_ctler is
-- 1000,000 generates 10ms refresh rates with 100Mhz (10 ns ) clock freq
  generic ( G_REFRESH_SCALE_FACTOR : integer:= 1000000); 
  Port ( 
        clk, rst_n : in std_logic;
        switch16_i : in std_logic_vector(15 downto 0);
        common_anode_o : out std_logic_vector(3 downto 0);
        seg7_cathode_o : out std_logic_vector(6 downto 0)
  );
end component;


-- constant C_RST_SCALE_FACTOR : integer :=1000000; -- this value results to 10ms with 10ns period of clk signal
-- constant G_REFRESH_SCALE_FACTOR : integer :=1000000; -- this value results to 10ms with 10ns period of clk signal

 -- we set counter scales to 4 to be able to simulate and see the waveforms
 constant C_RST_SCALE_FACTOR : integer :=4;   
 constant G_REFRESH_SCALE_FACTOR : integer :=4;    


 signal rst_n : std_logic;
 signal s_counter : unsigned(20 downto 0):=(others=>'0'); 

begin

-- reset generator 
process(clk)
begin
    if (s_counter = to_unsigned(C_RST_SCALE_FACTOR, 21)) then -- counts up to 10 ms, then assers the reset
        rst_n <= '1';
    elsif rising_edge (clk) then
        rst_n <= '0';
        s_counter <= s_counter + 1;
    end if;
end process;

i_seg7_ctler : seg7_ctler 
-- 1000,000 generates 10ms refresh rates with 100Mhz (10 ns ) clock freq
  generic map ( G_REFRESH_SCALE_FACTOR => G_REFRESH_SCALE_FACTOR)
  port map ( 
        clk => clk,
        rst_n => rst_n,
        switch16_i => sw,
        common_anode_o => an,
        seg7_cathode_o => seg
  );
 

end Behavioral;
