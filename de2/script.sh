#!/usr/bin/bash

if [ $# -ne 1 ]; then
    echo "Chưa truyền đối số"
    exit
fi

echo '-----Câu 1-----'

is_folder=false

for f in $(pwd)/*; do
    if [ "$(pwd)/$1" == $f ]; then
        is_folder=true
    fi
done

if $is_folder; then
    echo 'Hợp lệ'
else
    echo "Không hợp lệ"
fi

echo '-----Câu 2-----'
folder=0
files=0

for f in $1/*; do
    if [ -d $f ]; then
        let 'folder+=1'
    elif [ -f $f ]; then
        let 'files+=1'
    fi
done

echo 'Folder:' $folder
echo 'Files:' $files

echo '-----Câu 3-----'

list_empty() {
    empty_folder=0
    empty_file=0
    for f in $1/*; do
        if [[ -f $f ]]; then
            if [[ ! -s $f ]]; then
                let 'empty_file+=1'
            fi
        elif [[ -d $f ]]; then
            if [[ -z $(ls -A $f) ]]; then
                let 'empty_folder+=1'
            fi
        fi
    done

    echo 'Empty_folder:' $empty_folder
    echo 'Empty_file:' $empty_file
}

list_empty $1

echo '-----Câu 4-----'

read -p 'Bạn có muốn xóa tất cả thư mục và tệp rỗng không? (y/n): ' delete_empty_or_not

if [[ $delete_empty_or_not = 'y' ]]; then
    for f in $1/*; do
        if [[ -f $f ]]; then
            if [[ ! -s $f ]]; then
                $(rm -f $f)
            fi
        elif [[ -d $f ]]; then
            if [[ -z $(ls -A $f) ]]; then
                $(rm -rf $f)
            fi
        fi
    done
    echo 'Xóa thành công'
else
    exit
fi

list_empty $1
