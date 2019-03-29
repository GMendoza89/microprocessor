LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Decode is
    Port(
    CLK  : in  std_logic;
    RST  : in  std_logic;
    M    : in  std_logic_vector(16 downto 0);
    Enc  : in  std_logic;
    BCMD : out std_logic;
    Ki   : out std_logic_vector(8 downto 0);
    Ai   : out std_logic_vector(7 downto 0);
    SD   : out std_logic_vector(7 downto 0);
    SelB : out std_logic_vector(2 downto 0);
    IST  : out std_logic_vector(5 downto 0));
End Decode;

Architecture Decoding of Decode is
Signal Qp, Qn : std_logic_vector(16 downto 0);
Begin
    combinational: Process(M,QP,Enc)
    begin
        if(Enc = '1') then
            Qn <= M;
        else
            Qn <= Qp;
        end if;
    end Process Combinational;

    Sequential: Process(CLK,RST)
    begin
        if(RST = '0') then
            Qp <= (others => '0');
        elsif(CLK'event and CLK = '1') then
            Qp <= Qn;
        end if;
    end Process Sequential;

    IST <= Qp(16 downto 11);
    Ai <= Qp(10 downto 3);
    SD <= Qp(10 downto 3);
    Ki <= Qp(10 downto 2);
    BCMD <= Qp(3);
    SelB <= Qp(2 downto 0);
End Decoding;

