%                   Universidad de Guanajuato 
%           División de Ingenierias Campus Irapuato Salamanca
%       
%
%                   Maestria en Ingenieria Eléctrica
%
%                     Mendoza Pinto Gustavo David
%
%                          Microprocesadores
%
%
%
% Descripción
% Codigo que le un archivo .asm y genera una rom con las lineas de Programa de el microprocesador
% cada linea de programa deve de tener el siguiente formato
%
%           intruccion argumento1 argumento2

% la instruccion se puede escribir en mayuscula o minusculas 
% el argumento 1 puede ser un valor literal de 8 bits, direccion de memoria de 8 bits, o una direccion de instrucción de 9 bits, 
% el argumento 2 debe ser 1 o 0 para las instrucciones que tengan la opción de guardar en un registro F o en el registro W, o un argumento de tres bits para indicar 
% el bit a usar en las intrucciones de manipulacion de bits en los registros.
% ejemplos 
%
%           movlw 11001101
%           ANDWF 00001101 1
%           BTF 00110011 101
%           Call 100101100



clear all;
clc
NumberLn = 0;
d = zeros(512,17);
d = char(d);
ff = fopen('codigo.asm');

while not(feof(ff))
    
    txtln = fgetl(ff);
    txtln = lower(txtln);
    C = strsplit(txtln);
    c = char(C(1,1));
    switch (c)
        case 'addwf'
        d(NumberLn+1,:) = ['000000',char(C(1,2)),char(C(1,3)),'00'];
    case 'addlw'
        d(NumberLn+1,:) = ['000001',char(C(1,2)),'000'];
    case 'andwf'
        d(NumberLn+1,:) = ['000010',char(C(1,2)),char(C(1,3)),'00'];
    case 'andlw'
        d(NumberLn+1,:) = ['000011',char(C(1,2)),char(C(1,3)),'00'];
    case 'clrf'
        d(NumberLn+1,:) = ['000100',char(C(1,2)),'000'];
    case 'comf'
        d(NumberLn+1,:) = ['000101',char(C(1,2)),char(C(1,3)),'00'];
    case 'cpfseq'
        d(NumberLn+1,:) = ['000110',char(C(1,2)),'000'];
    case 'cpfsgt '
        d(NumberLn+1,:) = ['000111',char(C(1,2)),'000'];
    case 'cpfslt'
        d(NumberLn+1,:) = ['001000',char(C(1,2)),'000'];
    case 'decf'
        d(NumberLn+1,:) = ['001001',char(C(1,2)),char(C(1,3)),'00'];
    case 'decfsz'
        d(NumberLn+1,:) = ['001010',char(C(1,2)),char(C(1,3)),'00'];
    case 'decfsnz'
        d(NumberLn+1,:) = ['001011',char(C(1,2)),char(C(1,3)),'00'];
    case 'incf'
        d(NumberLn+1,:) = ['001100',char(C(1,2)),char(C(1,3)),'00'];
    case 'incfsz'
        d(NumberLn+1,:) = ['001101',char(C(1,2)),char(C(1,3)),'00'];
    case 'incfsnz'
        d(NumberLn+1,:) = ['001110',char(C(1,2)),char(C(1,3)),'00'];
    case 'iorwf'
        d(NumberLn+1,:) = ['001111',char(C(1,2)),char(C(1,3)),'00'];
    case 'iorlw '
        d(NumberLn+1,:) = ['010000',char(C(1,2)),'000'];
    case 'movf'
        d(NumberLn+1,:) = ['010001',char(C(1,2)),char(C(1,3)),'00'];
    case 'movwf'
        d(NumberLn+1,:) = ['010010',char(C(1,2)),'000'];
    case 'movlw'
        d(NumberLn+1,:) = ['010011',char(C(1,2)),'000'];
    case 'mulwf'
        d(NumberLn+1,:) = ['010100',char(C(1,2)),'000'];
    case 'mullw'
        d(NumberLn+1,:) = ['010101',char(C(1,2)),'000'];
    case 'negf'
        d(NumberLn+1,:) = ['010110',char(C(1,2)),'000'];
    case 'rlncf'
        d(NumberLn+1,:) = ['010111',char(C(1,2)),char(C(1,3)),'00'];
    case 'rrncf'
        d(NumberLn+1,:) = ['011000',char(C(1,2)),char(C(1,3)),'00'];
    case 'setf'
        d(NumberLn+1,:) = ['011001',char(C(1,2)),'000'];
    case 'subwf'
        d(NumberLn+1,:) = ['011010',char(C(1,2)),char(C(1,3)),'00'];
    case 'sublw'
        d(NumberLn+1,:) = ['011011',char(C(1,2)),'000'];
    case 'swapf'
        d(NumberLn+1,:) = ['011100',char(C(1,2)),char(C(1,3)),'00'];
    case 'tstfsz '
        d(NumberLn+1,:) = ['011101',char(C(1,2)),'000'];
    case 'xorwf'
        d(NumberLn+1,:) = ['011110',char(C(1,2)),char(C(1,3)),'00'];
    case 'xorlw'
        d(NumberLn+1,:) = ['011111',char(C(1,2)),'000'];
    case 'bcf'
        d(NumberLn+1,:) = ['100000',char(C(1,2)),char(C(1,3))];
    case 'bsf'
        d(NumberLn+1,:) = ['100001',char(C(1,2)),char(C(1,3))];
    case 'btfsc'
        d(NumberLn+1,:) = ['100010',char(C(1,2)),char(C(1,3))];
    case 'btfss'
        d(NumberLn+1,:) = ['100011',char(C(1,2)),char(C(1,3))];
    case 'btg'
        d(NumberLn+1,:) = ['100100',char(C(1,2)),char(C(1,3))];
    case 'call'
        d(NumberLn+1,:) = ['100101',char(C(1,2)),'00'];
    case 'goto'
        d(NumberLn+1,:) = ['100110',char(C(1,2)),'00'];
    case 'nop'
        d(NumberLn+1,:) = ['100111','00000000000'];
    case 'retlw'
        d(NumberLn+1,:) = ['101000','00000000000'];
    case 'return'
        d(NumberLn+1,:) = ['101001','00000000000'];
    case 'reset'
        d(NumberLn+1,:) = ['101010','00000000000'];
    end
    NumberLn = NumberLn +1;
end
fclose(ff);


n = 17;
M = 9;

D = 2^M;
D1 = 2^n;

for i=1:NumberLn
    Auxiliar = i-1;
    for j= M:-1:1
        IDX(i,j) = rem(Auxiliar,2);
        Auxiliar = floor(Auxiliar/2);
    end;
end;

fid = fopen('ROM.vhd','w');

% Encabezado de la descripcion
fprintf(fid,'-- Codigo de programa\n');
fprintf(fid,'--\n');
fprintf(fid,'\n');
fprintf(fid,'LIBRARY IEEE;\n');
fprintf(fid,'USE IEEE.std_logic_1164.all;\n');
fprintf(fid,'\n');
fprintf(fid,'Entity ROM_Prog is\n');
fprintf(fid,'   port( \n');
fprintf(fid,'      A : in  std_logic_vector(%d downto 0);\n',M-1);
fprintf(fid,'      D : out std_logic_vector(%d downto 0)\n',n-1);
fprintf(fid,'      );\n');
fprintf(fid,'   end ROM_Prog;\n');
fprintf(fid,'\n');
fprintf(fid,'Architecture Tabla of ROM_Prog is\n');
fprintf(fid,'Begin\n');
fprintf(fid,'    process(A)\n');
fprintf(fid,'    begin\n');
fprintf(fid,'        case A is\n');
for i=1:NumberLn
    fprintf(fid,'            when "');
    for j=1:M
        fprintf(fid,'%d',IDX(i,j));
    end;
    fprintf(fid,'" => D <= "');
    for j=1:17
        fprintf(fid,'%c',d(i,j));
    end;
    fprintf(fid,'" -- ardumendo %d \n',i);
end;
fprintf(fid,'            when others => D <= "00000000000000000";\n');
fprintf(fid,'        end case;\n');
fprintf(fid,'   end process;\n');
fprintf(fid,'end Tabla;\n');
fclose(fid);
