#!/usr/bin/env bash

key() {

    local special_keys

    [[ $1 == $'\e' ]] && {
        special_keys+=${1}
        #! debug
        printf "R 1 : %s\n" "${1}" >> logfile

        # \e A
        # \e [ A
        # \e [ 6 ~
        # \e [ 2 0 ~
        # \e [ 1 ; 5~
        # \e [ 1 ; 5C
        # -- - - - --
        #  1 2 3 4 5

        #* read 2
        read "${read_flags[@]}" -srn 1
        special_keys+=${REPLY}
        #! debug
        printf "R 2 : %s\n" "${REPLY}" >> logfile

        [[ $REPLY == $'[' ]] && {
            #* read 3
            read "${read_flags[@]}" -srn 1
            special_keys+=${REPLY}
            #! debug
            printf "R 3 : %s\n" "${REPLY}" >> logfile

            [[ ${REPLY} == [0-9] ]] && {
                #* read 4
                read "${read_flags[@]}" -srn 1
                special_keys+=${REPLY}
                #! debug
                printf "R 4 : %s\n" "${REPLY}" >> logfile
                
                [[ ${REPLY} == [[:digit:]] ]] && special_keys+="~"
                [[ ${REPLY} == ";" ]] && {
                    read "${read_flags[@]}" -srn 2
                    special_keys+=${REPLY}
                    #! debug
                    printf "R 5 : %s\n" "${REPLY}" >> logfile
                }
            }
        }
        
    }

    printf "\$1: %q\nspecial_keys: %q\n"\
            "$1"\
            "$special_keys"

    printf "%s\n" "-----------------------------"

}

read_flags=(-t 0.01)

for((;;)){
    read -t 120 -srn 1 && key "$REPLY"
}