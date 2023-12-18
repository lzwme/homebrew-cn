class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https:www.wolfssl.com"
  url "https:github.comwolfSSLwolfssl.git",
      tag:      "v5.6.4-stable",
      revision: "37884f864d6fd9b04f44677cb04da15d0c9d6526"
  license "GPL-2.0-or-later"
  head "https:github.comwolfSSLwolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+)[._-]stablei)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "007d4ddf18f960ecb4f68a21cf32af5d3d2c03ca32a1c00bfb2ffdf36391ca57"
    sha256 cellar: :any,                 arm64_ventura:  "a8e42fe1857726571e6c9c96a419e420cbd50bf4c2187ffce5ec1acfd3506e20"
    sha256 cellar: :any,                 arm64_monterey: "0f9cad5024441d378000218c740c70c85aa563848c2dde7394aa588bc4a37d53"
    sha256 cellar: :any,                 sonoma:         "d93e301a5b44e519725a10363778fc2ebf24ea62d1703a3728efcf4b1a0ccbd8"
    sha256 cellar: :any,                 ventura:        "95b918b60dabe425bd9e01b2dce8d7158050e5916c5ce1cb889e4a4f3a06d0b7"
    sha256 cellar: :any,                 monterey:       "e834f400971353cd70f8a9cf09a7227d1c8423e66f4ed299da2b6310e144d780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc553edf10a54fd40dc2f00c9f902ebcd1a76a45c7574c71f86b008c25f6279e"
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