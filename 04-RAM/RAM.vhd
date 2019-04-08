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
		RST, CLK: in std_logic;
        AE : in  std_logic_vector(n-1 downto 0);    -- Direccion de eEscritura
        WE: in  std_logic;
        DE : in std_logic_vector(m-1 downto 0);
		D0: out std_logic_vector(m-1 downto 0);    -- Display 0 de la fpga
        D1: out std_logic_vector(m-1 downto 0);    -- Display 1 de la FPGA
        D2: out std_logic_vector(m-1 downto 0);    -- Display 2 de la FPGA
        D3: out std_logic_vector(m-1 downto 0);    -- Display 3 de la FPGA
        L : out std_logic_vector(m-1 downto 0);    -- Salida a LEDS de la FPGA
        D : out std_logic_vector(m-1 downto 0)   -- Datos
        );
End RAM;

Architecture Generic_Array of RAM is
    subtype Registry_width  is std_logic_vector(m-1 downto 0);
    type    Memory is array(natural range <>) of Registry_width;
    signal RAM_Memory : Memory(0 to K-1);
    --signal DS     : std_logic_vector(m-1 downto 0);
    signal A1       : std_logic_vector(n-1 downto 0);
	
begin
    --Control de Lectura
    Read: process(A1,RAM_Memory)
    begin
        
        D <= RAM_Memory(to_integer(unsigned(A1)));
		D0 <=  RAM_Memory(2); -- los 7 menos significativos 
    	D1 <=  RAM_Memory(3);
    	D2 <=  RAM_Memory(4);
    	D3 <=  RAM_Memory(5);
    	L  <=  RAM_Memory(6);
    end Process Read;
	-- Control de escritura
    Write: process(RST,CLK,WE,DE,AE)
    begin
		if (RST = '0') then
			for i in 0 to K-1 loop
				RAM_Memory(i) <="00000000";	
			end Loop;
        elsif(CLK'event and CLK = '1')then
			if(WE = '0') then
            	RAM_Memory(to_integer(unsigned(AE))) <= DE;
			end if;
			A1 <= AE;
        end if;
    end process Write;

End Generic_Array;
