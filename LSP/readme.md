## Geração de Perfis estruturais customizados para Advance Steel.

Para gerar os prefis customizados abrir o arquivo **AS_Perfis_Base.dwg**.
1. Carregar e rodar a função **AS_Perfis_I-W_Gerar.LSP** ou **AS_Perfis_Tub_Gerar.LSP** conforme a necessidade.
2. Indicar a fonte dos dados que será um arquivo TXT com as dimensões registradas. O úsuario pode criar os seus 
próprios arquivos TXT para gerar perfis customizados em Advance Steel. Para os perfis W ou I siga a sequinte estrutura:
Para perfis I ou W os dados dimensionais devem estar ordenados de acordo a este exemplo. 

![Dados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/91f4e98f-6b04-498f-9baa-fddf7ba9eeb6)

Obs: O valor H deve ser 0. Os valores das colunas de material e grau não são utilizados para a geração do perfil.

![Perfis](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7d3b8544-b4d3-4ac7-9e7f-d729d9d43ab8)

Os perfis serão criados numa matriz de 40 colunas: 

![Perfis_criados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7bcc816d-9b52-44bd-902d-df1451759dcc)

Cada Frame da matriz contem:

 1. O frame retangular
 2. O contorno básico do perfil
 3. O contorno exato do perfil
 4. Os elementos de controle de alinhamento (9 para I W, 1 para tubulares)
 5. O nome do tipo de perfil
 6. O nome do fabricante 
 
![Perfil_Matriz](https://github.com/JLMenegotto/AulasBIM/assets/9437020/9c0ad315-5e22-4dad-a140-c2cc8c423778)

Despois de serem criados, eles estarão disponíveis na base de dados de perfis. Para selecionar dem ser acessada
a classe **Other Profiles** na interface de Advance Steel.

![Customizado_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/e560c753-6c1b-49bd-84cc-c17f1eb77144)

![Posicionamento](https://github.com/JLMenegotto/AulasBIM/assets/9437020/952b3069-d0cd-41d7-b8a7-a0c3dc976a03)
![Display](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b1892d25-b9e8-4653-850e-af123a5e5e37)

