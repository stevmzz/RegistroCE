@echo off
rem ===============================
rem    Compiler para RegistroCE
rem ===============================

echo Compilando archivos ASM...
MASM.EXE main.asm;
MASM.EXE io.asm;

echo Enlazando objetos...
LINK main.obj io.obj;

echo Ejecutando programa...
MAIN.EXE

pause
