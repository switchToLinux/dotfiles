#!/bin/bash


get_out_dir() {
    if command -v zenity &>/dev/null; then   # 通过对话框设置选择新目录
        selected_dir=$(zenity --file-selection --directory)
    fi
    [[ -z "$selected_dir" ]] && selected_dir="$HOME/Videos"
    echo -n $selected_dir
}

pid=$(pidof wf-recorder)
if [ -z "$pid" ]; then
    outdir=$(get_out_dir)
     outfile="${outdir}/area_$(date +%Y%m%d_%H%M%S).mp4"
     echo -n $outfile | wl-copy
    echo "Recording to $outfile"
    sleep 1
    nohup wf-recorder -g "$(slurp)" -f  ${outfile} >/dev/null 2>&1 &
else
    killall wf-recorder
    echo "Stopped recording"
fi

