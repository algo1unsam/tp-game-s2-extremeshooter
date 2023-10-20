import wollok.game.*
import personajes.*
import plataformas.*
import extras.*

class Fondo{
	const property position = game.origin()
	var property image
	method subir(parametro){}
	method sonido(sonidoDeFondo)
	{
		game.sound(sonidoDeFondo).shouldLoop(true)
		game.sound(sonidoDeFondo).volume(0.5)
		game.schedule(50, {game.sound(sonidoDeFondo).play()})
	}
}

class Marco{
	var property position
	var property image
	var property movimiento = true
	var x1
	var x2
	
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
	const property bosque 	= new Escenario(position = game.at(2,3), image = "bosqueSmall.png", sonidoDeFondo = "track1.mp3" )
	const property desierto = new Escenario(position = game.at(6,3), image = "desiertoSmall.png", sonidoDeFondo = "track2.mp3")
	const property castillo = new Escenario(position = game.at(10,3), image = "castilloSmall.png", sonidoDeFondo = "track3.mp3")
	const property futuro 	= new Escenario(position = game.at(14,3), image = "futureSmall.png", sonidoDeFondo = "track4.mp3")
	const property marco3   = new Marco(position = game.at(2,3), image = "marco3.png", x1 = 2, x2 = 16)
	
	var property cualFondo
	
	method iniciar(){
		game.clear()
		game.addVisual(new Fondo(image="negro.png"))
		self.agregarEscenarios()
		self.agregarTeclas()
	}
	
	method agregarEscenarios(){
		game.addVisual(bosque)
		game.addVisual(desierto)
		game.addVisual(castillo)
		game.addVisual(futuro)
		game.addVisual(marco3)//y agregamos marco ya que estamos
		game.hideAttributes(bosque)
		game.hideAttributes(desierto)
		game.hideAttributes(castillo)
		game.hideAttributes(futuro)
		game.hideAttributes(marco3)
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
	var property p3 = new TankFlan(position=game.at(9,4),jugador=null)
	
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
	
	method agregarTeclas(){
		keyboard.enter().onPressDo{self.iniciar()}
		keyboard.a().onPressDo{if (marco1.movimiento()){marco1.irALosLados(marco1.position().left(2))}	}
		keyboard.d().onPressDo{if (marco1.movimiento()) {marco1.irALosLados(marco1.position().right(2))}}
		keyboard.e().onPressDo{if (marco1.movimiento()){
			//Meter esto en un metodo
								if (not (marco1.position()==marco2.position())) {
									marco1.bloquearMovimiento()
									quienJugador1 = game.uniqueCollider(marco1)
									jugador1Ok = true
									if (self.seleccionPersonajesOk()){nivel1.iniciar()}
									}}
			
		}
		
		keyboard.left().onPressDo{if (marco2.movimiento()) {marco2.irALosLados(marco2.position().left(2))}}
		keyboard.right().onPressDo{if (marco2.movimiento()) {marco2.irALosLados(marco2.position().right(2))}}
		keyboard.l().onPressDo{if (marco2.movimiento()){
								if (not (marco1.position()==marco2.position())) {
								marco2.bloquearMovimiento()
								quienJugador2 = game.uniqueCollider(marco2)
								jugador2Ok = true
								if (self.seleccionPersonajesOk()){nivel1.iniciar()}
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
		game.onCollideDo(jugador1.personaje(),{piso => piso.subir(jugador1.personaje())})
		game.onCollideDo(jugador2.personaje(),{piso => piso.subir(jugador2.personaje())})
		game.onCollideDo(jugador1.personaje(),{disparo=> jugador1.recibeDanio(disparo.danio())})
		game.onCollideDo(jugador2.personaje(),{disparo=> jugador2.recibeDanio(disparo.danio())})
		//agregar collides de los poderes
	}
}


object visualesGeneral
{
	method agregar()
	{
		game.addVisual(jugador1.personaje())
		game.addVisual(jugador2.personaje())
		game.addVisualIn(vida, game.at(1, 9))
		game.addVisualIn(vida2, game.at(17, 9))
	}
}

object nivel1
{
	var fondoElegido
	method iniciar()
	{
		fondoElegido = new Fondo(image=seleccionEscenarios.cualFondo().image().toString().replace("Small", ""))
		self.asignarPersonajes()
		game.clear()
		game.addVisual(fondoElegido)
		fondoElegido.sonido(seleccionEscenarios.cualFondo().sonidoDeFondo())
		
		escenarioUno.creoPlataformas()
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