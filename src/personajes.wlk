import wollok.game.*
import proyectiles.*
import plataformas.*
import niveles.*

//JUGADORES
object jugador1
{
	var property personaje
	var property vida = 100
	var property posicionInicial = game.at(0,1)
	method controles()
	{
		keyboard.a().onPressDo({personaje.retroceder()})
		keyboard.d().onPressDo({personaje.avanzar()})
		keyboard.w().onPressDo({personaje.volar()})
		keyboard.j().onPressDo({personaje.disparo1()})
		keyboard.k().onPressDo({personaje.disparo2()})
		game.onTick(500,"caida",{=> personaje.caer()})
	}
	
	method asignarPersonaje() {
		personaje = seleccionPersonajes.quienJugador1()
		personaje.jugador(self)
		personaje.position(posicionInicial)
		personaje.direccion("der")
	}
	
	method recibeDanio(danioDisparo)
	{
		vida -= danioDisparo
	}
}

object jugador2
{
	const posicionInicial = game.at(game.width()-1,0)
	var property personaje
	var property vida = 100
	method controles()
	{
		keyboard.left().onPressDo({personaje.retroceder()})
		keyboard.right().onPressDo({personaje.avanzar()})
		keyboard.up().onPressDo({personaje.volar()})
		game.onTick(500,"caida",{=> personaje.caer()})
		keyboard.z().onPressDo({personaje.disparo1()})
		keyboard.x().onPressDo({personaje.disparo2()})
	}
	
	method asignarPersonaje() {
		personaje = seleccionPersonajes.quienJugador2()
		personaje.jugador(self)
		personaje.direccion("izq")
		personaje.position(posicionInicial)
	}
	method recibeDanio(danioDisparo)
	{
		vida -= danioDisparo
	}
}










//personajes jugables
class Personaje
{
	var property direccion = "der" //La orientacion a donde el personaje esta apuntando. Puede ser izquierda (izq) o derecha (der)
	var property position = game.origin()
	const property armamento
	var property jugador
	method avanzar()
	{
		position = self.position().right(1)
		direccion = "der"
	}
	method subir(algo){}
	method retroceder()
	{
		position = self.position().left(1)
		direccion = "izq"
	}	
	//Metodos para volar y caer	
	method enElSuelo()= self.position().y()==1
	method volar()
	{
		position = self.position().up(2)
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
		armamento.dispararProyectil1(self)
	}
	method disparo2()
	{
		armamento.dispararProyectil2(self)
	}
	
}


class PoolYui inherits Personaje(armamento = armamentoYui)
{
	method image() = "yui_" + direccion + ".png"

}

class Zipmata inherits Personaje(armamento = armamentoZipmata)
{
	method image() = "char_" + direccion + ".png"
}

class TankFlan inherits Personaje(armamento = armamentoThirdGuy)
{
	method image() = "flan_" + direccion + ".png"
}