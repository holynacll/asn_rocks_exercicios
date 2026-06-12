# Introducao ao R

# Legendas:
#  Explicacao Conteudo
## Dicas
### Pratica
#### Contexto Negocio

## DICAS
## Familiarize-se com os atalhos do teclado (Tools, Keyboards Shortcuts Help)
## Faca e refaca tudo que for proposto, pratica eh a unica solucao!
## Se quiser comentar uma linha do codigo, utilize o sustenido na frente
## se quiser ficar escrevendo muita coisa, sugiro "#'" pois o proximo enter tambem
## sera comentado!
#'como esse aqui em diante!
#'quando for um codigo, nao colocar o sustenido!
#'Pratique a documentacao do seu codigo! Isso eh uma das dicas mais preciosas
#'e infelizmente muito pouco praticada pela maioria

# Primeira coisa, o R funciona como uma calculadora
# Vamos conhecer os comandos basicos

# adicao
5+7

# subtracao
733 - 33

# multiplicacao
2 * 733

# divisao
733 / 3

# potencia
7 ^ 3

# Erro
# raramente acertaremos de primeira, aprenda conviver com os erros
# e use o google ao seu favor!
5?5

# comando sem fim
733 - 4
# se por ventura voce esquecer algo ou deixar um comando sem conclusao
# o R ira atras da proxima linha e nao apontara erro
# a nao ser que o que vier na sequencia nao seja executavel por ele!

### PARA PRATICAR

### Exercicio 
### Calcule quantos minutos exitem em um ano
60 * 24 * 365

### Exercicio 
### Dado que para cada modulo do meu curso eu levo cerca de 80 horas de preparo
### Quantos dias de 8 horas eu invisto para produzir um curso com 7 modulos?
modulo_por_horas = 80
curso_por_horas = modulo_por_horas * 7
dias_producao_curso= curso_por_horas / 8
dias_producao_curso
