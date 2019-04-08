library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity Multiplier is
	generic (bn: integer:= 8;
			 double: integer:= 16);
   port
   (
    RST, CLK, EnML : in std_logic;
      A, W: in std_logic_vector(bn-1 downto 0);
	  Rl,Rh:	out std_logic_vector(bn-1 downto 0)
   );
End Multiplier;

Architecture Behavioral of Multiplier is
    signal Qn,Qp : unsigned(double - 1 downto 0);
Begin
    Combinational: Process(EnML,A,W,Qp)
    begin
        if(EnML = '0') then 
            Qn <= unsigned(A) * unsigned(W);
        else
            Qn <= Qp;
        End if;
    end Process Combinational;

    Sequential: Process(RST,CLK)
    begin
        if(RST = '0') then
            Qp <= (others => '0');
        elsif(CLK'event and CLK = '1') then
            Qp <= Qn;
        end if;
    end Process Sequential;

   rl <= std_logic_vector(Qp(bn-1 downto 0));
   rh <= std_logic_vector(Qp(double-1 downto bn));
End Behavioral;
