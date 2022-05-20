**Il repository è aperto a contributi, basta aprire una [`pull request`](https://github.com/thezingaro/slurm-job-template-disi/pulls)!**

**Repository is opern to contributions, please open a [`pull request`](https://github.com/thezingaro/slurm-job-template-disi/pulls)!**

## Cluster di HPC con GPU per esperimenti di calcolo (draft version 1.0)

Per poter utilizzare il cluster il primo passo è abilitare l'account istituzionale per l'accesso ai sistemi del DISI. 
Se già attivo, avrai accesso con le credenziali istituzionali, anche in remoto (`SSH`), a tutte le macchine dei *laboratori Ercolani* e *Ranzani*. 

**La quota studente massima è per ora impostata a 400 MB**. 
In caso di necessità di maggiore spazio potrai ricorrere alla creazione di una cartella in `/public/` **che viene di norma cancellata ogni prima domenica del mese**.

`/home/` utente e `/public/` sono spazi di archiviazione condivisi tra le macchine, potrai dunque creare l'ambiente di esecuzione e i file necessari all'elaborazione sulla macchina **SLURM** ([slurm.cs.unibo.it](http://slurm..cs.unibo.it)) da cui poi avviare il *job* che verrà eseguito sulle macchine dotate di GPU.

## Istruzioni

Una possibile impostazione del lavoro potrebbe essere quella di creare un virtual environment Python inserendo all'interno tutto ciò di cui si ha bisogno e utilizzando pip per l'installazione dei moduli necessari. Le segnalo che per utilizzare **Python 3** è necessario invocarlo esplicitamente in quanto sulle macchine il default è **Python 2**. 
Nel cluster sono presenti **GPU** **Tesla** pilotate con driver `Nvidia v. 460.67` e librerie di computazione `CUDA 11.2.1`, quindi in caso di installazione di pytorch bisognerà utilizzare il comando 

```bash
pip3 install torch==1.8.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html
```

Il cluster utilizza uno schedulatore **SLURM** ([https://slurm.schedmd.com/overview.html](https://slurm.schedmd.com/overview.html)) per la distribuzione dei job. 
Per sottomettere un job bisogna predisporre nella propria area di lavoro un file di configurzione SLURM (nell'esempio sotto lo abbiamo nominato `script.sbatch`). 

Dopo le direttive **SLURM** è possibile inserire comandi di script (ad es. BASH). 

```bash
#!/bin/bash
#SBATCH --job-name=nomejob
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nome.cognome@unibo.it
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=nomeoutput
#SBATCH --gres=gpu:1

. bin/activate  # per attivare il virtual environment python

python test.py # per lanciare lo script python
```

Nell'esempio precedente:
- L'istruzione da tenere immutata è `--gres=gpu:1` (ogni nodo di computazione ha un'unica GPU a disposizione e deve essere attivata per poterla utilizzare). 
- Tutte le altre istruzioni di configurazione per SLURM **possono essere personalizzate**. Per la definizione di queste e altre direttive si rimanda alla documentazione ufficiale di SLURM (https://slurm.schedmd.com/sbatch.html). 
- Nell'esempio, dopo le istruzioni di configurazione di SLURM è stato invocato il programma.

Per poter avviare il job sulle macchine del cluster, è necessario:
1. accedere via SSH alla macchina [slurm.cs.unibo.it](http://slurm.cs.unibo.it) con le proprie credenziali;
2. lanciare il comando `sbatch <nomescript>`.

Alcune note importanti:
- saranno inviate e-mail per tutti gli evnti che riguardano il job lanciato, all'indirizzo specificato nelle istruzioni di configurazione (ad esempio al termine del job e nel caso di errori);
- i risultati dell'elaborazione saranno presenti nel file `<nomeoutput>` indicato nelle istruzioni di configurazioni;
- l'esecuzione sulle macchine avviene all'interno dello stesso **path relativo** che, essendo condiviso, viene visto anche dalle macchine dei laboratori e dalla macchina slurm.

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
