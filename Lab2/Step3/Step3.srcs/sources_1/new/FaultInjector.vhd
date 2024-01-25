library ieee;
use ieee.std_logic_1164.all;
entity Fault_Inject is
    port(
         IA : in std_logic_vector( 3 downto 0);
         IB : in std_logic_vector( 3 downto 0);
         FaultLocation: in std_logic_vector (3 downto 0);
         Operation: in std_logic_vector (2 downto 0);
         
         FA : out std_logic_vector( 3 downto 0);
         FB : out std_logic_vector( 3 downto 0);
         FOperation: out std_logic_vector (2 downto 0)
    );
end;

architecture Arch_Fault_Inject of Fault_Inject is 
    begin
        case FaultLocation(3 downto 2)
            when "00"
                --A
                FA <= IA;
                FA(FaultLocation(1 downto 0)) <= not IA(FaultLocation(1 downto 0))
                FB <= IB;
                FOperation <= Operation

            when "01"
                --B
                FA <= IA;
                FB <= IB;
                FB(FaultLocation(1 downto 0)) <= not IB(FaultLocation(1 downto 0))
                FOperation <= Operation
            when "10"
                --Op
                if(FaultLocation(1 downto 0) == "11")
                    FA <= IA;
                    FB <= IB;
                    FOperation <= Operation
                else
                    FA <= IA;
                    FB <= IB;
                    FOperation <= Operation;
                    FOperation(FaultLocation(1 downto 0)) <= not Operation(FaultLocation(1 downto 0));
                    end if;
            when others
            FA <= IA;
            FB <= IB;
            FOperation <= Operation
        end case
--        begin
--            process -- because it's a theretical component -> no need for logic
--            begin
--            if(FaultLocation < "0100") then  -- failt location = 0000 -> 0011 == 0 until even 3
--            FA <= IA xor FaultLocation;
--            FB <= IB;
--            FOperation <= Operation;
--            
--            else if(FaultLocation < "1000" ) then -- failt location = 0100 -> 0111 == 4 until even 7
--            FB <= IB xor FaultLocation;
--            FA <= IA;
--            FOperation <= Operation;
--            
--            else if(FaultLocation < "1010" ) then -- failt location = 1000 -> 1001 == 8 until even 9
--            FOperation <= Operation xor FaultLocation(2 downto 0);
--            FA <= IA;
--            FB <= IB;
--            
--            else  -- fr�n 10 until 16
--            FA <= IA;
--            FB <= IB;
--            FOperation <= Operation;
--            end if;
--            
--            end process;
--         end architecture;
end;