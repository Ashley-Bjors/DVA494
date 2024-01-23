library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity ArithLogic is
    port
    (
        A,
        B:in std_logic_vector (3 downto 0);
        AplusB,
        AandB,
        AxorB,
        AnandB,
        APlusOne,
        Ao,
        Bo,
        AllZero:out std_logic_vector (3 downto 0)
    );
end;
architecture Arch_ArithLogic of ArithLogic is
    begin
    AplusB <= A + B;
    AandB <= A and B;
    AxorB <= A xor B;
    AnandB <= A nor B;
    APlusOne <= A + "0001";
    Ao <= A;
    Bo <= B;
    AllZero <= "0000";
end;