LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity RAM is
    generic(
        m : integer := 8;                         -- Número de bits
        n : integer := 8;                         -- Lineas de Dirección
        k : integer := 256                        -- Número de Localidades
           );
    Port(
        A : in  std_logic_vector(n-1 downto 0);    -- Direcciones
        RD: in  std_logic;                         -- Lectura
        WE: in  std_logic;                         -- Escrittura
        CS: in  std_logic;                         -- Habilitación
        ML: in  std_logic_vector(n-1 downto 0);    -- Resultado byte menos significativos del Resultado de la multiplicación
        MH: in  std_logic_vector(n-1 downto 0);    -- Resultado byte menos significativos del Resultado de la multiplicación
        SW: in std_logic_vector(n-1 downto 0);     -- Entrada  de los Dip switch
        D0: out std_logic_vector(n-1 downto 0);    -- Display 0 de la fpga
        D1: out std_logic_vector(n-1 downto 0);    -- Display 1 de la FPGA
        D2: out std_logic_vector(n-1 downto 0);    -- Display 2 de la FPGA
        D3: out std_logic_vector(n-1 downto 0);    -- Display 3 de la FPGA
        L : out std_logic_vector(n-1 downto 0);    -- Salida a LEDS de la FPGA
        D : inout std_logic_vector(m-1 downto 0)   -- Datos
        );
End RAM;

Architecture Generic_Array of RAM is
    subtype Registry_width  is std_logic_vector(m-1 downto 0);
    type    Memory is array(natural range <>) of Registry_width;
    signal RAM_Memory : Memory(0 to K-1);
    signal DE, DS     : std_logic_vector(m-1 downto 0);
    signal G, W       : std_logic;
begin
    --Control de Lectura
    Read: process(CS,RD,WE,A,D,RAM_Memory)
    begin
        W  <= CS OR WE;
        G  <= CS NOR RD;
        DE <= D;
        DS <= RAM_Memory(to_integer(unsigned(A)));
    end Process Read;
    --Control Bidireccional
    Bidirectional: Process(G,DS)
    begin
        if(G='1') then
            D <= DS;
        else
            D <= (others => 'Z');
        end if;
    end process Bidirectional;
    --Control de Escritura
    Write: process(W)
    begin
        if(W'event and W='1')then
            RAM_Memory(to_integer(unsigned(A))) <= D;
        end if;
    end process write;
    RAM_Memory(0) <= MH;
    RAM_Memory(1) <= ML;
    D0 <=  RAM_Memory(2);
    D0 <=  RAM_Memory(3);
    D0 <=  RAM_Memory(4);
    D0 <=  RAM_Memory(5);
    L  <=  RAM_Memory(6);
    RAM_Memory(7) <= SW;
End Generic_Array;
