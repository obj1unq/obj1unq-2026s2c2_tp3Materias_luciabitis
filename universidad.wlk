import alumno.*
import requisitos.*

class Carrera {
  const materias = #{}
  
  method materias() = materias
  
  method materiaPertenece(materia) = materias.contains(materia)
  
  method agregarMaterias(nuevasMaterias) {
    materias.addAll(nuevasMaterias)
  }
  
  method materiasDelAñoAnteriorAMateria(_materia) = materias.filter(
    { materia => materia.año() == (_materia.año() - 1) }
  )

  
}

class Materia {
  var property requisitos = new Correlativas()
  const alumnos = #{}
  var property año = 0
  var property creditos = 0
  
  method esAlumnoIncripto(alumno) = alumnos.contains(alumno)
  
  method alumnoCumpleRequisitos(alumno) = requisitos.esCumplidoPor(alumno, self)
  
  method inscribirAlumno(alumno) {
    self.agregarAlumno(alumno)
  }
  
  method agregarAlumno(alumno) {
    alumnos.add(alumno)
  }
  
  method alumnosInscriptos() = alumnos
  
  method materiasDeAñoAnterior(
    carrera
  ) = carrera.materiasDelAñoAnteriorAMateria(self)
}