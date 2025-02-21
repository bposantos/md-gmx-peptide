# Peptide in TFE/water mixture

- These commands are compiled in the file 'command.sh';
- Additional files are annexed in this folder;

##### Choosing force field while processing the protein coordinates
`echo -e 1| gmx pdb2gmx -f peptide.pdb -o processed.gro -water spce -ignh -ter`

##### Choosing the protein box volume as 125 nm3
`gmx editconf -f processed.gro -o newbox.gro -c -d 1 -bt cubic

##### Insert the TFE molecules in the box
`gmx insert-molecules -f newbox.gro -ci tfe.gro -nmol 417 -o system.gro`

##### Add the missing informations in topol.top
`#include gromos54a7_atb.ff/TFE.itp`

##### Solvate the box with water molecules
`gmx solvate -cp system.gro -cs spc216.gro -o system_solv.gro -p topol.top`

##### Insert the ions to neutralize the box. In this case, one chlorine.
```
gmx grompp -f ions.mdp -c system_solv.gro -p topol.top -o ions.tpr -maxwarn 1
gmx genion -s ions.tpr -o system_solv_gro.gro -p topol.top -nname CL -pname NA -neutral -conc 0.15
```

##### Minimize the energy of the system
```
gmx grompp -f minim.mdp -c system_ion_solv.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -v -deffnm em
```

##### Equilibration - NVT
```
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -maxwarn 1
gmx mdrun -v -deffnm nvt
```
##### Equilibration - NPT
```
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr -maxwarn 1
gmx mdrun -v -deffnm npt
```
##### MD
```
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr -maxwarn 1
gmx mdrun -v -deffnm md_0_1
```
