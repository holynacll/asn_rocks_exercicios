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

# ============================================================================== #
# Questão 1. Qual eh a linha mais importante com relacao ao numero de produtos vendidos?
# ============================================================================== #

# Para obter o nome das colunas de forma mais fácil
names(quantidade_vendida)

# criando um novo dataset com base no dataset quantidade_vendida,
# realizando um agrupamento por linha de produto e
# obtendo o total de números vendidos por linha de produto
vendas_por_linha <- quantidade_vendida %>%
  group_by(Linha_produto) %>%
  summarise(total_quantidade_vendas = sum(Quantidade_vendida))

# Query para exibir o total de linhas de produtos vendidas 
# ordenadas do maior para o menor 
vendas_por_linha %>%
  arrange(desc(total_quantidade_vendas))
# Linha_produto   total_quantidade_vendas
# <chr>                             <dbl>
#   1 Sports                           546959
# 2 Clothes & Shoes                  463399
# 3 Outdoors                         199779
# 4 Children                         126021

# Gráfico de barras exibindo o total de linhas de produtos vendidas 
# ordenadas do maior para o menor
vendas_por_linha %>%
  mutate(
    Linha_produto = reorder(
      Linha_produto, -total_quantidade_vendas)
  ) %>%
  ggplot() +
  geom_col(aes(
      x=Linha_produto, 
      y=total_quantidade_vendas,
      fill=Linha_produto
    ),
  show.legend = FALSE
)

# Resposta: A linha de produtos mais relevante em termos de volume de vendas 
# foi a linha de Sports, com 546.959 unidades vendidas.

# ============================================================================== #
# Questão 2. Qual eh a linha mais importante com relacao ao valor do Lucro?
# ============================================================================== #

names(total_dinheiro_vendido)

# criando dataset agrupado por linha_produto e com o total de lucro pro linha de produto
linha_mais_importante <- total_dinheiro_vendido %>%
  group_by(Linha_produto) %>%
  summarise(total_lucro = sum(Total_dinheiro_vendido))

# Query ordenando do maior para o menor lucro de linha de produto 
linha_mais_importante %>%
  arrange(desc(total_lucro))
# Linha_produto   total_lucro
# <chr>                 <dbl>
#   1 Sports           4689773981
# 2 Clothes & Shoes  3458419577
# 3 Outdoors         2539107545
# 4 Children          447369288

# Gráfico de barras exibindo o lucro das linhas de produtos  
linha_mais_importante %>%
  ggplot() +
  geom_col(aes(
      x=Linha_produto,
      y=total_lucro,
      fill=Linha_produto
    ),
    show.legend = FALSE
  )

# Resposta: A linha de produto mais importante em relação ao valor do lucro
# é a linha de produto de Sports com um total de $ 4689773981.

# ============================================================================== #
# Questão 3. Qual o AnoQuarter em que o numero de unidades vendidas foi mais baixo, para a linha Children?
# ============================================================================== #
names(quantidade_vendida)

# Criando dataset numero_de_vendas_by_children
# com as quantidades de vendas da linha de produto Children
numero_de_vendas_by_children <- quantidade_vendida %>%
  filter(Linha_produto == "Children")

# Query de numero_de_vendas_by_children
# ordernando por Quantidade_vendida
# e selecionando o primeiro registro.
numero_de_vendas_by_children %>%
  arrange(Quantidade_vendida) %>%
  slice(1)
# AnoQuarter Linha_produto Quantidade_vendida
# <chr>      <chr>                      <dbl>
#   1 2001Q1     Children                    3787

# Gráfico de linha exibindo o número de vendas por AnoQuarter
numero_de_vendas_by_children %>%
  ggplot(aes(
    x=AnoQuarter,
    y=Quantidade_vendida,
    group = Linha_produto,
  )) +
  geom_line() +
  geom_point()

# Resposta: O AnoQuarter com menor vendas da linha Children foi 2001Q1.


# ============================================================================== #
# Questão 4. Qual a media de preco de cada linha?
# ============================================================================== #

names(total_dinheiro_vendido)

# Query de total_dinheir_vendido
# agrupando por linha_produto
# e obtendo a média de cada linha
media_precos_by_linha <- total_dinheiro_vendido %>%
  group_by(Linha_produto) %>%
  summarise(media_preco = mean(Total_dinheiro_vendido))

# Gráfico de barras exibindo as médias das linhas de produtos 
media_precos_by_linha %>%
  ggplot() +
  geom_col(aes(
    x=Linha_produto,
    y=media_preco,
    fill=Linha_produto
  ), show.legend = FALSE)


media_precos_by_linha
# Resposta: a média de preço de cada linha de produto é a seguinte:
# Linha_produto   media_preco
# <chr>                 <dbl>
#   1 Children           2541871.
# 2 Clothes & Shoes   12008401.
# 3 Outdoors          22670603.
# 4 Sports            13957661.


# ============================================================================== #
# Questão 5. A categoria Sports eh sensivel a preco? Ou seja, quando aumenta o preco a quantidade vendida cai?
# ============================================================================== #

names(custo_dinheiro)
names(quantidade_vendida)

# Query no dataset de custos filtrando Linha_produto por Sports
# agrupando por AnoQuarter
# calculando o custo total por AnoQuarter
custo_dinheiro_by_sports_groupby_anoquarter <- custo_dinheiro %>%
  filter(Linha_produto == "Sports") %>%
  group_by(AnoQuarter) %>%
  summarise(total_custo = sum(Custo_dinheiro))

# Query no dataset de vendas filtrando Linha_produto por Sports
# agrupando por AnoQuarter
# calculando a quantidade total de vendas por AnoQuarter.
quantidade_dinheiro_by_sports_groupby_anoquarter <- quantidade_vendida %>%
  filter(Linha_produto == "Sports") %>%
  group_by(AnoQuarter) %>%
  summarise(total_vendas = sum(Quantidade_vendida))
  
quantidade_dinheiro_by_sports_groupby_anoquarter
custo_dinheiro_by_sports_groupby_anoquarter

# dataframe com a junção das duas queries acima
vendas_custos <- quantidade_dinheiro_by_sports_groupby_anoquarter %>%
  inner_join(custo_dinheiro_by_sports_groupby_anoquarter, by = join_by("AnoQuarter" == "AnoQuarter"))
  
# Gráfico de Dispersão para verificar a relação entre as variáveis total_vendas e total_custos. 
# Podemos perceber que há uma vontade grande de traçar uma reta crescente entre os pontos, 
# isto significa que há uma possível correlação positiva entre as duas variáveis
vendas_custos %>%
  ggplot(aes(
    x=total_vendas,
    y=total_custo,
    fill = 
  )) +
  geom_point() 
  # geom_smooth(method = "lm", se = FALSE)

# Cálculo de correlação utilizando o método de Pearson por padrão
cor(
  vendas_custos$total_vendas,
  vendas_custos$total_custo
)
# [1] 0.9829935

# Resposta: Quanto maior o preço maior a quantidade de vendas,
# existe uma correlação positiva de 0.9829935.


# ============================================================================== #
# Questão 6. Qual a linha que teve maior variacao de preco durante os meses estudados?
# ============================================================================== #

names(custo_dinheiro)

# query de custo_dinheiro
# agrupado por Linha_produto
# calculando o desvio padrão de Custo_dinheiro por Linha_produto
# ordernando pelo maior para o menor desvio padrao do custo_dinheiro.
custo_dinheiro %>%
  group_by(Linha_produto) %>%
  summarise(custo_sd = sd(Custo_dinheiro)) %>%
  arrange(desc(custo_sd))

# Linha_produto   custo_sd
# <chr>              <dbl>
#   1 Outdoors          98904.
# 2 Sports            91350.
# 3 Clothes & Shoes   76991.
# 4 Children          13890.

# Resposta: A linha de produto que teve maior variação de preço/custo foi a linha Outdoors com desvio padrão de 98904.