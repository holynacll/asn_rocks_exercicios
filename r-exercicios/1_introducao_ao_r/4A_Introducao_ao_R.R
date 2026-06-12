# Introducao ao R

# Legendas:
#  Explicacao Conteudo
## Dicas
### Pratica
#### Contexto Negocio

# Nosso foco agora eh visualizacao de dados. Vamos conhecer os graficos
# atraves da biblioteca ggplot2 (que ja esta dentro da tidverse)
# sempre comece chamando suas bibliotecas
### Exercicio
### importe as bibliotecas de importacao de arquivos sas, txt e excel
### mais a biblioteca de manipulacao de dados
library(readr)
library(readxl)
library(haven)
library(tidyverse)

### Exercicio
### importe os arquivos employee_payroll.csv com o nome info_funcionarios
info_funcionarios <- read_csv("dados/employee_payroll.csv")

# A biblioteca ggplot2 faz seus graficos por camadas, ou seja, podemos ir 
# adicionando tarefas e desejos em cada uma das camadas
# vamos simplesmente pedir um grafico, ainda sem especificar qual
# repare que ele ira desenhar um espaco em branco
ggplot(data=info_funcionarios)

# precisamos especificar que tipo de grafico
# e qual variavel sera utilizada nele

# GRAFICO DE BARRAS
# faca um grafico de barras sobre a quantidade de dependentes
# que o colaborador tem
info_funcionarios %>% 
  count(Dependents) %>% 
  ggplot() +
  geom_col(aes(x=Dependents, y= n))

# voce pode adicionar cores
info_funcionarios %>% 
  count(Dependents) %>% 
  ggplot() +
  geom_colar(aes(x=Dependents, y= n, fill = Dependents))

# voce pode remover a legenda
info_funcionarios %>% 
  count(Dependents) %>% 
  ggplot() +
  geom_col(aes(x=Dependents, y= n, fill = Dependents), show.legend = FALSE)

# voce pode mudar o eixo de grafico
info_funcionarios %>% 
  count(Dependents) %>% 
  ggplot() +
  geom_col(aes(x=Dependents, y= n, fill = Dependents), show.legend = FALSE) +
  coord_flip()

# pode adicionar legendas sobre o volume
info_funcionarios %>% 
  count(Dependents) %>% 
  ggplot() +
  geom_col(aes(x=Dependents, y= n, fill = Dependents), show.legend = FALSE) +
  geom_label(aes(x = Dependents, y = n, label = n)) +
  coord_flip()


# HISTOGRAMA
# faca um histograma dos salarios
info_funcionarios %>% 
  ggplot() + 
  geom_histogram(aes(x=Salary))

# voce pode aumentar o numero de bins
info_funcionarios %>% 
  ggplot() + 
  geom_histogram(aes(x=Salary), bins=100)

# ou entao estipular o tamanho de cada bin
info_funcionarios %>% 
  ggplot() + 
  geom_histogram(aes(x=Salary), binwidth =10000)

# fazer a distribuicao dos salarios apenas de mulheres, pintando de rosa
info_funcionarios %>% 
  filter(Employee_Gender=="F") %>% 
  ggplot() + 
  geom_histogram(aes(x=Salary), fill="pink")

# ou fazer histograma sobrepostos por genero
info_funcionarios %>% 
  ggplot() + 
  geom_histogram(aes(x=Salary, color=Employee_Gender), fill="white")

info_funcionarios %>% 
  ggplot() + 
  geom_histogram(aes(x=Salary, color=Employee_Gender, fill=Employee_Gender))


# BOXPLOT
# faca um boxplot dos salarios
info_funcionarios %>% 
  ggplot() + 
  geom_boxplot(aes(x=Salary))

# boxplot por genero
info_funcionarios %>% 
  ggplot() + 
  geom_boxplot(aes(x=Employee_Gender, y=Salary))

# GRAFICO DE DISPERSAO
# com a base de dados mpg, faca o grafico de dispersao entre cty e hwy
mpg %>% 
  ggplot() + 
  geom_point(aes(x=cty, y=hwy))

# podemos adicionar cor aos pontos dado alguma outra variavel
mpg %>% 
  ggplot() + 
  geom_point(aes(x=cty, y=hwy, color=year))

# colocando ano como um caracter
mpg %>% 
  mutate(year = as.character(year)) %>% 
  ggplot() + 
  geom_point(aes(x=cty, y=hwy, color=year))

             
#### Contexto de Negocio
#### A empresa XPTO necessita responder algumas perguntas de negocio e precisa da
#### sua ajuda. Importante deixar claro que eles nao querem tabelas como respostas
#### eles desejam algo visual
### Exercicio
### Abuse dos graficos e responda
### Quantos funcionarios sao solteiros?
info_funcionarios %>%
  count(Marital_Status) %>%
  ggplot() +
  geom_col(aes(x=Marital_Status, y = n, fill=Marital_Status)) +
  geom_label(aes(x = Marital_Status, y = n, label = n))
  


### Exercicio
### Qual a distribuicao de salarios por Marital_Status
info_funcionarios %>%
  ggplot() +
  geom_histogram(aes(x=Salary, color=Marital_Status, fill=Marital_Status), bins=300)

info_funcionarios %>%
  ggplot() +
  geom_boxplot(aes(x=Marital_Status, y=Salary, fill=Marital_Status))

