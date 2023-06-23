# Relógio.dyn

As funções de Dynamo podem ser executadas de modo **Manual, Automático ou Periódico**. A função **Relógio.dyn** exemplifica a execução periódica em Dynamo. Para que o modo de execução periódico fique habilitado, deve haver dentro da função a participação das funções de Tempo (Time, TimeSpan...). Para a função Relogio.dyn, foram criados 3 ponteiros (Horas, Minutos e Segundos) e uma marcação circular de Horas e Minutos com o desenho do tipo de relógio.

Para que os ponteiros se movam angularmente, os módulos angulares devem ser:

 1. Para as horas = 12 => (360 / 12 = 30) 
 2. Para os minutos e segundos = 6 => (360 / 6 = 60)

![Relogio](https://github.com/JLMenegotto/AulasBIM/assets/9437020/ae27a62a-6541-4627-aa92-0322273bf85a)

