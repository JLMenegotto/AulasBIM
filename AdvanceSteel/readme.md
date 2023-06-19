# Geração de Perfis estruturais customizados para Advance Steel.

## O Advance Steel:
Advance Steel é uma aplicação integrada a AutoCAD que tem como finalidade o projeto de estruturas metálicas.
Embora ela conte com uma grande base de dados de perfis de aço utilizados na indústria, os fabricantes e os projetistas podem 
adicionar novos perfis. Para isso, programei duas funções em AutoLISP que ajudam a gerar e ordenar esses os perfis customizados.
Até o momento, escrevi funções de geração para formas de Perfis I e Tubos de seção circular vazados, mas ampliarei para outras formas. 

## Para usar a Função:
Para gerar os perfis customizados:

1. Baixar e abrir o arquivo   **AS_Perfis_Base.dwg**.
2. Baixar e carregar a função **AS_Perfis_Gerar.LSP**.
   
![Carregar](https://github.com/JLMenegotto/AulasBIM/assets/9437020/eca90b1a-1cb8-46f2-9723-9bd8363a8ccd)

3. Para executar desde a linha de comandos de Advance Steel, digite:
      1. **PERFIL**
         
4. A função solicitará ingressar o tipo de perfil (W I ou T)
5. Indique a fonte de dados => qual será o arquivo TXT das dimensões registradas.
   Pode utilizar os arquivos
     1. **AS_Perfis_Dados_I-W.TXT** de perfis laminados
     2. **AS_Perfis_Dados_CS.TXT**  de perfis soldados para colunas
     3. **AS_Perfis_Dados_VS.TXT**  de perfis soldados para vigas
     4. **AS_Perfis_Dados_CVS.TXT** de perfis soldados para vigas e colunas 
     5. **AS_Perfis_Dados_Tub.TXT** de perfis tubulares de seção circular
     6. O usuário também pode criar os seus próprios arquivos TXT. Para isso, siga a estrutura dos arquivos de exemplo. 

![Dados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/91f4e98f-6b04-498f-9baa-fddf7ba9eeb6)

## Observações:
      1. O valor H na tabela de perfis laminados deve ser 0. 
      2. Os valores das colunas de material e grau não são utilizados para a geração do perfil.
      3. A nomenclatura dos perfis W e Soldados concatena a coluna Classe com a coluna perfil que indica a Altura x Peso Nominal/m.

![Perfis](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7d3b8544-b4d3-4ac7-9e7f-d729d9d43ab8)

## Resultados:
Todos os perfis cadastrados nos arquivos TXT serão criados organizados numa matriz de 40 colunas: 

![Perfis_criados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7bcc816d-9b52-44bd-902d-df1451759dcc)

Cada Frame dessa matriz contem:

 1. O frame retangular
 2. O contorno externo básico do perfil
 3. O contorno externo exato do perfil
 4. O contorno interno básico do perfil para tubulares
 5. O contorno interno exato do perfil para tubulares
 6. Os elementos de controle de alinhamento (9 para I W, 1 para tubulares)
 7. O nome do tipo de perfil
 8. O nome do fabricante 

![Perfil_Matriz](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b36e6026-9368-4e61-86e4-510b3b2aaf49)

Despois de serem criados, eles ficarão disponíveis na base de dados de perfis. 
Para selecioná-los na interface de controle de Advance Steel deve ser acessada a classe **Other profiles**.

![Customizado_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/e560c753-6c1b-49bd-84cc-c17f1eb77144)

## Exemplos de manipulação:

![Posicionamento](https://github.com/JLMenegotto/AulasBIM/assets/9437020/952b3069-d0cd-41d7-b8a7-a0c3dc976a03)
![Display](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b1892d25-b9e8-4653-850e-af123a5e5e37)
