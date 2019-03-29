LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Mux_9bit is
    Port(
    PK : in  std_logic_vector(8 downto 0);
    IK : in  std_logic_vector(8 downto 0);
    SM9: in  std_logic;
    K  : out std_logic_vector(8 downto 0));
End Mux_9bit;

Architecture Behavioral of Mux_9bit is
Begin
    process(SM9)
    begin
        if(SM9 = '1') then
            K <= PK;
        else
            K <= IK;
        end if;
    end Process;
End Behavioral;
