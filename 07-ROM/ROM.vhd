-- Codigo de Microcontrolador
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity ROM is
   port( 
      A : in  std_logic_vector(8 downto 0);
      D : out std_logic_vector(16 downto 0)
      );
   end ROM;

Architecture Behavioral of ROM is
Begin
    process(A)
    begin
        case A is
            when "000000000" => D <= "00110000001111100"; -- instrucción  0 
            when "000000001" => D <= "01000100001111000"; -- instrucción  1 
            when "000000010" => D <= "01001000000110100"; -- instrucción  2 
            when "000000011" => D <= "01000100001100000"; -- instrucción  3 
            when "000000100" => D <= "10010100001110100"; -- instrucción  4 
            when "000000101" => D <= "01001000000010100"; -- instrucción  5 
            when "000000110" => D <= "01000100001101000"; -- instrucción  6 
            when "000000111" => D <= "10010100001110100"; -- instrucción  7 
            when "000001000" => D <= "01001000000011100"; -- instrucción  8 
            when "000001001" => D <= "01000100001110000"; -- instrucción  9 
            when "000001010" => D <= "10010100001110100"; -- instrucción  10 
            when "000001011" => D <= "01001000000100100"; -- instrucción  11 
            when "000001100" => D <= "10010100100011100"; -- instrucción  12 
            when "000001101" => D <= "00110000001100100"; -- instrucción  13 
            when "000001110" => D <= "01001100001010000"; -- instrucción  14 
            when "000001111" => D <= "00011000001100000"; -- instrucción  15 
            when "000010000" => D <= "10011000000000000"; -- instrucción  16 
            when "000010001" => D <= "00010000001100100"; -- instrucción  17 
            when "000010010" => D <= "00110000001101100"; -- instrucción  18 
            when "000010011" => D <= "01001100001010000"; -- instrucción  19 
            when "000010100" => D <= "00011000001101000"; -- instrucción  20 
            when "000010101" => D <= "10011000000000000"; -- instrucción  21 
            when "000010110" => D <= "00010000001101100"; -- instrucción  22 
            when "000010111" => D <= "00110000001110100"; -- instrucción  23 
            when "000011000" => D <= "01001100001010000"; -- instrucción  24 
            when "000011001" => D <= "00011000001110000"; -- instrucción  25 
            when "000011010" => D <= "10011000000000000"; -- instrucción  26 
            when "000011011" => D <= "00010000001110100"; -- instrucción  27 
            when "000011100" => D <= "10011000000000000"; -- instrucción  28 
            when "000011101" => D <= "01001000001011100"; -- instrucción  29 
            when "000011110" => D <= "01001100000000000"; -- instrucción  30 
            when "000011111" => D <= "00011100001011000"; -- instrucción  31 
            when "000100000" => D <= "10011000011110100"; -- instrucción  32 
            when "000100001" => D <= "01001100000001000"; -- instrucción  33 
            when "000100010" => D <= "00011100001011000"; -- instrucción  34 
            when "000100011" => D <= "10011000011111000"; -- instrucción  35 
            when "000100100" => D <= "01001100000010000"; -- instrucción  36 
            when "000100101" => D <= "00011100001011000"; -- instrucción  37 
            when "000100110" => D <= "10011000011111100"; -- instrucción  38 
            when "000100111" => D <= "01001100000011000"; -- instrucción  39 
            when "000101000" => D <= "00011100001011000"; -- instrucción  40 
            when "000101001" => D <= "10011000100000000"; -- instrucción  41 
            when "000101010" => D <= "01001100000100000"; -- instrucción  42 
            when "000101011" => D <= "00011100001011000"; -- instrucción  43 
            when "000101100" => D <= "10011000100000100"; -- instrucción  44 
            when "000101101" => D <= "01001100000101000"; -- instrucción  45 
            when "000101110" => D <= "00011100001011000"; -- instrucción  46 
            when "000101111" => D <= "10011000100001000"; -- instrucción  47 
            when "000110000" => D <= "01001100000110000"; -- instrucción  48 
            when "000110001" => D <= "00011100001011000"; -- instrucción  49 
            when "000110010" => D <= "10011000100001100"; -- instrucción  50 
            when "000110011" => D <= "01001100000111000"; -- instrucción  51 
            when "000110100" => D <= "00011100001011000"; -- instrucción  52 
            when "000110101" => D <= "10011000100010000"; -- instrucción  53 
            when "000110110" => D <= "01001100001000000"; -- instrucción  54 
            when "000110111" => D <= "00011100001011000"; -- instrucción  55 
            when "000111000" => D <= "10011000100010100"; -- instrucción  56 
            when "000111001" => D <= "01001100001001000"; -- instrucción  57 
            when "000111010" => D <= "00011100001011000"; -- instrucción  58 
            when "000111011" => D <= "10011000100011000"; -- instrucción  59 
            when "000111100" => D <= "10100100000000000"; -- instrucción  60 
            when "000111101" => D <= "10100000000001000"; -- instrucción  61 
            when "000111110" => D <= "10100001001111000"; -- instrucción  62 
            when "000111111" => D <= "10100000010010000"; -- instrucción  63 
            when "001000000" => D <= "10100000000110000"; -- instrucción  64 
            when "001000001" => D <= "10100001001100000"; -- instrucción  65 
            when "001000010" => D <= "10100000100100000"; -- instrucción  66 
            when "001000011" => D <= "10100000100000000"; -- instrucción  67 
            when "001000100" => D <= "10100000001111000"; -- instrucción  68 
            when "001000101" => D <= "10100000000000000"; -- instrucción  69 
            when "001000110" => D <= "10100000001100000"; -- instrucción  70 
            when "001000111" => D <= "00101000001000100"; -- instrucción  71 
            when "001001000" => D <= "10011000100011100"; -- instrucción  72 
            when "001001001" => D <= "00101000001001100"; -- instrucción  73 
            when "001001010" => D <= "10011000100011100"; -- instrucción  74 
            when "001001011" => D <= "00101000001010100"; -- instrucción  75 
            when "001001100" => D <= "10011000100011100"; -- instrucción  76 
            when "001001101" => D <= "10100100000000000"; -- instrucción  77 
            when others => D <= "00000000000000000";
        end case;
   end process;
end Behavioral;
