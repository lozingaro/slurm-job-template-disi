## Pytorch Distributed su Slurm

Pytorch distributed mette a disposizione delle primitive di comunicazione tra le GPU; in questo modo è possibile allenare un singolo modello in modo distribuito.
Per maggiori informazioni: https://pytorch.org/docs/stable/distributed.html


Per lanciare uno stesso script su più nodi, settate opportunamente il vostro sbatch, settando il numero di nodi e il numero di GPU per nodo.
Per lanciare lo stesso script su più nodi, dovete aggiungere `srun` al vostro comando. Inoltre, PyTorch distributed ha bisongo di due variabili environment, `MASTER_PORT` e `MASTER_ADDR`.
La prima può essere una qualsiasi porta libera; nel caso sia già occupata riceverete un errore. il `MASTER_ADDR` deve essere l'indirizzo di un nodo, in modo che le GPU possano comunicare.
Nell'esempio sottostante, settiamo `MASTER_PORT` a 29500 e `MASTER_ADDR` con il nome del primo nodo in `SLURM_JOB_NODELIST`.


```batch
#!/bin/bash
#SBATCH --job-name=tests
#SBATCH --mail-type=ALL
#SBATCH --mail-user=[myemail]
#SBATCH --time=01:00:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=output.txt
#SBATCH --gres=gpu:1

source cvenv/bin/activate

export MASTER_PORT=29500
master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr

srun python3 main.py
```


Nel vostro file python, ricordate di lanciare un processo diverso per ogni GPU sullo stesso nodo e di inizializzare `torch.distributed`.
Un esempio minimale è il seguente:

```python
import torch
import os
import argparse


def main():
    parser = argparse.ArgumentParser("Test")
    args = parser.parse_args()

    args.ngpus_per_node = torch.cuda.device_count()
    args.rank = int(os.getenv('SLURM_NODEID')) * args.ngpus_per_node
    args.world_size = int(os.getenv('SLURM_NNODES')) * args.ngpus_per_node
    args.dist_url = f'env://'
    torch.multiprocessing.spawn(do_something, (args,), args.ngpus_per_node)  

def do_something(device, args):
    args.rank += device
    torch.distributed.init_process_group(
        backend='nccl', init_method=args.dist_url,
        world_size=args.world_size, rank=args.rank
)  
    
    local_tensor = torch.rand(10, device=device)
    torch.distributed.all_reduce(local_tensor)

if __name__ == "__main__":
    main()
```

All'interno del metodo `do_something`, ogni GPU crea un tensore random e, con `all_reduce`, il valore finale di questo tensore sarà la somma dei valori locali nelle varie GPU.
