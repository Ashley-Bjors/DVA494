library ieee;
use ieee.std_logic_1164.all;

entity double_mux is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        i2      :in std_logic;
        i3      :in std_logic;
        s0      :in std_logic;
        s1      :in std_logic;
        out0    :out std_logic;
        out1    :OUT std_logic 
    );
end;

architecture Arch_double_mux of double_mux is
    component Mux4To1Inst is
     port
    (
        i0,i1,i2,i3     :in std_logic;
        s0,s1     :in std_logic;
        out0  :out std_logic
    );
    end component;
    component Mux4To1Exp is
     port
    (
        i0,i1,i2,i3     :in std_logic;
        s0,s1     :in std_logic;
        out0  :out std_logic
    );
    end component;

 begin
  
  mux0 : Mux4To1Exp port map(i0,i1,i2,i0,s0,s0,out0);
  mux1 : Mux4To1Inst port map(i0,i1,i2,i0,s0,s0,out1);
  
end;


library ieee;
use ieee.std_logic_1164.all;

entity tb is end;
architecture Arch_tb of tb is
 component double_mux is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        i2      :in std_logic;
        i3      :in std_logic;
        s0      :in std_logic;
        s1      :in std_logic;
        out0    :out std_logic;
        out1    :out std_logic
    );
  end component; 
  
  signal i0,i1,i2,i3,s0,s1,out0,out1 : std_logic;
  
  begin
   Mux : double_mux port map(i0,i1,i2,i3,s0,s1,out0,out1);
   process is
   begin
   i0 <= '0';
            i1 <= '0';
            i2 <= '0';
            i3 <= '0';
            s0 <= '0';
            s1 <= '0';
            wait for 10 ps;  
            

            i1 <= '1';
            s0 <= '1';
            wait for 10 ps;  
            
            i3 <= '1';
            s1 <= '1';
            wait for 10 ps;  
            
            i2 <= '1';
            s0 <= '0';
            wait for 10 ps;  
            
            i0 <= '1';
            s1 <= '0';
            wait for 10 ps;  
            
            i0 <= '0';
            i1 <= '0';
            i2 <= '0';
            i3 <= '0';
            s0 <= '1';
            s1 <= '1';
            wait for 10 ps;  
            
            i0 <= '1';
            wait for 10 ps;  
            
            i1 <= '1';
            wait for 10 ps;
            
            i2 <= '1';
            wait for 10 ps;
            
            i3 <= '1';
            wait for 10 ps;

            i0 <= '1';
            i1 <= '1';
            i2 <= '1';
            i3 <= '0';
            s0 <= '1';
            s1 <= '1';
            wait for 10 ps;  
            
            i0 <= '0';
            i1 <= '1';
            i2 <= '1';
            i3 <= '1';
            s0 <= '0';
            s1 <= '0';
            wait for 10 ps;  
            
            i0 <= '1';
            i1 <= '0';
            i2 <= '1';
            i3 <= '1';
            s0 <= '1';
            s1 <= '0';
            wait for 10 ps; 
            
            i0 <= '1';
            i1 <= '1';
            i2 <= '0';
            i3 <= '1';
            s0 <= '0';
            s1 <= '1';
            wait for 10 ps;   
            
            i0 <= '1';
            i1 <= '0';
            i2 <= '0';
            i3 <= '1';
            s0 <= '1';
            s1 <= '1';
            wait for 10 ps;  
   end process;
 end;