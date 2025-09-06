@echo off
rem ===============================
rem    Compiler para RegistroCE
rem ===============================

echo Compilando archivos ASM...
MASM.EXE asm/main.asm;
MASM.EXE asm/io.asm;
MASM.EXE asm/data.asm;
MASM.EXE asm/stud.asm;
MASM.EXE asm/find.asm;
MASM.EXE asm/bubble.asm;
MASM.EXE asm/stats.asm;

echo Enlazando objetos...
LINK main.obj io.obj stud.obj data.obj find.obj bubble.obj stats.obj;

echo Ejecutando programa...
MAIN.EXE

pause

