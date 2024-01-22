--AND GATE
library ieee;
use ieee.std_logic_1164.all;
entity Gate_And_3 is
    port
    (
        in1     :in std_logic;
        in2     :in std_logic;
        in3     :in std_logic;
        result  :out std_logic
    );
end;
architecture Arch_And_3 of Gate_And_3 is
    signal temp: std_logic;
begin
    temp <= in1 and in2 and in3;
    result <= temp;
end;

--OR GATE
library ieee;
use ieee.std_logic_1164.all;
entity Gate_Or_4 is
    port
    (
        in1     :in std_logic;
        in2     :in std_logic;
        in3     :in std_logic;
        in4     :in std_logic;
        result  :out std_logic
    );
end;
architecture Arch_Or_4 of Gate_Or_4 is
    signal temp: std_logic;
begin
    temp <= in1 or in2 or in3 or in4;
    result <= temp;
end;

--NOT GATE
library ieee;
use ieee.std_logic_1164.all;
entity Gate_Not is
    port
    (
        in1     :in std_logic;
        result  :out std_logic
    );
end;
architecture Arch_Not of Gate_Not is
    signal temp: std_logic;
begin
    temp <= not in1 ;
    result <= temp;
end;

--Mulitplexer
library ieee;
use ieee.std_logic_1164.all;
entity Mux4To1Exp is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        i2      :in std_logic;
        i3      :in std_logic;
        s0      :in std_logic;
        s1      :in std_logic;
        out0    :out std_logic
    );
end;
architecture Arch_Mux4To1Exp of Mux4To1Exp is 
    component Gate_And_3 is
    port
    (
        in1     :in std_logic;
        in2     :in std_logic;
        in3     :in std_logic;
        result  :out std_logic
    );
    end component;
    component Gate_Or_4 is
    port
    (
        in1     :in std_logic;
        in2     :in std_logic;
        in3     :in std_logic;
        in4     :in std_logic;
        result  :out std_logic
    );
    end component;
    component Gate_Not is
        port
        (
            in1 :in std_logic;
            result:out std_logic
        );
    end component;
    signal NotS0 : std_logic;
    signal NotS1 : std_logic;
    signal temp0 : std_logic;
    signal temp1 : std_logic;
    signal temp2 : std_logic;
    signal temp3 : std_logic;
begin
    NotGate0 : Gate_Not port map(s0,NotS0);
    NotGate1 : Gate_Not port map(s1,NotS1);
    AndGate0 : Gate_And_3 port map(i0,NotS0,NotS1,temp0);
    AndGate1 : Gate_And_3 port map(i1,s0,NotS1,temp1);
    AndGate2 : Gate_And_3 port map(i2,NotS0,s1,temp2);
    AndGate3 : Gate_And_3 port map(i3,s0,s1,temp3);
    OrGate : Gate_Or_4 port map(temp0,temp1,temp2,temp3,out0);
end; 

--TestBench for Multiplexer
library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture tb_arch of tb is 
    component Mux4To1Exp is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        i2      :in std_logic;
        i3      :in std_logic;
        s0      :in std_logic;
        s1      :in std_logic;
        out0    :out std_logic
    );
end component;
       signal i0      : std_logic;
       signal i1      : std_logic;
       signal i2      : std_logic;
       signal i3      : std_logic;
       signal s0      : std_logic;
       signal s1      : std_logic;
       signal out0    : std_logic;
    begin 
        entity_instance_1 : Mux4To1Exp
        port map(i0,i1,i2,i3,s0,s1,out0);
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
            s1 <= '1';
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
            
        end process;
    end;