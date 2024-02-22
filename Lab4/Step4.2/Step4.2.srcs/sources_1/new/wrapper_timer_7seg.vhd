library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;

entity clock_counter is
        generic(scalar: integer:= 100e6; resetval: integer:=9);
    port (
        clk,rst_n,en_i: in std_logic;
        count_o:out std_logic_vector(3 downto 0);
        carry:out std_logic
    ) ;
    end clock_counter;

    architecture arch_clock_counter of clock_counter is
        signal C_ONE_SECOND_SCALE_FACTOR : integer := scalar;
        signal counter: unsigned(27 downto 0):=(others => '0');
        signal sec :  unsigned(3 downto 0) := (others => '0');
        signal carry_sig : std_logic := '0';
    begin
    process(clk,rst_n)
    begin
        carry_sig <= '0';
        if(rst_n = '0') then -- reset if reset is activ low
            sec <= (others => '0'); 
            counter <= (others => '0');
            
        elsif(rising_edge(clk)) then -- in clk is activ high
            counter <= counter + 1; -- increment counter
            if(counter >= to_unsigned(C_ONE_SECOND_SCALE_FACTOR, 28)) then  -- if we have ticked for 1 sec
                counter <=  (others => '0'); -- reset counter
                if(sec >= to_unsigned(resetval,28)) then -- increment sec
                    carry_sig <= '1';
                    sec <= (others => '0');
                else
                    sec <= sec + 1; -- sec is below max value
                end if;
            end if;
        end if;
    end process;

    carry <= carry_sig;
    count_o <= std_logic_vector(sec);

end arch_clock_counter;

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;

entity timer is
    generic(sec_delay : integer := 100000000);
    port(
        clk,rst_n,en_i: in std_logic;                           
        bcd_sec_ones_o,bcd_sec_tens_o,bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
    );
    end timer;

    architecture arch_timer of timer is
        component clock_counter is
            generic(scalar: integer:= 100e6; resetval: integer:=9);
            port (
                clk,rst_n,en_i: in std_logic;
                count_o:out std_logic_vector(3 downto 0);
                carry:out std_logic
            ) ;
            end component;

        signal carry_one_s,carry_ten_s,carry_one_m,carry_ten_m : std_logic :='0';
    begin
        sec_ones:clock_counter generic map(sec_delay,9) port map(clk,'1','1',bcd_sec_ones_o,carry_one_s);
        sec_tens:clock_counter generic map(sec_delay,5) port map(carry_one_s,'1','1',bcd_sec_tens_o,carry_ten_s);
        min_ones:clock_counter generic map(sec_delay,9) port map(carry_ten_s,'1','1',bcd_mins_ones_o,carry_one_m);
        min_tens:clock_counter generic map(sec_delay,5) port map(carry_one_m,'1','1',bcd_mins_tens_o,carry_ten_m);
end architecture;

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
 
entity wrapper_timer_7seg is
    generic(C_RST_SCALE_FACTOR : integer:= 200);
    port(
       clk : in std_logic;
       seg : out std_logic_vector(6 downto 0);
       an : out std_logic_vector(3 downto 0)
    );
    end wrapper_timer_7seg;

    architecture arch_wrapper_timer_7seg of wrapper_timer_7seg is

    -- step 3
    component timer is
    generic(sec_delay : integer := 1000000); -- amount of tick/sec
    port(
        clk,rst_n,en_i: in std_logic;                           
        bcd_sec_ones_o,bcd_sec_tens_o,
        bcd_mins_ones_o,bcd_mins_tens_o: out  std_logic_vector(3 downto 0)
    );
    end component;

    -- copy past from zip file
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

    signal mm_ss_temp : std_logic_vector (15 downto 0) := (others => '0'); -- 4st 4 bit to 1 16 bit
    signal rst_n : std_logic := '1'; -- reset value
    signal s_counter : unsigned(20 downto 0):=(others=>'0'); -- reset counter

    begin
    -- generic map(x) = amount of tick inbetween increment, en_i always 1 => '1' 
    inst_timer : timer generic map(1000000) port map(clk,rst_n,'1',mm_ss_temp(3 downto 0),mm_ss_temp(7 downto 4),mm_ss_temp(11 downto 8),mm_ss_temp(15 downto 12));  
    -- generic map(x) = amount of tick inbetween increment
    inst_seg7 : seg7_ctler generic map(10000) port map(clk,'1',mm_ss_temp,an,seg);

    -- reset generator
    process(clk)
    begin
        if (s_counter = to_unsigned(C_RST_SCALE_FACTOR, 21)) then -- counts up to 10 ms, then assers the reset
            s_counter <= (others =>'0'); 
            rst_n <= '0'; -- active low
        elsif rising_edge (clk) then -- increment
            rst_n <= '1'; -- active low
            s_counter <= s_counter + 1;
        end if;
    end process;


end architecture;