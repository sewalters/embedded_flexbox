# Embedded, Baremetal, CSS Flexbox (in Ada)

A brief description of what this project does and who it's for

## Authors

- [Stuart Walters](https://github.com/sewalters)
- [Kien Nguyen](https://github.com/KNguyen5256)
- [John Shimer](https://github.com/Utavon)
- [Dominick Carlucci](https://github.com/DomCarl)

## Acknowledgements

 - Dr. Nasim Ibrahim
 - Olivier Henley
 - [AdaCore](https://www.adacore.com)
 - [Penn State College of Engineering](https://www.psu.edu)

## Prerequisite

- Alire [Setup Instructions](https://github.com/GNAT-Academic-Program#install-alire-an-ada-package-manager)
- Alire GAP index [Setup Instructions](https://github.com/GNAT-Academic-Program#add-the-gap-alire-index-important)
- OpenOCD
    - `sudo apt install openocd`
- Development board:
    - STM32F746disco

## How to Setup Environment
The set-up instructions make the following assumptions: 
- Users are working in a Windows environment
- Users know and have already set up a new 64-but Ubuntu v20.04 virtual machine (VM)
- Users are familiar with terminal commands
- Users know how to use Git
To begin setting the development environment for DUI:
- In Figure 39, on the left-hand side of the Ubuntu VM screen, click and open the Firefox browser.
![Figure 39](Images/image40.png)

### Fetch the Crate (Not Published Yet?)
```console
alr get embedded_flexbox
cd embedded_flexbox*
```  

### Pin Working Cross Compiler (IMPORTANT)
```console
alr pin gnat_arm_elf=12.2.1
```

### Build (Alire)
```console
alr build
```

### Build (GPRBuild)
```console
eval "$(alr printenv)"
gprbuild embedded_flexbox.gpr
```

### Build (GnatStudio)
```console
eval "$(alr printenv)"
gnatstudio embedded_flexbox.gpr
```

### Program to Board

```console
openocd -f /usr/share/openocd/scripts/board/stm32f7discovery.cfg -c 'program bin/your_main_here verify reset exit'
```    

## Additional Notes

For Penn State World Campus SWENG 480/481 Capstone Project Fall 2023 - Spring 2024

---

Happy Coding with Ada!
