LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;


Entity Program_counter is 
    generic(n : integer := 9);
    port (
    CLK,RST :in std_logic;
	Di      : in std_logic_vector(n-1 downto 0);        -- Número a cargar en el contador
	Ld	    : in std_logic;                              -- Cargar/habilitar
	INC     : in std_logic;	                             -- Habilitar Incremento en Uno
    INC2    : in std_logic;                              -- Habilitar Incremento en 2
	Do      : out std_logic_vector(n-1 downto 0));      -- Salida o entrada de contador
end Program_counter;

Architecture Behavioral of Program_counter is
    signal Qn,Qp : unsigned( n-1 downto 0 );
Begin

    Combinational: Process (Qp,Ld,INC,INC2,Di)
    begin
        if (Ld = '1') then
            Qn <= unsigned(Di);
        elsif (INC = '1') then
            Qn <= Qp + 1;
        elsif(INC2 = '1') then
            Qn  <= Qp + 2;
        else
            Qn <= Qp;
        end if;
    end Process Combinational;

    Secuential: Process(RST,CLK)
    begin
        if(RST = '0') then
            Qp <= (others => '1');
        elsif(CLK'event and CLK = '1') then
            Qp <= Qn;
        end if;
    end Process Secuential;
    Do <= std_logic_vector(Qp);
End Behavioral;
	
			
										   
