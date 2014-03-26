#!/bin/bash
# Installs GDAL java bindings
# Must be run as root

local_lib_path="/usr/local/lib"

gdal_git_branch="trunk"
gdal_git_url="https://github.com/OSGeo/gdal.git"
gdal_git_path="`pwd`/gdal"

java_path="/usr/lib/jvm/java-7-openjdk-i386"
java_bindings_path="$gdal_git_path/gdal/swig/java"
java_version="java-1.7.0-openjdk-i386"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Install system packages
apt-get update
apt-get install -q -y ant git libproj-dev openjdk-7-jdk python-dev swig

# Download GDAL source from git
git clone -b $gdal_git_branch $gdal_git_url

# Build GDAL with support for java bindings
cd $gdal_git_path/gdal
./configure
make
make install

# Modify java.opt file for building java bindings
cd $java_bindings_path
sed -i "1s/.*/JAVA_HOME=$java_path/" java.opt

# Set proper java version
update-java-alternatives -s $java_version

# Build java bindings
make

# Install java bindings
cp *.so $local_lib_path

# Run gdalinfo as a test
java -Djava.library.path="$local_lib_path" -classpath gdal.jar:build/apps gdalinfo
