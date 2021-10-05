LC_NUMERIC="en_US.UTF-8"

COLOR_GREEN="\033[32m"
COLOR_RESET="\033[39m"
COLOR_YELLOW="\033[33m"

nb_tests=100

function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    printf "\rProgress : |${_fill// /${COLOR_GREEN}█${COLOR_RESET}}${_empty// /-}| ${1}/${2}"

}

function testList {

    s=0
    max=0
    min=9999999
    printf "\nList size : $1\n"
    for i in `seq 0 $nb_tests`;
    do
        var=$(./push_swap `ruby -e "puts (1..$1).to_a.shuffle.join(' ')"`|wc -l|awk '{$1=$1};1')
        if [ "$var" -lt "$min" ]
        then
            min=$var
        fi
        if [ "$var" -gt "$max" ]
        then
            max=$var
        fi
        s=$(( $s + $var))
        ProgressBar $i $nb_tests
    done

    printf "\nAverage of actions : ${COLOR_YELLOW}"
    X=`echo "$s / ($nb_tests + 1)" | bc -l`
    printf %.0f "$X"
    printf "\n${COLOR_RESET}Max : ${COLOR_YELLOW}$max ${COLOR_RESET}| Min : ${COLOR_YELLOW}$min${COLOR_RESET}"
    echo
    arg=`ruby -e "puts (1..$1).to_a.shuffle.join(' ')"`; ./push_swap $arg | ./checker_Mac $arg
}

for arg in $@
do
    testList $arg
done
