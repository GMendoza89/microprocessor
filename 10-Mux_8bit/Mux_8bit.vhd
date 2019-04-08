LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Mux_8bit is
    Port(
    AI : in  std_logic_vector(7 downto 0);
    AR : in  std_logic_vector(7 downto 0);
    SM8: in  std_logic;
    A  : out std_logic_vector(7 downto 0));
End Mux_8bit;

Architecture Behavioral of Mux_8bit is
Begin
    process(SM8,AR,AI)
    begin
        if(SM8 = '0') then
            A <= AR;
        else
            A <= AI;
        end if;
    end Process;
End Behavioral;
