
width = 2560
height = 480
block_size = 32

v_blocks = int(height/block_size)
h_blocks = int(width/block_size)

bit_width = 1
depth = int(v_blocks * h_blocks)

ADDRESS_RADIX="UNS"
DATA_RADIX="BIN"

blocks = [422, 736, 740, 741, 742, 743, 744, 766, 767, 777, 778, 797, 798, 799, 838, 839, 846, 847, 857, 858, 908, 909, 918, 919, 926, 927, 937, 938, 988, 989, 998, 999, 1006, 1007, 1017, 1018]

colliders = [0] * depth

for idx in blocks:
    colliders[idx] = 1

for x in range(depth-h_blocks*2, depth):
    if((x % h_blocks) % 69 == 0 or (x % h_blocks) % 70 == 0):
        continue
    colliders[x] = 1


f = open("world1_1_collider.mif", "w")
f.write(f"WIDTH={bit_width};\n")
f.write(f"DEPTH={depth};\n")
f.write('\n')
f.write(f"ADDRESS_RADIX={ADDRESS_RADIX};\n")
f.write(f"DATA_RADIX={DATA_RADIX};\n")
f.write('\n')
f.write("CONTENT BEGIN\n")

for i in range(depth):
    f.write(f"\t{i} : {colliders[i]};\n")

f.write("END;")
f.close()