library ieee;
use ieee.std_logic_1164.all;
entity tb is end;
architecture tb_arch of tb is
    component ArithLogic is
        port
        (
            A,B:in std_logic_vector (3 downto 0);
            AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero:out std_logic_vector (3 downto 0)
        );
    end component;
    signal A,B: std_logic_vector (3 downto 0);
    signal AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero: std_logic_vector (3 downto 0);
    begin   
    TestBenchArithLogic: ArithLogic
        port map(A,B,AplusB,AandB,AxorB,AnandB,APlusOne,Ao,Bo,AllZero);
    process is
    begin
        A <= "0000";
        B <= "0000";
        wait for 10 ps;

        A <= "1000";
        B <= "1000";
        wait for 10 ps;

        A <= "1111";
        B <= "0000";
        wait for 10 ps;

        A <= "1010";
        B <= "0101";
        wait for 10 ps;

        A <= "1100";
        B <= "1100";
        wait for 10 ps;

        A <= "1111";
        B <= "1100";
        wait for 10 ps;
    end process;
end;

