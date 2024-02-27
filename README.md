# Embedded Flexbox Engine in Ada (Alire) (Temporary Description)

## Prerequisite

- Alire [Setup Instructions](https://github.com/GNAT-Academic-Program#install-alire-an-ada-package-manager)
- Alire GAP index [Setup Instructions](https://github.com/GNAT-Academic-Program#add-the-gap-alire-index-important)
- OpenOCD
    - `sudo apt install openocd`
- Development board:
    - STM32F746disco

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
openocd -f /usr/share/openocd/scripts/board/stm32f7discovery.cfg -c 'program bin/embedded_flexbox verify reset exit'
```    

## Additional Notes

For Penn State World Campus SWENG 480/481 Capstone Project Fall 2023 - Spring 2024

---

Happy Coding with Ada!
