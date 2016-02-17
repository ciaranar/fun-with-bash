#!/bin/bash

source oop.sh

class Stack
        func push
        func pop
        func Print
        var stack

stack::init() {
    # Add function but don't do anything
    return;
}

Stack::push() {
    stack+=($1);
}

Stack::Print() {
    for item in "${stack[@]}"; do
        echo $item
    done
}

Stack::pop() {
    unset queue[${#stack[@]}-1];
}
