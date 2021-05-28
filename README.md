Gentile Studente,

come probabilmente anticipato dal Prof. Viroli, è disponibile un cluster di HPC con GPU per esperimenti di calcolo.
Per poterlo utilizzare il primo passo è stato quello di abilitare il suo account istituzionale all'accesso ai nostri sistemi. In tal senso dovrebbe avere già ricevuto un e-mail di avvenuta abilitazione. Ha accesso con le credenziali istituzionali, anche in remoto, a tutte le macchine dei laboratori Ercolani e Ranzani. Nell'e-mail trova il link dedicato ai servizi informatici dipartimentali e nella sezione Accesso remoto troverà dettagli su tali macchine.
La quota studente massima è per ora impostata a 400 MB. In caso di necessità di maggiore spazio potrà ricorrere alla creazione di una sua cartella in /public/ che viene di norma cancellata ogni prima domenica del mese. Home utente e /public/ sono spazi di archiviazione condivisi tra le macchine, può dunque creare l'ambiente di esecuzione e i file necessari all'elaborazione sulla macchina slurm.cs.unibo.it da cui poi avviare il job che verrà eseguito sulle macchine dotate di GPU.

Una possibile impostazione del lavoro potrebbe essere quella di creare un virtual environment Python inserendo all'interno tutto ciò di cui si ha bisogno e utilizzando pip per l'installazione dei moduli necessari. Le segnalo che per utilizzare Python 3 è necessario invocarlo esplicitamente in quanto sulle macchine il default è Python 2. Nel cluster sono presenti GPU Tesla pilotate con driver Nvidia v. 460.67 e librerie di computazione CUDA 11.2.1, quindi in caso di installazione di pytorch bisognerà utilizzare il comando pip3 install torch==1.8.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html (rif. https://pytorch.org/).
Il cluster utilizza uno schedulatore SLURM (https://slurm.schedmd.com/overview.html) per la distribuzione dei job. Per effettuare il submit di un job bisogna predisporre nella propria area di lavoro un file di script SLURM (ad es. script.sbatch) in cui inserire le direttive per la configurazione del job stesso. Dopo le direttive è possibile inserire comandi di script (ad es. BASH). Un esempio di script è il seguente:


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

python test.py


Nell'esempio precedente la direttiva da riportare immutata è --gres=gpu:1 (ogni nodo di computazione ha un'unica GPU a disposizione e deve essere attivata per poterla utilizzare). Le altre possono essere personalizzate. Per la definizione di queste e altre direttive si rimanda alla documentazione di SLURM (https://slurm.schedmd.com/sbatch.html). Nell'esempio, dopo le direttive è stato invocato il programma.
Il processo deve essere accodato dalla macchina slurm.cs.unibo.it (accessibile via ssh) e lanciato il comando sbatch nomescript (ad es. sbatch script.sbatch). Con le direttive specificate nell'esempio saranno inviate e-mail all'indirizzo specificato alla partenza del job, al termine e nel caso di errori. I risultati dell'elaborazione saranno presenti nel file nomeoutput come indicato nella direttiva.

L'esecuzione sulle macchine avviene all'interno dello stesso path relativo che, essendo condiviso, viene visto anche dalle macchine dei laboratori e dalla macchina slurm.

Restiamo a disposizione per qualunque chiarimento.

Buon lavoro.

