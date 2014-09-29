#!/bin/sh
# Update latest ISO url by country
# Select country from https://github.com/Gen2ly/armrr
countries=(AT AU BE BG BR BY CA CH CL CN CO CZ DE DK EE ES FI FR GB GR HU IE IL IN IT JP KR KZ LK LU LV MK NC NL NO NZ PL PT RO RS RU SE SG SK TR TW UA US UZ VN ZA kernel.org)
country=""
[ "$1" ] && country="$1"

# Usage display if incorrect number of parameters given
if [ $# -gt 1 -o "$1" = -h -o "$1" = --help ]; then
    echo "${0##*/} [*country code] - download pacman ranked mirrorlist"
    echo " "${countries[@]}"" | fmt -c -w 80
    exit 1;
fi

# Select country from list
if ! [ "$country" ]; then
echo "Select country:"
    select country in "${countries[@]}"; do
        test -n "$country" && break
        echo "Select 1, or 2..."
    done;
fi

# Test if $country is in $countries array
if ! [[ " ${countries[*]} " == *" $country "* ]]; then
    echo "Invalid country code."
    exit 1;
fi

# Download mirrorlist by country
if [[ ${country} == 'kernel.org' ]]; then
    repo='https://mirrors.kernel.org/archlinux/'
fi

if ! [ ${repo} ]; then
    url='https://www.archlinux.org/mirrorlist/?country='${country}'&use_mirror_status=on'
    repo=$(curl -sS "$url"|grep '#Server'|head -n 1|sed 's/#Server = //'|sed 's/$repo\/os\/$arch//')
    if ! [ ${repo} ]; then
        echo 'Error: Download failed'
        exit 1;
    fi
fi

# Get latest ISO url
repo=${repo}'iso/latest/'
iso=($(curl -sS "${repo}sha1sums.txt"|awk 'NR==1'))

# Set latest ISO url in template
template='arch-template.json'
function setTamplateValue {
    sed -e '1,/"'${1}'": "\(.*\)"/s|"'${1}'": "\(.*\)"|"'${1}'": "'${2}'"|' ${template} > ${template}.bk && mv ${template}.bk ${template}
}
setTamplateValue 'iso_url' ${repo}${iso[1]}
setTamplateValue 'iso_checksum' ${iso[0]}

echo 'Update successfully: '${repo}${iso[1]}