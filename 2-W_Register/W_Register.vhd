LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
Entity W_Register is
	generic(n: integer := 8);	
	port(
	RST,CLK: in  std_logic;
	DIN    : in  std_logic_vector(n-1 downto 0);
	OPC    : in  std_logic_vector(1 downto 0);
	Dout   : out std_logic_vector(n-1 downto 0));
End W_Register;

Architecture Behavioral of W_Register is
signal Qp,Qn : std_logic_vector(n-1 downto 0);

Begin
	Combinational: process (Qp,OPC,DIN)
	begin
		case OPC is
			when "00" => Qn <= Qp;                 -- HOLD
			when "01" => Qn <= DIN;                -- WRITE
            when others => Qn <= (others => '0');  -- CLEAR
		end case;
	end process Combinational;
	Dout <= Qp;
	Secuential: process(RST,CLK)
	begin
		if(RST='0') then
			Qp <= (others => '0');
		elsif(CLK'event and CLK='1') then
			Qp <= Qn;
		end if;
	end Process Secuential;
End Behavioral;
