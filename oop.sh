#!/bin/bash

# Object Oriented Program Support for Bear Game

DEFCLASS=""
CLASS=""
THIS=0

class() {
        DEFCLASS="$1"
        # Init variables to hold variables and functions for the class.
        eval CLASS_${DEFCLASS}_VARS=""
        eval CLASS_${DEFCLASS}_FUNCTIONS=""
}

static() {
        return 0
}

func() {
        # Figure out the functions var so we can do stuff with it. With one called hello this would be set to:
        # CLASS_hello_FUNCTIONS
        if [ -v "funclist" ]; then
                local varname="CLASS_${DEFCLASS}_FUNCTIONS"
        else
                return
        fi
        # varname is now set to CLASS_hello_FUNCTIONSfunc assuming we had func passed to us
        # surely this should be "eval "varname=\"\${$varname}$1\"""? Unless having $ sets it again as not local.
        eval "$varname=\"\${$varname} $1\""
}

var() {
        # Figure out the functions var so we can do stuff with it. With one called hello this would be set to:
        # CLASS_hello_VARS
        local varname="CLASS_${DEFCLASS}_VARS"

        # varname is now set to CLASS_hello_VARSfunc assuming we had func passed to us
        # surely this should be "eval "varname=\"\${$varname}$1\"""? Unless having $ sets it again as not local.
        eval $varname="\"\${$varname} $1\""
}

loadvar() {
        for var in $varlist; do
            eval "$var=\"\$INSTANCE_${THIS}_$var\""
        done
}

loadfunc() {
        eval "funclist=\"\$CLASS_${CLASS}_FUNCTIONS\""
        for func in $funclist; do
            eval "${func}() { ${CLASS}::${func} \"\$*\"; return \$?; }"
        done
}

savevar() {
        eval "varlist=\"\$CLASS_${CLASS}_VARS\""
        for var in $varlist; do
            eval "INSTANCE_${THIS}_$var=\"\$$var\""
            echo "INSTANCE_${THIS}_$var=\"\$$var\""
        done
}

typeof() {
        eval echo \$TYPEOF_$1
}

new() {
        local class="$1"
        local cvar="$2"
        shift
        shift
        local id=$(uuidgen | tr A-F a-f | sed -e "s/-//g")
        eval TYPEOF_${id}=$class
        eval $cvar=$id
        local funclist
        eval "funclist=\"\$CLASS_${class}_FUNCTIONS\""
        #set -x
        for func in $funclist; do
            eval "function ${cvar}.${func}() { local t=\$THIS; THIS=$id; local c=\$CLASS; CLASS=$class; loadvar; loadfunc; ${class}::${func} \"\$*\"; rt=\$?; savevar; CLASS=\$c; THIS=\$t; return $rt; }"
        done
        eval "${cvar}.init \"\$*\" || true"
}
