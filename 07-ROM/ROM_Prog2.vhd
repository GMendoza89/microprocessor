-- Codigo de programa
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity ROM_Prog is
   port( 
      A : in  std_logic_vector(8 downto 0);
      D : out std_logic_vector(16 downto 0)
      );
   end ROM_Prog;

Architecture Tabla of ROM_Prog is
Begin
    process(A)
    begin
        case A is
            when "000000000" => D <= "01001101010101000" -- ardumendo 1 
            when "000000001" => D <= "01001000000000000" -- ardumendo 2 
            when "000000010" => D <= "10010100001001100" -- ardumendo 3 
            when "000000011" => D <= "01001101111100000" -- ardumendo 4 
            when "000000100" => D <= "00001000000000000" -- ardumendo 5 
            when "000000101" => D <= "10010100001001100" -- ardumendo 6 
            when "000000110" => D <= "01100000000000000" -- ardumendo 7 
            when "000000111" => D <= "10010100001001100" -- ardumendo 8 
            when "000001000" => D <= "01100000000000000" -- ardumendo 9 
            when "000001001" => D <= "10010100001001100" -- ardumendo 10 
            when "000001010" => D <= "01100000000000000" -- ardumendo 11 
            when "000001011" => D <= "10010100001001100" -- ardumendo 12 
            when "000001100" => D <= "00010000000000000" -- ardumendo 13 
            when "000001101" => D <= "10010100001001100" -- ardumendo 14 
            when "000001110" => D <= "10010100001001000" -- ardumendo 15 
            when "000001111" => D <= "01001000000000000" -- ardumendo 16 
            when "000010000" => D <= "10010100001001100" -- ardumendo 17 
            when "000010001" => D <= "10011000000000000" -- ardumendo 18 
            when "000010010" => D <= "10100000000000000" -- ardumendo 19 
            when "000010011" => D <= "00110100001000000" -- ardumendo 20 
            when "000010100" => D <= "10011000001001100" -- ardumendo 21 
            when "000010101" => D <= "00101000001000100" -- ardumendo 22 
            when "000010110" => D <= "10011000001001100" -- ardumendo 23 
            when "000010111" => D <= "00101000001001000" -- ardumendo 24 
            when "000011000" => D <= "10011000001001100" -- ardumendo 25 
            when "000011001" => D <= "10100100000000000" -- ardumendo 26 
            when others => D <= "00000000000000000";
        end case;
   end process;
end Tabla;
