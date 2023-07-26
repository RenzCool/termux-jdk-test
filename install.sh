#!/data/data/com.termux/files/usr/bin/bash

#Setup
set -e
shopt -s expand_aliases
alias ee='echo -e'

#Greetings
echo
ee "\e[93mThis script will install Java in Termux."
ee "\e[93mLibraries compiled by \e[32mRenz\e[93m, script written by \e[32mRenz \e[93mand \e[32mMyself\e[93m."
echo

#Checking for existing Java installation
if [ -e $PREFIX/bin/java ]
then
	ee "\e[32mJava is already installed!"
	echo
	exit
else
	#Checking, whether is someone trying to cheat and simplyfy their installation it on Linux (i.e. x86 (not listad, as you can see) machine) using this script, which have no reason to work.
	case `dpkg --print-architecture` in
	aarch64)
		archname="aarch64"; tag="v17.0.8" ;;
	arm64)
		archname="aarch64"; tag="v17.0.8" ;;
	armhf)
		archname="arm"; tag="v17.0.8" ;;
	armv7l)
		archname="arm"; tag="v17.0.8" ;;
	arm)
		archname="arm"; tag="v17.0.8" ;;
	*)
		ee "\e[91mERROR: Unknown architecture."; echo; exit ;;
	esac

	#Actual installation
	ee "\e[32m[*] \e[34mDownloading JDK-17 (~173Mb) for ${archname}...  🕛This will take some time, so better make a coffee.🕛"
	wget https://github.com/RenzCool/termux-jdk-test/releases/download/${tag}/jdk-17.0.8_linux${archname}_bin.tar.gz -q

	ee "\e[32m[*] \e[34mMoving JDK to system..."
	mv jdk-17.0.8_linux${archname}_bin.tar.gz $PREFIX/share

	ee "\e[32m[*] \e[34mExtracting JDK..."
	cd $PREFIX/share
	tar -xhf jdk-17.0.8_linux${archname}_bin.tar.gz

	ee "\e[32m[*] \e[34mSeting-up %JAVA_HOME%..."
	export JAVA_HOME=$PREFIX/share/jdk-17.0.8
	echo "export JAVA_HOME=$PREFIX/share/jdk-17.0.8" >> $HOME/.profile

	ee "\e[32m[*] \e[34mCoping Java wrapper scripts to bin..."
	#I'm not 100% sure, but getting rid of bin contnent MAY cause some issues with %JAVA_HOME%, thus it's no longer moved - copied instead. Sorry to everyone short on storage.
	cp bin/* $PREFIX/bin

	ee "\e[32m[*] \e[34mCleaning up temporary files..."
	rm -rf $HOME/install.sh
	rm -rf $PREFIX/share/jdk-17.0.8_linux${archname}_bin.tar.gz
	rm -rf $PREFIX/share/bin

	echo
	ee "\e[32mJava was successfully installed!\e[39m"
	echo "Enjoy your new, tasty Java :D (and a coffee, if you didn't drink it yet)"
	echo
fi
