LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Decode is
    Port(
    CLK    : in  std_logic;                       -- Relog Maestro
    RST    : in  std_logic;                       -- Reset Maestro
    M      : in  std_logic_vector(16 downto 0);   -- Entrada de Trama de la ROM
    Enc    : in  std_logic;                       -- Habilitacion de Decodificacion
    SDM8   : out std_logic;                       -- Seleccionador entre guardar en W o En memoria RAM DEMUX 8 Bits
    DataKi : out std_logic_vector(8 downto 0);    -- Direccion de Contador de Programa
    Data   : out std_logic_vector(7 downto 0);    -- Direccion de Memoria o literal
    SelB   : out std_logic_vector(2 downto 0);    -- Seleccionador de Bit
    IST    : out std_logic_vector(5 downto 0));   -- Instruccion
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

    IST   <= Qp(16 downto 11);
    Data  <= Qp(10 downto 3);
    DataKi<= Qp(10 downto 2);
    SDM8  <= NOT(Qp(2));
    SelB  <= Qp(2 downto 0);
End Decoding;

