﻿Desenvolvido por 
Renato Aparecido Françoso

LALG-MV
A Princípio a Máquina Virtual do HIPO lê arquivos no formato texto
com instruções HIPO, uma por linha.
Quando a instrução contém um endereço, o mesmo tem que estar separado
da instrução por um espaço, exemplo:

Instrução sem Endereço:
LEIT
RTPTR

Instruções Com Endereço:
ARMZ 4
CRVL 3

---------------------------------------------------------------
Interface do HIPO-MV

A interface consiste em :
- Barra de ferramentas
  Contém botões para 
   - Abrir um novo programa
   - Executar um programa Passo-a-Passo (instrução por instrução)
   - Executar um programa de uma vez 
   - Resetar o programa (voltar a pilha, fita de saída e 
     contador do programa para a posição inicial) (não é necessário 
     se for usar a execução total pois a mesma reseta automaticamente)
   - Fechar a MV

- Lista dos códigos de máquina (HIPO) do programa carregado
    Quando se abre um arquivo contendo códigos em linguagem HIPO
    os mesmos são mostrados nesta lista.

- Pilha de memória
    Pilha utilizada para armazenar valores durante a execução do programa

- Fita de Entrada
    Um campo utilizado para entrada de dados do programa, os dados deste campo
    devem ser separados por ; (ponto-e-vírgula) exemplo: meu programa lê três variáveis, 
    então na fita de entrada eu alimento com os seguintes valores:  15;6;800 
    a cada leitura que o programa fizer o valor mais à esquerda é consumido.    

- Fita de Saída
    a cada chamada que o programa fizer ao código write, um valor é adicionado nesse campo.

- Painel de mensagens
    Exibe mensagens de erro ou indicações para o bom funcionamento da Máquina

---------------------------------------------------------------
Teclas de atalho:
Ctrl+A    :Abrir um arquivo
F8        :Executar passo-a-passo
F9        :Executar tudo
Ctrl + E  :Foco na Fita de Entrada
Ctrl + S  :Foco na Fita de Saída
Ctrl + L  :Limpa Fita de Saída
Ctrl + F2 :Resetar a máquina

---------------------------------------------------------------
Exemplo de utilização:
Clique no botão "Abrir" para abrir um arquivo com linguagem de máquina (HIPO) 
Alimente a fita de entrada
clique no botão "Executar Tudo"
Veja os valores na fita de saída.




