import wollok.game.*



object fondo
{
	const image = "fondo.jpg"
	const sonidoDeFondo = game.sound("blaster.mp3")
	method background()
	{
		sonidoDeFondo.play()
		sonidoDeFondo.shouldLoop(true)
		game.boardGround(image)
		
	}
}


class Plataforma {
	
	const property image = "plataforma.png"
	var property position = game.origin()
	method subir(personaje)
	{
		personaje.position(personaje.position().up(1))
	}
	
}

class Nivel inherits Plataforma{
	
	var property plataformas = []
//	var property plataforma
	
	
	
	//method background()
	//{
	//	game.boardGround(image)
	//}
	
	
	
	method crearPlataforma(inicio,fin,altura){	//agregar un parametro mas en caso de que hayan otros estilos de plataforma
		(inicio..fin).forEach({numero => plataformas.add(new Plataforma(position=game.at(numero,altura)))})
	}
	
	method nuevoSuelo(){
		plataformas.forEach({p => game.addVisual(p)})
			
	}
	
}


object escenarioUno inherits Nivel
{
	method creoPlataformas()
	{
		self.crearPlataforma(0,game.width(),0)
		self.crearPlataforma(game.center().x()-2,game.center().x()+2,5)
		self.nuevoSuelo()
	}
//	override method crearEscaleras(){ PARA CREAR ESCALERAS MAS ADELANTE
//		self.crearEscalera(1,5,4)
//		self.crearEscalera(1,5,11)
//	}
//	
	
}