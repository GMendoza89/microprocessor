LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Demux_8bit is
    port(
    R   : in  std_logic_vector(7 downto 0);
    SD8 : in  std_logic;
    AR  : out std_logic_vector(7 downto 0);
    BW  : out std_logic_Vector(7 downto 0));
    
End Demux_8bit;

Architecture Behavioral of Demux_8bit is
Begin
    Process(SD8)
    begin
        if(SD8 = '1') then
            AR <= R;
            BW <= (others => 'Z');
        else
            AR <= (others => 'Z');
            BW <= R;
        end if;
    end process;
End Behavioral;


