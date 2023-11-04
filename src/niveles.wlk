import wollok.game.*
import personajes.*
import plataformas.*
import extras.*

class Fondo{
	const property position = game.origin()
	var property image
	method interaccionCon(jugador){}
	method sonido(sonidoDeFondo)
	{
		game.sound(sonidoDeFondo).shouldLoop(true)
		game.sound(sonidoDeFondo).volume(0.5)
		game.schedule(150, {game.sound(sonidoDeFondo).play()})
	}
}

class Marco{
	var property position
	var property image
	var movimiento = true
	var x1
	var x2
	
	method movimiento() = movimiento
	
	method liberarMovimiento()
	{
		movimiento = true
	}
	
	method bloquearMovimiento(){
		movimiento = false
	}
	
	method irALosLados(nuevaPosicion){
		if (self.validarRango(nuevaPosicion)){
			position = nuevaPosicion
		}
	}
	
	method validarRango(nuevaPosicion){
		return nuevaPosicion.x().between(x1,x2)
	}
	
}

class Escenario{
	var property position
	var property image
	var property sonidoDeFondo
	var property escenario
}

object portada{
	const testeo = new Fondo(image="portada.png")
	method iniciar(){
		game.addVisual(testeo)
		keyboard.enter().onPressDo{instrucciones.iniciar()}
	}
}

object instrucciones{
	method iniciar(){
		game.clear()
		game.addVisual(new Fondo(image="instrucciones.png"))
		keyboard.enter().onPressDo{seleccionEscenarios.iniciar()}
		
		
	}
}

object seleccionEscenarios{
	var property cualFondo
	const property marco3 = new Marco(position = game.at(2,3), image = "marco3.png", x1 = 2, x2 = 16)
	method bosque()		  = new Escenario(escenario = new NivelUno(), position = game.at(2,3), image = "bosqueSmall.png", sonidoDeFondo = "track1.mp3" )
	method desierto()	  = new Escenario(escenario = new NivelDos(), position = game.at(6,3), image = "desiertoSmall.png", sonidoDeFondo = "track2.mp3")
	method castillo()	  = new Escenario(escenario = new NivelTres(), position = game.at(10,3), image = "castilloSmall.png", sonidoDeFondo = "track3.mp3")
	method futuro() 	  = new Escenario(escenario = new NivelCuatro(), position = game.at(14,3), image = "futureSmall.png", sonidoDeFondo = "track4.mp3")
	
	method iniciar(){
		game.clear()
		game.addVisual(new Fondo(image="negro.png"))
		self.agregarEscenarios()
		self.agregarTeclas()
	}
	
	method agregarEscenarios(){
		game.addVisual(self.bosque())
		game.addVisual(self.desierto())
		game.addVisual(self.castillo())
		game.addVisual(self.futuro())
		game.addVisual(marco3)//y agregamos marco ya que estamos
	}
	
	method agregarTeclas(){
		keyboard.enter().onPressDo{if (marco3.movimiento()){
									marco3.bloquearMovimiento()
									cualFondo = game.uniqueCollider(marco3)
									seleccionPersonajes.iniciar()
									}}
		keyboard.left().onPressDo{if (marco3.movimiento()) {marco3.irALosLados(marco3.position().left(4))}}
		keyboard.right().onPressDo{if (marco3.movimiento()) {marco3.irALosLados(marco3.position().right(4))}}
	}
	
}

object seleccionPersonajes{
	var property p1 = new PoolYui(position=game.at(5,4),jugador=null)
	var property p2 = new Zipmata(position=game.at(7,4),jugador=null)
	var property p3 = new EagleMan(position=game.at(9,4),jugador=null)
	
	var property marco1 = new Marco(position = game.at(5,4), image = "marco1.png", x1 = 5, x2 = 10)
	var property marco2 = new Marco(position = game.at(7,4), image = "marco2.png", x1 = 5, x2 = 10)
	
	var property jugador1Ok = false
	var property jugador2Ok = false
	
	var property quienJugador1 
	var property quienJugador2
	
	method iniciar(){
		game.clear()
		game.addVisual(new Fondo(image="instrucciones.png"))
		self.agregarPersonajes()
		self.agregarTeclas()
		
	}
	
	method agregarPersonajes(){
		game.addVisual(new Fondo(image="seleccion.png"))
		game.addVisual(p1)
		game.addVisual(p2)
		game.addVisual(p3)
		game.addVisual(marco1)//y agregamos marcos ya que estamos
		game.addVisual(marco2)
	}

	method escogerPersonaje(_marco){
		_marco.bloquearMovimiento()
		return game.uniqueCollider(_marco)
	}

	method agregarTeclas(){
		keyboard.enter().onPressDo{self.iniciar()}
		keyboard.a().onPressDo{if (marco1.movimiento()){marco1.irALosLados(marco1.position().left(2))}	}
		keyboard.d().onPressDo{if (marco1.movimiento()) {marco1.irALosLados(marco1.position().right(2))}}
		keyboard.e().onPressDo{if (marco1.movimiento()){
					if (not (marco1.position()==marco2.position())) {
						quienJugador1 = self.escogerPersonaje(marco1)
						jugador1Ok = true
						if (self.seleccionPersonajesOk()){batalla.iniciar()}
					}}
			
		}
		
		keyboard.left().onPressDo{if (marco2.movimiento()) {marco2.irALosLados(marco2.position().left(2))}}
		keyboard.right().onPressDo{if (marco2.movimiento()) {marco2.irALosLados(marco2.position().right(2))}}
		keyboard.l().onPressDo{if (marco2.movimiento()){
					if (not (marco1.position()==marco2.position())) {
						quienJugador2 = self.escogerPersonaje(marco1)
						jugador2Ok = true
						if (self.seleccionPersonajesOk()){batalla.iniciar()}
					}}
			
		}
	}
	
	method seleccionPersonajesOk(){
		return (jugador1Ok and jugador2Ok)
	}	
}


object colisiones
{
	method validar()
	{
		const jugadores = [jugador1,jugador2]
		jugadores.forEach{jugador => 
			game.onCollideDo(jugador.personaje(),{objeto => objeto.interaccionCon(jugador)})
			game.onTick(100,"validarEnergia",{=>reguladorDeEnergia.validarEnergia(jugador)})
		}
		game.onTick(100,"validarMuerte",{=>final.validarVida() final.validarVida2()})
	}
}


object visualesGeneral
{
	method agregar()
	{
		const visuales = [jugador1.personaje(),jugador2.personaje(),vida1,vida2,energia1,energia2,energia1Png,energia2Png]
		visuales.forEach{ visual=>
			game.addVisual(visual)
		}
		self.agregarPociones()
	}
	method agregarPociones()
	{
		var time = 5000
		const pocion1 = new PocionEnergia()
		const pocion2 = new PocionEnergia()
		const pocion3 = new PocionEnergia()
		const pocion4 = new PocionEnergia()
		const pocion5 = new PocionEnergia()
		const listaPociones = [pocion1,pocion2,pocion3,pocion4,pocion5]
		listaPociones.forEach({pocion => game.schedule(time,{pocion.agregarPocion()}) time=time+5000})
	}
}

object batalla
{
	var escenarioElegido
	var fondoElegido
	method iniciar()
	{
		escenarioElegido=seleccionEscenarios.cualFondo()
		fondoElegido = new Fondo(image=escenarioElegido.image().toString().replace("Small", ""))
		self.asignarPersonajes()
		game.clear()
		game.addVisual(fondoElegido)
		fondoElegido.sonido(escenarioElegido.sonidoDeFondo())
		
		escenarioElegido.escenario().creoPlataformas()
		visualesGeneral.agregar()
		jugador1.controles()
		jugador2.controles()
		colisiones.validar()
		
		
	}
	
	method asignarPersonajes(){
		jugador1.asignarPersonaje()
		jugador2.asignarPersonaje()
		
	}
}
object final
{
	var final
	var check = 0
	method finalizarBatalla(){
		game.clear()
		game.addVisual(final)
		self.iniciar()
	}
	method validarVida() {
		check = jugador1.vidas()
		if (check <= 0){
			final = new Fondo(image="final2.png")
			self.finalizarBatalla()
		}
		}
  	 method validarVida2() {
		check = jugador2.vidas()
		if (check <= 0){
			final = new Fondo(image="final1.png")
			self.finalizarBatalla()
		}
}
	method iniciar(){
		self.reiniciar()
		keyboard.enter().onPressDo{portada.iniciar()}
	}
	method reiniciar(){
		seleccionPersonajes.p1(baseDeDatos.bp1())
		seleccionPersonajes.p2(baseDeDatos.bp2())
		seleccionPersonajes.p3(baseDeDatos.bp3())


		seleccionPersonajes.marco1(baseDeDatos.bmarco1())
		seleccionPersonajes.marco2(baseDeDatos.bmarco2())
		
		seleccionEscenarios.marco3().liberarMovimiento()
		seleccionPersonajes.marco1().liberarMovimiento()
		seleccionPersonajes.marco2().liberarMovimiento()

		seleccionPersonajes.jugador1Ok(baseDeDatos.bjugadorOk())
		seleccionPersonajes.jugador2Ok(baseDeDatos.bjugadorOk())
		
		jugador1.vidas(baseDeDatos.bvida())
		jugador2.vidas(baseDeDatos.bvida())
		jugador1.energia(baseDeDatos.benergia())
		jugador2.energia(baseDeDatos.benergia())
	}
}
object  baseDeDatos{
		method bp1() = new PoolYui(position=game.at(5,4),jugador=null)
		method bp2() = new Zipmata(position=game.at(7,4),jugador=null)
		method bp3() = new EagleMan(position=game.at(9,4),jugador=null)

		method bmarco1() = new Marco(position = game.at(5,4), image = "marco1.png", x1 = 5, x2 = 10)
		method bmarco2() = new Marco(position = game.at(7,4), image = "marco2.png", x1 = 5, x2 = 10)
		
		method bjugadorOk() = false
		
		method bvida() = 100
		method benergia()= 100
	}
