#!/bin/bash

nextflow run bzhanglab/COSMO --d1_file cosmo/example_data/test_pro.tsv --d2_file cosmo/example_data/test_rna.tsv --cli_file cosmo/example_data/test_cli.tsv --cli_attribute gender,msi --genes cosmo/example_data/genes.human.tsv --outdir output
