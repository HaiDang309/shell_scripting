#!/usr/bin/bash

declare -a room_id_arr
declare -a name_arr
declare -a phone_arr

while read -r line; do
    read room_id name phone <<<$line
    if [[ -z $name ]]; then
        name_arr+=('empty')
    fi
    if [[ -z $phone ]]; then
        phone_arr+=('empty')
    fi
    room_id_arr+=($room_id)
    name_arr+=($name)
    phone_arr+=($phone)
done <'reserve.txt'

number_of_room=${#room_id_arr[*]}
echo ${phone_arr[*]}

is_reserved() {
    if [[ -z $1 ]]; then
        exit
    fi

    flag=false
    index_room_search=0
    for index in $(seq 0 $(($number_of_room - 1))); do
        if [[ ${room_id_arr[$index]} = $1 ]]; then
            if [[ ${name_arr[$index]} = 'empty' ]]; then
                index_room_search=$index
                flag=true
            fi
        fi
    done
    if $flag; then
        echo '@Phòng trống@'
        unset name
        unset phone
        echo 'Vui lòng nhập thông tin để đặt phòng: '
        read -p 'Nhập tên: ' name
        read -p 'Nhập sđt: ' phone
        name_arr[$index_room_search]=$name
        phone_arr[$index_room_search]=$phone
        $(>'reserve.txt')
        for i in $(seq 0 $(($number_of_room - 1))); do
            echo "${room_id_arr[$i]} ${name_arr[$i]} ${phone_arr[$i]}" >>'reserve.txt'
            sed -i 's/empty//g' reserve.txt
        done
        echo '-----Thông tin phòng-----'
        cat reserve.txt
    else
        echo '@Phòng đã có người đặt@'
        echo '-----Thông tin khách hàng đã đặt-----'
        echo 'Name:' ${name_arr[$index_room_search]}
        echo 'Phone:' ${phone_arr[$index_room_search]}

        read -p 'Quý khách đã trả phòng chưa? (y/n): ' confirm
        if [[ $confirm = 'y' ]]; then
            name_arr[$index_room_search]=""
            phone_arr[$index_room_search]=""
            $(>'reserve.txt')
            for i in $(seq 0 $(($number_of_room - 1))); do
                echo "${room_id_arr[$i]} ${name_arr[$i]} ${phone_arr[$i]}" >>'reserve.txt'
            done
            cat reserve.txt
        else
            exit
        fi
    fi
}

read -p "Nhập số phòng để tìm kiểm tra (${room_id_arr[*]}): " id_of_room

is_reserved $id_of_room
