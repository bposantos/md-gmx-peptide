# Peptide in TFE/water mixture

- These commands are compiled in the file 'command.sh';
- Additional files are annexed in this folder;

##### Choosing force field while processing the protein coordinates
`gmx pdb2gmx -f peptide.pdb -o processed.gro -water spce -ignh -ter`

##### Choosing the protein box volume as 125 nm3
`gmx editconf -f processed.gro -o newbox.gro -box 5 5 5 -center 2.5 2.5 2.5`

##### Insert the TFE molecules in the box
`gmx insert-molecules -f newbox.gro -ci tfe.gro -nmol 417 -o system.gro`

##### Insert the ions to neutralize the box. In this case, one chlorine.
`gmx insert-molecules -f system.gro -ci CLA.gro -nmol 1 -o system_ion.gro`

##### Solvate the box with water molecules
`gmx solvate -cp system_ion.gro -cs spc216.gro -o system_ion_solv.gro -p topol.top`

##### Minimize the energy of the system
```
gmx grompp -f minim.mdp -c system_ion_solv.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -v -deffnm em
```
##### Make an index file to join elements
`gmx make_ndx -f em.gro -o index.ndx`


Select the itens: TFE|Cl|SOL. Press "q" and ENTER at the end.

##### Equilibration - NVT
```
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt.tpr -maxwarn 1
gmx mdrun -v -deffnm nvt
```
##### Equilibration - NPT
```
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -n index.ndx -o npt.tpr -maxwarn 1
gmx mdrun -v -deffnm npt
```
##### MD
```
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o md_0_1.tpr -maxwarn 1
gmx mdrun -v -deffnm md_0_1
```
