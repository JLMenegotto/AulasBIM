
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
  
                           (setq lin   (strcat  (vl-string-trim " "  #l) " - - -")
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

(defun c:Tubos ( )
  
            (setvar "osmode"  0)
            (setvar "cmdecho" 0)
            (setq
      		  con       0
		  col       1
                  fil       0
		  mod      40
		  
	          bitolas  (met_Ler_Dados)
                  BitolasR (cdr (reverse (cdr bitolas)))
	          qua      (length BitolasR) 
		  fox      (mapcar '(lambda (lst) (ssget "_X" (list (cons 0 "INSERT") (cons 2 lst)))) '("HYPE_REFAXIS0" "HYPE_REFAXIS1" "HYPE_REFAXIS2"
		   									                "HYPE_REFAXIS3" "HYPE_REFAXIS4" "HYPE_REFAXIS5"
												        "HYPE_REFAXIS6" "HYPE_REFAXIS7" "HYPE_REFAXIS8"))
		  nox      (mapcar '(lambda (lst)             (ssname lst 0)) fox )
	          pox      (mapcar '(lambda (lst) (met_dxf 10 (entget lst ))) nox )
            )

            (while (< con qua)  
                                (setq tubo             (nth con BitolasR)
				      
                                      fab              (nth 0   tubo )
				      cla              (nth 1   tubo )
				      cod              (nth 2   tubo )
				      dianom           (nth 3   tubo )
				      RaiEx   (* (atof (nth 4   tubo ))  0.5 )
				      espes      (atof (nth 5   tubo )) 
				      RaiIn   (- RaiEx  espes) 
				      
                                      m       (list  500   1100  0 )
				      n       (list -500   1100  0 )
                                      o       (list -500  -1100  0 )
				      p       (list  500  -1100  0 )
				)
	                        (dibuja_perfil_R
				                  mod
				                  col
				                  fil
				                  con                                         ;contador                
				                  fab                                         ;fabricante              
                                                  cla                                         ;classe                  
				                  (strcat cla "_" cod "_" dianom)             ;nome do tubo            
				                  (list  m n o p  )                           ;frame                   
				                  (list  RaiEx  RaiIN)                        ;raios externo e interno 
						   nox                                        ;blocos de posicionamento
				                   pox                                        ;pts bloco posicionamento
				)
				(setq
				       con  (1+ con)
	      	                       fil  (if (met_multiplo?  con  mod ) ( 1+ fil )  fil)
				)
	      		        (prompt ".")
	     )
             (setvar "cmdecho" 1)
             (prin1)
)

;; Função principal de geração dos quadros                                                                                                     
(defun dibuja_perfil_R (#m #c #f #n #fab #cla #cod LF LR LAX LPX)

                     (setq
		            fila     #f
			    colu    (met_congrueM?   #n   #m)
			    vetorT  (list (* colu 1100) (* fila -2300) 0)  
                            grupo   (ssadd)  
			    orig    (list 0 0 0)
	             )
                     (polilinha   LF               "Hype_Frame"              )    (setq grupo (ssadd (entlast) grupo))
                     (texto       (list 0 -1055 0) "Hype_TypeName"      #fab )    (setq grupo (ssadd (entlast) grupo))
                     (texto       (list 0 -1025 0) "Hype_SectionName"   #cod )    (setq grupo (ssadd (entlast) grupo))
                     (circulo     orig (nth 0 LR)  "Hype_OuterSection"       )    (setq grupo (ssadd (entlast) grupo))
                     (circulo     orig (nth 1 LR)  "Hype_InnerSection"       )    (setq grupo (ssadd (entlast) grupo))
                      
                     (command  "._insert"  "HYPE_COORDINATESYS" orig 25  25  0)   (setq grupo (ssadd (entlast) grupo))

  
                     (met_vlacopia  (nth 4 LAX) (nth 4 LPX) orig           )      (setq grupo (ssadd (entlast) grupo))
                     (circulo     orig (nth 0 LR)  "Hype_ExactOuterSection")      (setq grupo (ssadd (entlast) grupo))

  
                     (command "._move" grupo "" vetorT "")
                     (command "._HYPE_ADDSELECTEDPROFILES" grupo "")
                    (gc)
)

(defun met_vlacopia (ob p1 p2) (vla-move (vla-copy (vlax-ename->vla-object ob)) (vlax-3d-point p1) (vlax-3d-point p2)))


(defun met_copia (ob p1 p2) (command "._copy" ob "" p1 p2))
;; Desenha polylinha                                                                                                        
(defun polilinha ( pts  layer)
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