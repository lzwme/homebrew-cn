class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https:www.wolfssl.com"
  url "https:github.comwolfSSLwolfssl.git",
      tag:      "v5.7.0-stable",
      revision: "8970ff4c34034dbb3594943d11f8c9d4c5512bd5"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comwolfSSLwolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+)[._-]stablei)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8671c05a8465056ffbdc5a87296f5249893a1266fd9c8a47e08f87665f389137"
    sha256 cellar: :any,                 arm64_ventura:  "813adbbc241825a546600e5979d735e35c66650e5b10e65a72ccb9df215ddad0"
    sha256 cellar: :any,                 arm64_monterey: "ced44d6feb28ef0d5b333b9a55a70cd8585c1d4f2c03feba2d42953fb6bd7bac"
    sha256 cellar: :any,                 sonoma:         "508a6def8973c2a78258367aa2ac006d5273beb0ee47a7b811fb645f0bb4d36e"
    sha256 cellar: :any,                 ventura:        "f75479122307d1e9bc07189b31a5ea42deae5fef3c63fdae00f3937e125ad3f5"
    sha256 cellar: :any,                 monterey:       "61411684303a254b166bfb7cc790a890a7b5ba17eb2100defcfc44498f50766a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5417bf3989db7d5e39ce37f14aaf3b45a295b17e0dd6a160dc3ae4e04bc364a4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "util-linux" => :build

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-aesgcm-stream
      --enable-alpn
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-curve25519
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ed25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-ipv6
      --enable-jni
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-quic
      --enable-rabbit
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
      --enable-tls13
      --enable-sp
      --enable-fastmath
      --enable-fasthugemath
    ]

    if OS.mac?
      # Extra flag is stated as a needed for the Mac platform.
      # https:www.wolfssl.comdocswolfssl-manualch2
      # Also, only applies if fastmath is enabled.
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

    system ".autogen.sh"
    system ".configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end