from pwn import*

p = process('./prob')

i = 0

while i < 100:

        p.recvuntil(': ')
        data = p.recvuntil('=')[:-1]
        data = data.split(' ')
        print(data)
        data = int(data[0]) + int(data[2])
        p.sendline(str(data))

        i += 1

p.interactive()



