# RegistroCE

Sistema interactivo de gestión de calificaciones desarrollado en lenguaje ensamblador 8086.

## Descripción

RegistroCE es una aplicación de consola que permite gestionar calificaciones de estudiantes con capacidad para hasta 15 registros. Incluye funcionalidades de ingreso, estadísticas, búsqueda y ordenamiento.

## Características

- **Gestión de Estudiantes**: Registro de hasta 15 estudiantes con sus calificaciones
- **Análisis Estadístico**: Cálculo automático de promedios, notas máximas y mínimas
- **Búsqueda**: Localización de estudiantes por posición en la lista
- **Ordenamiento**: Organización ascendente o descendente por calificación
- **Validación**: Verificación automática de formatos y rangos (0-100)

## Requisitos del Sistema

- **DOSBox** (emulador recomendado)
- **MASM 6.11** (Microsoft Macro Assembler)
- **Sistema Operativo**: MS-DOS o compatible
- **Memoria**: 64 KB mínimo


## Instalación y Configuración

### 1. Preparar el entorno

1. Instalar DOSBox
2. Descargar e instalar MASM 6.11
3. Clonar o descargar este repositorio

### 2. Configurar DOSBox

```bash
# Montar la unidad con MASM
mount c: C:\MASM611

# Montar la carpeta del proyecto
mount d: ruta\al\proyecto\RegistroCE

# Cambiar a la unidad del proyecto
d:
```

### 3. Configurar PATH para MASM

```bash
PATH=C:\MASM611\BIN;%PATH%
```

## Compilación

Para compilar el programa, ejecute el script de construcción:

```bash
build.bat
```

Este script realiza automáticamente:
- Compilación de todos los archivos .asm
- Enlazado de los objetos
- Generación del ejecutable MAIN.EXE

## Ejecución

Una vez compilado correctamente, ejecute:

```bash
MAIN.EXE
```

## Estructura del Proyecto

```
RegistroCE/
├── asm/
│   ├── main.asm        # Programa principal
│   ├── io.asm          # Subrutinas de entrada/salida
│   ├── data.asm        # Estructuras de datos
│   ├── stud.asm        # Manejo de estudiantes
│   └── build.bat       # Script de compilación
├── docs/
│   ├── documentation.pdf
│   └── user_guide.pdf
└── README.md
```

## Opciones del programa

Al ejecutar el programa aparecerá un menú con 5 opciones:

1. **Ingresar calificaciones** - Registrar estudiantes y notas
2. **Mostrar estadísticas** - Ver análisis de las calificaciones
3. **Buscar estudiante** - Localizar por posición
4. **Ordenar calificaciones** - Organizar lista
5. **Salir** - Terminar programa

## Desarrollo

**Autores:**
- Steven Aguilar Alvarez
- Allan Zheng Tang  
- Javier Mora Masis

**Institución:** Instituto Tecnológico de Costa Rica  
**Escuela:** Ingeniería en Computadores  
**Curso:** CE1106 - Paradigmas de Programación  
**Semestre:** II-2025

## Documentación Adicional

Para información detallada sobre el uso del sistema, consulte el Manual de Usuario incluido en la carpeta `docs/`.
