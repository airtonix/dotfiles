#!/usr/bin/env sh
## Kindly inspired by Arkade by Alex Ellis
## https://github.com/alexellis/arkade

export VERIFY_CHECKSUM=0
export ALIAS_NAME="comtrya"
export OWNER=comtrya
export REPO=comtrya
export SUCCESS_CMD="$REPO --help"
export BINLOCATION="/usr/local/bin"


inferVersionFromLatest() {
    echo $(curl -sI https://github.com/$OWNER/$REPO/releases/latest | grep -i "location:" | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')
}

validateVersion() {
    local version=$1
    local status=$(curl -s -o /dev/null https://github.com/$OWNER/$REPO/releases/$version -w "%{http_code}")

    if [ $status != "200" ]; then
        echo "Failed while attempting to install $REPO. Please manually install:"
        echo ""
        echo "1. Open your web browser and go to https://github.com/$OWNER/$REPO/releases"
        echo "2. Download the latest release for your platform. Call it '$REPO'."
        echo "3. chmod +x ./$REPO"
        echo "4. mv ./$REPO $BINLOCATION"
        if [ -n "$ALIAS_NAME" ]; then
            echo "5. ln -sf $BINLOCATION/$REPO /usr/local/bin/$ALIAS_NAME"
        fi
        exit 1
    fi
}

hasCommand() {
    [ $(command -v $1) ] || {
        echo "You need $1 to use this script"
        exit 1
    }
}

checkHash(){

    sha_cmd="sha256sum"

    if [ ! -x "$(command -v $sha_cmd)" ]; then
    sha_cmd="shasum -a 256"
    fi

    if [ -x "$(command -v $sha_cmd)" ]; then

    targetFileDir=${targetFile%/*}

    (cd "$targetFileDir" && curl -sSL $url.sha256|$sha_cmd -c >/dev/null)

        if [ "$?" != "0" ]; then
            rm "$targetFile"
            echo "Binary checksum didn't match. Exiting"
            exit 1
        fi
    fi
}

getPackage() {
    uname=$(uname -s)
    userid=$(id -u)

    suffix=""

   version=$1

    case $uname in

    "MINGW"*)
        suffix="x86_64-pc-windows-msvc.exe"
        BINLOCATION="$HOME/bin"
        mkdir -p $BINLOCATION
        ;;

    "Darwin")
        arch=$(uname -m)
        echo $arch
        case $arch in
        "arm64")
        suffix="-aarch64-apple-darwin"
        ;;

        *)
        # We rely on Rosetta atm
        suffix="-x86_64-apple-darwin"
        ;;
        esac
    ;;

    "Linux")
        arch=$(uname -m)
        echo $arch
        case $arch in
        "x86_64")
        suffix="-x86_64-unknown-linux-gnu"
        ;;

        "aarch64")
        suffix="-aarch64-unknown-linux-gnu"
        ;;
        esac
    ;;
    esac

    targetFile="/tmp/$REPO$suffix"

    if [ "$userid" != "0" ]; then
        targetFile="$(pwd)/$REPO$suffix"
    fi

    if [ -e "$targetFile" ]; then
        rm "$targetFile"
    fi

    url=https://github.com/$OWNER/$REPO/releases/download/$version/$REPO$suffix
    echo "Downloading package $url as $targetFile"

    curl -sSL $url --output "$targetFile"

    if [ "$?" = "0" ]; then

        if [ "$VERIFY_CHECKSUM" = "1" ]; then
            checkHash
        fi

    chmod +x "$targetFile"

    echo "Download complete."

    if [ ! -w "$BINLOCATION" ]; then

            echo
            echo "============================================================"
            echo "  The script was run as a user who is unable to write"
            echo "  to $BINLOCATION. To complete the installation the"
            echo "  following commands may need to be run manually."
            echo "============================================================"
            echo
            echo "  sudo cp $REPO$suffix $BINLOCATION/$REPO"

            if [ -n "$ALIAS_NAME" ]; then
                echo "  sudo ln -sf $BINLOCATION/$REPO $BINLOCATION/$ALIAS_NAME"
            fi

            echo

        else

            echo
            echo "Running with sufficient permissions to attempt to move $REPO to $BINLOCATION"

            if [ ! -w "$BINLOCATION/$REPO" ] && [ -f "$BINLOCATION/$REPO" ]; then

            echo
            echo "================================================================"
            echo "  $BINLOCATION/$REPO already exists and is not writeable"
            echo "  by the current user.  Please adjust the binary ownership"
            echo "  or run sh/bash with sudo."
            echo "================================================================"
            echo
            exit 1

            fi

            mv "$targetFile" $BINLOCATION/$REPO

            if [ "$?" = "0" ]; then
                echo "New version of $REPO installed to $BINLOCATION"
            fi

            if [ -e "$targetFile" ]; then
                rm "$targetFile"
            fi

            ${SUCCESS_CMD}
        fi
    fi
}


hasCommand curl
version=${VERSION:=$(inferVersionFromLatest)}
validateVersion $version
getPackage $version
