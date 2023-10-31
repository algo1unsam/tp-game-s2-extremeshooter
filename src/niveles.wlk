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
	const property bosque 	= new Escenario(escenario = escenarioUno, position = game.at(2,3), image = "bosqueSmall.png", sonidoDeFondo = "track1.mp3" )
	const property desierto = new Escenario(escenario = escenarioDos, position = game.at(6,3), image = "desiertoSmall.png", sonidoDeFondo = "track2.mp3")
	const property castillo = new Escenario(escenario = escenarioTres, position = game.at(10,3), image = "castilloSmall.png", sonidoDeFondo = "track3.mp3")
	const property futuro 	= new Escenario(escenario = escenarioCuatro, position = game.at(14,3), image = "futureSmall.png", sonidoDeFondo = "track4.mp3")
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
									if (self.seleccionPersonajesOk()){batalla.iniciar()}
									}}
			
		}
		
		keyboard.left().onPressDo{if (marco2.movimiento()) {marco2.irALosLados(marco2.position().left(2))}}
		keyboard.right().onPressDo{if (marco2.movimiento()) {marco2.irALosLados(marco2.position().right(2))}}
		keyboard.l().onPressDo{if (marco2.movimiento()){
								if (not (marco1.position()==marco2.position())) {
								marco2.bloquearMovimiento()
								quienJugador2 = game.uniqueCollider(marco2)
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
		game.onCollideDo(jugador1.personaje(),{objeto => objeto.interaccionCon(jugador1)})
		game.onCollideDo(jugador2.personaje(),{objeto => objeto.interaccionCon(jugador2)})
		//agregar collides de los poderes
		game.onTick(100,"validarEnergia",{=>validarEnergia.maxEnergia(jugador1)})
		game.onTick(100,"validarEnergia",{=>validarEnergia.maxEnergia(jugador2)})
		game.onTick(100,"validarEnergia",{=>validarEnergia.minEnergia(jugador1)})
		game.onTick(100,"validarEnergia",{=>validarEnergia.minEnergia(jugador2)})
		game.onTick(100,"validarMuerte",{=>final.validarVida() final.validarVida2()})
	}
}


object visualesGeneral
{
	method agregar()
	{
		game.addVisual(jugador1.personaje())
		game.addVisual(jugador2.personaje())
		game.addVisual(vida1)
		game.addVisual(vida2)
		game.addVisual(energia1)
		game.addVisual(energia2)
		game.addVisual(energia1Png)
		game.addVisual(energia2Png)
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
	var finall
	var property check = 0
	method validarVida() {
		check = jugador1.vidas()
		if (check == 0){
			finall = new Fondo(image="final2.png")
			game.clear()
			game.addVisual(finall)
			self.iniciar()
		}
		}
  	 method validarVida2() {
		check = jugador2.vidas()
		if (check == 0){
			finall = new Fondo(image="final1.png")
			game.clear()
			game.addVisual(finall)
			self.iniciar()
		}
}
	method iniciar(){
		self.reiniciar()
		keyboard.enter().onPressDo{game.stop() game.start()}
	}
	method reiniciar(){
		seleccionPersonajes.p1().position(game.at(5,4))
		seleccionPersonajes.p2().position(game.at(7,4))
		seleccionPersonajes.p3().position(game.at(9,4))
		
		
	//	seleccionPersonajes.marco1(baseDeDatos.bmarco1())
	//	seleccionPersonajes.marco2(baseDeDatos.bmarco2())
		
		//seleccionPersonajes.jugador1Ok(baseDeDatos.bjugador1Ok())
	//	seleccionPersonajes.jugador2Ok(baseDeDatos.bjugador2Ok())
		jugador1.vidas(baseDeDatos.bvida())
		jugador2.vidas(baseDeDatos.bvida())
	}
}
object  baseDeDatos{
		const property bp1 = new PoolYui(position=game.at(5,4),jugador=null)
		const property bp2 = new Zipmata(position=game.at(7,4),jugador=null)
		const property bp3 = new EagleMan(position=game.at(9,4),jugador=null)
		
		const property bmarco1 = new Marco(position = game.at(5,4), image = "marco1.png", x1 = 5, x2 = 10)
		const property bmarco2 = new Marco(position = game.at(7,4), image = "marco2.png", x1 = 5, x2 = 10)
		
		const property bjugador1Ok = false
		const property bjugador2Ok = false
		
		const property bvida = 100
	}