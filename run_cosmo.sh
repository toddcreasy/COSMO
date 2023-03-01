#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

nextflow run $DIR/cosmo/main.nf $*
