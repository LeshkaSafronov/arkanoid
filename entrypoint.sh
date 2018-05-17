clear
stty -echo -icanon time 0 min 0
cu_row_col=$'\e[%d;%dH'
terminal_height=$(tput lines)
terminal_width=$(tput cols)

platform=(
	'__________________'
	'\________________/'
)
temp="${platform[0]}"
platform_length=${#temp}

platform_x=$((terminal_height - 1))
platform_y=$((terminal_width / 2 - ${#platform[0]} / 2))

ball=(
	' __ '
	'/  \'
	'\__/' 
)

clean_platform () {
	for i in "${!platform[@]}"; do
		printf "$cu_row_col" $((platform_x+i)) $platform_y
		printf %${platform_length}s |tr " " " "
	done
}

output_platform () {
	for i in "${!platform[@]}"; do 
		printf "$cu_row_col" $((platform_x+i)) $platform_y
		printf "${platform[$i]}"
	done
}

while true; do
	tput civis
	output_platform

	read keypress
	  case $keypress in
	  "")
	    ;;
	  $'\e[C')
		if [[ $((platform_y + platform_length)) -le $(tput cols) ]]; then
			clean_platform
			platform_y=$((platform_y + 1))
		fi
	    ;;
	  $'\e[D')
		if [[ $((platform_y - 1)) -ge 1 ]]; then
			clean_platform
			platform_y=$((platform_y - 1))
		fi
	    ;;
  	esac
done

stty sane