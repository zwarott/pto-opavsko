import subprocess
from datetime import datetime

def create_backup():
    try:
        # Generate backup file name with current date
        backup_date = datetime.now().strftime("%Y-%m-%d")
        backup_file = f"db_{backup_date}.tar"
        
        # Run backing up process using pg_dump
        subprocess.run(['pg_dump', '-U', 'zwarott', '-d', 'pto_opavsko', '-f', backup_file])

        # If backup created successfully
        print("Backup created successfully!")
    except subprocess.CalledProcessError as e:
        # If not, print error statement
        print("Error:", e)

# Create latest backup
create_backup()
