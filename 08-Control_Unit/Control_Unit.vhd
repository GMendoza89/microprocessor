LIBRARY IEEE;
USE	IEEE.std_logic_1164.all;

Entity Control_Unit is
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
--	RAs		: out std_logic;
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
End Control_Unit;

Architecture Behavioral of Control_Unit is
component B_Register 
	generic(n: integer := 8);	
	port(
	RST,CLK,G: in  std_logic;
	DIN    : in  std_logic_vector(n-1 downto 0);
	OPC    : in  std_logic_vector(1 downto 0);
    SelB   : in  std_logic_vector(2 downto 0);
    DBout  : out std_logic;  
	Dout   : out std_logic_vector(n-1 downto 0));
End	component;

Component Control
Port(
    RST,CLK : in  std_logic;
    SDM8    : in  std_logic;
    Sn      : in  std_Logic;
    Z       : in  std_Logic;
    V       : in  std_Logic;
    C       : in  std_Logic;
    G       : in  std_Logic;
    E       : in  std_Logic;
    L       : in  std_Logic;
    DataB   : in  std_logic;
    IST     : in  std_logic_vector(5 downto 0);
    ENDOP   : in  std_logic;
	OpB    :  out  std_logic_vector(1 downto 0):="00";
    S       : out std_logic_vector(3 downto 0);
	EnC     : out  std_logic;                       -- Habilitacion de Decodificacion
    STROP   : out std_logic;
    Ci      : out std_logic_vector(4 downto 0);
    Flag    : out std_logic;
    WoR     : out std_logic;
    LR      : out std_logic;
    RetW    : out std_logic_vector(1 downto 0));
End	 Component;

component Decode
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
End component; 
Component Instruction_FSM
	Port(
	 RST,CLK : in  std_logic;                        -- Reset Maestro y Relog Maestro
    STROP   : in  std_logic;                        -- Inicia Operacion a seleccionar
    CI      : in  std_logic_vector(4 downto 0);     -- Operacion a Iniciar
    FLAG    : in  std_logic;
    RetW    : in std_logic_vector(1 downto 0);      -- Seleccio de retornar W o limpiarlo
    Data    : in std_logic_vector(7 downto 0);      -- Dato de entrada Memoria o Direccion de RAM
    DataKi  : in std_logic_vector(8 downto 0);      -- Dato de entrada para la memoria de Programa
    WoR     : in  std_logic;                        -- Selecionador de Entrada a la ALU de Literal 0 O RAM 1
    LR      : in  std_logic;                        -- Seleccionar entre la operacion de RAM o de Literal 1 Ram 0 L
    Ki      : out std_logic_vector(8 downto 0);     -- Salida de Direccion en contador de programa
    SD      : out std_logic_vector(7 downto 0);     -- Salida de direccion de memoria RAM
    AI      : out std_logic_vector(7 downto 0);     -- Salida de Dato para operacion de Literal
    ENDOP   : out std_logic;                        -- Finalizacion de Ejecucion de Instruccion
    OPCW    : out std_logic_vector(1 downto 0);     -- Salida de Operacion de registro W
    WE      : out std_logic;                        -- Habilitacion de Escritura
    --RAs     : out std_logic;                        -- Registro RA para mantener dato obtenido de la RAM
    OPCS    : out std_logic_vector(1 downto 0);     -- Seleccionado de Operacion en el Stack
    ENM     : out std_logic;                        -- Habilitador del multiplicador
	 Ld      : out std_logic;                        -- Cargar valor en el contador del Programa
    INC     : out std_logic;                        -- Incrementar el valor del contador del Programa en 1
    INC2    : out std_logic;                        -- Incrementar el contador del Programa en 2
    SM9     : out std_logic;                        -- Seleccionar Valor en el multiplexor de 9 bits 0 pila 1 Ki
    SM8     : out std_logic;                        -- Seleccionar valor de multiplexor de 8 bits 1 literal 0 RAM
    SIRAM 	: out  std_logic_vector(1 downto 0);	-- Seleccionador de Multiplexor a la entrada de la RAM
	 EnDM8	: out std_logic;							-- Halilitador de Demultiplexor de resultado de salida de ALU
	 G			: out std_logic						-- COntrol bidireccional para registro W
	 );End component;

signal  Demux8, DataB, ENDOP, STROP, WoR, LR, EnC,FLAG, GB: std_logic;
signal	RetW,OpB  : std_logic_vector(1 downto 0);
signal SelB   : std_logic_vector(2 downto 0);
signal CI     : std_logic_vector(4 downto 0);
signal IST    : std_logic_vector(5 downto 0);
signal DataKi : std_logic_vector(8 downto 0);
signal Data	  : std_logic_vector(7 downto 0);



Begin
	BLK_Control: Control Port Map (RST, CLK, Demux8, Sn, Z, V, C, G, E, L, DataB, IST, ENDOP,OpB, S, EnC, STROP, Ci, Flag, WoR, LR, RetW);
	BLK_Decode : Decode	Port Map (CLK, RST, M, EnC , Demux8,DataKi, Data,SelB , IST);
	BLK_INSFSM : Instruction_FSM Port Map (RST,CLK, STROP, CI, FLAG, RetW, Data, DataKi, WoR, LR, Ki, SRAM, AI, ENDOP, OPCW, WE, OPCS, EnML, Ld, INC, INC2 , SM9, SM8, SIRAM, EnDM8, GB);
	BLK_BR	   : B_Register Port MAP (RST,CLK,GB, ORAM, OpB,SelB, DataB, IRAM);
	SDM8 <= Demux8;
End Behavioral;