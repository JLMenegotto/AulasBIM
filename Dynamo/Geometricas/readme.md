
# Geométricas

As funções geométricas exemplificam usos de traçados geométricos para o projeto. As explicações dos códigos e das formas podem ser vistas nestes vídeos.
Sugere-se que os alunos modifiquem as funções incorporando-lhes novas possibilidades.  

  1. Oval de 4 Centros:       https://youtu.be/h-NVtklN2mU
  2. Uso da Ciclóide:         https://youtu.be/7UbUaqYFVvs
  3. Espirais de n centros:   https://youtu.be/Swo7Bw9D8ZY

## Oval4Centros.dyn
Esta função exemplifica o uso formal de uma figura plana como a Oval de 4 Centros para iniciar o processo de busca formal de um 
projeto. A oval de 4 centros é construída a partir de losangos dimétricos ou isométricos que permitem a construção com compasso
de 4 arcos tangentes ao losango e conconcordantes entre si. O processo de construção inicia pela definição das mediatrizes que
permitirão encontrar os quatro centros dos 4 arcos que cumprem as condições de tangencias e concordâncias.

![o4c](https://github.com/JLMenegotto/AulasBIM/assets/9437020/fb9f37b6-173e-4d5b-82f1-bb098d3571df)

Code Block 1

1. Dx;
2. Dy;
3. p1 = Point.ByCoordinates(Dx , 0  , 0);
4. p2 = Point.ByCoordinates(0  , Dy , 0);
5. p3 = Point.ByCoordinates(-Dx, 0  , 0);
6. p4 = Point.ByCoordinates(0  , -Dy, 0);
7. LP = [p1,p2,p3,p4];
8. LPS = List.ShiftIndices(LP, 3);
9. Lad = Line.ByStartPointEndPoint(LP, LPS);
10. Pme = Line.PointAtParameter  (Lad , 0.5);
11. Nor = Line.NormalAtParameter (Lad , 0.5);
12. Tng = Line.TangentAtParameter(Lad , 0.5);
13. Pms = List.ShiftIndices(Pme, 3);
14. O4C = Arc.ByStartPointEndPointStartTangent(Pme, Pms, Tng);
15. Cen = O4C.CenterPoint;
16. Lin = Line.ByStartPointEndPoint(Cen, Pme);

## Forma_Cicloide_01.dyn
Esta função exemplifica a construção e o uso formal de uma Ciclóide, utilizada como lei formal de uma estrutura cíclica.  

![Cicloide](https://github.com/JLMenegotto/AulasBIM/assets/9437020/15731552-3b55-41f7-a398-ac2d0ad7974c)

![Cicloide2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/1c0a0aaa-993f-4e48-ac13-f4947621b362)

## Forma_Espiral_NCentros.dyn
Esta função exemplifica a construção e o uso formal de Espirais de n Centros. Embaixo, duas espirais, com 6 e 8 centros.

![Espirais](https://github.com/JLMenegotto/AulasBIM/assets/9437020/604a1d98-30c1-4c88-a420-4e3480b25063)
