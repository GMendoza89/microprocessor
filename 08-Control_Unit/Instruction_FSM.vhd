LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Instruction_FSM is
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
	 );
End Instruction_FSM;

Architecture Behavioral of Instruction_FSM is
    Signal Qp,Qn : std_logic_vector(4 downto 0);
Begin
   Combinational: Process(STROP, CI, FLAG, RetW, WoR, LR, Data, DataKi ,Qp)
   begin
       case Qp is
           when "00000" => -- Estado en espera a inicio de instruccion
               if(STROP = '1') then 
                   Qn <= CI;
               else
                   Qn <= Qp;
               end if; 
               ENDOP <= '1';
               Ki <= "000000000";-- Salida de direccion en 0 
               SD <= "00000000"; -- Salida de direccion 0
               AI <= "00000000"; -- Valor de Literal en 0
               OPCW <="00";      -- Registro W mantener
               We <= '1';        -- Escritura de la RAM inhabilitada
               --RAs <='1';        -- se mantiene dato en el regisro de la salida de la RAM
               OPCS <= "11";     -- STACK en NULL
               ENM <= '1';       -- Multiplicador deshabilitado
               Ld <= '1';        -- Sin cargar valor en el contador de Programa
               INC <= '1';       -- Sin Incremento en 1
               INC2 <= '1';      -- Sin Incremento en 2
               SM9 <= '1';       -- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= '1';       -- Salida del Multiplexor de 8 bits en la unidad de control
					EnDM8 <= '1';	 -- Habilitador de Demultiplexor
					
					SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';		 -- Control de direccion de Registro B
			   
			   
---------------------------------------------------Conjunto 1 y 2 --------------------------------------           
           
           when "00001" => 				-- inicia operacio de conjunto 1  de aplicaciones: [1,2,3,4,6,10,13,16,17,23,24,25,27,28,29,31,32]
               ENDOP <= '0';    		-- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               if (LR = '0') then 		-- seleccion de memoria de datos o de programa de la operacion
                   SD <= Data;
                   AI <= (others => '0');
               else
                    AI <= Data;
                    SD <= (others => '0');
                end if;
               OPCW <="00";     		-- Registro W mantiene
               We <= '1';       		-- Escritura de la RAM inhabilitada
               --RAs <= '0';      		-- Se gurada el valor de salida de la RAM
               OPCS <= "11";    		-- STACK en NULL
               ENM <= '1';      		-- Multiplicador deshabilitado
               Ld <= '1';       		-- Sin cargar valor en el contador de Programa
               INC <= '1';      		-- Sin Incremento en 1
               INC2 <= '1';      		-- Sin Incremento en 2
               SM9 <= '0';      		-- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= LR;
					EnDM8 <= '1';	 		-- Habilitador de Demultiplexor
					 		 		-- Habilitacion de multiplexor de Multiplicador
					SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';				-- 
					Qn <="00011";
            
				when "00010" =>   -- Se inicia Conjunto de aplicaciones 2 [5 26]
					ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= "000000000";-- Salida de direccion en 0 
               SD <= "00000000"; -- Salida de direccion 0
               AI <= "00000000"; -- Valor de Literal en 0
               OPCW <="00";      -- Registro W mantener
               We <= '1';        -- Escritura de la RAM inhabilitada
               --RAs <='1';        -- se mantiene dato en el regisro de la salida de la RAM
               OPCS <= "11";     -- STACK en NULL
               ENM <= '1';       -- Multiplicador deshabilitado
               Ld <= '1';        -- Sin cargar valor en el contador de Programa
               INC <= '1';       -- Sin Incremento en 1
               INC2 <= '1';      -- Sin Incremento en 2
               SM9 <= '1';       -- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= '1';       -- Salida del Multiplexor de 8 bits en la unidad de control
					EnDM8 <= '1';	 -- Habilitador de Demultiplexor
					 		 -- Habilitacion de multiplexor de Multiplicador
					SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';		 -- Control de direccion de Registro B
					Qn <= "00011";

            when "00011" => -- Se Guarda el Resultado de conjunto 1 y 2  de aplicaciones: : [1,2,3,4,6,10,13,16,17,23,24,25,27,28,29,31,32], [5,26]
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               if (LR = '0') then
                   SD <= Data;
                   AI <= (others => '0');
               else
                    AI <= Data;
                    SD <= (others => '0');
                end if;
               OPCW <='0'&WoR;     	-- 
               We <= WoR;        	-- 
               --RAs <='1';       	-- 
               OPCS <= "11";    	-- 
               ENM <= '1';      	-- 
               Ld <= '1';       	-- 
               INC <= '0';      	-- 
               INC2 <= '1';      	--  
               SM9 <= '0';      	-- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= LR;       	-- Salida del Multiplexor de 8 bits en la unidad de control
				EnDM8 <= '0';		-- Habilita de Demultiplexor-- 
				SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
				G <= '1';			-- 
				Qn <="00000"; 		-- 

-----------------------------------Conjunto 3 ---------------------------------------------------------------------

           when "00100" => 		-- inicia operacio de conjunto 3  de aplicaciones: [7,8,9,11,12,14,15,30]
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= Data;  	-- seleccion de memoria de datos
               AI <= (others => '0');
               OPCW <="00";     	-- Registro W mantiene
               We <= '1';       	-- 
               --RAs <= '0';      	-- Se guarda el valor de salida de la RAM
               OPCS <= "11";    	-- 
               ENM <= '1';      	-- 
               Ld <= '1';       	-- 
               INC <= '1';      	-- 
               INC2 <= '1';      	-- 
               SM9 <= '0';      	-- 
               SM8 <= '0';       	--
			   EnDM8 <= '1';		-- 
			   SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
               G <= '1';
			   Qn <="00101";
            
				when "00101" => -- Se Guarda el Resultado de conjunto 3  de aplicaciones: [7,8,9,11,12,14,15,30]
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               if (LR = '0') then
                   SD <= Data;
                   AI <= (others => '0');
               else
                    AI <= Data;
                    SD <= (others => '0');
                end if;
               OPCW <='0'&WoR;      -- Registro W mantiene
               We <= WoR;        	-- Escritura de la RAM dependiente de  WoR
               --RAs <='1';       	-- Se mntiene el valor accsedido de la Ram
               OPCS <= "11";    	-- 
               ENM <= '1';      	-- 
               Ld <= '1';       
				if(Flag = '1') then
				   INC  <= '1';
                   INC2 <= '0';     -- Incremento en 2 salta siguiente instruccion
               else
                   INC <= '0';      -- Incremento en 1 no salta intruccion
				   INC2 <='1';		-- 
				end if;
               SM9 <= '0';      	-- 
               SM8 <= '0';       	--
			   EnDM8 <= '0';		-- Se habilita demultiplexor
			    		 	-- 
			   SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
			   Qn <="00000";
----------------------------- Operacion especial MOVWF ------------------------------------------------------------

            when "00110" =>   	-- Se inicia Aplicacion MOVWF
				ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= "000000000";-- Salida de direccion en 0 
               SD <= Data; -- Salida de direccion 0
               AI <= "11111111"; -- Valor de Literal en 0
               OPCW <="00";
               We <= '1';        -- Escritura de la RAM inhabilitada
               --RAs <='1';        -- se mantiene dato en el regisro de la salida de la RAM
               OPCS <= "11";     -- STACK en NULL
               ENM <= '1';       -- Multiplicador deshabilitado
               Ld <= '1';        -- Sin cargar valor en el contador de Programa
               INC <= '1';       -- Sin Incremento en 1
               INC2 <= '1';      -- Sin Incremento en 2
               SM9 <= '1';       -- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= '1';       -- Salida del Multiplexor de 8 bits en la unidad de control
			   EnDM8 <= '1';	 -- Habilitador de Demultiplexor			
			   SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
			   G <= '1';		 -- Control de direccion de Registro B
			   Qn <= "00111";
				
            when "00111" => 	-- SE guarda w en F con ayuda de una AND
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= Data;
               AI <= (others => '1'); -- AND W con FF para mantener A
               OPCW <="00";     --        -- 
               We <= '0';       -- Escritura de la RAM habilitada
               --RAs <='1';       -- 
               OPCS <= "11";    -- 
               ENM <= '1';      -- 
               Ld <= '1';       -- 
               INC <= '0';      -- Incremento en 1
               INC2 <= '1';     --
               SM9 <= '0';      -- 
               SM8 <= '1';      --
			   EnDM8 <= '0';	-- Se habilita demultiplexor 
			   SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
			   G <= '1';
			   Qn <="00000"; 	-- 


------------------------------ Conjunto de Aplicaciones Orientadas a BIT ------------------------------------------
           when "01000" =>  	-- Inicia conjunto 4  de instrucciones: [33,34,37] 
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= Data;
               AI <= (others => '0');
               OPCW <="00";     -- 
               We <= '1';       -- 
               --RAs <= '1';      -- 
               OPCS <= "11";    -- 
               ENM <= '1';      -- 
               Ld <= '1';       -- 
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= '0';      -- 
			   EnDM8 <= '1';	--
			   SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
				G <= '0';
				Qn <="01001";

            when "01001" => -- Se Guarda el Resultado de operacion de bit de conjunto 4 de instrucciones 

               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= Data;
               AI <= (others => '0');
               OPCW <="00";     -- 
               We <= '0';       -- Escritura de la RAM habilitada
               --RAs <='1';       -- 
               OPCS <= "11";    -- 
               ENM <= '1';      -- 
               Ld <= '1';       -- Sin cargar valor en el contador de Programa
               INC <= '0';      -- Sin Incremento en 1
               INC2 <= '1';     -- Sin Incremento en 2
               SM9 <= '0';      -- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= '0';      -- Salida del Multiplexor de 8 bits en la unidad de control
				EnDM8 <= '1';	-- 
				SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
				G <= '0';		--
				Qn <="00000"; 	-- 

           when "01010" =>  -- Inicia conjunto 5  de instrucciones: [35,36] 
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= Data;
               AI <= (others => '0');
               OPCW <="00";     -- 
					We <= '0';       -- 
               --RAs <= '1';      -- 
               OPCS <= "11";    -- 
               ENM <= '1';      -- 
               Ld <= '1';       -- 
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= '0';       -- 
               EnDM8 <= '1';	-- 
				SIRAM  <= '0'&WoR;	     -- Seleccionador de multiplexor a la entrada de la RAM
				G <= '0';
				Qn <="01011";

            when "01011" => -- Se Guarda el Resultado de operacion de bit de conjunto 5 de instrucciones 
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= Data;
               AI <= (others => '0');
					OPCW <="00";     -- 
               We <= '1';       -- 
               --RAs <='1';       -- Se mntiene el valor accsedido de la Ram
               OPCS <= "11";    -- STACK en NULL
               ENM <= '1';      -- Multiplicador deshabilitado
               Ld <= '1';       -- Sin cargar valor en el contador de Programa
               if(FLAG = '1') then
                 INC <= '1';   	-- 
               	 INC2 <= '0';   -- Incremento en 2 Salta instruccion
               else
                 INC <= '0';   	--  Incremento en 1
               	 INC2 <= '1';   -- 
               end if;
               SM9 <= '0';      -- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= '0';      -- Salida del Multiplexor de 8 bits en la unidad de control
				EnDM8 <= '1';	-- 
				SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
				G <= '0';
				Qn <= "00000";

-------------------------------------- Operaciones de llamado ------------------------------------------------------
            when "01100" => -- Instruccion CALL
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= DataKi; 
               SD <= (others => '0');
               AI <= (others => '0');
               OPCW <="00";     -- 
               We <= '1';       -- 
               --RAs <= '0';      -- 
               OPCS <= "11";    -- Operacion del STACK en guardar
               ENM <= '1';      -- 
               Ld <= '1';       -- 
               INC <= '0';      -- Incremento en 1
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= '0';       --
					EnDM8 <= '1';	-- 
					 		-- 
					SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
               G <= '1';
					Qn <="01101";
            when "01101" => -- Se direcciona a la instruccion
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= DataKi; 
               AI <= (others => '0');
               SD <= (others => '0');
               OPCW <="00";     -- 
               We <= '1';        -- 
               --RAs <='1';       -- 
               OPCS <= "10";    -- STACK en NULL
               ENM <= '1';      -- 
               Ld <= '0';       -- Cargar valor en el contador de Programa
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= '0';      --
					EnDM8 <= '1';	-- 
					 		-- 
					SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
					Qn <="00000"; -- Ejecucion de Instruccion cargada

             when "01110" => 	-- Instruccion return
               ENDOP <= '0';    -- Estado de operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= (others => '0');
               AI <= (others => '0');
               OPCW <="11";     -- Registro W se mantiene o se recetea
               We <= '1';       -- 
               --RAs <= '1';      -- 
               OPCS <= "01";    -- se extrae valor del STACK
               ENM <= '1';      -- 
               Ld <= '0';       -- cargar valor en el contador de Programa
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '1';      -- 
               SM8 <= '0';      --
				EnDM8 <= '1';	--
				SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
               G <= '1';
				Qn <="00000"; 	-- Ejecucion de Instruccion cargada
			   
			when "01111" => 	-- Instruccion retlw
               ENDOP <= '0';    -- Estado de operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= (others => '0');
               AI <= Data;
               OPCW <="01";     -- Registro W cargar valor 
               We <= '1';       -- 
               --RAs <= '1';      -- 
               OPCS <= "01";    -- se extrae valor del STACK
               ENM <= '1';      -- 
               Ld <= '0';       -- cargar valor en el contador de Programa
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '1';      -- 
               SM8 <= '1';      --
				EnDM8 <= '0';	--
				SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
               G <= '1';
				Qn <="00000"; 	-- Ejecucion de Instruccion cargada

             when "10000" => 	-- Instruccion Goto
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= DataKi; 	-- se carga valor de A contador de Programa
               SD <= (others => '0');
               AI <= (others => '0');
               OPCW <="00";     -- 
               We <= '1';       -- 
               --RAs <= '0';      -- 
               OPCS <= "11";    -- 
               ENM <= '1';      -- 
               Ld <= '0';       -- 
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= '0';      --
				EnDM8 <= '1';	-- 
				SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
               G <= '1';
				Qn <="00000"; 	-- Ejecucion de Instruccion cargada
            
           when "10001" => -- Instruccion NOP
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= (others => '0');
               AI <= (others => '0');
               OPCW <="00";     -- 
               We <= '1';       -- 
               --RAs <= '0';      -- 
               OPCS <= "11";    --
               ENM <= '1';      -- 
               Ld <= '1';       -- 
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= LR;       -- 
				EnDM8 <= '1';	-- 
				SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
				G <= '1';
					Qn <="10010";
           when "10010" =>
               ENDOP <= '0';   
               Ki <= (others => '0'); 
               SD <= (others => '0');
               AI <= (others => '0');
					OPCW <="00";     -- 
               We <= '1';       -- 
               --RAs <= '0';      -- 
               OPCS <= "11";    --
               ENM <= '1';      -- 
               Ld <= '1';       -- 
               INC <= '0';      -- incremento en uno
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= LR;       -- 
					EnDM8 <= '1';	-- 
					 		-- 
					SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
               Qn <="00000";
 
             when "10011" => -- Instruccion Reset
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= "000000000"; 
               SD <= (others => '0');
               AI <= (others => '0');
               OPCW <=RetW;     -- Registro W mantiene
               We <= '1';       -- Escritura de la RAM inhabilitada
               --RAs <= '0';      -- Se gurada el valor de salida de la RAM
               OPCS <= "11";    -- Se lee siguiente direccion en el stack
               ENM <= '1';      -- Multiplicador deshabilitado
               Ld <= '0';       -- Sin cargar valor en el contador de Programa
               INC <= '1';      -- Sin Incremento en 1
               INC2 <= '1';      -- Sin Incremento en 2
               SM9 <= '1';      -- Salida de Multiplero de 9 bits al stack
               SM8 <= '0';       -- Salida del Multiplexor de 8 bits en la unidad de control
					EnDM8 <= '1';	 -- Habilitador de Demultiplexor
					 		 -- Habilitacion de multiplexor de Multiplicador
					SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
               Qn <="00000"; -- Ejecucion de Instruccion cargada
 
-------------------------------  operasiones de multiplicacion -----------------------------------------------------
            when "10100" => 	-- inicia operacio de multiplicacion
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               if (LR = '0') then -- seleccion de memoria de datos o de programa de la operacion
                   SD <= Data;
                   AI <= (others => '0');
               else
                    AI <= Data;
                    SD <= (others => '0');
                end if;
               OPCW <="00";     -- Registro W mantiene
               We <= '1';       -- 
               --RAs <= '1';      -- Se guarda el valor de salida de la RAM
               OPCS <= "11";    -- 
               ENM <= '0';      -- Multiplicador habilitado
               Ld <= '1';       -- 
               INC <= '1';      -- 
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= LR;       --
					EnDM8 <= '1';	 -- Habilitador de Demultiplexor
					 		 -- Habilitacion de multiplexor de Multiplicador
					SIRAM  <= "11";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
					Qn <="10101";
            
				when "10101" =>   -- Guardar reslutado alto de la multiplicacion
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= "00000000";
               AI <= (others => '0');
               OPCW <="00";      -- 
               We <= '0';        -- Escritura de la RAM habilitada
               --RAs <='1';        -- 
               OPCS <= "11";     -- 
               ENM <= '0';       -- Multiplicador deshabilitado
               Ld <= '1';        -- 
               INC <= '1';       -- 
               INC2 <= '1';      -- 
               SM9 <= '0';       -- 
               SM8 <= '1';       -- 
					EnDM8 <= '1';	 -- 
					
					SIRAM  <= "10";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
               Qn <="10110"; 	 --
			
			when "10110" =>   	 -- Guardar reslutado bajo de la multiplicacion
               ENDOP <= '0';    -- Estado de Operacion sin finalizar
               Ki <= (others => '0'); 
               SD <= "00000001";
               AI <= (others => '0');
               OPCW <="00";     -- 
               We <= '0';       -- Escritura de la RAM habilitada
               --RAs <='1';       -- 
               OPCS <= "11";    -- 
               ENM <= '0';      -- 
               Ld <= '1';       -- 
               INC <= '1';      -- Incremento en 1
               INC2 <= '1';     -- 
               SM9 <= '0';      -- 
               SM8 <= '1';      -- 
					EnDM8 <= '1';	 -- 
					SIRAM  <= "11";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
               Qn <="00000"; -- incremento en uno para la siguiente
			 
			
			   
			   
			   
           	 
			   
			  when others =>  -- estados inconclusos  
               ENDOP <= '1';
               Ki <= "000000000"; -- Salida de direccion en 0 
               SD <= "00000000";  -- Salida de direccion 0
               AI <= "00000000";  -- Valor de Literal en 0
               OPCW <="00";      -- Registro W mantiene
               We <= '1';        -- Escritura de la RAM inhabilitada
               --RAs <='1';        -- se mantiene dato en el regisro de la salida de la RAM
               OPCS <= "11";     -- STACK en NULL
               ENM <= '1';       -- Multiplicador deshabilitado
               Ld <= '1';        -- Sin cargar valor en el contador de Programa
               INC <= '1';       -- Sin Incremento en 1
               INC2 <= '1';       -- Sin Incremento en 2
               SM9 <= '1';       -- Salida de Multiplero de 9 bits de la unnidad de control
               SM8 <= '1';       -- Salida del Multiplexor de 8 bits en la unidad de control
					EnDM8 <= '1';	 -- Habilitador de Demultiplexor
					 		 -- Habilitacion de multiplexor de Multiplicador
					SIRAM  <= "01";	     -- Seleccionador de multiplexor a la entrada de la RAM
					G <= '1';
               Qn <=(others => '0');
       end Case;
   end Process Combinational;

   Sequential: Process(RST,CLK)
   begin
       if(RST = '0') then
           Qp <= (others => '0');
       elsif(CLK'event and CLK = '1') then
           Qp <= Qn;
       end if;
   end Process Sequential;
End Behavioral;

