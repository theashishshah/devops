- Binary files are the files that aren't meant to edit or read by a normal user instead these are meant to use by OS or any process that understands 0s and 1s because binary files contains only 0s and 1s.
- They are meant to be executable

### Script
A script is:
    A text file that contains a sequence of commands, meant to be executed by another program (an interpreter).
Key idea:
binary - CPU runs it directly
script - it is meant to run by another program ( but isn't CPU also a program?)

-- No, CPU isn't a program, instead it is a hardware that is made up of circuits and transistor, that does a specific job.
? Then how it executes binary files?
-- what exactly a binary file contains? just raw 0s and 1s, right? because CPU is wired to perform a task for a specific patterns of 0s and 1s.

### Whats' a actully a script is and how does it run?
- it is a set of instructions and it is run by interpretor.
#! /bin/bash shebang -> this tells linux to use bash interepreter to translate this script file
script cmd line

so to write any script, you need an interpretor that understand your file type.
eg: .sh is undestand by bash (program)
    .js is understand by node.js ( program )
- because linux or CPU doesn't care in which language you write the script, write the script in a languge that can translate the meaning of what you want to do to linux


So to achieve same task but in different environment, we write same things in that environment frienly.
eg: in bash we can write
```bash
touch file.txt, app.js
```
but in js file, node doesn't understand the meaning of touch or anything so we write in node friendly way
```js
const fs = require('fs');
fs.writeFile('example.txt');
```
underlying both are doing the same job, just the mechanism is different.


? What's the difference between a normal text file and a executable text file? how do they behave differently or how do they differ?
- So, a normal text file is just a file without any executable permissions and when you edit it or read it, you can do this but if you want to run it as a program then you can't (also a program is nothing just a file, right ? but written a in way that someone can understands it and run it. you can also read and edit a file, so why a text file can't be a program? it is just the way kernel reads it). 