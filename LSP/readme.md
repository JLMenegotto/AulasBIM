## Geração de Perfis estruturais customizados para Advance Steel.

Advance Steel é uma aplicação integrada a AutoCAD que tem como finalidade o projeto de estruturas metálicas.
Embora ela conte com uma grande base de dados de perfis de aço utilizados na indústria, fabricantes e projetistas podem 
adicionar novos perfis. Para isso, programei duas funções em AutoLISP que ajudam a gerar e ordenar esses novos perfis.
No momento foram criadas funções de geração para formas I W e tubos circulares vazados, mas ampliarei para outras formas. 

Para gerar os prefis customizados abrir o arquivo **AS_Perfis_Base.dwg**.

1. Carregar e rodar a função **AS_Perfis_I-W_Gerar.LSP** ou **AS_Perfis_Tub_Gerar.LSP** conforme a necessidade. 
2. Na linha de comandos de Advance Steel executar a função **PERFIL** (gera perfis I ou W) ou a função **TUBOS** (gera os tubulares).
3. Indicar a fonte dos dados que será um arquivo TXT com as dimensões registradas.
   Pode utilizar os arquivos **AS_Perfis_I-W_Dados_Laminados.TXT** **AS_Perfis_I-W_Dados_Soldados.TXT** ou
   **AS_Perfis_Tub_Dados.TXT** como exemplo ou criar os seus próprios arquivos TXT.
   
Para os perfis W ou I siga a sequinte estrutura. 

![Dados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/91f4e98f-6b04-498f-9baa-fddf7ba9eeb6)

Obs: O valor H deve ser 0. Os valores das colunas de material e grau não são utilizados para a geração do perfil.

![Perfis](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7d3b8544-b4d3-4ac7-9e7f-d729d9d43ab8)

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

![Perfil_Matriz](https://github.com/JLMenegotto/AulasBIM/assets/9437020/9c0ad315-5e22-4dad-a140-c2cc8c423778)

Despois de serem criados, eles ficarão disponíveis na base de dados de perfis. 
Para selecioná-los na interface de controle de Advance Steel deve ser acessada a classe **Other profiles**.

![Customizado_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/e560c753-6c1b-49bd-84cc-c17f1eb77144)

Exemplos de manipulação: 
![Posicionamento](https://github.com/JLMenegotto/AulasBIM/assets/9437020/952b3069-d0cd-41d7-b8a7-a0c3dc976a03)
![Display](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b1892d25-b9e8-4653-850e-af123a5e5e37)

