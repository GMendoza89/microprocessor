LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity TB_W_Register is
    generic(n : integer := 8);
End TB_W_Register;

Architecture Simulation of TB_W_Register is
    Signal RST,CLK : std_logic := '0';
    signal DIN,Dout  : std_logic_vector(n-1 downto 0);
    signal OPC      : std_logic_vector(1 downto 0);
    component W_Register
        generic(n : integer := 8);
        port(
	    RST,CLK: in  std_logic;
	    DIN    : in  std_logic_vector(n-1 downto 0);
	    OPC    : in  std_logic_vector(1 downto 0);
	    Dout   : out std_logic_vector(n-1 downto 0));
    end component;
Begin
    SimBlk0: W_Register Port Map(RST,CLK,DIN,OPC,Dout);
    
    CLK <= not CLK after 10 ns;

    Testing: Process
    begin
        -- estado inical 
        RST <= '0';
        wait for 20 ns;
        RST <= '1';
        OPC <= "00";        -- mantenemos Dato
        DIN <= "11111110";  -- Dato de entrada FE
        wait for 20 ns;
        -- Cargamos el valor
        OPC <= "01";        -- Cargamos Dato
        wait for 20 ns;
        -- Estado 1
        OPC <= "00";
        DIN <= "01011010";   -- Dato 5A
        wait for 20 ns;
        -- Mantener Dato
        OPC <= "01";
        wait for 20 ns;
        --limpiar registro
        OPC <= "11";
        wait for 20 ns;
        OPC <= "10";
        wait;
    end process Testing;
End Simulation;
