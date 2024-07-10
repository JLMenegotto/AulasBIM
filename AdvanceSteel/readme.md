# Geração de Perfis estruturais customizados para Advance Steel.

## O Advance Steel:
Advance Steel é uma aplicação integrada em AutoCAD cuja finalidade é o projeto de estruturas metálicas em ambiente BIM.
Embora ela conte com uma grande base de dados dos perfis de aço utilizados pela indústria, os fabricantes e os projetistas podem 
adicionar novos perfis customizados. Para isso, programei duas funções em AutoLISP que ajudam a gerar e ordenar a customização.
Até o momento, escrevi funções de geração para formas de Perfis W, U e Tubos de Seção Circular, mas ampliarei para outras formas. 
Esta é uma das formas de ampliar a base de dados de perfis do Advance Steel. Outra forma, é adicionar diretamente os dados 
nas planilhas de perfis utilizando um editor de planilhas SQL.

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
      3. A nomenclatura dos perfis W e Soldados concatena a coluna **Classe** com a coluna **Perfil** que indica a Altura x Peso Nominal/m.

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

## 
[**Canal YouTube:** Videos com explicação dos conteúdos e metodologias das funções](https://www.youtube.com/channel/UCCN58u2BP38F09aswlJrILA)
#### **Consulte outros projetos**
  
   1. [**OntologiaBIM:** Construtor de ontologias OWL](https://github.com/JLMenegotto/OntologiaBIM)
   2. [**Acustica2024 e Parla:** Integração do Simulador Acústico BRASS com Revit](https://github.com/JLMenegotto/Acustica_2024)
   3. [**RIO:** Reformatação de acervos digitais](https://github.com/JLMenegotto/Rio)
   4. [**Promenade:** Sistema IoT para microlocalização](https://github.com/JLMenegotto/Promenade)
   5. [**Sistemas Projetivos:** Funções para o ensino de Geometria Descritiva em Revit](https://github.com/JLMenegotto/SistemasProjetivos)
   6. [**Atratores:** Funções AutoLISP para geração de pontos](https://github.com/JLMenegotto/Atratores)
   7. [**EGC:** Funções em AutoLISP para representação e formalização do projeto](https://github.com/JLMenegotto/EGC)
   8. [**Funções Geométricas:** Funções Dynamo para geometria plana](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Geometricas)
   9. [**Funções de Análise de Lotes:** Funções Dynamo para o projeto conceptual a partir do lote](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Lotes)
  10. [**Funções Obras Paradigmáticas:** Funções Dynamo de projetos paradigmáticos]( https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Obras)
  11. [**Funções Gerais de Predios:** Funções Dynamo para automatizar o projeto](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Predio)
  12. [**Funções Periódicas Temporais:** Funções Dynamo para trabalhar com o tempo](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Relógio)
  13. [**Funções para Galpões:** Funções Dynamo para automatizar o projeto de Gapões de aço](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Galpão)
  14. [**Funções para Treliças:** Funções Dynamo para automatizar o projeto de treliças](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Treliças)
  15. [**Funções para Ambientes:** Funções Dynamo para automatizar o projeto a partir do objeto Room em Revit](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Rooms)
  16. [**Funções para Advance Steel:** Funções para gerar perfis customizados em AdvanceSteel](https://github.com/JLMenegotto/AulasBIM/tree/master/AdvanceSteel)
  17. [**Funções para torres:** Funções para Dynamo gerar estruturas verticais](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Torres)
      
  18. [**Bibliografia**](https://jlmenegotto.wixsite.com/jlmenegotto-bim/pesquisa)
  19. [**Publicações**](https://jlmenegotto.wixsite.com/jlmenegotto-bim/jlm-public)
      
![capa](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b6f1b49d-24e5-4588-b52f-d93869d3784b)


