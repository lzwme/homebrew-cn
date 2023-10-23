class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.9.1.tar.bz2"
  sha256 "0a1edc13e8f2bd661f39e316387d941e22de6a03b8a7a2fc662fdf8b942ea2be"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e1038e17c57c280d94a93256c21be0f5873a840f41358fd4f2993ad2957e3723"
    sha256 arm64_ventura:  "b1c2161d60906793f5a4f47485fd52b6eaf3a279d527dedceae8786e7a628a8f"
    sha256 arm64_monterey: "584fc0bfd46ea951a594b2336fa5c5a876997a4b623cf4a8432021f8c11a91d9"
    sha256 sonoma:         "792293879f07034ca94e686a702cc6949370c8939b430c9f44fd51e5e04598a9"
    sha256 ventura:        "6a1d7183140ab6c44deb1582c04ba087131d6170f1ae814613799ae287863588"
    sha256 monterey:       "cc5131605cf528a82bffc0f17461c09ae0a73ae8553c3fe4ff12057687211c93"
    sha256 x86_64_linux:   "f8e7add91b34550030e00e641597045c0047867efef618b063782729a44d9b1e"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end