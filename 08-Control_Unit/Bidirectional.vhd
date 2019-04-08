LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Bidirectional is
    Port(
    FE : out std_logic_vector(7 downto 0);
    FS : in  std_logic_vector(7 downto 0);
    G  : in  std_logic;
    FBD: inout std_logic_vector(7 downto 0));
End Bidirectional;

Architecture Behavioral of Bidirectional is
Begin
    Process(FS,G,FBD)
    begin
        if (G='1') then
            FBD <= FS;
        else
            FBD <= (others => 'Z');
        end if;
        FE <= FBD;
    end process;
end Behavioral;

