#!/bin/bash

function _heap_print() {
  local -n _hp=${1}
  echo "Heap:"
  echo "  Size: ${_hp[0]}"
  if [ ${_hp[0]} -eq 0 ]; then
    echo "  Array: []"
  else
    echo "  Array: [ ${_hp[@]:1} ]"
  fi
}

function _heap_swap() {
  local -n _hs=${1}
  local tmp=${_hs[$2]}
  _hs[$2]=${_hs[$3]}
  _hs[$3]=${tmp}
}

function _heap_move_down() {
  local -n _hmd=${1}
  local i=$2
  while true; do
    [ $i -lt ${_hmd[0]} ] || break
    local it=$i
    local il=$(($i*2))
    [ $il -le ${_hmd[0]} ] && [ ${_hmd[$il]} -lt ${_hmd[$it]} ] && it=$il
    local ir=$(($i*2+1))
    [ $ir -le ${_hmd[0]} ] && [ ${_hmd[$ir]} -lt ${_hmd[$it]} ] && it=$ir
    [ $it -ne $i ] || break
    _heap_swap _hmd $it $i
    i=$it
  done
}

function _heap_move_up() {
  local -n _hmu=$1
  local idx=$2
  while true; do
    [ $idx -gt 1 ] || break
    local pidx=$(($idx/2))
    [ ${_hmu[$idx]} -lt ${_hmu[$pidx]} ] || break
    _heap_swap _hmu $idx $pidx
    idx=$pidx
  done
}

function heap_new_empty() {
  local -n _hne=${1}
  _hne=(0)
}

function heap_from_array() {
  local -n _hfa=${1}
  local -n _arr=${2}
  _hfa[0]=${#_arr[@]}
  _hfa+=(${_arr[@]})
  for i in $(seq ${_hfa[0]} -1 1); do
    _heap_move_down _hfa $i
  done
}

function heap_push() {
  local -n _hpu=${1}
  _hpu[0]=$((${_hpu[0]}+1))
  _hpu+=($2)
  _heap_move_up _hpu ${_hpu[0]}
}

function heap_pop() {
  local -n _hpo=${1}
  _heap_swap _hpo 1 ${_hpo[0]}
  _hpo[0]=$((${_hpo[0]}-1))
  _heap_move_down _hpo 1
}

function heap_min() {
  local -n _hpmin=${1}
  echo ${_hpmin[1]}
}

function heap_size() {
  local -n _hsz=${1}
  echo ${_hsz[0]}
}

function heap_sort() {
  local -n _arrso=${1}
  local h
  heap_from_array h _arrso
  _arrso=()
  while [ $(heap_size h) -gt 0 ]; do
    _arrso+=($(heap_min h))
    heap_pop h
  done
}

