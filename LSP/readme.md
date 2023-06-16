## Macro Gerar_Perfis_I_AdvanceSteel.LSP 

Para gerar os prefis customizados abrir o arquivo **Perfis_Customizados.dwg** , carregar e rodar a função **Gerar_Perfis_I_AdvanceSteel.lsp**.
A função solicita a escolha do arquivo TXT que devem conter as dimensões dos perfis de acordo com a sequinte estrutura:

Fabricante	Classe	Perfil	    d	    tw	    h	    tf	    bf	  R/ec  	Mate	 Grau
GERDAU	    W	      610x217	   627	  16.5	 0000	  27.7	 328	  12.7	  A572	 50
GERDAU	    W	      610x195	   622	  15.4	 0000	  24.4	 328	  12.7	  A572	 50
GERDAU	    W	      610x174    616	   14	   0000	  21.6	 325	  12.7	  A572	 50

![Dimensoes_lsp](https://github.com/JLMenegotto/AulasBIM/assets/9437020/e67ecfdd-03db-41a4-9ecc-3984e8dc15c9)

O úsuario pode criar os seus próprios arquivos TXT para gerar os perfis customizados em Advance Steel

Os perfis serão criados numa matriz com os frames e os dados necessários para controlar os alinhamentos.

![Perfis_criados](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7bcc816d-9b52-44bd-902d-df1451759dcc)

Os valores de Fabricante e tipo de perfil que será incorporado á base de dados do desenho. 

![Perfil_Customizado](https://github.com/JLMenegotto/AulasBIM/assets/9437020/3671c88d-0b31-4c2b-a207-952e8580df02)
