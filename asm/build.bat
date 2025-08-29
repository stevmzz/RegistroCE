@echo off
rem ===============================
rem    Compiler para RegistroCE
rem ===============================

echo Compilando archivos ASM...
MASM.EXE asm/main.asm;
MASM.EXE asm/io.asm;

echo Enlazando objetos...
LINK main.obj io.obj;

echo Ejecutando programa...
MAIN.EXE

pause
