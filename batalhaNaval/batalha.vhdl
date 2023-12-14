library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity batalha is 
    port(
        key: in  std_logic_vector(3 downto 0); --clock: key(0);
        sw : in std_logic_vector(9 downto 0); --entrada das posicoes-sw(0-3), vertical(1)/horizontal(0)-sw(8), reset-sw(9);
        ledR : out std_logic_vector(9 downto 0); -- quantia de barcos posicionados
        ----------------DISPLAYS-------------------
        hex0, hex1, hex2, hex3 : out std_logic_vector(6 downto 0);
        -------------------------------------------
        ledG: out std_logic_vector(7 downto 0) --leds que representam acertos
    );
end batalha;

architecture comportamento_batalha of batalha is
    ----------------------------------
    component codificador is    
    port(
        x, y, z, w: in std_logic;
        saida: out std_logic_vector(3 downto 0)
    );
    end component codificador;
    ----------------------------------
    component display is
    port(
        jogadas: in integer range -1 to 6;
        hex0: out std_logic_vector(6 downto 0);
        hex1: out std_logic_vector(6 downto 0);
        hex2: out std_logic_vector(6 downto 0);
        hex3: out std_logic_vector(6 downto 0)
    );
    end component display;
    ----------------------------------
    type estados is (A, C, C2, D, E, S);
    signal est_atual: estados;
    signal aux, aux2, aux3: std_logic_vector(3 downto 0); --posicoes dos barcos codificadas;
    signal jogadas: integer range -1 to 6 := 5;

begin
    --codifica os barcos
    codif: codificador
    PORT MAP(
        w => sw(0),
        z => sw(1),
        y => sw(2),
        x => sw(3),
        saida => aux
    );

    --codifica a segunda posição do barco de tamanho 2
    codif_2: codificador
    PORT MAP(
        w => aux3(0),
        z => aux3(1),
        y => aux3(2),
        x => aux3(3),
        saida => aux2
    );
    
    --exibe quantidade de jogadas no led de 7 segmentos
    nome : display
    PORT MAP(
        jogadas => jogadas,
        hex0 => hex0,
        hex1 => hex1,
        hex2 => hex2,
        hex3 => hex3
    );

process(key(0), sw(9)) --clock e reset

    variable barco_1, barco_2_1, barco_2_2, jogada: std_logic_vector(3 downto 0); --posicoes dos barcos
	variable alvo: std_logic_vector(3 downto 0); --posicao do tiro
    variable flag: std_logic_vector(2 downto 0); --conta acertos
    variable acerta_todos: std_logic := flag(0) and flag(1) and flag(2); --indica se todos barcos foram acertados
    variable flag0: std_logic; --indica que acabaram as jogada

begin

    if(sw(9) = '1') then
        est_atual <= S;
        ledR(0) <= '0';
        ledR(1) <= '0';
        barco_1 := "0000";
        barco_2_1 := "0000";
        barco_2_2 := "0000";
        ledG(6) <= '0';
        ledG(5) <= '0';
        ledG(4) <= '0';
        jogadas <= 6;
        flag0 := '0';
        flag := "0000";
        acerta_todos := '0';

    elsif (key(0)'EVENT and key(0) = '1') then
        case est_atual is

            when S => --limpa os campos
                ledR(0) <= '0';
                ledR(1) <= '0';
                barco_1 := "0000";
                barco_2_1 := "0000";
                barco_2_2 := "0000";
                flag0 := '0';
                flag := "0000";
                acerta_todos := '0';
                ledG(6) <= '0';
                ledG(5) <= '0';
                ledG(4) <= '0';
                jogadas <= 6;
                est_atual <= A;

            when A => --escolhe o primeiro barco (1 posicao)
                barco_1 := aux;
                ledR(0) <= '1';
                est_atual <= C;

            when C => --posiciona o barco de tamanho 2
                --posiciona a primeira posição do barco de tamanho 2
                barco_2_1 := aux;
                ledR(1) <= '1';

                --posiciona a segunda posição do barco de tamanho 2
                jogada(0) := sw(0);
                jogada(1) := sw(1);
                jogada(2) := sw(2);
                jogada(3) := sw(3);
                aux3 <= jogada;

                --valida se selecionou a horizontal ou vertical
                if(sw(8) = '1') then
                    if(jogada(3) = '1' and jogada(2) = '1') then
                        aux3 <= jogada - "0100";
                    else
                        aux3 <= jogada + "0100";
                    end if;
                else
                    if (jogada(0) = '1' and jogada(1) = '1') then
                        aux3 <= jogada - "0001";
                    else
                        aux3 <= jogada + "0001";
                    end if;
                end if;
                est_atual <= C2;

            when C2 =>

                barco_2_2:= aux2;
                est_atual <= D;

            when D => --estado onde os ataques acontecem

                alvo(0) := sw(0);
                alvo(1) := sw(1);
                alvo(2) := sw(2);
                alvo(3) := sw(3);

                --verifica se acertou um barco

                if(alvo = barco_1) then --acertou barco 1
                    ledG(4) <= '1';
                    flag(0) := '1';
                    ledR(0) <= '0';
                    if(jogadas /= 1) then --se acertou na ultima jogada, ganha mais uma jogada!
                        jogadas <= jogadas-1;
                    end if;

                elsif(alvo = barco_2_1) then --acertou primeira posicao do barco 2
                    ledG(5) <= '1';
                    flag(1) := '1';
                    if(flag(2) = '1') then --confere se a segunda posicao ja havia sido acertada
                        ledR(1) <= '0';
                    end if;
                    if(jogadas /= 1) then 
                        jogadas <= jogadas-1;
                    end if;

                elsif(alvo = barco_2_2) then --acertou a segunda posicao do barco 3 
                    ledG(6) <= '1';
                    flag(2) := '1';
                    if(flag(1) = '1') then --confere se a primeira posicao ja havia sido acertada
                        ledR(1) <= '0';
                    end if;
                    if(jogadas /= 1) then 
                        jogadas <= jogadas-1;
                    end if;
                else 
                    jogadas <= jogadas-1; --desconta as jogadas
                end if;
                est_atual <= E;

            when E =>
                
                acerta_todos := flag(0) and flag(1) and flag(2); --verifica se acertou todos os barcos;

                if(jogadas = 0) then --flag que indica que acabaram as jogadas
                    flag0 := '1';
                end if;

                if (acerta_todos = '1' or flag0 = '1') then --acertou todos os barcos ou acabaram as jogadas
                    est_atual <= S;
                else 
                    est_atual <= D;
                end if;

        end case;
    end if;

    end process;

end comportamento_batalha;

