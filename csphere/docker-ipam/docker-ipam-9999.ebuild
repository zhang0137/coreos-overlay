# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Csphere Docker IPAM"
HOMEPAGE="https://csphere.cn/"

CROS_WORKON_PROJECT="nicescale/netplugin"
CROS_WORKON_LOCALNAME="netplugin"
CROS_WORKON_REPO="git://github.com"

if [[ "${PV}" == 9999 ]]; then
    KEYWORDS="~amd64 ~arm64"
else
    CROS_WORKON_COMMIT="3c9bde188312dad74a743159ae9f250ed2424b3e"
    KEYWORDS="amd64 arm64"
fi

inherit  systemd cros-workon

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

CDEPEND="
"

DEPEND="
	>=dev-lang/go-1.3
"

RDEPEND="
"

RESTRICT="installsources strip"

src_compile() {
	rm -rf /tmp/src/github.com/nicescale/netplugin
	mkdir -p /tmp/src/github.com/nicescale/netplugin
	cp -a . /tmp/src/github.com/nicescale/netplugin/
	GIT_COMMIT=$(git rev-parse --short HEAD)
	if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  		GIT_COMMIT=${GIT_COMMIT}-dirty
	fi
	GOPATH=/tmp:/tmp/src/github.com/nicescale/netplugin/Godeps/_workspace/ \
		CGO_ENABLED=0 GOOS=linux \
		go build -a -installsuffix cgo -ldflags=" -X main.gitCommit='$GIT_COMMIT' -w" \
		-o /tmp/net-plugin || die  "build netplugin"
}

src_install() {
	newbin /tmp/net-plugin net-plugin
}