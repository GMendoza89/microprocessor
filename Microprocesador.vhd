LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Microprocesador is
    Port(
    RST,CLK : in  std_logic;
    DSW     : in  std_logic_vector(7 downto 0);
    D0      : out std_logic_vector(6 downto 0);
    D1      : out std_logic_vector(6 downto 0);
    D2      : out std_logic_vector(6 downto 0);
    D3      : out std_logic_vector(6 downto 0);
    L0      : out std_logic_vector(7 downto 0);
	 L1		: out std_logic_vector(7 downto 0));
End Microprocesador;

Architecture Behavioral of Microprocesador is
    component ALU
         generic (n     : integer := 8;
              mid_n : integer := 4);
     port(    A : in  std_logic_vector(n-1 downto 0);
              B : in  std_logic_vector(n-1 downto 0);
              S : in  std_logic_vector(3 downto 0);
              R : out std_logic_vector(n-1 downto 0);
              Sn : out std_logic;
              Z : out std_logic;
              V : out std_logic;
              C : out std_logic;
              G : out std_logic;
              L : out std_logic;
              E : out std_logic);
    End component;

    Component W_Register
        generic(n: integer := 8);
     port(
        RST,CLK: in  std_logic;
        DIN    : in  std_logic_vector(n-1 downto 0);
        OPC    : in  std_logic_vector(1 downto 0);
        Dout   : out std_logic_vector(n-1 downto 0));
    end Component;

    Component Program_counter 
            generic(n : integer := 9);
     port (
        CLK,RST :in std_logic;
        Di      : in std_logic_vector(n-1 downto 0);        -- Número a cargar en el   contador
        Ld      : in std_logic;                              -- Cargar/habilitar
        INC     : in std_logic;                              -- Habilitar Incremento   en Uno
        INC2    : in std_logic;                              -- Habilitar Incremento   en 2
        Do      : out std_logic_vector(n-1 downto 0));      -- Salida o entrada de     contador
    end component;

    component RAM
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
    End Component;

    Component STACK
            generic(
         m : integer := 9;     --Numero de bits
         n : integer := 2;     -- Lineas de direccion
         k : integer := 9      -- Numero de localidades
         );
     port(
         RST : in std_logic;                         --Reset de control
         CLK : in std_logic;                         --Reloj Maestro
         OPR : in std_logic_vector(1 downto 0);      --Modo de operacion
         DE  : in std_logic_vector(m-1 downto 0);    --Dato de entrada
         DS  : out std_logic_vector(m-1 downto 0);   --Dato de salida
         E   : out std_logic;                        --Memoria vacia
         F   : out std_logic                         --Memoria llena
         );
    end Component;

    Component Multiplier 
             generic (bn: integer:= 8;
              double: integer:= 16);
    port
    (
     RST, CLK, EnML : in std_logic;
       A, W: in std_logic_vector(bn-1 downto 0);
       Rl,Rh:    out std_logic_vector(bn-1 downto 0)
    );
    end component;

    component ROM
        port(
       A : in  std_logic_vector(8 downto 0);
       D : out std_logic_vector(16 downto 0)
       );
    end component;

   component Control_Unit
	Port(
		RST,CLK : in std_logic;
	M		: in std_logic_Vector(16 downto 0);
	Sn		: in std_logic;
	Z		: in std_logic;
	V		: in std_logic;
	C		: in std_logic;
	G		: in std_logic;
	E		: in std_logic;
	L		: in std_logic;
	
	ORAM	: in std_logic_vector(7 downto 0);
	IRAM	: out std_logic_vector(7 downto 0);
	OPCW    : out std_logic_vector(1 downto 0);     -- Salida de Operacion de registro W
	SRAM	: out std_logic_vector(7 downto 0);
	--RAs		: out std_logic;
	KI		: out std_logic_vector(8 downto 0);
	AI		: out std_logic_vector(7 downto 0);
	SM8		: out std_logic;
	SM9		: out std_logic;
	SDM8	: out std_logic;
	EnML		: out std_logic;			   
	OPCS		: out std_logic_vector(1 downto 0);
	
	LD      : out std_logic;
	INC		: out std_logic;
	INC2	: out STD_Logic;
	
	S		: out std_logic_vector(3 downto 0);
	WE 		: out std_logic;
	SIRAM 	: out  std_logic_vector(1 downto 0);	-- Seleccionador de Multiplexor a la entrada de la RA
	
	EnDM8	: out std_logic							-- Halilitador de Demultiplexor de resultado de salida de ALU
	);
   end component;

   component Mux_9bit
           Port(
     PK : in  std_logic_vector(8 downto 0);
     IK : in  std_logic_vector(8 downto 0);
     SM9: in  std_logic;
     K  : out std_logic_vector(8 downto 0));
   end component;

   component Mux_8bit
       Port(
     AI : in  std_logic_vector(7 downto 0);
     AR : in  std_logic_vector(7 downto 0);
     SM8: in  std_logic;
     A  : out std_logic_vector(7 downto 0));
   end component;

   

   component Demux_8bit
            port(
     R   : in  std_logic_vector(7 downto 0);
	EnDM8: in std_logic;
    SD8 : in  std_logic;
    AR  : out std_logic_vector(7 downto 0);
    BW  : out std_logic_Vector(7 downto 0));
   end component;
	
	component MUX_Ram
port(
	SIRAM : in  std_logic_vector(1 downto 0);
	R		: in  std_logic_vector(7 downto 0);
	B		: in  std_logic_vector(7 downto 0);
	RMH	: in  std_logic_vector(7 downto 0);
	RML	: in  std_logic_vector(7 downto 0);
	IRAM	: out std_logic_vector(7 downto 0)
);
end component;

   signal LD,INC,INC2, EnML,Sn, Z, V, C, G, E, L, SM8, SM9, SDM8,  WE, EnDM8: std_logic;
   signal M: std_logic_vector(16 downto 0);
   signal Ki, DRom, K, Ks: std_logic_vector(8 downto 0);
   Signal IRAM,ORAM, SRAM, A, Ai, W, R, Bw, AR, RH, RL, DL0, DL1, DL2, DL3, LL0, BRAM, RRAM,RHRAM, RLRAM : std_logic_vector(7 downto 0);
   Signal S : std_logic_vector(3 downto 0);
   signal OPCW, OPCS, SIRAM  : std_Logic_vector(1 downto 0);

Begin

    BLK01_ConUnit: Control_Unit Port Map (RST, CLK, M, Sn, Z, V, C, G, E, L, ORAM, BRAM, OPCW, SRAM, Ki, Ai, SM8, SM9, SDM8, EnML, OPCS, LD, INC, INC2, S, WE, SIRAM, EnDM8);
    BLK02_ROM    : ROM Port Map (DRom, M);
    BLK03_PrCot  : Program_counter Port Map (CLK,RST, K, LD, INC, INC2, DRom);
    BLK04_STACK  : stack Port Map (RST, CLK, OPCS, DRom, Ks, open, open);
    BLK05_MUX9   : Mux_9bit Port Map (Ks,ki,SM9,K);
    BLK06_ALU    : ALU Port MAP (A,W,S,R,Sn,Z,V,C,G,L,E);
    BLK07_W      : W_Register Port Map (RST,CLK, Bw,OPCW, W);
    BLK08_DM8    : Demux_8bit Port Map(R,EnDM8, SDM8, RRAM, Bw);
    BLK09_MUX8   : Mux_8bit Port MAP (Ai, ORAM, SM8,A);
    BLK10_RAM    : RAM Port MAP (RST,CLK, SRAM, WE,IRAM, DL0,  DL1, DL2, DL3, LL0, ORAM);
    BLK11_Mull   : Multiplier Port Map(RST,CLK, EnML, A, W, RLRAM,RHRAM);
    BLK12_MUXRAM : MUX_Ram Port Map (SIRAM, RRAM,BRAM,RHRAM,RLRAM,IRAM);
	 D0 <= DL0(6 downto 0);
    D1 <= DL1(6 downto 0);
    D2 <= DL2(6 downto 0);
    D3 <= DL3(6 downto 0);
	 L0 <= LL0;
	 L1 <= DSW;
	 
End Behavioral;













