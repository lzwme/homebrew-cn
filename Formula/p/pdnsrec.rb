class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.1.3.tar.bz2"
  sha256 "c34ee31f522d93997e04ab2ed0fb58de6569c13ed2a2cb0d371cef49a585356a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e383abc5481a4ef2fc62605eefa93b1f0eaaaced020b1a85bb5b13374bd1809e"
    sha256 arm64_sonoma:  "92abc803c18759503c791b4e7346ddc8771f97c9f3eb12a3421fe45317f5cc0c"
    sha256 arm64_ventura: "ed055ddba61317436ac6ea7dbd0f8e7c79573ce51580191aeb788799b05d64db"
    sha256 sonoma:        "1d5997b80cdb4027cc16329795cb80add0d73338a37cc6cf0a8e2797d85b7775"
    sha256 ventura:       "021af070993c716c04551302b7a099561c0f78099bac154dfe23dd4ff562d1b3"
    sha256 x86_64_linux:  "d3a588660ed82024630a7324d93e21260125c212d2dc2ad028abbed86ca0263f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

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