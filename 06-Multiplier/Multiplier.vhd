library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity Multiplier is
	generic (bn: integer:= 8;
			 double: integer:= 16);
   port
   (
      Nibble1, Nibble2: in std_logic_vector(bn-1 downto 0);
	  Rl,Rh:	out std_logic_vector(bn-1 downto 0)
   );
End Multiplier;

Architecture Behavioral of Multiplier is
    signal Result : unsigned(double - 1 downto 0);
Begin

   Result <= unsigned(Nibble1) * unsigned(Nibble2);
   rl <= std_logic_vector(Result(bn-1 downto 0));
   rh <= std_logic_vector(Result(double-1 downto bn));
End Behavioral;
