import universidad.*
import requisitos.*

class Estudiante {
  const property carreras = #{}
  const historialAcademico = new HistorialAcademicoDeAlumno()
  
  //inscripcion a carreras
  method carrerasInscriptas() = carreras
  
  method agregarCarrera(carrera) {
    carreras.add(carrera)
  }
  
  method inscripcionEnCarrera(carrera) {
    self.validarInscripcionACarrera(carrera)
    self.agregarCarrera(carrera)
  }
  
  method validarInscripcionACarrera(carrera) {
    if (carreras.contains(carrera)) self.error(
        "no es posible la inscripcion a esta carrera"
      )
  }
  
  method materiaPerteneceACarrera(materia) = carreras.any(
    { carrera => carrera.materiaPertenece(materia) }
  )
  
  //Historia académica
  method cursadaFinalizadaEn(materia, nota) {
    historialAcademico.agregarCursada(materia, nota)
  }
  
  method aproboMateria(materia) {
    historialAcademico.esCursadaAprobada(materia)
  }
  
  method promedioEnCarrera(carrera) {
    historialAcademico.promedioEnCarrera(carrera)
  }
  
  method cantidadDeMateriasAprobadasEnCarrera(carrera) {
    historialAcademico.cantidadDeMateriasAprobadasEnCarrera(carrera)
  }
  
  method promedioDeNotas() {
    historialAcademico.promedio()
  }
}

class HistorialAcademicoDeAlumno {
  const cursadas = #{}
  
  //cursadas
  method esCursadaAprobada(materia) = cursadas.any(
    { cursada =>
      (cursada.nombreDeMateria() == materia) && cursada.esAprobada() }
  )
  
  method agregarCursada(materia, nota) {
    self.validarCursada(materia, nota)
    const materiaCursada = new MateriaCursada(
      nombreDeMateria = materia,
      nota = nota
    )
    cursadas.add(materiaCursada)
  }
  
  method validarCursada(materia, nota) {
    if ((!nota.between(1, 10)) || self.esMateriaAprobada(materia)) self.error(
        "no es posible registrar esta materia"
      )
  }
  //promedios

  method materiasDeCarrera(carrera) {
    cursadas.filter({cursada => carrera.materiaPertenece(cursada.materia())})
  }

  method promedioEnCarrera(carrera) {
    
  }
}