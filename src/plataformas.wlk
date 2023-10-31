import wollok.game.*
class Plataforma {
	const property image = "plataforma.png"
	var property position = game.origin()
	method subir(personaje)
	{
		personaje.position(personaje.position().up(1))
	}
	method interaccionCon(jugador)
	{
		const personaje = jugador.personaje()
		self.subir(personaje)
	}
}

class Nivel inherits Plataforma{
	
	var property plataformas = []
	
	method crearPlataforma(inicio,fin,altura){	//agregar un parametro mas en caso de que hayan otros estilos de plataforma
		(inicio..fin).forEach({numero => plataformas.add(new Plataforma(position=game.at(numero,altura)))})
	}
	
	method nuevoSuelo(){
		plataformas.forEach({p => game.addVisual(p)})			
	}
	
}

//Nivel 1
object escenarioUno inherits Nivel
{
	method creoPlataformas()
	{
		self.crearPlataforma(0,game.width(),0)
		self.crearPlataforma(game.center().x()-2,game.center().x()+2,5)
		self.nuevoSuelo()
	}
}

//Nivel 2
object escenarioDos inherits Nivel {
	method creoPlataformas()
	{
		self.crearPlataforma(0,game.width(),0)
		self.crearPlataforma(game.center().x()-1,game.center().x()-3,3)
		self.crearPlataforma(game.center().x()+7,game.center().x()+4,3)
		self.nuevoSuelo()
	}
}

//Nivel 3
object escenarioTres inherits Nivel {
	method creoPlataformas()
	{
		self.crearPlataforma(0,game.width(),0)
		self.crearPlataforma(game.center().x()-4,game.center().x()-2,7)
		self.crearPlataforma(game.center().x()+4,game.center().x()+2,7)
		self.crearPlataforma(game.center().x()-2,game.center().x()+2,2)
		self.crearPlataforma(game.center().x()+2,game.center().x()+2,2)
		self.nuevoSuelo()
	}
}

//Nivel 4
object escenarioCuatro inherits Nivel {
	method creoPlataformas()
	{
		self.crearPlataforma(0,game.width(),0)
		self.crearPlataforma(game.center().x()-2,game.center().x()+2,5)
		self.nuevoSuelo()
	}
}
