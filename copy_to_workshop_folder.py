import shutil
import os

destination = '../Teardown-FPSCounter-workshop'

# Check if the destination folder exists and create it if it doesn't
if not os.path.exists(destination):
    os.mkdir(destination)

# Delete all files in the destination folder
for file in os.listdir(destination):
    os.remove(destination + '/' + file)

# Copy the files with the relevant extensions from the source folder
num = 0
for file in os.listdir('.'):
    file_ext = file.split('.')[-1]
    if file_ext in ['jpg', 'lua', 'txt']:
        shutil.copy(file, destination + '/' + file)
        num += 1

print(f'Copied {num} files.')
