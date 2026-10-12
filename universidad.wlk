class Carrera {
  const materias = #{}
  const estudiantes = #{}
  
  method inscribirAlumno(alumno) {
    estudiantes.add(alumno)
  }
  
  method materiaPertenece(materia) = materias.contains(materia)

  method agregarMaterias(nuevasMaterias) {
    materias.addAll(nuevasMaterias)
  }
}

class Materia {
}

