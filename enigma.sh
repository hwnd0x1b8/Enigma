#!/usr/bin/env bash

MESSAGE_REGEX='^[A-Z ]+$'
FILE_NAME_REGEX='^[a-zA-Z.]+$'

encrypt_message() {
    openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$1" -out "$1.enc" -pass pass:"$2" &>/dev/null
}

decrypt_message() {
    openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$1" -out "${1%.enc}" -pass pass:"$2" &>/dev/null
}

create_file() {
    echo "Enter the filename:"
    read -r file_name
    if [[ "$file_name" =~ $FILE_NAME_REGEX ]]; then
        echo "Enter a message:"
        read -r message
        if [[ -n "$message" && $message =~ $MESSAGE_REGEX ]]; then
            echo "$message" > "$file_name"
            echo "The file was created successfully!"
        else
            echo "This is not a valid message!"
        fi
    else
        echo "File name can contain letters and dots only!"
    fi
}

read_file() {
    echo "Enter the filename:"
    read -r file_name
    if [[ -e "$file_name" ]]; then
        echo "File content:"
        cat $file_name
    else
        echo "File not found!"
    fi
}

encrypt_file() {
    echo "Enter the filename:"
    read -r file_name
    if [[ -e "$file_name" ]]; then
        echo "Enter password:"
        read -r password
        encrypt_message "$file_name" "$password"
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            rm $file_name
            echo "Success"
        fi
    else
        echo "File not found!"
    fi
}

decrypt_file() {
    echo "Enter the filename:"
    read -r file_name
    if [[ -e "$file_name" ]]; then
        echo "Enter password:"
        read -r password
        decrypt_message "$file_name" "$password"
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            rm $file_name
            echo "Success"
        fi
    else
        echo "File not found!"
    fi
}

echo "Welcome to the Enigma!"
while :
do
    echo "0. Exit"
    echo "1. Create a file"
    echo "2. Read a file"
    echo "3. Encrypt a file"
    echo "4. Decrypt a file"
    echo "Enter an option:"
    read -r option

    case "${option}" in
        0 )
            echo "See you later!"
            break
            ;;
        1 )
            create_file
            ;;
        2 )
            read_file
            ;;
        3 )
            encrypt_file
            ;;
        4 )
            decrypt_file
            ;;
        * )
            echo "Invalid option!"
    esac
done

