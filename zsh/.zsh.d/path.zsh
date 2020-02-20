PATH="/sbin"
PATH="/bin:${PATH}"
PATH="/usr/sbin:${PATH}"
PATH="/usr/bin:${PATH}"
PATH="/usr/local/sbin:${PATH}"
PATH="/usr/local/bin:${PATH}"

PATH="${HOME}/.node_modules/bin:${PATH}"

PATH="${HOME}/.cargo/bin:${PATH}"

GOPATH="${HOME}/go"
PATH="${GOPATH}/bin:${PATH}"

export GOPATH
export PATH
