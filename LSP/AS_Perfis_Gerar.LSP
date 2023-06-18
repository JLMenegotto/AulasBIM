;;;;;                                                                                                 
;;;;;                                                                                                 
;;;;; MACRO PARA GERAR SEÇÕES CUSTOMIZADAS EM ADVANCE STEEL                                           
;;;;; AUTOR: PROF. JOSÉ LUIS MENEGOTTO - ESCOLA POLITÃ‰CNICA DA UFRJ                                  
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
                          (initget 1 "I W T")
                          (setq tipo  (strcase (getkword "\nDefina o Tipo de Perfil (Perfil I / Perfil W / Tubular seção Circular (I W ou T): ")))
                          (c:DesenhaPerfil   tipo)
)

(defun c:DesenhaPerfil ( #t )
  
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
		      
		                (if (or (equal #t "I") (equal #t "W") (equal #t "H") (equal #t "HP")) 
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
				          x2       bf
				          y1       (- alt tf)
				          y2          alt
				       
				          a     (list       x1        y1  0 )
				          b     (list       x2        y1  0 )
				          c     (list       x2        y2  0 )
				          d     (list (* -1 x2)       y2  0 )
				          e     (list (* -1 x2)       y1  0 )
				          f     (list (* -1 x1)       y1  0 )
				          g     (list (* -1 x1) (* -1 y1) 0 )
				          h     (list (* -1 x2) (* -1 y1) 0 )
				          i     (list (* -1 x2) (* -1 y2) 0 )
				          j     (list       x2  (* -1 y2) 0 )
				          k     (list       x2  (* -1 y1) 0 )
				          l     (list       x1  (* -1 y1) 0 )
				      
				          ex1          tw
				          ex2       (+ tw      ra)
				          ex3          bf
				          ey1       (- alt tf  ra)
				          ey2       (- alt tf)
				          ey3          alt
				      
				          ea     (list       ex1        ey1 )
				          eb     (list       ex2        ey2 )
				          ec     (list       ex3        ey2 )
				          ed     (list       ex3        ey3 )
				      
				          ee     (list (* -1 ex3)       ey3 )
				          ef     (list (* -1 ex3)       ey2 )
				          eg     (list (* -1 ex2)       ey2 )
				          eh     (list (* -1 ex1)       ey1 )

				          ei     (list (* -1 ex1) (* -1 ey1))
				          ej     (list (* -1 ex2) (* -1 ey2))
				          ek     (list (* -1 ex3) (* -1 ey2))
				          el     (list (* -1 ex3) (* -1 ey3))
				      
				          em     (list       ex3  (* -1 ey3))
				          en     (list       ex3  (* -1 ey2))
				          eo     (list       ex2  (* -1 ey2))
				          ep     (list       ex1  (* -1 ey1))

					  L_conS (list   a  b  c  d  e  f  g  h  i  j  k  l )
					  L_conX (list  ea eb ec ed ee ef eg eh ei ej ek el em en eo ep )
			   	     )
				)

		                (setq Grupo
                                            (cond
				                 ((equal  #t  "T")  (dibuja_perfil_TC   mod  col  fil  con  fab  cla  cod  nox  pox  L_frame  L_conS         ))
				                 ((equal  #t  "I")  (dibuja_perfil_I    mod  col  fil  con  fab  cla  cod  nox  pox  L_frame  L_conS  L_conX ))
				                 ((equal  #t  "W")  (dibuja_perfil_I    mod  col  fil  con  fab  cla  cod  nox  pox  L_frame  L_conS  L_conX ))
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
				((= #cla "VS" )  0.0      )
			        ((= #cla "CS" )  0.0      )
			        ((= #cla "CVS")  0.0      )
				(t               0.0      )))
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
                         (cons 10 (nth 15 pts)) (cons 42  0.0)))
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
