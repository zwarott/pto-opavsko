import sys
import subprocess
import getpass
import os

def decrypt_file(encrypted_file):
    try:
        # Prompt the user to enter the decryption password
        decryption_password = getpass.getpass(prompt="Enter decryption password: ")

        # Extract the file name without extension from the encrypted file path
        file_name = os.path.splitext(encrypted_file)[0]

        # Run the decryption process using GnuPG
        subprocess.run(['gpg', '--batch', '--passphrase', decryption_password, '--output', f'{file_name}', '--decrypt', encrypted_file], check=True)

        print("File decrypted successfully!")
    except subprocess.CalledProcessError as e:
        print("Error:", e)
        print("Decryption failed. Please check the decryption password and try again.")

if __name__ == "__main__":
    # Check if the encrypted file path is provided as a command-line argument
    if len(sys.argv) != 2:
        print("Usage: python script_name encrypted_file")
        sys.exit(1)

    # Get the encrypted file path from the command-line argument
    encrypted_file = sys.argv[1]

    # Call the decrypt_file function with the provided encrypted file path
    decrypt_file(encrypted_file)
