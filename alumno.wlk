import universidad.*
import requisitos.*


class Estudiante {
  const historialAcademico = new HistorialAcademicoDeAlumno()
  
  method inscripcionEnCarrera(carrera) {
    historialAcademico.validarInscripcion(carrera)
    historialAcademico.agregarCarrera(carrera)
  }
  
  method materiaPerteneceACarrera(
    materia
  ) = historialAcademico.materiaPerteneceACarrera(materia)
  
  method carrerasInscriptas() = historialAcademico.carrerasInscriptas()
  
  method cursadaFinalizadaEn(materia, nota) {
    historialAcademico.materiaCursada(materia, nota)
  }
  
  method aproboMateria(materia) = historialAcademico.esMateriaAprobada(materia)
  
  method promedioEnCarrera(carrera) = historialAcademico.promedioEnCarrera(
    carrera
  )
  
  method cantidadDeMateriasAprobadasEnCarrera(
    carrera
  ) = historialAcademico.cantidadDeMateriasAprobadasEnCarrera(carrera)
  
  method promedioDeNotas() = historialAcademico.promedioDeNotas()
  
  method cantidadDeMateriasAprobadas() = historialAcademico.cantidadDeMateriasAprobadas()
  
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
  
  method carreraDe(materia) = historialAcademico.carreraDe(materia)
  
  method aproboAño(materia, año) = historialAcademico.aproboAño(materia, año)
  
  method creditos(materia) = historialAcademico.creditosDeCarreraDeMateria(materia)
}

class HistorialAcademicoDeAlumno {
  const historialDeMaterias = []
  const carrerasInscriptas = []
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
      nota = _nota,
      carrera = carrerasInscriptas.find(
        { carrera => carrera.materiaPertenece(materia) }
      )
    )
    historialDeMaterias.add(materiaCursada)
    self.agregarMateriaAprobada(materiaCursada)
  }
  method validarMateriaYNota(materia, nota) {
    if ((!nota.between(1, 10)) || self.esMateriaAprobada(materia)) self.error(
        "no es posible registrar esta materia"
      )
  }
  
  method esMateriaAprobada(materia) = materiasAprobadas.any(
    { cursada => cursada.nombreDeMateria() == materia }
  )
  
  method agregarMateriaAprobada(materia) {
    if (self.esNotaAprobada(materia.nota())) materiasAprobadas.add(materia)
  }
  
  method esNotaAprobada(nota) = nota >= 6
  
  method promedioEnCarrera(carrera) = self.sumaDeNotasAprobadasEnCarrera(
    carrera
  ) / self.cantidadDeMateriasAprobadasEnCarrera(carrera)
  
  method cantidadDeMateriasAprobadasEnCarrera(
    carrera
  ) = self.materiasAprobadasDeCarrera(carrera).size()
  
  method materiasAprobadasDeCarrera(carrera) = materiasAprobadas.filter(
    { materia => materia.carrera() == carrera }
  )
  
  method sumaDeNotasAprobadasEnCarrera(
    carrera
  ) = self.materiasAprobadasDeCarrera(carrera).sum(
    { materia => materia.nota() }
  )
  
  method promedioDeNotas() = materiasAprobadas.average(
    { cursada => cursada.nota() }
  )
  
  method cantidadDeMateriasAprobadas() {
    materiasAprobadas.size()
  }
  
  method esMateriaApta(materia) = (self.materiaPerteneceACarrera(
    materia
  ) && (!self.esMateriaAprobada(materia))) && (!self.InscriptoEnMateria(
    materia
  ))
  
  method InscriptoEnMateria(materia) = materia.esAlumnoIncripto(self)
  
  method seCumplenRequisitosDe(materia) = materia.alumnoCumpleRequisitos(self)
  
  method carreraDe(materia) = self.carrerasInscriptas().find(
    { carrera => carrera.materiaPertenece(materia) }
  )
  
method creditosDeCarreraDeMateria(materia) = self.materiasAprobadasDeCarrera(
    self.carreraDe(materia)
  ).sum({ cursada => cursada.nombreDeMateria().creditos() })
  
  method aproboAño(materia, año) = self.carreraDe(materia).materias().all(
    { mat => (mat.año() == año) && self.esMateriaAprobada(mat) }
  )
}

class MateriaYNotaDeAlumno {
  var property nombreDeMateria = new Materia()
  var property nota = 10
  var property carrera = new Carrera()
}