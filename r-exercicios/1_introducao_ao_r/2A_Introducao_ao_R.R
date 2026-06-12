# Introducao ao R


# Legendas:
#  Explicacao Conteudo
## Dicas
### Pratica
#### Contexto Negocio


# Vamos conhecer os objetos no R
# um objeto nada mais eh do que um "nome" para alguma coisa
# essa coisa pode ser um valor, uma base de dados, uma funcao...
# o operador recebe (< -) eh quem cria um objeto
# no windows o atalho do recebe eh "alt + -", teste se para voce tambem
# veja esse exemplo
a <- 2
A <- 4
# note que o R executou o codigo e nao soltou nenhuma saida
# a unica coisa que ele fez, foi criar o objeto a
# que contem o valor 2, nesse exemplo

## DICA
## todo objeto no R eh case sensitive, ou seja,
## o objeto a eh diferente do objeto A!!!

# para visualizar o que tem dentro de um objeto, basta chama-lo
a
a-2
a-A

# Tipos de objetos atomicos

# objeto character
# declarado entre aspas
"C"
"733"
escola <- "asn.rocks"
escola

# numeric
733
0.733
pi
nota <- 10
nota

# integer
123L
4L
730L

# complex
3 + 58i

# logical
TRUE
FALSE

# para saber a classe de um objeto utilizamos class()
bb <- 12
class(bb)

suc <- "asn.rocks"
class(suc)

ad <- TRUE
class(ad)


# quando necessitamos atribuir mais de um valor ao objeto, criamos vetores!
# Vetores sao estruturas muito importantes!
# na essencia sao como uma coluna do seu conjunto de dados
# nada mais sao do que um conjunto de valores indexados
# vamos declarar alguns vetores, visualiza-los e ver sua classe:
vetor1 <- c(7, 3, 3)
vetor1
class(vetor1)

vetor2 <- c("x", "y", "z")
vetor2
class(vetor2)

vetor3 <- c(4, 2, 2)
vetor3
class(vetor3)

vetor4 <- 1:4
vetor4
class(vetor4)

vetor5 <- 10:1
vetor5
class(vetor5)

#coercao - sempre que classe mais forte ganha
vetor6 <- c("adriana",22, "bruno", 33) 
vetor6
class(vetor6)

# podemos procurar posicoes especificas em um vetor
vetor6[1]
# ou ate algumas posicoes especificas de uma vez
vetor6[c(1,3)]
vetor6[c(2,4)]

# tambem somos capazes de fazer conta com vetores
# conta com vetores
# a mesma operacao em todos os valores do vetor
vetor1 - 4
vetor1 /2
vetor1 * 2

# soma posicao com posicao dos vetores
vetor1 + vetor1
# multiplicacao posicao com posicao dos vetores
vetor1 * vetor3
# veja o que acontece quando sao vetores de tamanhos diferentes
vetor3*vetor4

# em alguns casos pode ser interessante forcar uma classe
# exemplo
x <- -2:30
class(x)
as.numeric(x)
as.logical(x)
as.character(x)

# podemos usar alguns comandos para investigar os vetores
# quantidade de posicoes de um vetor
length(vetor1)
# soma dos valores de um vetor
sum(vetor1)
# media dos valores de um vetor
mean(vetor1)

### PARA PRATICAR

### Exercicio 
### Crie um vetor chamado esporte e liste os 3 esporte que voce mais gosta
### conforme sua ordem de preferencia e responda
### qual o seu segundo esporte favorito utilizando a impressao da posicao em questao
esporte <- c("Futebol", "Volei", "Basquete")
esporte[c(2)]

### depois do exercicio execute o codigo abaixo e verifique o que acontece
paste("eu amo", esporte)

### Exercicio 
### Calcule a soma de todos os valores entre 20 e 60
sum(20:60)

### Calcule a media entre os valores de 100 a 700
mean(100:700)

### Exercicio 
### Crie um vetor chamado idades e coloque a sua idade, a do seu pai e mae
### atraves de vetores, imprima a idade de voces daqui 17 anos
idades = c(31, 68, 60)
idades + 17


## DICAS
## Importante saber que existem alguns valores especiais no R
## por exemplo quando voce pede uma informacao que nao existe
vetor1
vetor1[4]
## NA significa falta de informacao! ou o missing!

## Ja o NAN significa not a number, ou seja, contas que nao existem
0/0
log(-1)

## o inf representa infinito, um numero que nao conseguimos calcular
733^9847

# em analise de dados pode ser necessario que declaremos um vetor (ou variavel)
# como fator, dependendo da analise que faremos
# fatores sao vetores characteres que sao lidos como variaveis nominais
aluno <- c("Regular", "Bolsista", "Bolsista", "Regular", "Regular", "Bolsista")
aluno
class(aluno)
aluno_fator <- as.factor(aluno)
aluno_fator
as.numeric(aluno)
as.numeric(aluno_fator)

# Listas sao muito importantes no R
# todo data frame eh uma lista
# elas sao como varios vetores, mas que permitem misturar classes
lista1 <- list(733, "adriana", TRUE)
lista1
# repare que nao tem coercao

# cada elemento de uma lista, o que nos permite colocar vetores de tamanhos diferentes
# eh bem comum e usado colocar nome para cada posicao de uma lista
cursos <- list( descricao = c("Entendendo Estatistica Divertidamente", "Data Science Analytics: uma visao geral", "Data Science para negocios","Data Science Analytics: uma visao nao supervisionada"),
                pagina = c("https://l.ead.me/asn_eed",  "https://l.ead.me/asn_dsavg", "https://l.ead.me/asn_dsn", "https://l.ead.me/asn_dsans"),
                valores = c(1500, 3500, 500, 500),
                data_curso = c(as.Date("2020-10-13"), as.Date("2020-10-13"), as.Date("2020-09-12"), as.Date("2020-10-22"))
)
cursos

# podemos navegar dentro das listas
cursos$descricao
cursos$descricao[3]

# como dito, todo data frame eh uma lista
# e vamos utilizar muito data frames
# para transformar uma lista em um data frame
df <- as.data.frame(cursos)
df
View(df)
as.list(df)

# data frames sao nossas base de dados com linhas e colunas
# ou seja, data frames sao tabelas que seguem propriedades definidas:
# todas as colunas tem o mesmo numero de linhas
# todas as colunas tem que ter nome
# data frames tem sempre duas dimensoes

# extraindo informacao da dimensao do data frame
# linhas e colunas (nessa ordem)
dim(df)

# podemos navegar dentro de data frames
# df[linha , coluna]
# informacao da primeira linha, segunda coluna:
df[1,2]

# todas as linhas de uma determinada coluna
df[,1]

# todas as colunas de uma determinada linha
df[1,]

# selecionando apenas uma coluna do data frame
df$descricao

# extraindo algumas informacoes bem basicas do data frame
str(df)

# extraindo o nome das variaveis de um data frame
names(df)

# comando para abrir em formato de base de dados
View(df)


### PARA PRATICAR

### Exercicio 
### Responda algumas questoes sobre o data frame instalado nativamente no R
mtcars
### quantas linhas e colunas ele tem?
dim(mtcars)
# 32 linhas

### quais sao os nomes das colunas?
names(mtcars)

### calcule a media da variavel disp
mean(mtcars$disp)

### calcule o desvio padrao da variavel disp
sd(mtcars$disp)

### qual eh a classe da variavel mpg
class(mtcars$mpg)

### crie um novo data frame que contenha o mtcars chamado teste
teste <- mtcars

### teste sera o data frame mtcars com uma variavel a mais
### essa variavel a mais deve chamar chute e eh a variavel mpg + 500 
teste$chute <- teste$mpg + 500
View(teste)
