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
  
  method aproboMateria(materia) = historialAcademico.esCursadaAprobada(materia)
  
  method promedioEnCarrera(carrera) = historialAcademico.promedioEnCarrera(
    carrera
  )
  
  method cantidadDeMateriasAprobadasEnCarrera(
    carrera
  ) = historialAcademico.cantidadDeMateriasAprobadasEnCarrera(carrera)
  
  method promedioDeNotas() = historialAcademico.promedio()
  
  // Inscripciones a las materias
  method puedeInscribirseAMateria(materia) = ((self.materiaPerteneceACarrera(
    materia
  ) && (!self.aproboMateria(materia))) && (!materia.esAlumnoIncripto(
    self
  ))) && materia.alumnoCumpleRequisitos(self)
  
  method materiasAccesiblesDeCarrera(carrera) = carrera.materias().filter(
    { materia => self.puedeInscribirseAMateria(materia) }
  )
  
  method inscribirEnMateria(materia) {
    self.validarInscripcionDeMateria(materia)
    materia.inscribirAlumno(self)
  }

  method validarInscripcionDeMateria(materia) {
    if (!self.puedeInscribirseAMateria(materia)) self.error(
        "no es posible inscribirse a esta materia"
      )
  }

   method InscriptoEnMateria(materia) = materia.esAlumnoIncripto(self)
  
  method seCumplenRequisitosDe(materia) = materia.alumnoCumpleRequisitos(self)
  
method carreraDe(materia) = carreras.find({ carrera => carrera.materiaPertenece(materia) })
  
  method aproboAño(materia, año) = self.carreraDe(materia).materias().filter(
    { mat => mat.año() == año }
  ).all({ mat => self.aproboMateria(mat) })
  
  method creditos(materia) = historialAcademico.materiasAprobadasDeCarrera(
    self.carreraDe(materia)
  ).sum({ cursada => cursada.materia().creditos() })


}

class HistorialAcademicoDeAlumno {
  const cursadas = #{}
  
  //cursadas
  method esCursadaAprobada(materia) = cursadas.any(
    { cursada => (cursada.materia() == materia) && cursada.esAprobada() }
  )
  
  method agregarCursada(_materia, nota) {
    self.validarCursada(_materia, nota)
    const materiaCursada = new MateriaCursada(materia = _materia, nota = nota)
    cursadas.add(materiaCursada)
  }
  
  method validarCursada(materia, nota) {
    if ((!nota.between(1, 10)) || self.esCursadaAprobada(materia)) self.error(
        "no es posible registrar esta materia"
      )
  }
  
  //promedios
  method materiasDeCarrera(carrera) = cursadas.filter(
    { cursada => carrera.materiaPertenece(cursada.materia()) }
  )
  
  method promedioEnCarrera(carrera) = self.sumaDeNotasAprobadasEnCarrera(
    carrera
  ) / self.cantidadDeMateriasAprobadasEnCarrera(carrera)
  
  method sumaDeNotasAprobadasEnCarrera(
    carrera
  ) = self.materiasAprobadasDeCarrera(carrera).sum(
    { materia => materia.nota() }
  )
  
  method cantidadDeMateriasAprobadasEnCarrera(
    carrera
  ) = self.materiasAprobadasDeCarrera(carrera).size()
  
  method materiasAprobadasDeCarrera(carrera) = self.materiasDeCarrera(
    carrera
  ).filter({ materia => materia.esAprobada() })
  
  method materiasAprobadas() = cursadas.filter(
    { materia => materia.esAprobada() }
  )
  
  method promedio() = self.materiasAprobadas().average(
    { cursada => cursada.nota() }
  )


}

class MateriaCursada {
  var property materia
  var property nota
  
  method esAprobada() = nota >= 6
}