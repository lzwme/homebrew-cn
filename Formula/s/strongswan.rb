class Strongswan < Formula
  desc "VPN based on IPsec"
  homepage "https://www.strongswan.org"
  url "https://download.strongswan.org/strongswan-6.0.1.tar.bz2"
  sha256 "212368cbc674fed31f3292210303fff06da8b90acad2d1387375ed855e6879c4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.strongswan.org/"
    regex(/href=.*?strongswan[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "e985909f77f15b306013dd82941e3e7e27865795955a16b19f09d5320763f38d"
    sha256 arm64_sonoma:  "66e75131ae4a46b25fd40cb9cd2fd7dee7713f6d41b711af5d636a45d474df4d"
    sha256 arm64_ventura: "04be533d4f1a6bc0ed63d4bba854e4087f4b8afca6745850be4095b263366bbb"
    sha256 sonoma:        "62a7f02ff94d392ff6c96a7000972e2c1d4f234b5950f92fd70a219afdcf96fa"
    sha256 ventura:       "4a13f63e4aa18d48c7154a5771fa6ea1cdf440cf4d4fecdc6222f5288df8f55b"
    sha256 arm64_linux:   "8617eb00446e840c420a9fbab06cacc0724f04c9c867a229af29495345dea578"
    sha256 x86_64_linux:  "bd322cdce36f46f31fdcb827b97b60ba30df1db7abb18e979eb59c36c504747a"
  end

  head do
    url "https://github.com/strongswan/strongswan.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "curl"

  def install
    # Work around RPATH modifications corrupting binary. Upstream patchelf fixed this issue
    # https://github.com/NixOS/patchelf/issues/315 but it may be missing in patchelf.rb
    ENV.append_path "HOMEBREW_RPATH_PATHS", libexec if OS.linux?

    args = %W[
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
      --enable-kdf
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
      --enable-curl
    ]

    args << "--enable-kernel-pfroute" << "--enable-osx-attr" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      You will have to run both "ipsec" and "charon-cmd" with "sudo".
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsec --version")
    assert_match version.to_s, shell_output("#{bin}/charon-cmd --version")
  end
end