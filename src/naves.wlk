

class Nave { 
	var property velocidad = 0
	
	method acelerar(_velocidad) {
		velocidad = (velocidad + _velocidad).min(300000) 
	}
	method propulsar() {
		self.acelerar(20000)
	}
	
	method prepararParaViajar() {
		self.acelerar(15000)
	} 
	
	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
	
	method recibirAmenaza()
}

class NaveDeCarga inherits Nave{

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}

class NaveDeResiduosRadiactivos inherits NaveDeCarga {
	
	var property sellada = false
	override method recibirAmenaza() {
		self.sellarAlVacio()
	}
	
	method sellarAlVacio() {
		velocidad = 0
		sellada = true
	}
	
	override method prepararParaViajar() {
		self.sellarAlVacio()
		super()
	}
}
class NaveDePasajeros inherits Nave{

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
	
	override method prepararParaViajar() {
		super()
		modo.prepararParaViajar(self)
	}

}

class EstadoDeNaveDeCombate {
	
	method emitir(nave, mensaje) {
		nave.emitirMensaje(mensaje)
	}
	
	method invisible()
	method recibirAmenaza(nave)
	method prepararParaViajar(nave)
}

object reposo inherits EstadoDeNaveDeCombate {

	override method invisible() = false

	override method recibirAmenaza(nave) {
		self.emitir(nave, "¡RETIRADA!")
	}
	
	override method prepararParaViajar(nave) {
		self.emitir(nave, "Saliendo en misión")
		nave.modo(ataque);
	}

}

object ataque inherits EstadoDeNaveDeCombate {

	override method invisible() = true

	override method recibirAmenaza(nave) {
		self.emitir(nave, "Enemigo encontrado")
	}
	override method prepararParaViajar(nave) {
		self.emitir(nave, "Volviendo a la base")
	}

}

