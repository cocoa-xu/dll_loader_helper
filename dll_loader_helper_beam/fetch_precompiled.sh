#!/bin/bash

set -e

erlc checksum.erl
erlc precompiled.erl 
erl -noshell -s precompiled fetch_precompile -s erlang halt
