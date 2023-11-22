class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-5.9.12.tar.bz2"
  sha256 "5e6018b07cbe9f72c044c129955a13be3e2f799ceb53f53a4459da6a922b95e5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fab57b0b3e6639f20c6179be80f80e196da39837d3f0da9387a996fcd3f05902"
    sha256 arm64_ventura:  "0d1b1df6a38f8ce5f1b0bf177870a10050c3fe83fbc30f2df0b5601d3ad5fdad"
    sha256 arm64_monterey: "4f091357a3605407fa21c67d7bfe8a33c8fde0e0533693cbaa8a229829db50b6"
    sha256 sonoma:         "323317604cedd0d17cdcca98b0ebab814698e0ddd7d535eb8bec4533280a36c9"
    sha256 ventura:        "4110a6d80502e03b0c8c70fc3eb947dad6f18112d749ac6e5191f53ec1e30732"
    sha256 monterey:       "f08274f86e60222c1b267f9f4d5bc72928b89ffe0bf7e5ec282939e33f620a9b"
  end

  head do
    url "https://github.com/strongswan/strongswan.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "openssl@3"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --disable-defaults
      --enable-charon
      --enable-cmd
      --enable-constraints
      --enable-curve25519
      --enable-eap-gtc
      --enable-eap-identity
      --enable-eap-md5
      --enable-eap-mschapv2
      --enable-ikev1
      --enable-ikev2
      --enable-kernel-pfkey
      --enable-nonce
      --enable-openssl
      --enable-pem
      --enable-pgp
      --enable-pkcs1
      --enable-pkcs8
      --enable-pkcs11
      --enable-pki
      --enable-pubkey
      --enable-revocation
      --enable-scepclient
      --enable-socket-default
      --enable-sshkey
      --enable-stroke
      --enable-swanctl
      --enable-unity
      --enable-updown
      --enable-x509
      --enable-xauth-generic
    ]

    args << "--enable-kernel-pfroute" << "--enable-osx-attr" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
  end

  test do
    system "#{bin}/ipsec", "--version"
    system "#{bin}/charon-cmd", "--version"
  end
end