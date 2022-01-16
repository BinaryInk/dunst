#!/bin/bash

function keypress {
    echo "press enter to continue..."
    read key
}

function tmp_dunstrc {
        cp "$1" dunstrc.tmp
        echo -e "\n$2" >> dunstrc.tmp
}

function start_dunst {
        killall dunst
        ../../dunst -config $1 &
        sleep 0.1
}

function basic_notifications {
    ../../dunstify -a "dunst tester"         "normal"    "<i>italic body</i>"
    ../../dunstify -a "dunst tester"  -u c   "critical"   "<b>bold body</b>"
    ../../dunstify -a "dunst tester"         "long body"  "This is a notification with a very long body"
    ../../dunstify -a "dunst tester"         "duplucate"
    ../../dunstify -a "dunst tester"         "duplucate"
    ../../dunstify -a "dunst tester"         "duplucate"
    ../../dunstify -a "dunst tester"         "url"        "www.google.de"

}

function show_age {
    echo "###################################"
    echo "show age"
    echo "###################################"
    killall dunst
    ../../dunst -config dunstrc.show_age &
    ../../dunstify -a "dunst tester"  -u c "Show Age" "These should print their age after 2 seconds"
    basic_notifications
    keypress
}

function run_script {
    echo "###################################"
    echo "run script"
    echo "###################################"
    killall dunst
    PATH=".:$PATH" ../../dunst -config dunstrc.run_script &
    ../../dunstify -a "dunst tester" -u c \
        "Run Script" "After Keypress, 2 other notification should pop up."
    keypress
    ../../dunstify -a "dunst tester" -u c "trigger" "this should trigger a notification"
    keypress
}

function replace {
    echo "###################################"
    echo "replace"
    echo "###################################"
    killall dunst
    ../../dunst -config dunstrc.default &
    id=$(../../dunstify -a "dunst tester" -p "Replace" "this should get replaces after keypress")
    keypress
    ../../dunstify -a "dunst tester" -r $id "Success?" "I hope this is not a new notification"
    keypress

}

function limit {
    echo "###################################"
    echo "limit"
    echo "###################################"
    tmp_dunstrc dunstrc.default "notification_limit=4"
    start_dunst dunstrc.tmp
    ../../dunstify -a "dunst tester" -u c "notification limit = 4"
    basic_notifications
    rm dunstrc.tmp
    keypress

    tmp_dunstrc dunstrc.default "notification_limit=0"
    start_dunst dunstrc.tmp
    ../../dunstify -a "dunst tester" -u c "notification limit = 0 (unlimited notifications)"
    basic_notifications
    rm dunstrc.tmp
    keypress
}

function markup {
    echo "###################################"
    echo "markup"
    echo "###################################"
    killall dunst
    ../../dunst -config dunstrc.default &
    ../../dunstify -a "dunst tester"  "Markup Tests" -u "c"
    ../../dunstify -a "dunst tester"  "Title" "<b>bold</b> <i>italic</i>"
    ../../dunstify -a "dunst tester"  "Title" '<a href="github.com"> Github link </a>'
    ../../dunstify -a "dunst tester"  "Title" "<b>broken markup</i>"
    keypress

    killall dunst
    ../../dunst -config dunstrc.nomarkup &
    ../../dunstify -a "dunst tester" -u c "No markup Tests" "Titles shoud still be in bold and body in italics"
    ../../dunstify -a "dunst tester" "Title" "<b>bold</b><i>italic</i>"
    ../../dunstify -a "dunst tester" "Title" "<b>broken markup</i>"
    keypress

}

function test_origin {
    tmp_dunstrc dunstrc.default "origin = $1\n offset = 10x10"
    start_dunst dunstrc.tmp
    ../../dunstify -a "dunst tester" -u c "$1"
    basic_notifications
    rm dunstrc.tmp
    keypress
}

function origin {
    echo "###################################"
    echo "origin"
    echo "###################################"
    test_origin "top-left"
    test_origin "top-center"
    test_origin "top-right"
    test_origin "left-center"
    test_origin "center"
    test_origin "right-center"
    test_origin "bottom-left"
    test_origin "bottom-center"
    test_origin "bottom-right"
}

function test_width {
    tmp_dunstrc dunstrc.default "width = $1"
    start_dunst dunstrc.tmp
    ../../dunstify -a "dunst tester" -u c "width = $1"
    basic_notifications
    rm dunstrc.tmp
    keypress
}

function width {
    echo "###################################"
    echo "width"
    echo "###################################"
    test_width "100"
    test_width "200"
    test_width "400"
    test_width "(0,400)"
}

function test_height {
    tmp_dunstrc dunstrc.default "height = $1"
    start_dunst dunstrc.tmp
    ../../dunstify -a "dunst tester" -u c "height = $1"
    ../../dunstify -a "dunst tester" -u c "Temporibus accusantium libero sequi at nostrum dolor sequi sed. Cum minus reprehenderit voluptatibus laboriosam et et ut. Laudantium blanditiis omnis ipsa rerum quas velit ut. Quae voluptate soluta enim consequatur libero eum similique ad. Veritatis neque consequatur et aperiam quisquam id nostrum. Consequatur voluptas aut ut omnis atque cum perferendis. Possimus laudantium tempore iste qui nemo voluptate quod. Labore totam debitis consectetur amet. Maxime quibusdam ipsum voluptates quod ex nam sunt. Officiis repellat quod maxime cumque tenetur. Veritatis labore aperiam repellendus. Provident dignissimos ducimus voluptates."
    basic_notifications
    rm dunstrc.tmp
    keypress
}

function height {
    echo "###################################"
    echo "height"
    echo "###################################"
    test_height "50"
    test_height "100"
    test_height "200"
}

function progress_bar {
    killall dunst
    ../../dunst -config dunstrc.default &
    ../../dunstify -h int:value:0 -a "dunst tester" -u c "Progress bar 0%: "
    ../../dunstify -h int:value:33 -a "dunst tester" -u c "Progress bar 33%: "
    ../../dunstify -h int:value:66 -a "dunst tester" -u c "Progress bar 66%: "
    ../../dunstify -h int:value:100 -a "dunst tester" -u c "Progress bar 100%: "
    keypress
    killall dunst
    ../../dunst -config dunstrc.default &
    ../../dunstify -h int:value:33 -a "dunst tester" -u l "Low priority: "
    ../../dunstify -h int:value:33 -a "dunst tester" -u n "Normal priority: "
    ../../dunstify -h int:value:33 -a "dunst tester" -u c "Critical priority: "
    keypress
    killall dunst
    ../../dunst -config dunstrc.progress_bar &
    ../../dunstify -h int:value:33 -a "dunst tester" -u n "The progress bar should not be the entire width"
    ../../dunstify -h int:value:33 -a "dunst tester" -u n "You might also notice height and frame size are changed"
    ../../dunstify -h int:value:33 -a "dunst tester" -u c "Short"
    keypress
}

function icon_position {
    for position in left top right off; do
        tmp_dunstrc dunstrc.icon_position "icon_position = $position"
        start_dunst dunstrc.tmp
        for urgency in l n c; do
            ../../dunstify -a "dunst tester" -I '../data/icons/valid.png' -u $urgency "icon_position = $position"
        done
        rm dunstrc.tmp
        keypress
    done
}

function hide_text {
    start_dunst dunstrc.hide_text
    ../../dunstify -a "dunst tester" -I '../data/icons/valid.png' -u n "text not hidden" "You should be able to read me!\nThe next notifications should not have any text."
    ../../dunstify -a "dunst tester" -u l "text hidden" "If you can read me then hide_text is not working."
    ../../dunstify -a "dunst tester" -I '../data/icons/valid.png' -u l "text hidden + icon" "If you can read me then hide_text is not working."
    ../../dunstify -a "dunst tester" -h int:value:$((RANDOM%100)) -I '../data/icons/valid.png' -u l "text hidden + icon + progress bar" "If you can read me then hide_text is not working."
    keypress
}

if [ -n "$1" ]; then
    while [ -n "$1" ]; do
        $1
        shift
    done
else
    width
    height
    origin
    limit
    show_age
    run_script
    ignore_newline
    replace
    markup
    progress_bar
    icon_position
    hide_text
fi

killall dunst
