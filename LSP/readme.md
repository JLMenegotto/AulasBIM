## Geração de Perfis estruturais customizados em Advance Steel.

Para gerar os prefis customizados abrir o arquivo **Perfis_Customizados.dwg** , carregar e rodar a função **Gerar_Perfis_I_AdvanceSteel.lsp**.
A função solicita a escolha de um arquivo TXT onde devem estar registradas as dimensões dos perfis de acordo com a sequinte estrutura:


![dadoscustomizados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/5ee9a745-ba64-4357-8c05-7a393a85852a)


![Dimensoes_lsp](https://github.com/JLMenegotto/AulasBIM/assets/9437020/e67ecfdd-03db-41a4-9ecc-3984e8dc15c9)

O úsuario pode criar os seus próprios arquivos TXT para gerar os perfis customizados em Advance Steel

Os perfis serão criados numa matriz de 40 colunas: 

![Perfis_criados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7bcc816d-9b52-44bd-902d-df1451759dcc)

Cada Frame da matriz contem:

 **1. o frame
 2. o contorno básicos 
 3. o contorno exato 
 4. os 9 elementos de controle de alinhamento
 5. o nome do fabricante 
 6. o nome do tipo de perfil**
 
![Perfil_Customizado](https://github.com/JLMenegotto/AulasBIM/assets/9437020/3671c88d-0b31-4c2b-a207-952e8580df02)
