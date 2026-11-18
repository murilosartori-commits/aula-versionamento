programa
{
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> t
	inclua biblioteca Util --> u

	const inteiro tamanho = 25
	const inteiro resolucao = 700
	const inteiro delay = 100
	const inteiro comecar_tempo = 3000

	const logico morrer_bater_corpo = verdadeiro
	const logico morrer_bater_parede = verdadeiro
	const logico ativar_maca = verdadeiro

	inteiro primeira_interacao = u.tempo_decorrido()
	inteiro ultima_interacao = u.tempo_decorrido()
	inteiro razao = resolucao/tamanho
	
	inteiro cobra_x[tamanho*tamanho]
	inteiro cobra_y[tamanho*tamanho]
	inteiro tamanho_cobra = 3

	inteiro atual_y = tamanho/2, atual_x = tamanho - tamanho/5
	inteiro direcao[2] = {0, -1}

	logico mudou_direcao = falso

	logico comeu_maca = falso
	inteiro maca_y = tamanho/2
	inteiro maca_x = tamanho/3

	funcao atualizar_direcao() {
		se ((t.tecla_pressionada(t.TECLA_W) ou t.tecla_pressionada(t.TECLA_SETA_ACIMA)) e direcao[0] != 1) {
			direcao[0] = -1
			direcao[1] = 0
			mudou_direcao = verdadeiro
			retorne
		}
		se ((t.tecla_pressionada(t.TECLA_A) ou t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)) e direcao[1] != 1) {
			direcao[0] = 0
			direcao[1] = -1
			mudou_direcao = verdadeiro
			retorne
		}
		se ((t.tecla_pressionada(t.TECLA_S) ou t.tecla_pressionada(t.TECLA_SETA_ABAIXO)) e direcao[0] != -1) {
			direcao[0] = 1
			direcao[1] = 0
			mudou_direcao = verdadeiro
			retorne
		}
		se ((t.tecla_pressionada(t.TECLA_D) ou t.tecla_pressionada(t.TECLA_SETA_DIREITA)) e direcao[1] != -1) {
			direcao[0] = 0
			direcao[1] = 1
			mudou_direcao = verdadeiro
			retorne
		}
	}
	
	funcao desenhar_fundo() {
		g.definir_cor(g.COR_BRANCO)
		g.limpar()
	}

	funcao desenhar_grade() {
		g.definir_cor(g.COR_PRETO)
		para (inteiro adolfo = 1; adolfo < tamanho; adolfo++) {
			g.desenhar_linha(razao * adolfo, 0, razao * adolfo, resolucao)
			g.desenhar_linha(0, razao * adolfo, resolucao, razao * adolfo)
		}
	}

	funcao desenhar_corpo(inteiro cor, inteiro x, inteiro y) {
		g.definir_cor(cor)
		g.desenhar_retangulo(razao * (x-1), razao * (y-1), razao, razao, verdadeiro, verdadeiro)
		
	}

	funcao logico possui(inteiro x, inteiro y) {
		para (inteiro i = 1; i < tamanho_cobra; i++) {
			se (cobra_x[i-1] == x e cobra_y[i-1] == y) {
				retorne verdadeiro
			}
		}
		retorne falso
	}

	funcao logico passo(logico colisao_parede, logico colisao_corpo) {
		inteiro proxima_linha = atual_y + direcao[0]
		inteiro proxima_coluna = atual_x + direcao[1]
		se (proxima_linha < 1 ou proxima_linha > tamanho ou proxima_coluna < 1 ou proxima_coluna > tamanho) {
			se (nao colisao_parede) {
				desenhar_corpo(g.COR_VERDE, atual_x, atual_y)
				para (inteiro i = 1; i < tamanho_cobra; i++) {
					desenhar_corpo(g.COR_AZUL, cobra_x[i-1], cobra_y[i-1])
				}
				retorne verdadeiro
			}
			retorne falso
		}
		logico bateu = possui(proxima_coluna, proxima_linha)
		se (bateu) {
			se (nao colisao_corpo) {
				desenhar_corpo(g.COR_VERDE, atual_x, atual_y)
				para (inteiro i = 1; i < tamanho_cobra; i++) {
					desenhar_corpo(g.COR_AZUL, cobra_x[i-1], cobra_y[i-1])
				}
				retorne verdadeiro
			}
			retorne falso
		}

		se (proxima_linha == maca_y e proxima_coluna == maca_x) {
			comeu_maca = verdadeiro
		}

		desenhar_corpo(g.COR_VERDE, proxima_coluna, proxima_linha)
		inteiro anterior_y = atual_y
		inteiro anterior_x = atual_x
		
		atual_y = proxima_linha
		atual_x = proxima_coluna

		para (inteiro i = 1; i < tamanho_cobra; i++) {
			inteiro cache_x = cobra_x[i-1]
			inteiro cache_y = cobra_y[i-1]
			cobra_x[i-1] = anterior_x
			cobra_y[i-1] = anterior_y
			
			desenhar_corpo(g.COR_AZUL, anterior_x, anterior_y)
			
			anterior_x = cache_x
			anterior_y = cache_y
		}
		
		retorne verdadeiro
	}

	funcao desenhar_maca() {
		enquanto(possui(maca_x, maca_y)) {
			maca_x = u.sorteia(1, tamanho)
			maca_y = u.sorteia(1, tamanho)
		}
		desenhar_corpo(g.COR_VERMELHO, maca_x, maca_y)
	}
	
	funcao inicio() {
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(resolucao, resolucao)

		enquanto (nao t.tecla_pressionada(t.TECLA_ESC))
		{
			se (tamanho_cobra >= tamanho*tamanho) {
				escreva("Você ganhou.")
				retorne
			}
			
			se (nao mudou_direcao) {
				atualizar_direcao()
			}
			
			se ((u.tempo_decorrido() - ultima_interacao) >= delay) {
				desenhar_fundo()
				desenhar_grade()
				
				se (nao comeu_maca e ativar_maca) {
					desenhar_maca()
				} senao {
					se (ativar_maca) {
						tamanho_cobra += 1
					}
					comeu_maca = falso
				}
				
				se (nao passo(morrer_bater_parede, morrer_bater_corpo)) {
					escreva("Você perdeu.")
					retorne
				}
				
				se (ultima_interacao == primeira_interacao) {
					g.definir_cor(g.COR_AZUL)
					g.definir_tamanho_texto(25.0)
					g.desenhar_texto(resolucao/2-120, resolucao/2-40, "Aguarde para começar.")
					g.renderizar()
					u.aguarde(comecar_tempo)
					ultima_interacao += comecar_tempo
				} senao {
					g.renderizar()
				}

				mudou_direcao = falso
				ultima_interacao += delay
			}
		}
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 831; 
 * @DOBRAMENTO-CODIGO = [32, 59, 64, 72, 78, 87, 138, 146];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */