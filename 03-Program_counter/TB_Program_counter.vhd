LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity TB_Program_counter is
    generic(n : integer := 9);
End TB_Program_counter;

Architecture Simulation of TB_Program_counter is
    component  Program_counter 
    generic(n : integer := 9);
    port (
    CLK,RST :in std_logic;
	Di      : in std_logic_vector(n-1 downto 0);        -- Número a cargar en el contador
	Ld	    : in std_logic;                              -- Cargar/habilitar
	INC     : in std_logic;	                             -- Habilitar Incremento en Uno
    INC2    : in std_logic;                              -- Habilitar Incremento en 2
	Do      : out std_logic_vector(n-1 downto 0));      -- Salida o entrada de contador
    end component;

    signal RST,Ld,INC,INC2 : std_logic;
    signal CLK : std_logic := '0';
    signal Di,Do : std_logic_vector(n-1 downto 0);
    
Begin

    SimBLK: Program_counter Port Map (CLK,RST,Di,Ld,INC,INC2,Do);

    CLK <= NOT(CLK) after 10 ns;
    RST <= '0','1' after 40 ns;
    Ld <= '0','1' after 80 ns,'0' after 100 ns;
    INC <= '0','1' after 40 ns, '0' after 60 ns,'1' after 100 ns, '0' after 160 ns;
    INC2 <= '0','1'after 60 ns, '0'after 80 ns, '1' after 160 ns, '0' after 200 ns;
    Di <= "000011111";
End Simulation;




