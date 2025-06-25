# trab4_sis_digi
Nome: Artur Cardoso Rihl Kniest

Calculo para encontrar o numero de bit do expoente e mantissa:

X = 8 (+/-) (∑b mod 4)

2 + 3 + 1 + 0 + 6 + 2 + 0 + 4 + 3 = 21

Dígito verificador = 3 (impar) sinal +

X = 8 + ∑b mod 4

21 ÷ 4 = 5, resto 1
21 mod 4 = 1


Calculo do expoente:
X = 8 + 1 = 9 bits

Callculo da mantissa:
Y = 31 - 9 = 22 bits

Entao: Expoente: 9 bits e Mantissa: 22 bits

-------------------------------------------

Formato dos operandos:
Bit 31: Sinal (0 = positivo, 1 = negativo)
Bits 30 a 22: expoente (9 bits)
Bits 21 a 0: mantissa (22 bits)

Sinais:
expoente_a, expoente_b: xpoentes dos operandos
mantissa_a, mantissa_b: Mantissas dos operandos

mantissa_result: resultado da operação de mantissa

mantissa_final: mantissa após normalização e arredondamento
expoente_final: resultado do expoente
status_out: vetor de 4 bits com os flags: EXACT OVERFLOW UNDERFLOW INEXACT

-------------------------------------------
Funcionamento da FPU
1 extração:
O sinal, expoente e mantissa são separados dos op_a_in e op_b_in

2 alinhamento de mantissas:
Se os expoentes são diferentes, a menor mantissa é deslocada à direita pela diferença dos expoentes
O maior expoente é utilizado como expoente base do resultado

3 operação (Soma/Subtração):
Se os sinais dos operandos são iguais realiza soma
Se os sinais são diferentes realiza subtração, usando o maior módulo como base para o sinal

4 normalização:
Ajusta a mantissa para que o primeiro bit mais significativo (bit oculto) seja 1
Se o resultado tenha overflow (bit extra), realiza shift-right na mantissa e incrementa o expoente

5 arredondamento:
Verifica os bits descartados no alinhamento:
Se qualquer bit for ‘1’, o flag INEXACT é ativado
Se o bit mais próximo do corte for ‘1’, incrementa a mantissa (aredondamento)

6 checagem de Overflow e Underflow:
Overflow: Se o expoente final excede 511 (111111111) 

Underflow: Se o expoente final é igual a zero e perdeu precisão após o alinhamento e normalização

7 Status:
EXACT → Nenhum overflow, underflow ou arredondamento
OVERFLOW → Resultado excede a faixa representável
UNDERFLOW → Resultado muito pequeno para ser representado
INEXACT → aconteceu arredondamento

---------------------------------------------------------------
Espectro numerico:
Botei duas fotos, uma sendo a menor para ter uma ideia e a outra sendo a expandida.
Ambas mostram apenas numeros positivos, nao teria como botar uma linha para casa numero entao decidi botar 22 linhas entre os numeros 2^x
decidi isso para ficar mais facil de visualizar. 
Entre cada 2^-x e 2^x tem 2^22 numeros, por isso decidi botar 22 marcasoes alem de ser um bom numero para visualizar. 

-----------------------------------------------------------------
Infelizmente nao consequi rodar meu codigo corretamente por isso a falta de resultados, nao foi uma boa ideia fazer em VHDL.
Se podesse fazer de novo trocaria para Verilog, mas espero que a logica no meu codigo esteja correta.
