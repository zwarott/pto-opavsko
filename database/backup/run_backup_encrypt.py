import subprocess
from datetime import datetime
import getpass
import os

def create_backup():
    try:
        # Prompt the user to enter the encryption password
        encryption_password = getpass.getpass(prompt="Enter encryption password: ")

        # Ask user to repeat encryption password for confirmation
        repeat_encryption_password = getpass.getpass(prompt="Repeat encryption password: ")

        # Check if encryption passwords match
        if encryption_password != repeat_encryption_password:
            print("Encryption passwords do not match. Aborting.")
            return

        # Set the PGPASSWORD environment variable to provide the PostgreSQL password
        os.environ['PGPASSWORD'] = getpass.getpass(prompt="Enter PostgreSQL password: ")

        # Generate backup file name with current date
        backup_date = datetime.now().strftime("%Y-%m-%d")
        backup_file = f"db_{backup_date}.sql"

        # Run backing up process using pg_dump to create SQL backup
        subprocess.run(['pg_dump', '-U', 'zwarott', '-d', 'pto_opavsko', '-f', backup_file])

        # Encrypt the SQL backup file using GnuPG
        subprocess.run(['gpg', '--symmetric', '--batch', '--passphrase', encryption_password, backup_file])

        # If encryption successful, remove the unencrypted SQL backup file
        subprocess.run(['rm', backup_file])

        # If backup and encryption completed successfully
        print("Backup created and encrypted successfully!")
    except subprocess.CalledProcessError as e:
        # If not, print error statement
        print("Error:", e)

# Create latest backup and encrypt it
create_backup()

# Encrypt file within terminal running command below:
# gpg --output output_file.sql --decrypt input_file.sql.gpg  
