# Linux essentials cmd and bash cripting

## what's the $PATH variable in the system, what does it  do? what does it mean when we add gcc compilers in windows or any machine, everyone says add this compiler into path, so what does it mean?

So how lets say .c file is executed in our system? 
- Not every program understands .c file, so our system checks who's responsible for executing/compiling this .c file.
- So internally in PATH variable system checks, if there are some program that can execute/compile this .c file.
- If yes then it gets compiled/executed else throw error.

So, PATH variable is just a normal varialbe like in any program that keeps/has locations of progams for specific purpose.