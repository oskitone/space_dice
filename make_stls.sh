#!/bin/bash

{

# Exit on error
set -o errexit
set -o errtrace

# Constants
openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
timestamp=$(git log -n1 --date=unix --format="%ad" openscad)
commit_hash=$(git log -n1 --format="%h" openscad)

# Flags
bonk=
prefix="space_dice"
dir="local/3d-models/$prefix-$timestamp-$commit_hash"
query=

# Internal variables
_found_matches=

function help() {
    echo "\
Renders STL models.

Usage:
./make_stls.sh [-hectb] [-p PREFIX] [-d DIRECTORY] [-q COMMA,SEPARATED,QUERY]

Usage:
./make_stls.sh                    Export all STLs
./make_stls.sh -h                 Show this message and quit
./make_stls.sh -e                 Echo out output directory and quit
./make_stls.sh -c                 Echo out commit hash and quit
./make_stls.sh -t                 Echo out timestamp and quit
./make_stls.sh -b                 Bonk and open folder when done
./make_stls.sh -p <prefix>        Set filename prefix
                                  Default is 'space_dice'
./make_stls.sh -d <directory>     Set output directory
                                  Default is local/3d-models/<prefix>...
./make_stls.sh -q <query>         Export only STLs whose filename stubs match
                                  comma-separated query
"
}

function export_stl() {
    stub="$1"
    override=$(echo "SHOW_${stub}" | tr '[a-z]' '[A-Z]')
    x_rotation="${2:-0}"
    y_rotation="${3:-0}"

    function _run() {
        filename="$dir/$prefix-$timestamp-$commit_hash-$stub.stl"

        echo "Exporting $filename..."

        # The "& \" at the end runs everything in parallel!
        $openscad "openscad/space_dice.scad" \
            --quiet \
            -o "$filename" \
            --export-format "binstl" \
            -D "SHOW_ENCLOSURE_BOTTOM=false" \
            -D "SHOW_BATTERY=false" \
            -D "SHOW_BATTERY_COVER=false" \
            -D "SHOW_PCB=false" \
            -D "SHOW_KNOBS=false" \
            -D "SHOW_BUTTON_ACTUATOR_MOUNT=false" \
            -D "SHOW_BUTTON_CAP=false" \
            -D "SHOW_SIDE_SWITCH_CLUTCH=false" \
            -D "SHOW_TOP_SWITCH_CLUTCHES=false" \
            -D "SHOW_SPEAKER=false" \
            -D "SHOW_LED_DISPLAY=false" \
            -D "SHOW_NUTS_AND_BOLTS=false" \
            -D "SHOW_ENCLOSURE_TOP=false" \
            -D "SHOW_PRINT_TEST=false" \
            -D "Y_ROTATION=$y_rotation " \
            -D "X_ROTATION=$x_rotation " \
            -D "$override=true" \
            & \
    }

    if [[ -z "$query" ]]; then
        _run
    else
        for query_iterm in "${query[@]}"; do
            if [[ "$stub" == *"$query_iterm"* ]]; then
                _found_matches=true
                _run
            fi
        done
    fi
}

function run() {
    mkdir -pv $dir >/dev/null
    echo "$dir"
    echo

    function finish() {
        # Kill descendent processes
        pkill -P "$$"
    }
    trap finish EXIT

    start=`date +%s`

    export_stl enclosure_bottom
    export_stl battery_cover
    export_stl knobs
    export_stl button_actuator_mount 90 0
    export_stl button_cap
    export_stl side_switch_clutch 0 90
    export_stl top_switch_clutches
    export_stl led_display
    export_stl enclosure_top 180 0
    export_stl print_test 180 0
    wait

    end=`date +%s`
    runtime=$((end-start))

    if [[ "$query" && -z $_found_matches ]]; then
        echo "Found no matches for query '$query'"
    else
        if [[ $bonk ]]; then
            printf "\a"
            open $dir
        fi
    fi

    echo
    echo "Finished in $runtime seconds"
}

while getopts "h?b?p:d:e?c?t?q:" opt; do
    case "$opt" in
        h) help; exit ;;
        b) bonk=true ;;
        p) prefix="$OPTARG" ;;
        d) dir="$OPTARG" ;;
        e) echo "$dir"; exit ;;
        c) echo "$commit_hash"; exit ;;
        t) echo "$timestamp"; exit ;;
        q) IFS="," read -r -a query <<< "$OPTARG" ;;
        *) help; exit ;;
    esac
done

run "${query[@]}"

}
