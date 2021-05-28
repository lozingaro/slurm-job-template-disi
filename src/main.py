import sys
import torch

if not torch.cuda.is_available():
    print("Torch CUDA acceleration is NOT available!")
    sys.exit()

for i in range(torch.cuda.device_count()):
    name = torch.cuda.get_device_name(i)
    print(f"I am GPU number {i}, but you can call me {name}")
