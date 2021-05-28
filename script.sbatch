#!/bin/bash
#SBATCH --job-name=job1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nome.cognome@unibo.it
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=nomeoutput
#SBATCH --gres=gpu:1

. bin/activate  # per attivare il virtual environment python

bash ./test/test1.sh