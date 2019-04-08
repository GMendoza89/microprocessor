LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity TB_B_Register is
    generic(n: integer :=8);
End TB_B_Register;

Architecture Simulation of TB_B_Register is
    component B_Register
	    generic(n: integer := 8);	
	    port(
	    RST,CLK: in  std_logic;
	    DIN    : in  std_logic_vector(n-1 downto 0);
	    OPC    : in  std_logic_vector(1 downto 0);
        SelB   : in  std_logic_vector(2 downto 0);
        DBout  : out std_logic;  
	    Dout   : out std_logic_vector(n-1 downto 0));
    end component;
    signal RST,CLK : std_logic:='0';
    signal DIN    :  std_logic_vector(n-1 downto 0);
	signal OPC    :  std_logic_vector(1 downto 0);
    signal SelB   :  std_logic_vector(2 downto 0);
    signal DBout  :  std_logic;  
	signal Dout   :  std_logic_vector(n-1 downto 0);
Begin
    SIMBLK: B_Register Port Map (CLK,RST,DIN,OPC,SelB,DBout,Dout);

    CLK <= not(CLK) after 10 ns;
    RST <= '1' AFTER 20 ns;
    DIN <= "10101010" after 20 ns;
    SelB <= "000","001"after 40 ns, "011" after 80 ns, "111" after 100 ns;
    OPC <= "10","01" after 100 ns, "00" after 120 ns, "11" after 140 ns;
End Simulation;

