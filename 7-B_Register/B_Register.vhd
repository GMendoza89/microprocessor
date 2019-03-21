LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
Entity B_Register is
	generic(n: integer := 8);	
	port(
	RST,CLK: in  std_logic;
	DIN    : in  std_logic_vector(n-1 downto 0);
	OPC    : in  std_logic_vector(1 downto 0);
    SelB   : in  std_logic_vector(2 downto 0);
    DBout  : out std_logic;  
	Dout   : out std_logic_vector(n-1 downto 0));
End B_Register;

Architecture Behavioral of B_Register is
signal Qp,Qn,Qb : std_logic_vector(n-1 downto 0);
Signal HB,HBC   : std_logic;
Begin
    
    
    BitCombinational: process(DIN,SelB)
    begin
        case SelB is
            when "000" =>
                Qb <= DIN(n-1 downto 1)&HB;
                HBC <= DIN(0);
             when "001" =>
                Qb <= Din(n-1 downto 2)&HB&DIN(0);
                HBC <= DIN(1);
             when "010" =>
                Qb <= Din(n-1 downto 3)&HB&DIN(1 downto 0);
                HBC <= DIN(2);
             when "011" =>
                Qb <= Din(n-1 downto 4)&HB&DIN(2 downto 0);
                HBC <= DIN(3);
            when "100" =>
                Qb <= Din(n-1 downto 5)&HB&DIN(3 downto 0);
                HBC <= DIN(4);
            when "101" =>
                Qb <= Din(n-1 downto 6)&HB&DIN(4 downto 0);
                HBC <= DIN(5);
            when "110" =>
                Qb <= Din(n-1)&HB&DIN(5 downto 0);
                HBC <= DIN(6);
            when others =>
                Qb <= HB&DIN(6 downto 0);
                HBC <= DIN(7);
    end case;
     end process BitCombinational;


	Combinational: process (Qp,OPC,DIN)
	begin
		case OPC is
            when "00" => HB <='0';                 -- Data bit clear
                         Qn <= Qb;
                         DBout <= 'X';
            when "01" => HB <= '1';
                         QN <= Qb;                -- Data Bit set
                         DBout <= 'X';
            when "10" => HB <= NOT(DIN(to_integer(unsigned(SelB)))); -- Data Bit toogle
                         Qn <= Qb;
                         DBout <= 'X';
            when others => Qn <= Din;              -- Data Bit Read
                           HB <= 'X';
                           DBout <= HBC;
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
