import subprocess
import matplotlib.pyplot as plt

cache_ls = []
cache_define = []
Iamat_ls = []
Imiss_rate = []
Damat_ls = []
Dmiss_rate = []
W_size = []
B_size = []
S_size = []
for i in range(10):
    size = 2 ** i
    W_size.append(size)
    S_size.append(size)

for j in range(8):
    size = 2 ** (3+j)
    B_size.append(size)
B = B_size[7]

for i in range(10):
    S = S_size[i]
    for j in range(10):
        W = W_size[j]
        size = S*B*W
        icpa = "--ic=" + str(S) + ":" + str(W) + ":" + str(B)
        dcpa = "--dc=" + str(S) + ":" + str(W) + ":" + str(B)
        log = subprocess.run(["spike", "--isa=rv32i",  icpa,  dcpa, "/opt/riscv/riscv32-unknown-elf/bin/pk",  "program"], stdout=subprocess.PIPE)
        log = str(log.stdout).replace(" ", "").split("\\n")
        miss_rate = [string for string in log if "MissRate" in string]
        DMR = float(miss_rate[0].replace("D$MissRate:", "").replace("%", ""))
        IMR = float(miss_rate[1].replace("I$MissRate:", "").replace("%", ""))
        cost = (0.1 + 0.0001 * size)
        D_amat = (1 + DMR / 100 * 10) * cost
        I_amat = (1 + IMR / 100 * 10) * cost
        Dmiss_rate.append(DMR)
        Damat_ls.append(D_amat)
        Imiss_rate.append(IMR)
        Iamat_ls.append(I_amat)
        cache_ls.append(size)
        word = S, ":", W
        cache_define.append(word)
# print(B, len(Damat_ls),len(Dmiss_rate))

minimum = Iamat_ls[0]
idx = 0
for i in range(len(Iamat_ls)):
    if(Iamat_ls[i] < minimum):
        minimum = Iamat_ls[i]
        idx = i


plt.scatter(cache_ls,Iamat_ls, s=20)
plt.xscale('log')
plt.title('AMAT of Instruction Memory (B = 1024)')
plt.xlabel('Cache Size')
plt.ylabel('AMAT')
plt.annotate(str(cache_define[idx]), (cache_ls[idx], Iamat_ls[idx] + 0.2))
plt.annotate(str(Iamat_ls[idx]), (cache_ls[idx], Iamat_ls[idx] + 400))
plt.show()

