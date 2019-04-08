LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Demux_8bit is
    port(
    R   : in  std_logic_vector(7 downto 0);
	EnDM8: in std_logic;
    SD8 : in  std_logic;
    AR  : out std_logic_vector(7 downto 0);
    BW  : out std_logic_Vector(7 downto 0));
    
End Demux_8bit;

Architecture Behavioral of Demux_8bit is
signal Ww,WR : std_logic;
Begin
	--control de salidas a el BUS Bidireccional de la RAM y Registro W
	Ww <= not(EnDM8) and SD8;
	WR <= EnDM8 NOR SD8;
    Process(R, Ww,WR)
    begin
		
        if(WR = '1') then
            AR <= R;
            BW <= (others => '0');
        elsif(Ww = '1')then
            AR <= (others => '0');
            BW <= R;
		else 
			AR <= (others => '0');
			BW <= (others => '0');
        end if;
    end process;
End Behavioral;



