import universidad.*
import alumno.*

class Correlativas {
  const property correlativas = #{}
  
  method esCumplidoPor(alumno, materia) = correlativas.all(
    { correlativa => alumno.aproboMateria(correlativa) }
  )
}

class Creditos {
  var property cantidad = 0
  
  method esCumplidoPor(alumno, materia) = alumno.creditos(materia) >= cantidad
}

class AñosAnteriores {
  method esCumplidoPor(alumno, materia) = alumno.aproboAño(
    materia,
    materia.año() - 1
  )
}

class RequisitoNulo {
  method esCumplidoPor(alumno, materia) = true
}