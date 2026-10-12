class Estudiante {
  const historialAcademico = new HistorialAcademicoDeAlumno()
  
  method inscripcionEnCarrera(carrera) {
    historialAcademico.validarInscripcion(carrera)
    historialAcademico.agregarCarrera(carrera)
    carrera.inscribirAlumno(self)
  }
  
  method materiaPerteneceACarrera(
    materia
  ) = historialAcademico.materiaPerteneceACarrera(materia)
  
  method carrerasInscriptas() = historialAcademico.carrerasInscriptas()
  
  method cursadaFinalizada(materia, nota) {
    historialAcademico.materiaCursada(materia, nota)
  }
  
  method aproboMateria(materia) {
    historialAcademico.esMateriaAprobada(materia)
  }

  method promedioEnCarrera(carrera) {
    historialAcademico.promedioDeCarrera(carrera)
  }

  method cantidadDeMateriasAprobadasEnCarrera(carrera) {
    historialAcademico.cantidadDeMateriasAprobadasEnCarrera(carrera)
  }

  method promedioDeNotas() {
    historialAcademico.promedio()
  }
  
  method cantidadDeMateriasAprobadas() {
    historialAcademico.cantidadDeMateriasAprobadas()
  }

}

class HistorialAcademicoDeAlumno {
  const historialDeMaterias = []
  const carrerasInscriptas = #{}
  const materiasAprobadas = #{}
  
  method validarInscripcion(carrera) {
    if (carrerasInscriptas.contains(carrera)) self.error(
        "no es posible la inscripcion a esta carrera"
      )
  }
  
  method agregarCarrera(carrera) {
    carrerasInscriptas.add(carrera)
  }
  
  method carrerasInscriptas() = carrerasInscriptas
  
  method materiaPerteneceACarrera(materia) = carrerasInscriptas.any(
    { carrera => carrera.materiaPertenece(materia) }
  )
  
  method materiaCursada(materia, nota) {
    self.validarMateriaYNota(materia, nota)
    self.agregarMateriaYNota(materia, nota)
  }
  
  method agregarMateriaYNota(materia, _nota) {
    const materiaCursada = new MateriaYNotaDeAlumno(
      nombreDeMateria = materia,
      nota = _nota
    )
    historialDeMaterias.add(materiaCursada)
    self.agregarMateriaAprobada(materia, _nota)
  }
  
  method validarMateriaYNota(materia, nota) {
    if ((!nota.between(1, 10)) && (!self.esMateriaAprobada(materia)))
      self.error("no es posible registrar esta materia")
  }
  
  method esMateriaAprobada(materia) = materiasAprobadas.contains(materia)
  
  method agregarMateriaAprobada(materia, nota) {
    if (self.esNotaAprobada(nota)) materiasAprobadas.add(materia)
  }
  
  method esNotaAprobada(nota) = nota >= 6

  method promedioEnCarrera(carrera) {
    return self.sumaDeNotasAprobadasEnCarrera(carrera) / self.cantidadDeMateriasAprobadasEnCarrera(carrera)
  }

  method materiasAprobadasDeCarrera(carrera) {
    materiasAprobadas.filter({closure})
  }
  method cantidadDeMateriasAprobadasEnCarrera(carrera) {
    historialAcademico.cantidadDeMateriasAprobadasEnCarrera(carrera)
  }

  method promedioDeNotas() {
    historialAcademico.promedio()
  }
  
  method cantidadDeMateriasAprobadas() {
    historialAcademico.cantidadDeMateriasAprobadas()
  }
}

class MateriaYNotaDeAlumno {
  var property nombreDeMateria = matematica1
  var property nota = 10

  method esDeCarrera(carrera) {
    
  }
}