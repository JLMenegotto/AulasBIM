;;;;;                                                                                       
;;;;;                                                                                       
;;;;;                                                                                       
;;;;; FUNÇÃO PARA GERAÇÃO AUTOMÁTICA DE SEÇOES CUSTOMIZADAS EM ADVANCE STEEL                
;;;;; AUTOR: PROF. JOSÉ LUIS MENEGOTTO - ESCOLA POLIÉCNICA DA UFRJ                          
;;;;; CURSO:      ESPECIALIZAÇÃO EM ESTRUTURAS METÁLICAS                                    
;;;;; DISCIPLINA: Desenho, Montagem e Fabricação (CAD/CAM/BIM) aplicadas a projetos de aço  
;;;;;                                                                                       
;;;;;                                                                                       
;;;;;                                                                                       
(defun met_dxf      (#a #b)      (cdr (assoc #a
					     (if (listp  #b)
					                 #b
					         (entget #b)
					     )
			         )
		                )
)
					    
(defun met_pmedio    (#a #b)                                                                         
	                          (mapcar '/ (mapcar '+ #a #b)                                                 
					     (list 2.0 2.0 2.0)                                        
				  )                                                                      
)
(defun met_bcentro   (#a #b #c)                                                                         
	                          (mapcar '/ (mapcar '+ #a #b #c)                                                 
					     (list 3.0  3.0  3.0)                                        
				  )                                                                      
)
(defun met_parte (l / li lin lis dado)
                           (setq lin   (strcat  (vl-string-trim " "  l) " - - -")
                                 li    (vl-string->list   lin) 
				 dado  t 
                                 lis  '()
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
(defun met_Translada (#pts  #vet)
                       (mapcar '(lambda (p) (mapcar '+ p #vet) ) #pts)
)

(defun c:Perfil ()
  
            (setvar "osmode"  0)
            (setvar "cmdecho" 0)
  
            (setq bitolas  (met_Ler_Dados)
                  BitolasI (cdr (reverse (cdr bitolas)))
	          qua      (length BitolasI) 
		  con      0

		  ax1       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS0")))
		  ax2       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS1")))
		  ax3       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS2")))
		  ax4       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS3")))
		  ax5       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS4")))
		  ax6       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS5")))
		  ax7       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS6")))
		  ax8       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS7")))
                  ax9       (ssget "_X" (list (cons 0 "INSERT") (cons 2 "HYPE_REFAXIS8")))
                  ref1      (ssname ax1 0)
		  ref2      (ssname ax2 0)
		  ref3      (ssname ax3 0)
		  ref4      (ssname ax4 0)
                  ref5      (ssname ax5 0)
                  ref6      (ssname ax6 0)
		  ref7      (ssname ax7 0)
		  ref8      (ssname ax8 0)
		  ref9      (ssname ax9 0)
		  Px1       (met_dxf 10 (entget ref1))
		  Px2       (met_dxf 10 (entget ref2))
		  Px3       (met_dxf 10 (entget ref3))		  
		  Px4       (met_dxf 10 (entget ref4))
		  Px5       (met_dxf 10 (entget ref5))
		  Px6       (met_dxf 10 (entget ref6))
		  Px7       (met_dxf 10 (entget ref7))
		  Px8       (met_dxf 10 (entget ref8))
		  Px9       (met_dxf 10 (entget ref9))		  
            )
            (while (< con qua)  
                                (setq perfil  (nth con BitolasI)
				      
                                      fab              (nth 0   perfil )
				      cla              (nth 1   perfil )
				      cod              (nth 2   perfil )
				      alt     (* (atof (nth 3   perfil ))  0.5 )
				      tw      (* (atof (nth 4   perfil ))  0.5 )
				      hi      (* (atof (nth 5   perfil ))  0.5 )
                                      tf         (atof (nth 6   perfil ))
				      bf      (* (atof (nth 7   perfil ))  0.5 )				      
			              ra         (atof (nth 8   perfil ))
				    				      
				      x1       tw
				      x2       bf
				      y1       (- alt tf)
				      y2          alt
				      
				      a     (list       x1        y1    0 )
				      b     (list       x2        y1    0 )
				      c     (list       x2        y2    0 )
				      d     (list (* -1 x2)       y2    0 )
				      e     (list (* -1 x2)       y1    0 )
				      f     (list (* -1 x1)       y1    0 )
				      g     (list (* -1 x1) (* -1 y1)   0 )
				      h     (list (* -1 x2) (* -1 y1)   0 )
				      i     (list (* -1 x2) (* -1 y2)   0 )
				      j     (list       x2  (* -1 y2)   0 )
				      k     (list       x2  (* -1 y1)   0 )
				      l     (list       x1  (* -1 y1)   0 )

                                      m     (list  500   1100  0)
				      n     (list -500   1100  0)
                                      o     (list -500  -1100  0)
				      p     (list  500  -1100  0)				      

				      ex1          tw
				      ex2       (+ tw  ra)
				      ex3          bf
				      ey1       (- alt tf ra)
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
				)
	      
	                        (dibuja_perfil_I
				                con                                                      ;contador        
				                fab                                                      ;fabricante      
                                                cla                                                      ;classe          
				                cod                                                      ;código perfil   
				                (list   m n o p                                        ) ;frame           
				                (list   a  b  c  d  e  f  g  h  i  j  k  l             ) ;contorno básico 
				                (list  ea eb ec ed ee ef eg eh ei ej ek el em en eo ep ) ;contorno exato
				                (list  ref1 ref2 ref3 ref4 ref5 ref6 ref7 ref8 ref9)
				                (list  Px1  Px2  Px3  Px4  Px5  Px6  Px7  Px8  Px9) 
				)
				(setq con  (1+ con))      
	     )
             (setvar "osmode" 0)
             (setvar "cmdecho" 1)
)

;; Função principal de geração dos quadros                                                                                                     
(defun dibuja_perfil_I (#n #fab #cla #cod LF LP LPE LAX LPX)

                     (setq
   		           vetorT (list (* #n 1100) 0 0)
                           grupo  (ssadd)
		           topo   (met_pmedio (nth 2 LP) (nth 3 LP))  
			   base   (met_pmedio (nth 8 LP) (nth 9 LP))
			   esq    (met_pmedio (nth 3 LP) (nth 8 LP))
			   dir    (met_pmedio (nth 2 LP) (nth 9 LP))  
			   orig   (list 0 0 0)
	             )
 
                     (polilinha   #cla LF          "Hype_Frame"                         ) (setq grupo (ssadd (entlast) grupo))
                     (texto       (list 0 -1055 0) "Hype_TypeName"            #fab      ) (setq grupo (ssadd (entlast) grupo))
                     (texto       (list 0 -1025 0) "Hype_SectionName" (strcat #cla #cod)) (setq grupo (ssadd (entlast) grupo))

                     (polilinha    #cla LP         "Hype_OuterSection"     )              (setq grupo (ssadd (entlast) grupo))
                     
                     (command  "._insert"  "HYPE_COORDINATESYS" orig 25  25    0)         (setq grupo (ssadd (entlast) grupo))
                     (command  "._insert"  "HYPE_COORDINATESYS" topo 25  25    0)         (setq grupo (ssadd (entlast) grupo))
                     (command  "._insert"  "HYPE_COORDINATESYS" base 25  25  180)         (setq grupo (ssadd (entlast) grupo))
   
                     (command "._copy" (nth 0 LAX) "" (nth 0 LPX) (nth 3 LP))             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 1 LAX) "" (nth 1 LPX) topo      )             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 2 LAX) "" (nth 2 LPX) (nth 2 LP))             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 3 LAX) "" (nth 3 LPX) esq       )             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 4 LAX) "" (nth 4 LPX) orig      )             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 5 LAX) "" (nth 5 LPX) dir       )             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 6 LAX) "" (nth 6 LPX) (nth 8 LP))             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 7 LAX) "" (nth 7 LPX) base      )             (setq grupo (ssadd (entlast) grupo))
                     (command "._copy" (nth 8 LAX) "" (nth 8 LPX) (nth 9 LP))             (setq grupo (ssadd (entlast) grupo))

                     (polilinhaEx  #cla LPE  "Hype_ExactOuterSection")                    (setq grupo (ssadd (entlast) grupo))
  
                     (command "._move" grupo "" vetorT "")
                    (gc)
 )

;; Desenha polylinha BASICA do perfil                                                                                                       
(defun polilinha (#cla pts  layer)
       (entmake
            (append
                    (list
	               (cons  0   "LWPOLYLINE")
                       (cons 100  "AcDbEntity")
                       (cons 100  "AcDbPolyline")
                       (cons  8   layer)
                       (cons 90  (length pts))
                       (cons 70   1)
                    )
                    (mapcar '(lambda (p) (cons 10 p) ) pts)
	   ))
)

;; Desenha polylinha EXATA do perfil                                                                                                          
(defun polilinhaEx (#cla pts  layer)
       (setq bulge (if (= #cla "W")
		       -0.414214
		        0.0
		   ))
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
             ))
)

;; Coloca os textos                                                                                                                             
(defun texto     (pt layer texto )
       (entmake
                  (list
                     (cons   0  "TEXT"       )
                     (cons 100  "AcDbEntity" )
                     (cons 100  "AcDbText"   )
                     (cons  1    texto       )
                     (cons  8    layer       )
	             (cons 10   (list 0 0 0) )
	             (cons 40    25          )
    	             (cons 71     0          )
	             (cons 72     1          )
                  )
        )
        (command "._move" (entlast) "" pt "") 
)
