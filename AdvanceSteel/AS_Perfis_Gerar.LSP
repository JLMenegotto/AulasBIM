;;;;;                                                                                                 
;;;;;                                                                                                 
;;;;; MACRO PARA GERAR SEÇÕES CUSTOMIZADAS EM ADVANCE STEEL                                           
;;;;; AUTOR: PROF. JOSÉ LUIS MENEGOTTO - ESCOLA POLITÉCNICA DA UFRJ                                   
;;;;; CURSO:      ESPECIALIZAÇÃO EM ESTRUTURAS METÁLICAS                                              
;;;;; DISCIPLINA: DESENHO, MONTAGEM E FABRICAÇÃO (CAD/CAM/BIM) APLICADAS A PROJETOS DE AÇO            
;;;;;                                                                                                 
;;;;; NOTA IMPORTANTE: Rodar a função dentro do arquivo AS_Perfis_Base.DWG utilizado como base        
;;;;;                                                                                                 
;;;;;                                                                                                 


(defun met_multiplo? (#p #n)     (zerop (met_congrueM? #p #n)))
(defun met_congrueM? (#p #n)     (rem                  #p #n))
(defun met_dxf       (#a #b)     (cdr (assoc #a (if (listp  #b)  #b (entget #b)))))
(defun met_pmedio    (#a #b)     (mapcar '/ (mapcar '+ #a #b)    (list 2.0  2.0  2.0)))
(defun met_bcentro   (#a #b #c)  (mapcar '/ (mapcar '+ #a #b #c) (list 3.0  3.0  3.0)))

(defun met_parte     (#l / li lin lis dado)
  
                           (setq lin    (strcat  (vl-string-trim " "  #l) " - - -")
                                 li     (vl-string->list   lin) 
				 dado   t 
                                 lis   '()
	                   )
                           (while (/= dado "")
			                       (setq dado  (substr lin 1 (vl-position 32 li)))
  			                       (setq lis   (cons dado lis)		  
                                                     li    (member 32 li)                   
                                                     lin   (vl-string-trim dado lin)         
                                                     lin   (vl-string-trim " "  lin)          
                                                     li    (vl-string->list     lin)          
					       )
                           )
                           (if (cdr lis) (reverse (cdr lis)))
)

(defun met_Ler_Dados ()
                           (setq
			        bitolas  '()
			        arq       (getfiled "SELECIONE A TABELA COM OS DADOS DOS PERFIS"  "TXT"  ""  0)
			        arquivo   (open (strcat arq) "r")
		           )
                           (while (setq lin (read-line arquivo))
                                  (if (not (null lin))
                                      (progn
                                         (setq palav   (met_parte (vl-list->string (subst 32 9 (vl-string->list lin))))
                                               bitolas (cons palav bitolas))
			              )
                                  ) 
                           ) 
                           (close arquivo)
                           bitolas
)

(defun C:Perfil ()
                          (gc)
                          (initget 1 "W T U")
                          (setq tipo  (strcase (getkword "\nDefina o Tipo de Perfil ( W / Tubular Circular / Perfil U (W, T ou U): ")))
                          (c:DesenhaPerfiles   tipo)
)

(defun c:DesenhaPerfiles ( #t )
  
                    (setvar "osmode"  0)
                    (setvar "cmdecho" 0)
  
                    (setq  bitolas   (met_Ler_Dados)
                           BitolasD  (cdr (reverse (cdr bitolas)))
	                   qua       (length BitolasD) 
                           con         0
	                   col         1
                           fil         0
   			   mod        40
		           fox       (mapcar '(lambda (lst) (ssget "_X" (list (cons 0 "INSERT") (cons 2 lst))) ) '(
														     "HYPE_REFAXIS0"  "HYPE_REFAXIS1"  "HYPE_REFAXIS2"
			    									                     "HYPE_REFAXIS3"  "HYPE_REFAXIS4"  "HYPE_REFAXIS5"
												                     "HYPE_REFAXIS6"  "HYPE_REFAXIS7"  "HYPE_REFAXIS8"
														  ))
  		           nox       (mapcar '(lambda (lst)             (ssname lst 0) ) fox)
	                   pox       (mapcar '(lambda (lst) (met_dxf 10 (entget lst )) ) nox)
			   
                           frame1    (list   500    1100   0 )
                           frame2    (list  -500    1100   0 )
                           frame3    (list  -500   -1100   0 )
		           frame4    (list   500   -1100   0 )
			   L_frame   (list frame1  frame2  frame3  frame4 )			   
		    )
  
                    (while (< con qua)

		                (setq Dados      ( nth  con BitolasD )  
				      fab        ( nth  0  Dados     )
				      cla        ( nth  1  Dados     )
				      dad2       ( nth  2  Dados     )
                                      dad3       ( nth  3  Dados     )
				      dad4       ( nth  4  Dados     )
                                      dad5       ( nth  5  Dados     )
                                      dad6       ( nth  6  Dados     )				      
				)
		      
		                (if (or (equal #t "W") (equal #t "H") (equal #t "HP")) 
		                    (setq				            
				          dad7   ( nth  7  Dados     )    
                                          dad8   ( nth  8  Dados     )				       
				    )
				)
		      
		                (if (equal #t "T") 
		                    (setq
				          cod       (strcat cla "_" dad2 "_" dad3)
				          raiEx     (*           (atof dad4)  0.5 ) 
				          raiIn     (-    raiEx  (atof dad5))
					  L_conS    (list raiEx  raiIn)
			   	    )
		                    (setq
				          cod              dad2
					  alt     (* (atof dad3)  0.5 )
				          tw      (* (atof dad4)  0.5 )
				          hi      (* (atof dad5)  0.5 )
                                          tf         (atof dad6)
				          bf      (* (atof dad7)  0.5 )				      
			                  ra         (atof dad8)
				  
				          x1       tw
				          x2       (-  bf tw)
					  x3       bf
					  x4       (+ tw ra)
					  
				          y1       alt 
				          y2       (- alt tf   )
                                          y3       (- alt tf tf)
					  y4       (- alt tf ra)
					  
                                          a1       (list x1  y2  0)
					  b1       (list x3  y2  0)
					  c1       (list x3  y3  0)
					  d1       (list x2  y3  0)
					  e1       (list x3  y2  0)
					  f1       (list x3  y1  0)
					  g1       (list x1  y1  0)

					  q1       (list x4  y2  0)
					  r1       (list x1  y4  0)

					  a2       (mapcar '* a1 (list -1  1  0))
					  b2       (mapcar '* b1 (list -1  1  0))
					  c2       (mapcar '* c1 (list -1  1  0))
					  d2       (mapcar '* d1 (list -1  1  0))
					  e2       (mapcar '* e1 (list -1  1  0))
					  f2       (mapcar '* f1 (list -1  1  0))
					  g2       (mapcar '* g1 (list -1  1  0))

					  q2       (mapcar '* q1 (list -1  1  0))
					  r2       (mapcar '* r1 (list -1  1  0))

					  a3       (mapcar '* a1 (list -1 -1  0))
					  b3       (mapcar '* b1 (list -1 -1  0))
					  c3       (mapcar '* c1 (list -1 -1  0))
					  d3       (mapcar '* d1 (list -1 -1  0))
					  e3       (mapcar '* e1 (list -1 -1  0))
					  f3       (mapcar '* f1 (list -1 -1  0))
					  g3       (mapcar '* g1 (list -1 -1  0))
					  
					  q3       (mapcar '* q1 (list -1 -1  0))
					  r3       (mapcar '* r1 (list -1 -1  0))
					  
					  a4       (mapcar '* a1 (list  1 -1  0))
					  b4       (mapcar '* b1 (list  1 -1  0))
					  c4       (mapcar '* c1 (list  1 -1  0))
					  d4       (mapcar '* d1 (list  1 -1  0))
					  e4       (mapcar '* e1 (list  1 -1  0))
					  f4       (mapcar '* f1 (list  1 -1  0))
					  g4       (mapcar '* g1 (list  1 -1  0))

					  q4       (mapcar '* q1 (list  1 -1  0))
					  r4       (mapcar '* r1 (list  1 -1  0))
			   	     )
				)

		                (setq
                                        L_conTU (list  raiEx  raiIn)
					L_conW1 (list  a1    e1 f1 f2 e2 a2 a3       e3 f3 f4 e4    a4 ) ;;simples
					L_conW2 (list  r1 q1 e1 f1 f2 e2 q2 r2 r3 q3 e3 f3 f4 e4 q4 r4 ) ;;exactos
					L_conC1 (list  a1 e1 f1    g2 g3 f4 e4 a4                      ) ;;simples
					L_conC2 (list  r1 q1 e1 f1 g2 g3 f4 e4 q4 r4                   ) ;;exactos
				)
		      
		                (setq Grupo
                                            (cond
				                 ((equal  #t  "T")  (dibuja_perfil_TC  mod  col  fil  con  fab  cla  cod  nox  pox  L_frame  L_conTU          ))
				                 ((equal  #t  "W")  (dibuja_perfil_I   mod  col  fil  con  fab  cla  cod  nox  pox  L_frame  L_conW1  L_conW2 ))
						 ((equal  #t  "U")  (dibuja_perfil_U   mod  col  fil  con  fab  cla  cod  nox  pox  L_frame  L_conC1  L_conC2 ))
						 (t   nil)
				            )
			       	)
		                (if (/= Grupo nil)
		                    (command "._HYPE_ADDSELECTEDPROFILES" Grupo "") 
                                )
		                (setq
				       con  (1+ con)
	      	                       fil  (if (met_multiplo?  con  mod ) ( 1+ fil )  fil)
				)
     		                (prompt ".")
		                (gc)
	              )
                      (setvar "cmdecho"  1)
                      (prin1)
)

;;                                                                                                                                             
;; Funçao principal de desenho dos quadros e das seções Tubulares Circular                                                                     
;;                                                                                                                                             
(defun dibuja_perfil_TC (#m #c #f #n #fab #cla #cod nox pox LF LR )

                        (setq
			      grupo    (ssadd)
			      orig     (list 0  0  0 )
		              fila     #f
			      colu     (met_congrueM?   #n   #m)
			      vetorT   (list (* colu 1100) (* fila -2300) 0)
			      vetort1  (list     0                 -1060  0)
			      vetort2  (list     0                 -1090  0)
    	                )
  
                        (polilinha   #cla LF         "Hype_Frame"                )    (setq grupo (ssadd (entlast) grupo))
                        (texto       vetort1         "Hype_SectionName"     #cod )    (setq grupo (ssadd (entlast) grupo))  
                        (texto       vetort2         "Hype_TypeName"        #fab )    (setq grupo (ssadd (entlast) grupo))
  
                        (circulo     orig (nth 0 LR) "Hype_OuterSection"         )    (setq grupo (ssadd (entlast) grupo))
                        (circulo     orig (nth 1 LR) "Hype_InnerSection"         )    (setq grupo (ssadd (entlast) grupo))
                      
                        (command  "._insert"  "HYPE_COORDINATESYS" orig 25  25  0)    (setq grupo (ssadd (entlast) grupo))
  
                        (met_vlacopia     (nth 4 nox) (nth 4 pox) orig          )     (setq grupo (ssadd (entlast) grupo))
                        (circulo     orig (nth 0 LR ) "Hype_ExactOuterSection"  )     (setq grupo (ssadd (entlast) grupo))

                        (command "._move" grupo "" vetorT "")
                   grupo
)
;;                                                                                                                                             
;; Funçao principal de desenho dos quadros e das seções I W                                                                                    
;;                                                                                                                                             
(defun dibuja_perfil_I  ( #m #c #f #n #fab #cla #cod nox pox LF LP LPE )

                        (setq
			      grupo    (ssadd)
			      orig     (list 0  0  0 )
			      fila      #f
			      colu     (met_congrueM?   #n   #m)
			      vetorT   (list (* colu 1100) (* fila -2300) 0)
			      vetort1  (list     0                 -1060  0)
			      vetort2  (list     0                 -1090  0)
			      
		              topo     (met_pmedio  (nth 2 LP)  (nth 3 LP) )  
 		 	      base     (met_pmedio  (nth 8 LP)  (nth 9 LP) )
			      esq      (met_pmedio  (nth 3 LP)  (nth 8 LP) )
			      dir      (met_pmedio  (nth 2 LP)  (nth 9 LP) )  
	                )
                        (polilinha    #cla LF  "Hype_Frame"                          ) (setq grupo (ssadd (entlast) grupo))
                        (texto        vetort1  "Hype_SectionName" (strcat #cla #cod) ) (setq grupo (ssadd (entlast) grupo))
                        (texto        vetort2  "Hype_TypeName"            #fab       ) (setq grupo (ssadd (entlast) grupo))  

                        (polilinha    #cla LP  "Hype_OuterSection"                   ) (setq grupo (ssadd (entlast) grupo))
                     
                        (command  "._insert"  "HYPE_COORDINATESYS" orig 25  25    0)   (setq grupo (ssadd (entlast) grupo))
                        (command  "._insert"  "HYPE_COORDINATESYS" topo 25  25    0)   (setq grupo (ssadd (entlast) grupo))
                        (command  "._insert"  "HYPE_COORDINATESYS" base 25  25    0)   (setq grupo (ssadd (entlast) grupo))

                        (met_vlacopia  (nth 0 nox)   (nth 0 pox)   (nth 3 LP))         (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 1 nox)   (nth 1 pox)    topo      )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 2 nox)   (nth 2 pox)   (nth 2 LP))         (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 3 nox)   (nth 3 pox)    esq       )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 4 nox)   (nth 4 pox)    orig      )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 5 nox)   (nth 5 pox)    dir       )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 6 nox)   (nth 6 pox)   (nth 8 LP))         (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 7 nox)   (nth 7 pox)    base      )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 8 nox)   (nth 8 pox)   (nth 9 LP))         (setq grupo (ssadd (entlast) grupo))

                        (polilinhaEx  #cla LPE  "Hype_ExactOuterSection")              (setq grupo (ssadd (entlast) grupo))
  
                        (command "._move" grupo "" vetorT "")
                   grupo
)

;;                                                                                                                                             
;; Funçao principal de desenho dos quadros e das seções C                                                                                      
;;                                                                                                                                             
(defun dibuja_perfil_U  ( #m #c #f #n #fab #cla #cod nox pox LF LP LPE )


                          (setq
			      grupo    (ssadd)
			      orig     (list 0  0  0 )
			      fila      #f
			      colu     (met_congrueM?   #n   #m)
			      vetorT   (list (* colu 1100) (* fila -2300) 0)
			      vetort1  (list     0                 -1060  0)
			      vetort2  (list     0                 -1090  0)
			      
		              topo     (met_pmedio  (nth 2 LP)  (nth 3 LP) )  
 		 	      base     (met_pmedio  (nth 8 LP)  (nth 9 LP) )
			      esq      (met_pmedio  (nth 3 LP)  (nth 8 LP) )
			      dir      (met_pmedio  (nth 2 LP)  (nth 9 LP) )  
	                )
                        (polilinha    #cla LF  "Hype_Frame"                          ) (setq grupo (ssadd (entlast) grupo))
                        (texto        vetort1  "Hype_SectionName" (strcat #cla #cod) ) (setq grupo (ssadd (entlast) grupo))
                        (texto        vetort2  "Hype_TypeName"            #fab       ) (setq grupo (ssadd (entlast) grupo))  

                        (polilinha    #cla LP  "Hype_OuterSection"                   ) (setq grupo (ssadd (entlast) grupo))
                     
                        (command  "._insert"  "HYPE_COORDINATESYS" orig 25  25    0)   (setq grupo (ssadd (entlast) grupo))
                        (command  "._insert"  "HYPE_COORDINATESYS" topo 25  25    0)   (setq grupo (ssadd (entlast) grupo))
                        (command  "._insert"  "HYPE_COORDINATESYS" base 25  25    0)   (setq grupo (ssadd (entlast) grupo))

                        (met_vlacopia  (nth 0 nox)   (nth 0 pox)   (nth 3 LP))         (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 1 nox)   (nth 1 pox)    topo      )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 2 nox)   (nth 2 pox)   (nth 2 LP))         (setq grupo (ssadd (entlast) grupo))
;;;                        (met_vlacopia  (nth 3 nox)   (nth 3 pox)    esq       )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 4 nox)   (nth 4 pox)    orig      )        (setq grupo (ssadd (entlast) grupo))
                        (met_vlacopia  (nth 5 nox)   (nth 5 pox)    dir       )        (setq grupo (ssadd (entlast) grupo))
;;;                        (met_vlacopia  (nth 6 nox)   (nth 6 pox)   (nth 8 LP))         (setq grupo (ssadd (entlast) grupo))
;;;                    (met_vlacopia  (nth 7 nox)   (nth 7 pox)    base      )        (setq grupo (ssadd (entlast) grupo))
;;;                        (met_vlacopia  (nth 8 nox)   (nth 8 pox)   (nth 9 LP))         (setq grupo (ssadd (entlast) grupo))

                        (polilinhaEx  #cla LPE  "Hype_ExactOuterSection")              (setq grupo (ssadd (entlast) grupo))
  
                        (command "._move" grupo "" vetorT "")
                   grupo 
)

(defun met_vlacopia (ob p1 p2) (vla-move (vla-copy (vlax-ename->vla-object ob)) (vlax-3d-point p1) (vlax-3d-point p2)))

;; Desenha polylinha BASICA do perfil e Frames                                                                                                
(defun polilinha (#cla pts  layer)
               (entmake
                 (append
                   (list
	                  (cons   0   "LWPOLYLINE")
                          (cons 100   "AcDbEntity")
                          (cons 100   "AcDbPolyline")
                          (cons   8    layer)
                          (cons  90   (length pts))
                          (cons  70    1)
                     )
                     (mapcar '(lambda (p) (cons 10 p) ) pts)
	         ))
)

;; Desenha polylinha EXATA do perfil                                                                                                          
(defun polilinhaEx (#cla pts  layer)
  
             (setq bulge (cond
			        ((= #cla "W"  ) -0.414214 )
			        ((= #cla "H"  ) -0.414214 )
			        ((= #cla "HP" ) -0.414214 )
			        ((= #cla "U"  ) -0.414214 )				
				((= #cla "VS" )  0.0      )
			        ((= #cla "CS" )  0.0      )
			        ((= #cla "CVS")  0.0      )
				(t               0.0      )))
             (if (= #cla "U")
	         (entmake
                     (list
                         (cons 0    "LWPOLYLINE")
                         (cons 100  "AcDbEntity")
                         (cons 100  "AcDbPolyline")
		         (cons 8    layer)
                         (cons 90   (length pts))
                         (cons 70       1)
                         (cons 10 (nth  0 pts)) (cons 42  bulge)
                         (cons 10 (nth  1 pts)) (cons 42  0.0)
			 (cons 10 (nth  2 pts)) (cons 42  0.0)
                         (cons 10 (nth  3 pts)) (cons 42  0.0)
                         (cons 10 (nth  4 pts)) (cons 42  0.0)
                         (cons 10 (nth  5 pts)) (cons 42  0.0)
                         (cons 10 (nth  6 pts)) (cons 42  0.0)
			 (cons 10 (nth  7 pts)) (cons 42  0.0)
			 (cons 10 (nth  8 pts)) (cons 42  bulge)
			 (cons 10 (nth  9 pts)) (cons 42  0.0)
		   )
                 )
                 (entmake
                     (list
                         (cons 0    "LWPOLYLINE")
                         (cons 100  "AcDbEntity")
                         (cons 100  "AcDbPolyline")
		         (cons 8    layer)
                         (cons 90   (length pts))
                         (cons 70       1)
                         (cons 10 (nth  0 pts)) (cons 42  bulge)
                         (cons 10 (nth  1 pts)) (cons 42  0.0)
			 (cons 10 (nth  2 pts)) (cons 42  0.0)
                         (cons 10 (nth  3 pts)) (cons 42  0.0)
                         (cons 10 (nth  4 pts)) (cons 42  0.0)
                         (cons 10 (nth  5 pts)) (cons 42  0.0)
                         (cons 10 (nth  6 pts)) (cons 42  bulge)
                         (cons 10 (nth  7 pts)) (cons 42  0.0)
			 (cons 10 (nth  8 pts)) (cons 42  bulge)
                         (cons 10 (nth  9 pts)) (cons 42  0.0)
                         (cons 10 (nth 10 pts)) (cons 42  0.0)
                         (cons 10 (nth 11 pts)) (cons 42  0.0)
			 (cons 10 (nth 12 pts)) (cons 42  0.0)
                         (cons 10 (nth 13 pts)) (cons 42  0.0)
		         (cons 10 (nth 14 pts)) (cons 42  bulge)
                         (cons 10 (nth 15 pts)) (cons 42  0.0)
		   )
              )
	   )
)

;; Desenha circulo                                                                                                           
(defun circulo (cen rai layer)
               (entmake
                   (list
                        (cons 0    "CIRCLE")
                        (cons 100  "AcDbEntity")
                        (cons 100  "AcDbCircle")
		        (cons 8    layer)
                        (cons 10   cen)
		        (cons 40   rai)
                 ))
)
;; Coloca os textos                                                                                                                             
(defun texto (pt layer texto )
               (entmake
                   (list
                           (cons   0  "TEXT"       )
                           (cons 100  "AcDbEntity" )
                           (cons 100  "AcDbText"   )
                           (cons  1    texto       )
                           (cons  8    layer       )
	                   (cons 10    (list 0 0 0))
	                   (cons 40    25          )
    	                   (cons 71     0          )
	                   (cons 72     1          )
                    )
                )
                (command "._move" (entlast) "" pt "") 
)

(prompt "\nFunção carregada.... \nPara executar digite PERFIL")
(princ)