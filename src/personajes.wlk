import wollok.game.*
import proyectiles.*
import plataformas.*
import niveles.*
import extras.*

//JUGADORES
class Jugador
{
	var property personaje
	var property vidas = 100
	var property energia = 100
	method direccionInicial()
	method posicionInicial()
	method controles()
	
	method asignarPersonaje() {
		personaje.jugador(self)
		personaje.position(self.posicionInicial())
		personaje.direccion(self.direccionInicial())
	}
	method recibeDanio(danioDisparo)
	{
		vidas -= danioDisparo
	}
	method gastarEnergia(gasto)
	{
		energia -= gasto
	}
	method sinEnergia() = energia <= 0
	method recargaEnergia(pocion) 
	{
		energia += pocion
	}
}

object jugador1 inherits Jugador(personaje = null){
	override method posicionInicial() = game.at(0,1)
	override method direccionInicial() = derecha
	override method controles()
	{
		keyboard.a().onPressDo({personaje.moverIzquierda()})
		keyboard.d().onPressDo({personaje.moverDerecha()})
		keyboard.w().onPressDo({personaje.volar()})
		keyboard.j().onPressDo({personaje.disparo1()})
		keyboard.k().onPressDo({personaje.disparo2()})
		game.onTick(500,"caida",{=> personaje.caer()})
	}
	
	override method asignarPersonaje() {
		personaje = seleccionPersonajes.quienJugador1()
		super()}
}

object jugador2 inherits Jugador(personaje = null){
	override method posicionInicial() = game.at(game.width()-1,0)
	override method direccionInicial() = izquierda
	override method controles()
	{
		keyboard.left().onPressDo({personaje.moverIzquierda()})
		keyboard.right().onPressDo({personaje.moverDerecha()})
		keyboard.up().onPressDo({personaje.volar()})
		game.onTick(500,"caida",{=> personaje.caer()})
		keyboard.z().onPressDo({personaje.disparo1()})
		keyboard.x().onPressDo({personaje.disparo2()})
	}
	
	override method asignarPersonaje() {
		personaje = seleccionPersonajes.quienJugador2()
		super()
	}
}

//personajes jugables
class Personaje
{
	var property direccion = derecha //La orientacion a donde el personaje esta apuntando. Puede ser izquierda (izq) o derecha (der)
	var property estado = reposo
	var property position = game.origin()
	const property armamento
	var property jugador
	
	method nombre()
	
	method image()= self.nombre() + direccion.nombre() + estado.nombre() + ".png"
	
	method moverDerecha()
	{
		position = self.position().right(1)
		direccion = derecha
	}
	method moverIzquierda()
	{
		position = self.position().left(1)
		direccion = izquierda
	}
	
	method interaccionCon(otroJugador)
	{
		otroJugador.personaje().moverDerecha()
		self.moverIzquierda()
	}
	
	//Metodos para volar y caer	
	method enElSuelo()= self.position().y()==1
	method volar()
	{
		if(not(jugador.sinEnergia())){
		jugador.gastarEnergia(5)
		position = self.position().up(2)}
	}
	method caer() //Cuando dejé de volar
	{
		 if(not self.enElSuelo())
		 {
		 	position = self.position().down(1)
		 }
	}
	
	method disparo1()
	{
		if(not(jugador.sinEnergia())){
		estado = ataque
		jugador.gastarEnergia(10)
		armamento.dispararProyectil1(self)}
	}
	method disparo2()
	{
		if(not(jugador.sinEnergia())){
		estado = ataque
		jugador.gastarEnergia(10)
		armamento.dispararProyectil2(self)}
	}
	
}


class PoolYui inherits Personaje(armamento = armamentoYui)
{
	override method nombre() = "temp_"
}

class Zipmata inherits Personaje(armamento = armamentoZipmata)
{
	override method nombre() = "elr_"
}

class EagleMan inherits Personaje(armamento = armamentoEagleMan)
{
	override method nombre() = "eag_"
}