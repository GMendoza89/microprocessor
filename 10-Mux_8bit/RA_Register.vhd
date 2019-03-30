LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity RA_Register is
    Port(
    RST,CLK : in  std_logic;
    RAi     : in  std_logic_vector(7 downto 0);
    RAs     : in  std_logic;
    RAo     : out std_logic_vector(7 downto 0)
        );
End RA_Register;

Architecture Behavioral of RA_Register is
    signal Qn, Qp : std_logic_vector(7 downto 0);
Begin
    Combinational: Process(RAi,Qp,RAs)
    begin
        if(RAs = '1') then
            Qn <= Qp;
        else
            Qn <= RAi;
        end if;
    end Process Combinational;

    Sequential: Process(CLK,RST)
    begin
        if(RST = '0') then
            Qp <= (others => '0');
        elsif(CLK'event and CLK = '1') then
            Qp <= Qn;
        end if;
    end process Sequential;
    RAo <= Qp;
End Behavioral;

