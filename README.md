# trab4_sis_digi


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
