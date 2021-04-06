# problemB
Course unit: Computation Theory (TC) - Problem B in ocaml

Resolution of Problem B in ocaml

# Geração de palavras a partir de gram´aticas

## Problema

  Considere uma gramática algébrica G = (Σ, N, P, S) com possivelmente produções epsilon.
  Escreva um programa que lê um inteiro n e uma gramática G e que calcule o conjunto de palavras de tamanho menor ou igual a n. Estas palavras serão listadas por ordem alfabética, uma por linha.

## Entrada

  Para simplificar o formatos dos dados em entrada admitiremos aqui que os símbolos não terminais são representadas por nomes (string) começados por maiúsculas e os símbolos terminais são constituídos exclusivamente por minúsculas. Em particular o símbolo inicial será sempre o não-terminal S. Uma produção terá sempre o formato N -> α em que α é uma sequência não vazia de símbolos (terminais ou não-terminais separados por um espaço). Em particular o símbolo é representado pelo carácter _ (underscore).  
O formato dos dados em entrada é então o seguinte.  
Na primeira linha consta o inteiro n que é o inteiro que representa o tamanho máximo das palavras por gerar.  
Na segunda linha consta um inteiro m que indica quantas produções tem a gramática.  
As restantes m linhas introduzem as produções da gramática (uma por linha).  
  
  ## Saída
  
Imagine que a gramática em entrada gere k palavras distintas de tamanho menor ou igual a n, então a saída do programa são estas k palavras, ordenadas alfabeticamente, uma por linha.  

 ## Exemplo de entrada
 
 2  
 11  
 S -> A  
 S -> B D e  
 A -> A e  
 A -> e  
 B -> d  
 B -> C C  
 C -> e C  
 C -> e  
 C -> _  
 D -> a D  
 D -> a  
 
 ## Exemplo de Saída
 
 ae  
 e  
 ee  
