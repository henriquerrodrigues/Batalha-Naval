library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
    port(
        jogadas: in integer range -1 to 6;
        hex0: out std_logic_vector(6 downto 0);
        hex1: out std_logic_vector(6 downto 0);
        hex2: out std_logic_vector(6 downto 0);
        hex3: out std_logic_vector(6 downto 0)
    );
end display;

architecture behavior of display is

    begin
    process(jogadas)

        begin
        if jogadas=0 then
            hex0(0)<='0';
            hex0(1)<='0';
            hex0(2)<='0';
            hex0(3)<='0';
            hex0(4)<='0';
            hex0(5)<='0';
            hex0(6)<='1';

        elsif jogadas=1 then
            hex0(0)<='1';
            hex0(1)<='0';
            hex0(2)<='0';
            hex0(3)<='1';
            hex0(4)<='1';
            hex0(5)<='1';
            hex0(6)<='1';

        elsif jogadas=2 then
            hex0(0)<='0';
            hex0(1)<='0';
            hex0(2)<='1';
            hex0(3)<='0';
            hex0(4)<='0';
            hex0(5)<='1';
            hex0(6)<='0';

        elsif jogadas=3 then
            hex0(0)<='0';
            hex0(1)<='0';
            hex0(2)<='0';
            hex0(3)<='0';
            hex0(4)<='1';
            hex0(5)<='1';
            hex0(6)<='0';

        elsif jogadas=4 then
            hex0(0)<='1';
            hex0(1)<='0';
            hex0(2)<='0';
            hex0(3)<='1';
            hex0(4)<='1';
            hex0(5)<='0';
            hex0(6)<='0';

        elsif jogadas=5 then
            hex0(0)<='0';
            hex0(1)<='1';
            hex0(2)<='0';
            hex0(3)<='0';
            hex0(4)<='1';
            hex0(5)<='0';
            hex0(6)<='0';

        else
            hex0(0)<='0';
            hex0(1)<='1';
            hex0(2)<='0';
            hex0(3)<='0';
            hex0(4)<='0';
            hex0(5)<='0';
            hex0(6)<='0';
        end if;

        -- desativa os outros displays ----------------------------------------------
        hex1(0)<='1';
        hex1(1)<='1';
        hex1(2)<='1';
        hex1(3)<='1';
        hex1(4)<='1';
        hex1(5)<='1';
        hex1(6)<='1';

        hex2(0)<='1';
        hex2(1)<='1';
        hex2(2)<='1';
        hex2(3)<='1';
        hex2(4)<='1';
        hex2(5)<='1';
        hex2(6)<='1';

        hex3(0)<='1';
        hex3(1)<='1';
        hex3(2)<='1';
        hex3(3)<='1';
        hex3(4)<='1';
        hex3(5)<='1';
        hex3(6)<='1';
        -----------------------------------------------------------------------------
    end process;
end behavior;