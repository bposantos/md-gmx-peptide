#peptide in 40% of TFE
#System Preparation
echo -e 1|gmx pdb2gmx -f peptide.pdb -o processed.gro -water spce -ignh -ter
gmx editconf -f processed.gro -o newbox.gro -c -d 1 -bt cubic
gmx insert-molecules -f newbox.gro -ci tfe.gro -nmol 417 -o system.gro
#add the 417 tfe molecules in the topol.top file
#Solvation
gmx solvate -cp system.gro -cs spc216.gro -o system_solv.gro -p topol.top
#Counter-ions
gmx grompp -f ions.mdp -c system_solv.gro -p topol.top -o ions.tpr -maxwarn 1
gmx genion -s ions.tpr -o system_solv_ions.gro -p topol.top -nname CL -pname NA -neutral -conc 0.15 #Choose SOL
#Energy minimization
gmx grompp -f minim.mdp -c system_ion_solv.gro -p topol.top -o em.tpr -maxwarn 1
gmx mdrun -v -deffnm em
#Equilibration
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -maxwarn 1
gmx mdrun -v -deffnm nvt
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr -maxwarn 1
gmx mdrun -v -deffnm npt
#Production
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr -maxwarn 1
gmx mdrun -v -deffnm md_0_1
