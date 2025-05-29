buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.4.0")
        classpath("com.google.gms:google-services:4.4.2") // Firebase services
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Opcional pero recomendado: establecer la ruta del directorio de compilación
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Tarea para limpiar el proyecto
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}