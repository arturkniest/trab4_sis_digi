library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FPU is
    Port (
        clock : in  std_logic;
        reset : in  std_logic;
        op_a_in : in  std_logic_vector(31 downto 0);
        op_b_in : in  std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0);
        status_out : out std_logic_vector(3 downto 0)
    );
end FPU;

architecture Behavioral of FPU is

    signal sinal_a, sinal_b : std_logic;
    signal expoente_a, expoente_b : std_logic_vector(8 downto 0);
    signal mantissa_a, mantissa_b : std_logic_vector(22 downto 0);

    signal mantissa_a_expandida, mantissa_b_expandida : std_logic_vector(47 downto 0);
    signal mantissa_result : std_logic_vector(47 downto 0);
    signal mantissa_final  : std_logic_vector(23 downto 0);

    signal expoente_final : std_logic_vector(8 downto 0);
    signal sinal_result : std_logic;

    signal exact : std_logic;
    signal overflow : std_logic;
    signal underflow : std_logic;
    signal inexact : std_logic;

    signal resultado : std_logic_vector(31 downto 0);

begin

    process(clock, reset)
        variable diff : integer;
        variable diff_extra : integer;
    begin
        if reset = '0' then
            resultado   <= (others => '0');
            status_out  <= (others => '0');

        elsif rising_edge(clock) then
            --sinal, expoente e mantissa
            sinal_a <= op_a_in(31);
            sinal_b <= op_b_in(31);

            expoente_a  <= op_a_in(30 downto 22);
            expoente_b  <= op_b_in(30 downto 22);

            mantissa_a  <= op_a_in(21 downto 0);
            mantissa_b  <= op_b_in(21 downto 0);

            --arrumando mantissas
            if conv_integer(expoente_a) > conv_integer(expoente_b) then
                diff := conv_integer(expoente_a) - conv_integer(expoente_b);

                mantissa_a_expandida(23 + diff downto diff) <= '1' & mantissa_a;
                mantissa_a_expandida(diff - 1 downto 0) <= (others => '0');

                mantissa_b_expandida(23 downto 0) <= '1' & mantissa_b;
                mantissa_b_expandida(46 downto 24) <= (others => '0');

                expoente_final <= expoente_a;

            elsif conv_integer(expoente_b) > conv_integer(expoente_a) then
                diff := conv_integer(expoente_b) - conv_integer(expoente_a);

                mantissa_b_expandida(23 + diff downto diff) <= '1' & mantissa_b;
                mantissa_b_expandida(diff - 1 downto 0) <= (others => '0');

                mantissa_a_expandida(23 downto 0) <= '1' & mantissa_a;
                mantissa_a_expandida(46 downto 24) <= (others => '0');

                expoente_final <= expoente_b;

            else
                diff := 0;
                mantissa_a_expandida(23 downto 0) <= '1' & mantissa_a;
                mantissa_a_expandida(47 downto 24) <= (others => '0');

                mantissa_b_expandida(23 downto 0) <= '1' & mantissa_b;
                mantissa_b_expandida(47 downto 24) <= (others => '0');
                expoente_final <= expoente_a;
            end if;

            --soma ou subtração
            if sinal_a = sinal_b then
                sinal_result <= sinal_a;
                mantissa_result <= mantissa_a_expandida + mantissa_b_expandida;
            elsif sinal_a = '0' and sinal_b = '1' then
                mantissa_result <= mantissa_a_expandida - mantissa_b_expandida;
                sinal_result <= sinal_a;
            else
                mantissa_result <= mantissa_b_expandida - mantissa_a_expandida;
                sinal_result <= sinal_b;
            end if;

            --normalizacao
            diff_extra := diff + 22;
            mantissa_final(22 downto 0) <= mantissa_result(diff_extra downto diff); 
            mantissa_final(23) <= '0'; --bit extra pra verificar se teve carry depois do arredondamento 

            if diff > 0 then 
                --se tiver qualquer bit = 1 na parte que vai ser descartada, marca inexact
                if mantissa_result(diff - 1 downto 0) /= (others => '0') then
                    inexact <= '1';
                else
                    inexact <= '0';
                end if;

                --se o bit mais proximo que foi cortado = 1, entao arredonda somando 1 
                if mantissa_result(diff - 1) = '1' then
                    mantissa_final <= mantissa_final + 1;
                end if;
            end if;
           

            --verifica se teve carry depois do arredondamento
            if mantissa_final(23) = '1' then
                if expoente_a = "111111111" and expoente_b = "111111111" then --se fez o carry e os expoentes estao grandes demais = overflow
                    overflow <= '1';    --overflow
                else
                    overflow <= '0';
                end if;

                if mantissa_final(0) = '1' then --underflow pq esse 1 no final vai ser cortado 
                    underflow <= '1';
                else
                    underflow <= '0';
                end if;

                mantissa_final <= mantissa_final(23 downto 1);  
                expoente_final <= expoente_final + 1;
            else 

                overflow <= '0'; 

            end if;

            --exato
            if overflow = '0' and underflow = '0' and inexact = '0' then
                exact <= '1';
            else
                exact <= '0';
            end if;

            --monta resultado final
            data_out <= sinal_result & expoente_final & mantissa_final(21 downto 0);

            --status final
            status_out <= exact & overflow & underflow & inexact;
        end if;

    end process;

end Behavioral;


