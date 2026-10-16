import universidad.*
import requisitos.*

class Estudiante {
  const historialDeMaterias = []
  const carrerasInscriptas = #{}
  const materiasAprobadas = #{}
  
  method agregarCarrera(carrera) {
    carrerasInscriptas.add(carrera)
  }
  
  method inscripcionEnCarrera(carrera) {
    self.validarInscripcion(carrera)
    self.agregarCarrera(carrera)
  }
  
  method validarInscripcion(carrera) {
    if (carrerasInscriptas.contains(carrera)) self.error(
        "no es posible la inscripcion a esta carrera"
      )
  }
  
  method materiaPerteneceACarrera(materia) = carrerasInscriptas.any(
    { carrera => carrera.materiaPertenece(materia) }
  )
  
  method carrerasInscriptas() = carrerasInscriptas
  
  method cursadaFinalizadaEn(materia, nota) {
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
  
  method aproboMateria(materia) = materiasAprobadas.any(
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
  method promedioDeNotas() =  materiasAprobadas.average(
    { cursada => cursada.nota() }
  )
  
  method cantidadDeMateriasAprobadas() = materiasAprobadas.size()
  
  
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
  
  
  method carreraDe(materia) = self.carrerasInscriptas().find(
    { carrera => carrera.materiaPertenece(materia) }
  )
  
  method aproboAño(_materia, año) = self.carreraDe(_materia).materias()
  .filter({ materia => materia.año() == año })
  .all({ materia => self.esMateriaAprobada(materia) })
  
  method creditos(materia) = self.materiasAprobadasDeCarrera(
    self.carreraDe(materia)
  ).sum({ cursada => cursada.nombreDeMateria().creditos() })
}

class MateriaYNotaDeAlumno {
  var property nombreDeMateria = new Materia()
  var property nota = 10
  var property carrera = new Carrera()
}