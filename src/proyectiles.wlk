import wollok.game.*
class Disparo
{
	var property position
	const property etiquetaTickMovement = "mover"+self.toString()  
	method danio() = 10
	method image() = "shoot.png"
	method sonido(sonidoDeFondo)
	{
		game.sound(sonidoDeFondo).shouldLoop(false)
		game.sound(sonidoDeFondo).play()
	}
	method colocarProyectil(_chara)
	{
		self.evaluarComportamiento(_chara)
		game.schedule(100,
			{=>	game.addVisual(self)
				self.sonido("blaster.mp3")})
	}
	
	method moverIzq()
	{
		position = self.position().left(1)
	}
	method moverDer()
	{
		position = self.position().right(1)
	}
	
	//Detiene el movimiento de los proyectiles, se usa cuando colisiona con los personajes
	method detenerMovimiento()
	{
		game.removeTickEvent(etiquetaTickMovement)
		game.removeVisual(self)
	}
	
	//Si un proyectil no colisiona, se autodestruye en 1000 ticks
	method automaticSelfDestruction()
	{
			game.schedule(1000,{self.detenerMovimiento()})
	}
	
	
	method evaluarComportamiento(_chara)
	{
//		_chara.direccion().comportamineto()
		if(_chara.direccion() == "der")
			{self.comportamientoDerecha()}
		else
			{self.comportamientoIzquierda()}
	}
	method comportamientoIzquierda()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverIzq()})
	}
	method comportamientoDerecha()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverDer()})
	}
	method subir(personaje){}
}

class DisparoVertical inherits Disparo
{
	method moverArriba()
	{
		position = self.position().up(1)
	}
	method moverAbajo()
	{
		position = self.position().down(1)
	}
	method comportamientoArriba()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverArriba()})
	}
	method comportamientoAbajo()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverAbajo()})
	}
	method comportamientoVertical(_chara)
	{
		if(_chara.enElSuelo())	{self.comportamientoArriba()}
		else	{self.comportamientoAbajo()}
	}
	override method evaluarComportamiento(_chara)
	{
		self.comportamientoVertical(_chara)
	}
	
}

class DisparoDiagonal inherits DisparoVertical
{
	override method comportamientoDerecha()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverDer() self.moverArriba()})
	}
	override method comportamientoIzquierda()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverIzq() self.moverArriba()})
	}
	override method evaluarComportamiento(_chara)
	{
		if(_chara.direccion() == "der")	{self.comportamientoDerecha()}
		else							{self.comportamientoIzquierda()}
	}
}

class DisparoDiagonalInferior inherits DisparoDiagonal
{
	override method comportamientoDerecha()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverDer() self.moverAbajo()})
	}
	override method comportamientoIzquierda()
	{
		game.onTick(100,etiquetaTickMovement,{=> self.moverIzq() self.moverAbajo()})
	}
}



//Armamentos
class Armamento
{
	method dispararProyectil(_chara,proyectil)
	{
		proyectil.colocarProyectil(_chara)
		proyectil.automaticSelfDestruction()
	}
}

object armamentoZipmata inherits Armamento
{
	method dispararProyectil1(_chara)
	{
		const proyectil = new DisparoDiagonal(position = _chara.position())
		self.dispararProyectil(_chara,proyectil)
	}
	method dispararProyectil2(_chara)
	{
		const proyectil = new DisparoDiagonalInferior(position = _chara.position())
		self.dispararProyectil(_chara,proyectil)
	}
}

object armamentoYui inherits Armamento
{
	method dispararProyectil1(_chara)
	{
		const proyectil = new Disparo(position = _chara.position())
		self.dispararProyectil(_chara,proyectil)
	}
	method dispararProyectil2(_chara)
	{
		const proyectil = new DisparoVertical(position = _chara.position())
		self.dispararProyectil(_chara,proyectil)
	}
}
object armamentoThirdGuy inherits Armamento
{
	method dispararProyectil1(_chara)
	{
		const proyectil = new Disparo(position = _chara.position())
		self.dispararProyectil(_chara,proyectil)
	}
	method dispararProyectil2(_chara)
	{
		const proyectil = new DisparoDiagonal(position = _chara.position())
		self.dispararProyectil(_chara,proyectil)
	}
}