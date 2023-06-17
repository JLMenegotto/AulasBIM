## Geração de Perfis estruturais customizados em Advance Steel.

Para gerar os prefis customizados abrir o arquivo **AS_Perfis_Base.dwg**.
1. Carregar e rodar a função **AS_Perfis_I-W_Gerar.LSP** ou **AS_Perfis_Tub_Gerar.LSP** conforme a necessidade.
2. Indicar a fonte dos dados que será um arquivo TXT com as dimensões registradas. O úsuario pode criar os seus 
próprios arquivos TXT para gerar perfis customizados em Advance Steel. Para os perfis W ou I siga a sequinte estrutura:
Para perfis I ou W os dados dimensionais devem estar ordenados de acordo a este exemplo. 
![dadoscustomizados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/5ee9a745-ba64-4357-8c05-7a393a85852a)

O valor H deve ser 0.

![Perfis](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7d3b8544-b4d3-4ac7-9e7f-d729d9d43ab8)


Os perfis serão criados numa matriz de 40 colunas: 

![Perfis_criados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7bcc816d-9b52-44bd-902d-df1451759dcc)

Cada Frame da matriz contem:

 1. o frame
 2. o contorno básico 
 3. o contorno exato 
 4. os 9 elementos de controle de alinhamento
 5. o nome do tipo de perfil
 6. o nome do fabricante 
 
![Perfil_Matriz](https://github.com/JLMenegotto/AulasBIM/assets/9437020/9c0ad315-5e22-4dad-a140-c2cc8c423778)

