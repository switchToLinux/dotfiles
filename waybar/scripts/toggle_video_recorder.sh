#!/bin/bash

# 最后一次选择的目录和文件
lastdir_file="/tmp/.wf-recorder.outdir"         # 最后一次选择的目录
lastvideo_file="/tmp/.wf-recorder.outfile"      # 最后一次选择的文件

get_out_dir() {
    if command -v zenity &>/dev/null; then   # 通过对话框设置选择新目录
        selected_dir=$(zenity --file-selection --directory)
    fi
    # [[ -z "$selected_dir" ]] && selected_dir="$HOME/Videos"
    echo -n $selected_dir
}

toggle() {
    pid=$(pidof wf-recorder)
    if [ -z "$pid" ]; then
        outdir=$(get_out_dir)
        [[ -z "$outdir" ]] && notify-send "Info" "recording canceled" && exit 1
        [[ ! -d "$outdir" ]] && notify-send "Info" "directory not exists" && exit 1

        outfile="${outdir}/area_$(date +%Y%m%d_%H%M%S).mp4"
        echo -n $outdir| tee ${lastdir_file}
        echo -n $outfile| tee ${lastvideo_file} | wl-copy
        notify-send "Info" "recording started"
        nohup wf-recorder -g "$(slurp)" -f  ${outfile} >/dev/null 2>&1 &
    else
        killall wf-recorder
        notify-send "Info" "Stopped recording"
    fi
}

status() {
    # 根据 wf-recorder 的进程状态判断是否正在录制，并输出相应的JSON格式信息，自定义class控制显示效果
    status_on=(
        "󰃽 录制中·"
        "󰃽 录制中··"
    )
    array_length=${#status_on[@]}
    random_index=$(( RANDOM % array_length ))
    random_status=${status_on[$random_index]}

    pid=$(pidof wf-recorder)
    if [ -z "$pid" ]; then
        echo "{\"text\":\"󰃾 \", \"class\":\"recorder-stop\"}"
    else
        echo "{\"text\":\"${random_status}\", \"class\":\"recording\"}"
    fi
}

action="${1:-toggle}"

case "${action}" in
    toggle|status)
        $action
        ;;
    *)
        echo "Usage: $0 [toggle|status]"
        exit 1
        ;;
esac
