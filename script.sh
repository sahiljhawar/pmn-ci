#!/bin/bash

# Set up environment variables
export FC=$(which gfortran)
export CC=$(which gcc)
export CXX=$(which g++)

# Install dependencies
# conda install -c conda-forge c-compiler numpy matplotlib scipy
brew install openmpi gcc openblas lapack cmake

# conda install -c conda-forge mpi4py

# Install MultiNest
git clone https://github.com/JohannesBuchner/MultiNest
cd MultiNest/build
rm -rf *
cmake -DCMAKE_C_COMPILER=$(which gcc) -DCMAKE_CXX_COMPILER=$(which g++) -DCMAKE_C_FLAGS="-arch arm64" -DCMAKE_CXX_FLAGS="-arch arm64" ..
make
cd ../..
echo  "check files $(ls -l $HOME/notebooks/pmn-ci/MultiNest/)"
export LD_LIBRARY_PATH=$HOME/notebooks/pmn-ci/MultiNest/lib:$LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$HOME/notebooks/pmn-ci/MultiNest/lib:$DYLD_LIBRARY_PATH

# Install Pymultinest
python -V
python -m pip install --upgrade pip
pip install pymultinest corner

# Install mpi4py
python -c 'import mpi4py'

# Test imports
python -c 'import pymultinest'
rm -rf chains/

# Get PMN
git clone https://github.com/JohannesBuchner/PyMultiNest.git

# Run MPI tests
echo "Running tests"
python PyMultiNest/pymultinest_demo_minimal.py
python PyMultiNest/pymultinest_demo.py

# Run long filename test
python PyMultiNest/tests/pymultinest_long_name_test.py
