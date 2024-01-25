library ieee;
use ieee.std_logic_1164.all;
entity Max4Bit8To1 is
    port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        i2:in std_logic_vector (3 downto 0);
        i3:in std_logic_vector (3 downto 0);
        i4:in std_logic_vector (3 downto 0);
        i5:in std_logic_vector (3 downto 0);
        i6:in std_logic_vector (3 downto 0);
        i7:in std_logic_vector (3 downto 0);
        s0:in std_logic_vector (2 downto 0);
        o:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_Max4Bit8To1 of Max4Bit8To1 is
    component Max4Bit4To1 is
        port
        (
            i0:in std_logic_vector (3 downto 0);
            i1:in std_logic_vector (3 downto 0);
            i2:in std_logic_vector (3 downto 0);
            i3:in std_logic_vector (3 downto 0);
            s0:in std_logic_vector (1 downto 0);
            o:out std_logic_vector (3 downto 0)
        );
    end component;
    component Max4Bit2To1 is
        port
        (
            i0:in std_logic_vector (3 downto 0);
            i1:in std_logic_vector (3 downto 0);
            s0:in std_logic;
            o:out std_logic_vector (3 downto 0)
        );
    end component;
    signal Max4Bit4To1_Temp1:std_logic_vector (3 downto 0);
    signal Max4Bit4To1_Temp2:std_logic_vector (3 downto 0);
begin

    Max4Bit4To1_1:Max4Bit4To1 port map(i7,i6,i5,i4,s0(1 downto 0),Max4Bit4To1_Temp1);
    Max4Bit4To1_2:Max4Bit4To1 port map(i3,i2,i1,i0,s0(1 downto 0),Max4Bit4To1_Temp2);
    Max4Bit2To1_1:Max4Bit2To1 port map(Max4Bit4To1_Temp1,Max4Bit4To1_Temp2,s0(2),o);
end;



library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture arch_tb of tb is
    component Max4Bit8To1 is
     port
    (
        i0:in std_logic_vector (3 downto 0);
        i1:in std_logic_vector (3 downto 0);
        i2:in std_logic_vector (3 downto 0);
        i3:in std_logic_vector (3 downto 0);
        i4:in std_logic_vector (3 downto 0);
        i5:in std_logic_vector (3 downto 0);
        i6:in std_logic_vector (3 downto 0);
        i7:in std_logic_vector (3 downto 0);
        s0:in std_logic_vector (2 downto 0);
        o:out std_logic_vector (3 downto 0)
    );

end component;
 signal i0,i1,i2,i3,i4,i5,i6,i7,o : std_logic_vector (3 downto 0);
 signal s0 :std_logic_vector (2 downto 0);
 
begin
 Max4Bit8To1_temp0: Max4Bit8To1 port map(i0,i1,i2,i3,i4,i5,i6,i7,s0,o);
  process is 
  begin
  
  i0 <= "0000";
  i1 <= "0001";
  i2 <= "0010";
  i3 <= "0011";
  i4 <= "0100";
  i5 <= "0101";
  i6 <= "0110";
  i7 <= "0111";
  s0 <= "000";
  wait for 10 ps;
  

  s0 <= "001";
  wait for 10 ps;
  
   s0 <= "010";
  wait for 10 ps;
  
   s0 <= "011";
  wait for 10 ps;
  
   s0 <= "100";
  wait for 10 ps;
  
   s0 <= "101";
  wait for 10 ps;
  
   s0 <= "110";
  wait for 10 ps;
  
   s0 <= "111";
  wait for 10 ps;
  
  end process;
end;
