#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Wofi Beats to play online Music or Locally saved media files

# 说明： 播放 youtube 音乐需要提前安装 yt-dlp / mpv 命令工具， 如果希望 playerctl 可以控制mpv 还需要安装 mpv-mpris 插件。
# 个人更新记录
#     1. 增加 env_file 记录本地文件目录
# Variables
env_file="$HOME/.music_local.list"
online_music_file="$HOME/.music_online.list"
online_iptv_file="$HOME/.iptv_online.list"
online_radio_file="$HOME/.radio_online.list"
pid_file="/tmp/play_music_mpv.pid"


SEP="|"  # title与 url 的分隔符

declare -A online_info
# Online Stations. Edit as required
declare -A online_music_list=(
  ["FM - Easy Rock 96.3 📻🎶"]="https://radio-stations-philippines.com/easy-rock"
  ["FM - Easy Rock - Baguio 91.9 📻🎶"]="https://radio-stations-philippines.com/easy-rock-baguio" 
  ["FM - Love Radio 90.7 📻🎶"]="https://radio-stations-philippines.com/love"
  ["FM - WRock - CEBU 96.3 📻🎶"]="https://onlineradio.ph/126-96-3-wrock.html"
  ["FM - Fresh Philippines 📻🎶"]="https://onlineradio.ph/553-fresh-fm.html"
  ["Radio - Lofi Girl 🎧🎶"]="https://play.streamafrica.net/lofiradio"
  ["Radio - Chillhop 🎧🎶"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
  ["Radio - Ibiza Global 🎧🎶"]="https://filtermusic.net/ibiza-global"
  ["Radio - Metal Music 🎧🎶"]="https://tunein.com/radio/mETaLmuSicRaDio-s119867/"
  ["YT - Wish 107.5 YT Pinoy HipHop 📻🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJnmgMYwCKid4XIFqUKBVWEs&si=vahW_noh4UDJ5d37"
  ["YT - Youtube Top 100 Songs Global 📹🎶"]="https://youtube.com/playlist?list=PL4fGSI1pDJn6puJdseH2Rt9sMvt9E2M4i&si=5jsyfqcoUXBCSLeu"
  ["YT - Wish 107.5 YT Wishclusives 📹🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJn5B22H9HOWP3Kxxs-DkPSM&si=d_Ld2OKhGvpH48WO"
  ["YT - Relaxing Piano Music 🎹🎶"]="https://youtu.be/6H7hXzjFoVU?si=nZTPREC9lnK1JJUG"
  ["YT - Youtube Remix 📹🎶"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
  ["YT - Korean Drama OST 📹🎶"]="https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ"
  ["YT - lofi hip hop radio beats 📹🎶"]="https://www.youtube.com/live/jfKfPfyJRdk?si=PnJIA9ErQIAw6-qd"
  ["YT - Relaxing Piano Jazz Music 🎹🎶"]="https://youtu.be/85UEqRat6E4?si=jXQL1Yp2VP_G6NSn"
)

# Function for displaying notifications
notification() {
  notify-send  "Now Playing:" "$@"
}

stop_music() {
  # Check if music is already playing
  # ps -ef | grep mpv | grep -v mpvpaper | awk '{ print $2 }' | xargs kill
  if [ -f "$pid_file" ]; then
    pid=$(cat "$pid_file")
    if [ -z "$pid" ]; then
      rm -f "$pid_file"
      return
    else
      kill "$pid"
      rm -f "$pid_file"
    fi
  fi
  sleep 1
}
start_play_music() {
  stop_music
  nohup mpv --shuffle --loop-playlist --vid=no "$@" >/dev/null 2>&1 &
  echo "$!" > "$pid_file"
}

start_play_video() {
  stop_music
  nohup mpv --loop-playlist "$@" >/dev/null 2>&1 &
  echo "$!" > "$pid_file"
}

get_music_dir() {
  if [ -f "$env_file" ]; then
      selected_dir=$( (cat "$env_file" && echo "..." ) | wofi --dmenu -p "Select Music Directory" --sort-order alphabetical)
  else
    selected_dir="..."
  fi
  if [[ "$selected_dir" == "..." ]] ; then 
    if command -v zenity &>/dev/null; then   # 通过对话框设置选择新目录
      selected_dir=$(zenity --file-selection --directory)
    fi
  fi
  [[ -z "$selected_dir" ]] && return 1
  # 如果目录为新增的目录，则将其添加到 .env 文件中
  if ! grep -q "^$selected_dir$" "$env_file" 2>/dev/null; then
      echo "$selected_dir" >> "$env_file"
  fi
  echo -n $selected_dir
}
# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
  local_music=()
  filenames=()
  selected_dir=$(get_music_dir)
  [[ -z "$selected_dir" ]] && notification "please select a valid directory, first" && return 1
  while IFS= read -r file; do
    local_music+=("$file")
    filenames+=("$(basename "$file")")
  done < <(find -L "$selected_dir" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.ape" \
      -o -iname "*.wma" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.dts" \
      -o -iname "*.mkv" -o -iname "*.mov" \))
}


# Main function for playing local music
play_local_music() {
  populate_local_music
  [[ "$?" != "0" ]] && notification "populate_local_music got error!"  && return 1

  # Prompt the user to select a song
  choice=$(printf "%s\n" "${filenames[@]}" | wofi  --dmenu)

  if [ -z "$choice" ]; then
    exit 1
  fi

  # Find the corresponding file path based on user's choice and set that to play the song then continue on the list
  for (( i=0; i<"${#filenames[@]}"; ++i )); do
    if [ "${filenames[$i]}" = "$choice" ]; then
      stop_music
      notification "$choice"
      nohup mpv --playlist-start="$i" --loop-playlist --vid=no  "${local_music[@]}" >/dev/null 2>&1 &
      echo "$!" > "$pid_file"
      break
    fi
  done
}

# Main function for shuffling local music
shuffle_local_music() {
  notification "Shuffle Play local music"
  
  selected_dir=$(get_music_dir)
  [[ -z "$selected_dir" ]] && notification "please select a valid directory, first" && return 1
  start_play_music "$selected_dir"
}

# 播放在线资源模板函数
# 参数:
#   $1: online_config_file 资源配置列表文件(内容格式:title|url)
play_online_audio() {
  local online_config_file="$1"
  if [[ -f "$online_config_file" ]] ; then
    # 读取文件并恢复数组
    while IFS="${SEP}" read -r key value; do
      [[ "$key" =~ ^#.*$ ]] && continue # 跳过注释行
      [[ "$key" =~ ^\s*$ ]] && continue # 跳过空行
      [[ -z "$key" || -z "$value" ]] && continue

      online_info["$key"]="$value"
    done <  "$online_config_file"
  fi

  choice=$(for online in "${!online_info[@]}"; do  echo "$online" ; done | wofi --dmenu --sort-order alphabetical -p "add playlist: title|link ")
  if [ -z "$choice" ]; then
    exit 1
  fi
  link=${online_info["$choice"]}
  if [[ -z "$link" ]] ; then # 可能添加新链接
    IFS="$SEP"  read -r key value  <<< "$choice"
    if [[ ! -z "$key" && ! -z "$value" && "$value" =~ ^https: ]] ; then
      echo "$key${SEP}${value}"  >> $online_config_file
      choice="$key"
      link="$value"
    fi
  fi
  echo "choice:$choice"
  echo "link=$link"
  notification "$choice"
  start_play_music "$link"
}


show_menu() {
  echo "1 随机本地音乐(Shuffle Local Music)"
  echo "2 播放本地音乐(Local Music)"
  echo "3 播放在线音乐(Online Music)"
  echo "4 播放在线电台(Online Radio)"
  echo "5 播放直播IPtv(Online IPtv)"
}

user_choice=$(show_menu| wofi --dmenu | cut -d" " -f1)

echo "User choice: $user_choice"

case "$user_choice" in
  "1")
    shuffle_local_music
    ;;
  "2")
    play_local_music
    ;;
  "3")
    play_online_audio "$online_music_file"
    ;;
  "4")
    play_online_audio "$online_radio_file"
    ;;
  "5")
    play_online_audio "$online_iptv_file"
    ;;
  *)
    ;;
esac
