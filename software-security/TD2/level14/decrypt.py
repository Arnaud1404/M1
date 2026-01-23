token="857:g67?5ABBo:BtDA?tIvLDKL{MQPSRQWW."

def decrypt(token:str) -> None:
    padding = 0 
    for char in token:
        print(chr(ord(char)-padding), end="")
        padding += 1

decrypt(token)
