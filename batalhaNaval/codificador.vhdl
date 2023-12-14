library ieee;
use ieee.std_logic_1164.all;

entity codificador is
    port(
        x, y, z, w: in std_logic;
        saida: out std_logic_vector(3 downto 0)
    );
end codificador;

architecture comportamento of codificador is
    
    signal x2: std_logic; 
    signal y2: std_logic; 
    signal z2: std_logic; 
    signal w2: std_logic; 
    
    begin
        
        -- Transforma as entradas NOT's em uma variável
        x2 <= not(x);
        y2 <= not(y);
        z2 <= not(z);
        w2 <= not(w);
        
        saida(0) <= ((x and z2 and w2) or (y2 and z and w) or (x2 and y and w) or (y and z2 and w));
        saida(1) <= ((y2 and z and w2) or (x2 and y2 and w) or (w and z2 and y) or (x and y and z2) or (x and y and w));
        saida(2) <= ((x2 and w) or (z2 and w2 and y2) or (x and w and z2) or (z and w and y2));
        saida(3) <= ((z and x and w2) or (x and w2 and z2) or (x2 and z2 and y) or (x2 w and y) or (y2 and z and w2));

end comportamento;