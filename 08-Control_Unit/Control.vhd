LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Control is
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
End Control;

Architecture Behavioral of Control is
    signal Qn ,Qp : std_logic_vector(1 downto 0);
Begin
	FSM: Process(ENDOP, Qp)
    begin
		case Qp is
			when "00" =>  -- Decodifico instruccion
				STROP <= '0';
				EnC <= '1';
				Qn <= "01";
			when "01" => -- Ejecuto instruccion
				STROP <= '1';
				EnC <= '0';
				Qn <= "10";
			when others => -- Esepero a termino de instruccion
				STROP <= '0';
				EnC <= '0';
			if (ENDOP = '1') then
				Qn <= "00";
			else
				Qn <= Qp;
			end if;
		end case;
    end Process FSM;
	
	Sequential:Process(CLK,RST)
	begin
		if (RST = '0') then
			Qp <="00";
		elsif(CLK'event and CLK ='1') then
			Qp<=Qn;
		end if;
		end process Sequential;

    Selection: Process(IST,Sn,Z,V,C,G,E,L,DataB,SDM8)
    begin
        case IST is
            when "000000" =>   -- AddWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0000";    -- Seleccion de La ALU ADD
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W
				

            when "000001" =>   -- AddLL
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0000";    -- Seleccion de La ALU ADD
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '1';     -- Seleccion de Literal
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "000010" =>   -- AndWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0001";    -- Seleccion de La ALU AND
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "000011" =>   -- Andlw
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0001";    -- Seleccion de La ALU AND
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '1';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "000100" =>   -- CLRF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0010";    -- Seleccion de La ALU clear
                CI <= "00010"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "000101" =>   -- COMP
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0011";    -- Seleccion de La ALU not
                CI <= "00001"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "000110" =>   -- CFSEQ
                OpB <= "11";		-- Operacion de Registro B Read BIT
				S <="0100";    -- Seleccion de La ALU compara
                CI <= "00100"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= E;    --  Bandera Igual
                RetW <= "00";    -- no se usa la opcion de W

            when "000111" =>   -- CFSGQ
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0100";    -- Seleccion de La ALU compara
                CI <= "00100"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= G;    -- Bandera Mayor
                RetW <= "00";    -- no se usa la opcion de W

            when "001000" =>   -- CFSLQ
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0100";    -- Seleccion de La ALU compara
                CI <= "00100"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= L;    --  Bandera Menor
                RetW <= "00";    -- no se usa la opcion de W

            when "001001" =>   -- DecF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0101";    -- Seleccion de La ALU A-1
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- W

            when "001010" =>   -- DECFSZ
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0101";    -- Seleccion de La ALU A - 1
                CI <= "00100"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <=  Z;    -- Bandera del  Zero
                RetW <= "00";    --

            when "001011" =>   -- DECFSNZ
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0101";    -- Seleccion de La ALU A - 1
                CI <= "00100"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- 
                FLAG <= NOT(Z);    -- Bandera del Zero
                RetW <= "00";    --

            when "001100" =>   -- INCF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0110";    -- Seleccion de La ALU A + 1
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- 

            when "001101" =>   -- INCFSZ
					OpB <= "11";		-- Operacion de Registro B Read BIT
                S <="0110";    -- Seleccion de La ALU A + 1
                CI <= "00100"; -- 
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- 
                FLAG <= Z;    -- Bandera del Zero
                RetW <= "00";    --

            when "001110" =>   -- INCFSNZ
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0110";    -- Seleccion de La ALU A + 1
                CI <= "00100"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= NOT(Z);    -- Bandera del 0
                RetW <= "00";    --
                
            when "001111" =>   -- IORWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0111";    -- Seleccion de La OR
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010000" =>   -- IORLF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0111";    -- Seleccion de La OR
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '1';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010001" =>   -- MOVF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La MOV
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010010" =>   -- MOVWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="0001";    -- Seleccion de La ALU AND
                CI <= "00110"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '1';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010011" =>   -- MOVLW
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La MOV
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '1';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010100" =>   -- MULWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La MOV
                CI <= "10100"; -- Seleccion de Inicio de maquina de estado
                WoR <= '1';   -- 
                LR <= '1';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010101" =>   -- MULLW
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La MOV
                CI <= "10100"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010110" =>   -- Complement's 2 F
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1001";    -- Seleccion de La ALU Complemento a 2
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "010111" =>   -- RTLNC
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1010";    -- Seleccion de La ALU Rotar a la izquierda
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "011000" =>   -- RTRNC
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1011";    -- Seleccion de La ALU Rotar a la Derechaº
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- 
                LR <= '0';     -- 
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    --

            when "011001" =>   -- SETF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1100";    -- Seleccion de La ALU SET  
                CI <= "00010"; -- Seleccion d Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "011010" =>   -- SUBWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1101";    -- Seleccion de La ALU A - B
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de la RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "011011" =>   -- SUBLW
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1101";    -- Seleccion de La ALU A - B
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de Literal
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "011100" =>   -- SWAPF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1110";    -- Seleccion de La ALU SWAP
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "011101" =>   -- TSTFSZ
					OpB <= "11";		-- Operacion de Registro B Read BIT
                S <="1000";    -- Seleccion de La ALU MOV
                CI <= "00100"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de Literal
                FLAG <= Z;    -- Bandera del 0
                RetW <= "00";    -- no se usa la opcion de W


            when "011110" =>   -- XORWF
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1111";    -- Seleccion de La ALU XOR
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "011111" =>   -- XORLW
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1111";    -- Seleccion de La ALU ADD
                CI <= "00001"; -- Seleccion de Inicio de maquina de estado
                WoR <= SDM8;   -- Salida Demux de La RAM
                LR <= '1';     -- Seleccion de Literal
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "100000" =>   -- BCF 
				    OpB <= "00";		-- Operacion de Registro B CLEAR BIT 
                S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01000"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W


            when "100001" =>   -- BSF
				    OpB <= "01";		-- Operacion de Registro B Set Bit BIT
                S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01000"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
               RetW <= "00";    -- no se usa la opcion de W

            when "100010" =>   -- BTFSZ
				    OpB <= "11";		-- Operacion de Registro B Read BIT
                S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01010"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= DataB;    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "100011" =>   -- BTFSZ
					 OpB <= "11";		-- Operacion de Registro B Read BIT
                S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01010"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= NOT(DataB);    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "100100" =>   -- BTF
					OpB <= "01";		-- Operacion de Registro B Toogle BIT
                S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01000"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "100101" =>   -- CALL  
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01100"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "100110" =>   -- GOTO 
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La ALU ADD
                CI <= "10000"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W

            when "100111" =>   -- NOP 
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La ALU ADD
                CI <= "10001"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W


            when "101000" =>   -- RETLW 
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01111"; -- Seleccion de Inicio de maquina de estado
                WoR <= '1';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "01";    -- no se usa la opcion de W

            when "101001" =>   -- RETURN 
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La ALU ADD
                CI <= "01110"; -- Seleccion de Inicio de maquina de estado
                WoR <= '1';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "11";    -- no se usa la opcion de W

            when OTHERS =>   -- RESET 
                OpB <= "11";		-- Operacion de Registro B Read BIT
					 S <="1000";    -- Seleccion de La ALU ADD
                CI <= "10011"; -- Seleccion de Inicio de maquina de estado
                WoR <= '0';   -- Salida Demux de La RAM
                LR <= '0';     -- Seleccion de RAM
                FLAG <= '0';    -- No se usa ninguana Bandera
                RetW <= "00";    -- no se usa la opcion de W
        end case;
    End Process Selection;

End Behavioral;
