# Introducao ao R

# Legendas:
#  Explicacao Conteudo
## Dicas
### Pratica
#### Contexto Negocio

# Nese bloco vamos praticar tudo sssque vimos em um problema de negocio!

#### Contexto Negocio
#### Voce recebeu 3 bases diferentes:
#### total_dinheiro_vendido.txt, custo_dinheiro.txt e quantidade_vendida.xlsx 

#### Dicionario de dados total_dinheiro_vendido.txt:
#### Variavel  - Descricao
#### AnoQuarter - AnoQuarter da coleta da informacao
#### Linha_produto - Linha do Produto
#### Categoria_produto - Categoria do Produto 
#### Total_dinheiro_vendido - Valor total do que foi vendido 

#### Dicionario de dados custo_dinheiro.txt:
#### Variavel - Descricao
#### AnoQuarter - AnoQuarter da coleta da informacao
#### Linha_produto - Linha do Produto
#### Categoria_produto - Categoria do Produto
#### Custo_dinheiro - Custo total do que foi vendido

#### Dicionario de dados quantidade_vendida.xlsx:
#### Variável - Descricao
#### AnoQuarter - AnoQuarter da coleta da informacao
#### Linha_produto - Linha do Produto 
#### Quantidade_vendida - Quantidade vendida por Linha/AnoQuarter

#### Uma serie de perguntas aguardam respostas:
#### 1. Qual eh a linha mais importante com relacao ao numero de produtos vendidos?
#### 2. Qual eh a linha mais importante com relacao ao valor do Lucro?
#### 3. Qual o AnoQuarter em que o numero de unidades vendidas foi mais baixo, para a linha Children?
#### 4. Qual a media de preco de cada linha?
#### 5. A categoria Sports eh sensivel a preco? Ou seja, quando aumenta o preco a quantidade vendida cai?
#### 6. Qual a linha que teve maior variacao de preco durante os meses estudados?   


# Bora trabalhar?
# Lembre sempre de documentar seu passo a passo para nao se perder
# e tambem porque agora voce e Deus sabem o que esta fazendo
# ja amanha, soh Deus sabera e olhe la!

# Como ja lemos todas as perguntas, sabemos que teremos que criar variaveis novas
# como preco, lucro e que parar criar essas variaveis vamos ter que relacionar todas
# as variaveis, sendo assim, vamos comecar importando os dados, cruzando eles e 
# criando as novas variaveis. Tambem eh importante ressaltar que cada tabela origem
# esta em uma dimensao de dados diferente, ou seja, precisa fazer algumas sumarizacoes

# DIY (do it yourself) - bom trabalho!:
# Importação das bibliotecas de manipulação e visualização de dados
library(readr)
library(readxl)
library(haven)
library(tidyverse)

# Importação dos datasets
total_dinheiro_vendido <- read_delim(
  "dados/total_dinheiro_vendido.txt", 
  delim = "|",
  escape_double = FALSE,
  trim_ws = TRUE
)

custo_dinheiro <- read_delim(
  "dados/custo_dinheiro.txt",
  delim = " ",
  quote = "\"",
  escape_double = FALSE,
  trim_ws = TRUE
)

quantidade_vendida <- read_excel("dados/quantidade_vendida.xlsx")

# Criando visões das bases de dados na dimensão Linha_produto

custo_dinheiro_by_linha_produto <- custo_dinheiro %>%
  group_by(Linha_produto, AnoQuarter) %>%
  summarise(Soma_custo_dinheiro = sum(Custo_dinheiro))

total_dinheiro_vendido_by_linha_produto <- total_dinheiro_vendido %>%
  group_by(Linha_produto, AnoQuarter) %>%
  summarise(Soma_total_dinheiro_vendido = sum(Total_dinheiro_vendido))

total_dinheiro_vendido_by_linha_produto

# Criando o datalake: Cruzando as bases de dados

total_dinheiro_vendido_by_linha_produto %>%
  head()

quantidade_vendida %>%
  head()

empresa_xpto <- quantidade_vendida %>%
  inner_join(custo_dinheiro_by_linha_produto, join_by(Linha_produto, AnoQuarter)) %>%
  inner_join(total_dinheiro_vendido_by_linha_produto, join_by(Linha_produto, AnoQuarter)) %>%
  mutate(
    lucro = Soma_total_dinheiro_vendido - Soma_custo_dinheiro,
    preco = Soma_total_dinheiro_vendido / Quantidade_vendida
  )

# ============================================================================== #
# Questão 1. Qual eh a linha mais importante com relacao ao numero de produtos vendidos?
# ============================================================================== #

empresa_xpto %>%
  group_by(Linha_produto) %>%
  summarise(sum_quantidade_vendida = sum(Quantidade_vendida)) %>%
  arrange(desc(sum_quantidade_vendida)) %>%
  head(1)

empresa_xpto %>%
  ggplot() +
  geom_col(aes(
    x=Linha_produto,
    y=Quantidade_vendida,
    fill=Linha_produto
  ), show.legend = FALSE)

# Resposta: A linha de produtos mais relevante em termos de volume de vendas 
# foi a linha de Sports, com 546.959 unidades vendidas.

# ============================================================================== #
# Questão 2. Qual eh a linha mais importante com relacao ao valor do Lucro?
# ============================================================================== #

empresa_xpto %>%
  group_by(Linha_produto) %>%
  summarise(sum_lucro = sum(lucro)) %>%
  arrange(desc(sum_lucro))

empresa_xpto %>%
  ggplot() +
  geom_col(aes(
    x=Linha_produto,
    y=lucro,
    fill=Linha_produto
  ), show.legend = FALSE)

 # Resposta: A linha de produto mais importante em relação ao valor do lucro
# é a linha de produto de Sports com um total de $ 4664604655.

# ============================================================================== #
# Questão 3. Qual o AnoQuarter em que o numero de unidades vendidas foi mais baixo, para a linha Children?
# ============================================================================== #
empresa_xpto %>%
  filter(Linha_produto == "Children") %>%
  arrange(Quantidade_vendida)

empresa_xpto %>%
  filter(Linha_produto == "Children") %>%
  ggplot(aes(
    x=AnoQuarter,
    y=Quantidade_vendida,
    group = 1
  )) + 
  geom_line() +
  geom_point()

# Resposta: O AnoQuarter com menor vendas da linha Children foi 2001Q1.

# ============================================================================== #
# Questão 4. Qual a media de preco de cada linha?
# ============================================================================== #

names(total_dinheiro_vendido)

empresa_xpto %>%
  group_by(Linha_produto) %>%
  summarise(media_preco = mean(preco))

empresa_xpto %>%
  group_by(Linha_produto) %>%
  summarise(media_preco = mean(preco)) %>%
  ggplot() +
  geom_col(
    aes(
      x=Linha_produto,
      y=media_preco,
      fill = Linha_produto
    ),
    show.legend = FALSE
  ) +
  geom_label(aes(
    x=Linha_produto,
    y=media_preco,
    label=round(media_preco, 2)
  )) +
  labs(
    x="Linha de Produto",
    y="Média de Preço",
    title = "Média de Preço das Linhas de Produtos"
  )

# ============================================================================== #
# Questão 5. A categoria Sports eh sensivel a preco? Ou seja, quando aumenta o preco a quantidade vendida cai?
# ============================================================================== #


empresa_xpto %>%
  filter(Linha_produto == "Sports") %>%
  ggplot(aes(
    y=preco,
    x=Quantidade_vendida
  )) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Resposta: O gráfico de dispersão passa uma vontade
# de traçar uma reta entre os pontos. E passa um sentimento que 
# há uma correlação que quanto menor o preço, maior é a quantidade de vendas.


# ============================================================================== #
# Questão 6. Qual a linha que teve maior variacao de preco durante os meses estudados?
# ============================================================================== #

empresa_xpto %>%
  group_by(Linha_produto) %>%
  summarise(preco_cv = (sd(preco)/mean(preco)) * 100) %>%
  arrange(desc(preco_cv))

empresa_xpto %>%
  group_by(Linha_produto) %>%
  summarise(preco_cv = (sd(preco)/mean(preco)) * 100) %>%
  ggplot() +
  geom_col(aes(
    x=Linha_produto,
    y=preco_cv,
    fill=Linha_produto
  ), show.legend = FALSE)

# Resposta: A linha de produto que teve maior variação 
# de preço foi a linha Sports com coeficente de variação de 445.


