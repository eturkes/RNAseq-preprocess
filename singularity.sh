#!/bin/sh

# Copyright 2020 Emir Turkes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Shell script for building a Singularity image from Docker Hub and running it.
# Run with "sh ./singularity.sh rstudio 8787".
# Then locally something like "ssh -N -L 8787:localhost:8787 user@ip-address".
# The ports can be set to whatever you choose.
# For more details: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
# Be sure to check images and paths.

singularity pull -n tau-vulnerability.simg docker://eturkes/rnaseq-preprocess:R3.6.3v1

if [ "$1" = "all" ]; then
    singularity exec \
        -B .:/home/rstudio/RNAseq-preprocess \
        rnaseq-preprocess.simg \
    Rscript -e "source('/home/rstudio/RNAseq-preprocess/R/run_all.R')"

elif [ "$1" = "rstudio" ]; then
    # TODO: Point bind point to user's home.
    DISABLE_AUTH=true RSTUDIO_SESSION_TIMEOUT="0" \
    singularity exec \
        -B .:/home/rstudio/RNAseq-preprocess \
        rnaseq-preprocess.simg rserver --www-address=127.0.0.1 --www-port=$2
fi
