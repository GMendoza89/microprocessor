LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
Entity B_Register is
	generic(n: integer := 8);	
	port(
	RST,CLK,G: in  std_logic;
	DIN    : in  std_logic_vector(n-1 downto 0);
	OPC    : in  std_logic_vector(1 downto 0);
    SelB   : in  std_logic_vector(2 downto 0);
    DBout  : out std_logic;  
	Dout   : out std_logic_vector(n-1 downto 0));
End B_Register;

Architecture Behavioral of B_Register is
signal Qp,Qn : std_logic_vector(n-1 downto 0);
Signal HBP,HBN   : std_logic;
Begin
    
    
    DBout <= HBP;
	Control:Process(G, Qp)
	begin
		if(G = '0') then
			Dout <= Qp;
		else
			Dout <= (others => '0');
		end if;
	end Process Control;
		
			
	Combinational: process (Qp,OPC,DIN,SelB)
	begin
		case OPC is
            when "00" => HBN <='0';                 -- Data bit clear
                         Qn <= DIN;
            when "01" => HBN <= '1';
                         QN <= DIN;                -- Data Bit set
            when "10" => HBN <= NOT(DIN(to_integer(unsigned(SelB)))); -- Data Bit toogle
                         Qn <= DIN;
            when others => Qn <= DIN;              -- Data Bit Read
                           HBN <= DIN(to_integer(unsigned(SelB)));
		end case;
	end process Combinational;

	Secuential: process(RST,CLK,SelB)
	begin
		if(RST='0') then
			Qp <= (others => '0');
            HBP <='0';
		elsif(CLK'event and CLK='1') then
			HBP <= HBN;
            case SelB is
                when "000" => Qp <= Qn(n-1 downto 1)&HBN;
                when "001" => Qp <= Qn(n-1 downto 2)&HBN&Qn(0);
                when "010" => Qp <= Qn(n-1 downto 3)&HBN&Qn(1 downto 0);
                when "011" => Qp <= Qn(n-1 downto 4)&HBN&Qn(2 downto 0);
                when "100" => Qp <= Qn(n-1 downto 5)&HBN&Qn(3 downto 0);
                when "101" => Qp <= Qn(n-1 downto 6)&HBN&Qn(4 downto 0);
                when "110" => Qp <= Qn(n-1)&HBN&Qn(5 downto 0);
                when others => Qp <=HBN&Qn(6 downto 0);
            end case;
		end if;
	end Process Secuential;
End Behavioral;
