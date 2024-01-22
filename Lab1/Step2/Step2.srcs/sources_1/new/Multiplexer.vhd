--AND GATE
library ieee;
use ieee.std_logic_1164.all;
entity Gate_And is
    port
    (
        in1     :in std_logic;
        in2     :in std_logic;
        result  :out std_logic
    );
end;
architecture Arch_And of Gate_And is
    signal temp: std_logic;
begin
    temp <= in1 and in2;
    result <= temp;
end;

--OR GATE
library ieee;
use ieee.std_logic_1164.all;
entity Gate_Or is
    port
    (
        in1     :in std_logic;
        in2     :in std_logic;
        result  :out std_logic
    );
end;
architecture Arch_Or of Gate_Or is
    signal temp: std_logic;
begin
    temp <= in1 or in2;
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
entity Mux2To1 is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        s0      :in std_logic;
        out0    :out std_logic
    );
end;
architecture Arch_Mux2To1 of Mux2To1 is 
    component Gate_And is
        port
        (
            in1 :in std_logic;
            in2 :in std_logic;
            result:out std_logic
        );
    end component;
    component Gate_Or is 
        port
        (
            in1 :in std_logic;
            in2 :in std_logic;
            result :out std_logic
        );
    end component;
    component Gate_Not is
        port
        (
            in1 :in std_logic;
            result:out std_logic
        );
    end component;
--  signal i0 : std_logic;
--  signal i1 : std_logic;
--  signal s0 : std_logic;
--  signal out0 : std_logic;
    signal tempS : std_logic;
    signal temp0 : std_logic;
    signal temp1 : std_logic;
begin
   NotGate : Gate_Not port map(s0,tempS);
   AndGate0 : Gate_And port map(i0,tempS,temp0);
   AndGate1 : Gate_And port map(i1,s0,temp1);
   OrGate : Gate_Or port map(temp0,temp1,out0);
end; 

--TestBench for Multiplexer
library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture tb_arch of tb is 
    component Mux2To1 is
    port
    (
        i0      :in std_logic;
        i1      :in std_logic;
        s0      :in std_logic;
        out0    :out std_logic
    );
    end component;
    signal i0      : std_logic;
    signal i1      : std_logic;
    signal s0      : std_logic;
    signal out0    : std_logic;
    begin 
        entity_instance_1 : Mux2To1
        port map(i0,i1,s0,out0);
        process is
        begin
            i0 <= '0';
            i1 <= '0';
            s0 <= '0';
            wait for 10 ps;  
            
            i0 <= '1';
            i1 <= '0';
            s0 <= '0';
            wait for 10 ps;
            
            i0 <= '0';
            i1 <= '1';
            s0 <= '0';
            wait for 10 ps;
                      
            i0 <= '1';
            i1 <= '1';
            s0 <= '0';
            wait for 10 ps;
            
            i0 <= '0';
            i1 <= '0';
            s0 <= '1';
            wait for 10 ps;
            
            i0 <= '1';
            i1 <= '0';
            s0 <= '1';
            wait for 10 ps;
            
            i0 <= '0';
            i1 <= '1';
            s0 <= '1';
            wait for 10 ps;
            
            i0 <= '1';
            i1 <= '1';
            s0 <= '1';
            wait for 10 ps;
        end process;
    end;