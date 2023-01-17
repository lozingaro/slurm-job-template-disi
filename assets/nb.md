### Eseguire notebook Jupyter sul cluster (italiano)
È possibile eseguire un server jupyter sul cluster e connettersi ad esso dal proprio computer tramite i seguenti passaggi:

1. Per prima cosa, è necessario installare il pacchetto `jupyter` con `pip` nel proprio virtual environment.
2. Definire il seguente script di configurazione **SLURM**:
```bash
#!/bin/bash
#SBATCH --job-name=nomejob
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nome.cognome@unibo.it
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=output.txt
#SBATCH --gres=gpu:1

source <path/to/venv>/bin/activate

ip addr  # per ottenere l'indirizzo IP del nodo
jupyter notebook --ip=0.0.0.0 --port=8888  # per eseguire il server Jupyter
```
3. Esaminare l'output con `cat output.txt` e prendere nota:
    - dell'indirizzo IP del nodo;
    - del token di Jupyter.
4. Aprire una seconda shell e configurare un tunnel ssh nel seguente modo (sostituendo `<ip_addr>` con l'indirizzo IP ottenuto al passaggio 3):
```bash
ssh -L 8888:<ip_addr>:8888 nome.cognome@slurm.cs.unibo.it
```
5. Dal browser del proprio computer, accedere al seguente indirizzo (sostituendo `<token>` con il token ottenuto al passaggio 3):
```
http://127.0.0.1:8888/?token=<token>
```
6. A questo punto è possibile creare/aprire ed eseguire un notebook Jupyter.

### Execute Jupyter notebooks on the cluster (english)
It is possible to execute a Jupyter server on the cluster and connect to it from your computer by following these steps:

1. First of all, it is necessary to install the `jupyter` package using `pip` in your virtual environment.
2. Define the following **SLURM** configuration script:
```bash
#!/bin/bash
#SBATCH --job-name=jobname
#SBATCH --mail-type=ALL
#SBATCH --mail-user=name.surname@unibo.it
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=output.txt
#SBATCH --gres=gpu:1

source <path/to/venv>/bin/activate

ip addr  # to obtain the node's IP address
jupyter notebook --ip=0.0.0.0 --port=8888  # to execute the Jupyter server
```
3. Examine the output with `cat output.txt` and note:
    - the node's IP address;
    - the Jupyter's token.
4. Open a second shell and configure an SSH tunnel as follows (substitute `<ip_addr>` with the actual IP address obtained at step 3):
```bash
ssh -L 8888:<ip_addr>:8888 name.surname@slurm.cs.unibo.it
```
5. From your computer browser, head to the following address (substitute `<token>` with the actual token obtained at step 3):
```
http://127.0.0.1:8888/?token=<token>
```
6. Now you can create/open and execute a Jupyter notebook.
