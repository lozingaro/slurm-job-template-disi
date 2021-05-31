#### START SLURM CONFIGURATION ####

#!/bin/bash
#SBATCH --job-name=test
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nome.cognome@unibo.it
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=./test/test.log
#SBATCH --gres=gpu:1

#### END SLURM CONFIGURATION ####

#### START USER SCRIPT ####

source ./venv/bin/activate # activates the Python virtual environment, installed under 'venv' folder

bash ./test/test.sh

#### END USER SCRIPT ####