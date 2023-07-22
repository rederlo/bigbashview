#!/usr/bin/env bash

readonly red=$(tput setaf 124)
readonly green=$(tput setaf 2)
readonly pink=$(tput setaf 129)
readonly reset=$(tput sgr0)

function sh_debug {
   export PS4='${red}${0##*/}${green}[$FUNCNAME]${pink}[$LINENO]${reset} '
   set -x
   #set -e
   shopt -s extglob
   #Only to debug
   #rm -R "$HOME/.config/bigcontrolcenter/"
   #Don't group windows
   #xprop -id "$(xprop -root '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)" -f WM_CLASS 8s -set WM_CLASS "$$"
}

function sh_getbgcolor {
	local cfile="$HOME/.config/bigbashview_lightmode"
	local lightmode=0
	local result
	local status

	# Open Autodetect and read saved background color
	if ! test -s "$cfile"; then
		# Read background color
		if result="$(kreadconfig5 --group "Colors:Window" --key BackgroundNormal)"; then
			if (( -n "$result" )); then
				KDE_BG_COLOR="$(bc | sed 's|^|(|g;s|,|+|g;s|$|)/3|g' <<< "$result")"
				# Verify if is light or not
				if [[ "$KDE_BG_COLOR" -gt "127" ]]; then
					lightmode=1
				fi
			fi
		fi
	else
		lightmode=$(printf "%s" "$(<"$cfile")")
	fi

	if ((lightmode)); then
		echo '<body class=light-mode>'
	else
		echo '<body>'
	fi
}

function sh_setbgcolor {
	local cfile="$HOME/.config/bigbashview_lightmode"
	local lightmode=0

	[[ "$1" = "true" ]] && lightmode=1
	echo "$lightmode" >"$cfile"
}

function sh_lang_he {
	grep ^he <<< "$LANG"
	return "$?"
}

function sh_getcpu {
	#awk -F ':' 'NR==1 {print $2}' <<< "$(grep 'model name' /proc/cpuinfo)"
	grep 'model name' /proc/cpuinfo | awk -F ':' 'NR==1 {print $2}'
}

function sh_getmemory {
	awk -F' ' 'NR==2 {print $2}' < <(free -h)
}

function sh_getvga {
	awk -F: '/VGA/ {print $3}' < <(lspci)
}

function sh_catecho {
	echo "$(<"$1")"
}

function sh_catprintf {
	printf "%s" "$(<"$1")"
}

function sh_printfile {
	sh_catecho "$1"
}

function sh_installed_pkgs {
	echo $(pacman -Q | cut -f1 -d" ")
}

function sh_info_msg {
	printf "\033[1m$@\n\033[m"
}

function sh_get_greeting_message {
   local hora_atual=$(date +%H)
   local greeting_message

   if (( hora_atual >= 6 && hora_atual < 12 )); then
      greeting_message=$"Bom dia"
   elif (( hora_atual >= 12 && hora_atual < 18 )); then
      greeting_message=$"Boa tarde"
   else
      greeting_message=$"Boa noite"
   fi
   echo "$greeting_message"
}

function sh_get_user {
	[[ "$USER" != "biglinux" ]] && echo " $USER"
}

function sh_get_lang {
	echo "$LANG"
}

function sh_get_locale {
	echo "$(grep _ <(locale -a) | head -1 | cut -c1-5)"
}

