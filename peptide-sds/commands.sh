gmx pdb2gmx -f peptide.pdb -o processed.gro -water spce -ignh -ter
gmx editconf -f processed.gro -o newbox.gro -box 10 10 14 -center 5 5 12
#nano position.dat
#gmx editconf -f sds.pdb -o sds.gro -center 0 0 0
gmx insert-molecules -f newbox.gro -ci sds.gro -nmol 1 -ip positions.dat -dr 0 0 0 -o system.gro
gmx solvate -cp system.gro -cs spc216.gro -o system_solv.gro -p topol.top
gmx grompp -f ions.mdp -c system_solv.gro -p topol.top -o ions.tpr -maxwarn 1
gmx genion -s ions.tpr -o system_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
gmx grompp -f minim.mdp -c system_solv_ions.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -v -deffnm em
gmx make_ndx -f em.gro -o index.ndx
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt.tpr -maxwarn 1
gmx mdrun -v -deffnm nvt
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -n index.ndx -o npt.tpr -maxwarn 1
gmx mdrun -v -deffnm npt
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o md_0_1.tpr -maxwarn 1
gmx mdrun -v -deffnm md_0_1
