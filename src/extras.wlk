import wollok.game.*
import personajes.*

class Vida
{
	const jugador
	method image() = jugador.vidas().toString()+"corazones.png"
	method interaccionCon(unJugador){}
}
object vida1 inherits Vida(jugador = jugador1) {
	method position()= game.at(1, 9)
}

object vida2 inherits Vida(jugador = jugador2) {
	method position()= game.at(17, 9)
}
object color
{
	const property blanco 	= "FFFFFF"
	const property noBlanco = "000000"
}

class Energia
{
	const jugador
	const life
	method position() = life.position().down(1).right(1)
	method textColor() = color.blanco()
	method text() = jugador.energia().toString()
	method interaccionCon(unJugador){}
}

object energia1 inherits Energia(jugador = jugador1, life = vida1){}
object energia2 inherits Energia(jugador = jugador2, life = vida2){}

object derecha
{
	method nombre() = "der"
	method comportamientoDireccional(disparo){disparo.comportamientoDerecha()}
	method repelerADireccionOpuesta(personaje){personaje.moverIzquierda()}
}
object izquierda
{
	method nombre() = "izq"
	method comportamientoDireccional(disparo){disparo.comportamientoIzquierda()}
	method repelerADireccionOpuesta(personaje){personaje.moverDerecha()}
}

object reposo
{
	method nombre()=""
}

object ataque
{
	method nombre()="_ataque"
}

class PocionEnergia
{
	const energiaQueRestaura = 10
	var posicionInicial = self.cambiarPosicionEnX()
	method cambiarPosicionEnX() = 0.randomUpTo(game.width())
	method image() = "pocion.png"
	method position() = game.at(posicionInicial,1)
	method agregarPocion()
	{
		posicionInicial = self.cambiarPosicionEnX()
		game.addVisual(self)
	}
	method regenerarPocion()
	{
		game.schedule(5000,{=>self.agregarPocion()})
	}
	method removerPng() 
	{
		game.removeVisual(self)
		self.regenerarPocion()
	}
	method recarga(jugador)
	{
		jugador.recargaEnergia(energiaQueRestaura)
		self.removerPng()
	}
	method interaccionCon(jugador)
	{
		self.recarga(jugador)
	}
	
}
object reguladorDeEnergia
{
	var check = 0
	method maxEnergia(jugador)
	{
		check = jugador.energia()
		if(check > 100){
			jugador.energia(100)
		}
	}
	method minEnergia(jugador)
	{
		check = jugador.energia()
		if(check < 0){
			jugador.energia(100)
		}
	}
	method validarEnergia(jugador)
	{
		self.minEnergia(jugador)
		self.maxEnergia(jugador)
	}
}
class EnergiaPng{
	const position
	method position()= position.position().left(1)
	method image()="energiaPng.png"
	method interaccionCon(unJugador){}
}

object energia1Png inherits EnergiaPng(position = energia1){}
object energia2Png inherits EnergiaPng(position = energia2){}
	
//Cosas faltantes:
//	sonidos faltantes
//	cambiar skins de personajes y disparos