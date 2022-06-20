#peptide in 40% of TFE
gmx pdb2gmx -f peptide.pdb -o processed.gro -water spce -ignh -ter
gmx editconf -f processed.gro -o newbox.gro -box 5 5 5 -center 2.5 2.5 2.5
gmx insert-molecules -f newbox.gro -ci tfe.gro -nmol 417 -o system.gro
gmx insert-molecules -f system.gro -ci CLA.gro -nmol 1 -o system_ion.gro
#add the 417 tfe molecules and 1 CL in the topol.top file
gmx solvate -cp system_ion.gro -cs spc216.gro -o system_ion_solv.gro -p topol.top
gmx grompp -f minim.mdp -c system_ion_solv.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -v -deffnm em
gmx make_ndx -f em.gro -o index.ndx
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt.tpr -maxwarn 1
gmx mdrun -v -deffnm nvt
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -n index.ndx -o npt.tpr -maxwarn 1
gmx mdrun -v -deffnm npt
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o md_0_1.tpr -maxwarn 1
gmx mdrun -v -deffnm md_0_1
