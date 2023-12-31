#!&PREFIX/bin/ sh

if ! hash wget > /dev/null
then
    apt install wget -y
fi

print_status() {
    printf "(>) ${1}...\n"
}

set_arch() {
    case "$(uname -m)" in
        aarch64|armv8l)
            ARCH=aarch64
            ;;
        armv7l|arm)
            ARCH=arm
            ;;
        *)
            printf "(!) Your device architecture not supported yet.\n"
            exit 1
            ;;
    esac
}

get_tar() {
    wget -q --show-progress -c https://github.com/Hax4us/java/releases/download/v8/jdk-17.0.8_linux-${ARCH}_bin.tar.gz -O jdk-17.0.8_linux-${ARCH}_bin.tar.gz
    tar -xf jdk-17.0.8_linux-${ARCH}_bin.tar.gz -C $PREFIX/share 
    chmod +x $PREFIX/share/bin/*
}

get_java()
{
cat <<- CONF > $PREFIX/bin/java
#!/usr/bin/bash

unset LD_PRELOAD
export JAVA_HOME="$PREFIX/share/jdk-17.0.8"

export LIB_DIR="\$PREFIX/share/glib"
export LD_LIBRARY_PATH="\$LIB_DIR"
exec proot -0 \$JAVA_HOME/bin/java "\$@"
CONF
}

cleanup() {
    rm -f jdk-17.0.8_linux-${ARCH}_bin.tar.gz
    rm -rf $PREFIX/share/bin
}

set_arch
print_status "Getting system architecture"
get_tar
print_status "Extracting tar files to specific directory"
print_status "Setting up java program for execution"
get_java
print_status "Cleaning up unwanted files"
cleanup
