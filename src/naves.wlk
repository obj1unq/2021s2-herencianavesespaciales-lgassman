class Nave {
	var property velocidad = 0

	method acelerar(aceleracion) {
		velocidad = (velocidad + aceleracion).min(300000)		
	}

	method propulsar() {
		self.acelerar(20000)
	}	
	
	method preparar() {
		self.acelerar(15000)
	}
	
	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
	
	method recibirAmenaza()
}

class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
	
}

class NaveDeResiduosRadiactivos inherits NaveDeCarga {
	
	var property sellado = false
	
	override method recibirAmenaza() {
		self.sellarAlVacio()
	}
	
	method sellarAlVacio() {
		velocidad = 0
		sellado = true	
	}
	
	override method preparar() {
		self.sellarAlVacio()
		super()
	}
	
}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave {

	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	/* las de combate, si se encuentran en modo ataque emiten el mensaje "Volviendo a la base", 
	 * mientras que si están en reposo emiten el mensaje "Saliendo en misión" y se ponen en modo ataque.
	 */
	 override method preparar() {
	 	super()
	 	modo.preparar(self)
	 }
}


class EstadoDeNave {
	
	method preparar(nave) {
		nave.emitirMensaje(self.mensajeDePreparacion())
	}
	
	method mensajeDePreparacion()
}

object reposo inherits EstadoDeNave {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	
	override method preparar(nave) {
		super(nave)
		nave.modo(ataque)
	}
	override method mensajeDePreparacion() {
		return "Saliendo en misión"
	}

}

object ataque inherits EstadoDeNave {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	
	override method mensajeDePreparacion() {
		return "Volviendo a la base"
	}

}

