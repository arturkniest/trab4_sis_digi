library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FPU_tb is
end FPU_tb;

architecture Behavioral of FPU_tb is

    component FPU
        Port (
            clock      : in  std_logic;
            reset      : in  std_logic;
            op_a_in    : in  std_logic_vector(31 downto 0);
            op_b_in    : in  std_logic_vector(31 downto 0);
            data_out   : out std_logic_vector(31 downto 0);
            status_out : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clock      : std_logic := '0';
    signal reset      : std_logic := '0';
    signal op_a_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal op_b_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal data_out   : std_logic_vector(31 downto 0);
    signal status_out : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

    

begin

    uut: FPU port map (
        clock => clock,
        reset => reset,
        op_a_in => op_a_in,
        op_b_in => op_b_in,
        data_out => data_out,
        status_out => status_out
    );

    clk_process : process
    begin
        clock <= '0';
        wait for clk_period/2;
        clock <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        
        -- Teste 1: 2 + 2
        
        op_a_in <= "00000010000000000000000000000001";
        op_b_in <= "00000010000000000000000000000001";
        wait for 40 ns;
        

        
        -- Teste 2: 4 - 2
        
        op_a_in <= "00000010100000000000000000000000";
        op_b_in <= "10000010000000000000000000000001"; -- 2 negativo
        wait for 40 ns;
        
        -- Teste 3: 0 + 5 (Elemento neutro)
      
        op_a_in <= "00000000000000000000000000000000"; -- Zero
        op_b_in <= "00000010101000000000000000000000"; -- 5
        wait for 40 ns;


        -- Teste 4: 7 - 0 
        op_a_in <= "00000010111000000000000000000000"; -- 7
        op_b_in <= "10000000000000000000000000000000"; -- Zero negativo
        wait for 40 ns;
        
        -- Teste 5: Overflow
       
        op_a_in <= "11111111100000000000000000000000";
        op_b_in <= "11111111100000000000000000000000";
        wait for 40 ns;

        -- Teste 6: Underflow
        op_a_in <= "00000000100000000000000000000000";
        op_b_in <= "00000000100000000000000000000000";
        wait for 40 ns;

        -- Teste 7: Soma com sinais opostos (cancelamento)
        op_a_in <= "00000010000000000000000000000001"; -- 2
        op_b_in <= "10000010000000000000000000000001"; -- -2
        wait for 40 ns;

        -- Teste 8: -5 + (-3)
        op_a_in <= "10000010101000000000000000000000"; -- -5
        op_b_in <= "10000010011000000000000000000000"; -- -3
        wait for 40 ns;

        -- Teste 9: 8 + (-5)

        op_a_in <= "00000011000000000000000000000000"; -- 8
        op_b_in <= "10000010101000000000000000000000"; -- -5
        wait for 40 ns;

        -- Teste 10: 0 + 0

        op_a_in <= "00000000000000000000000000000000";
        op_b_in <= "00000000000000000000000000000000";
        wait for 40 ns;

        assert false report "Fim da simulação." severity failure;
    end process;

end Behavioral;
