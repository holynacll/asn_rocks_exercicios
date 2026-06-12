# Introducao ao R

# Legendas:
#  Explicacao Conteudo
## Dicas
### Pratica
#### Contexto Negocio

# Vamos falar sobre pacotes/bibliotecas
# no R existem varias bibliotecas criadas pela comunidade que estao disponiveis para uso
## DICA: priorize usar bibliotecas conhecidas e de alta manipulacao
# essas bibliotecas podem ser instaladas facilmente
# Tools, install packages
# ou atraves do comando install.packages("nome_do_pacote")
# importante lembrar que soh devemos instalar a biblioteca uma vez
# depois basta chama-la, nao tem mais necessidade de instalar
# analogia da lampada: voce so instala uma vez, depois soh acende ou apaga

# existem varias bibliotecas muito uteis
# vamos comecar falando sobre as de importacao de arquivos
# depois daremos foco nas de manipulacao e visualizacao

## sempre coloque todas suas bibliotecas logo no inicio do codigo
## boa pratica muito utilizada

# vamos chamar todas as bibliotecas necessarias para
# importar aquivos excel, csv e sas ou spss
# manipular dados
library(readr)
library(readxl)
library(haven)
library(tidyverse)

# estrutura do codigo para importacao de arquivos

# ler arquivo txt ou csv, pela biblioteca readr
# nome_base <- read_delim(file = "nome_arquivo.txt", delim = "|")

# ler arquivo excel, pela biblioteca readrxl
# nome_base <- read_excel(path = "nome_arquivo.xlsx")

# ler arquivo sas ou spss, pela biblioteca haven
# nome_base <- read_sas("nome_arquivo.sas7bdat")
# nome_base <- read_spss("nome_arquivo.sav")

## DICA: abuse da opcao point and click:
## File, Import Data Set e siga o passo a passo!

# vamos utilizar a base da dados employee_master.sas7bdat durante o curso
# importar essa base com o nome funcionarios
funcionarios <- read_sas("dados/employee_master.sas7bdat", NULL)


### Exercicio
### quantas linhas e colunas tem nessa base de dados?
dim(funcionarios)

### quais sao os nomes das variaveis dessa base?
names(funcionarios)

### explore o dicionario de dados

# dicionario de dados funcionarios
# base de dados dos colaboradores da empresa XPTO
# cada linha representa um colaborador com sua informacao atual
# descricao das variaveis:
# Employee_ID - identificador do colaborador - nominal
# Employee_Name - nome do colaborador - nominal
# Employee_Gender - genero do colaborador - nominal
# Birth_Date - data de nascimento do colaborador - data
# Employee_Hire_Date - data de contratacao do colaborador - data
# Salary - salario atual do colaborador - continua
# Street_Number - numero da moradia do colaborador - nominal
# City - cidade do colaborador - nominal
# State - estado do colaborador - nominal
# Country - pais do colaborador - nominal
# Postal_Code - cep do colaborador - nominal
# Department - departamento onde o colaborador atua - nominal
# Job_Title - titulo do cargo do colaborador - nominal
# Manager_ID - identificador do gerente do colaborador - nominal

### Exercicio
### pensando estatisticamente, como você classificaria cada variavel?
### adicione a definicao ao lado de cada uma das variaveis


# alem das bibliotecas de importacao, eh importante conhecermos 
# as bibliotecas de manipulacao de dados
# atualmente a biblioteca mais forte nisso eh a tidyverse!

# FILTRO
# filtrar linha de uma base de dados
# listar apenas os funcionarios da cidade Sydney
funcionarios %>% 
  filter(City == "Sydney")

## DICA: para o comando pipe aperte "ctrl + shift + m"
## DICA: sempre apos um pipe, aperte o enter

# listar apenas funcionarios de San Diego e Melbourne
funcionarios %>% 
  filter(City %in% c("San Diego", "Melbourne"))

# listar apenas os funcionarios que sao de Philadelphia E ganham menos que 36000
t1 <- funcionarios %>% 
  filter(City == "Philadelphia",
         Salary < 36000)

# listar apenas os funcionarios que sao de mulheres OU que trabalham no administrativo
funcionarios %>% 
  filter(Employee_Gender == "F" |
         Department == "Administration")

#### Contexto de Negocio
#### A empresa XPTO fara uma acao de RH extremamente especifico
#### sera um evento apenas para mulheres que ganham menos que 30000 ao ano
#### e que nao trabalhem no departamento Sales nem Accounts
### Exercicio
### crie uma nova base de dados chamada evento_rh
### que contenha todas essas restricoes!
evento_rh <- funcionarios %>% 
  filter(Salary < 30000,
         Employee_Gender == "F",
         !Department %in% c("Sales", "Accounts"))




# SELECIONANDO COLUNAS
# selecionar colunas te permite limitar as variaveis que voce deseja
# selecionando apenas a variavel Nome do colaborador
funcionarios %>% 
  select(Employee_Name)

# selecionando todas as variaveis menos o salario
funcionarios %>% 
  select(-Salary)

# selecionando apenas as variaveis que comecam com a palavra Employee
funcionarios %>% 
  select(starts_with("Employee"))

#### Contexto de Negocio
#### A empresa XPTO precisa da lista com o nome e a data de nascimento
#### de todos os colaboradores que ganhem menos de 50000 por ano
### Exercicio
### crie uma nova base de dados chamada niver_50
### que contenha essas restricoes!
niver_50 <- funcionarios %>% 
  filter(Salary < 50000) %>% 
  select(Employee_Name, Birth_Date)

# ORDENANDO DADOS
# ordenar dados permite que organizemos os dados da forma que for conveniente
# ordenando a base do menor para o maior salario
funcionarios %>% 
  arrange(Salary)

# ordenando a base do maior para o menor salario
funcionarios %>% 
  arrange(desc(Salary))

# ordenando a base por departamento e depois por salario do maior para o menor 
s <- funcionarios %>% 
  arrange(Department, desc(Salary))

#### Contexto de Negocio
#### A empresa XPTO precisa da lista de todos os funcionarios homens
#### que sejam do departamento de Sales, que nao sejam de San Diego
#### esse conjunto de dados deve conter todas as variaveis menos o salario.
#### Eh importante que essa base de dados
#### esteja ordenada pela cidade, departamento e salario (maior para o menor)
#### mesmo que esta variaveis nao esteja na base de dados
### Exercicio
### crie uma nova base de dados chamada homens
### que contenha essas restricoes!
homens <- funcionarios %>%
  filter(Employee_Gender == "M", Department == "Sales", City != "San Diego") %>% 
  arrange(City, Department, desc(Salary)) %>% 
  select(-Salary)



# CRIANDO NOVAS COLUNAS
# Criar novas colunas nos da novas opcoes de analise conforme o contexto
# crie uma nova variavel chama salario_mensal, que divide o salario por 13
# e selecione apenas o nome e o salario mensal, ordenando pela nova variavel
funcionarios %>% 
  mutate(salario_mensal = Salary/13) %>% 
  select(Employee_Name, salario_mensal) %>% 
  arrange(salario_mensal)

# crie uma nova variavel chamada salario_ajustado, onde todas as mulheres terao
# um aumento de 20% e os homens um aumento de 5%
# selecione apenas o nome, genero e o salario ajustado
funcionarios %>% 
  mutate(Salario_ajustado = ifelse(Employee_Gender == "F", Salary*1.2,
                                   Salary*1.05)) %>% 
  select(Employee_Name, Employee_Gender, Salario_ajustado)

#### Contexto de Negocio
#### A empresa XPTO devera cumprir uma nova regra do sindicato
#### Todos os funcionarios com mais de 20 anos de casa deverao receber um ajuste
#### salarial de 15%. No entanto isso soh eh valido para colaboradores de San Diego.
#### O sindicado exige que a lista de funcionarios com o novo salario seja enviado ainda hoje.
### Exercicio
### crie uma nova base de dados chamada urgente
### que contenha essas restricoes!
urgente <- funcionarios %>% 
  mutate(
    tempo_de_servico = interval(Employee_Hire_Date, today()) / years(1),
    tempo_de_servico_maior_que_20_anos = tempo_de_servico >= 20,
    salario_corrigido = ifelse(tempo_de_servico_maior_que_20_anos, Salary * 1.15, Salary)
  ) %>% 
  filter(City == "San Diego", tempo_de_servico_maior_que_20_anos) %>% 
  select(Employee_Name, salario_corrigido)


# AGRUPANDO E SUMARIZANDO DADOS
# Sumarizar ou realizar contas a partir de um agrupamento eh uma tarefa extremamente
# comum e necessaria. Isso eh muito importante!
# descubra o menor e o maior salario de cada departamento
funcionarios %>% 
  group_by(Department) %>% 
  summarise(menor_salario = min(Salary),
            maior_salario = max(Salary))

# descubra a media salarial por genero
funcionarios %>% 
  group_by(Employee_Gender) %>% 
  summarise(media_salario = mean(Salary))

#### Contexto de Negocio
#### A diretoria da empresa XPTO ficou reflexiva sobre nossa analise anterior
#### e gostaria de descobrir em qual cargo isso acontece
### Exercicio
### Calcule a media, min, max e desvio padrao do salario por job_title e genero
### Responda: por que o desvio padrão aparece como NA em algumas linhas?
salarios_por_genero_e_cargo <- funcionarios %>% 
  group_by(Job_Title, Employee_Gender) %>% 
  summarise(
    media_salario = mean(Salary),
    menor_salario = min(Salary),
    maior_salario = max(Salary),
    desvio_padrao_salario = sd(Salary)
  )

### Exercicio
### Carregue a base de dados country_lookup.xslx no R com o nome country
country <- read_excel("dados/country_lookup.xlsx")

# JUNTANDO TABELAS
# No dia a dia sempre vamos precisar cruzar informacoes de mais de uma tabela
# Left, Rigth, inner e full join sao importantes
# o que voce ira usar, depende do que precisa fazer!
# Na nova base importada, encontramos o de-para do pais para seu nome completo
# adicione essa informacao na tabela de funcionarios
# vamos manter apenas as variaveis Nome, departamento, pais e o pais escrito
 funcionarios %>% 
  select(Employee_Name, Department, Country) %>% 
  left_join(country, by = join_by("Country"=="Country_Key"))

 
#### Contexto de Negocio
#### A diretoria da empresa XPTO estava em uma discussao sobre salarios e uma
#### pergunta surgiu: qual a diferenca do salario mensal do colaborador e 
#### seu respectivo gerente? Existe algum colabora que ganha mais que o gerente?
### Exercicio
### Encontre uma forma de criar uma nova variavel que contenha, de forma ordenada
### a diferenca de salarios mensais entre colaborador e gerente. Faça isso para
### todos os colaboradores da tabela
colaborador_x_gerente <- funcionarios %>% 
   left_join(
     funcionarios,
     suffix = c("_func", "_chefe"),
     by = join_by("Manager_ID"=="Employee_ID"),
   ) %>% 
  mutate(
    salario_mensal_func = Salary_func / 13,
    salario_mensal_chefe = Salary_chefe / 13,
    diff_salario = salario_mensal_chefe - salario_mensal_func
  ) %>% 
  select(
    Employee_Name_func,
    salario_mensal_func,
    Employee_Name_chefe,
    salario_mensal_chefe,
    diff_salario
  ) %>% 
  arrange(diff_salario)
  



