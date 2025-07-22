class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.4.tar.bz2"
  sha256 "d28731b5560ca4389f566c281f40f96ca397183b1d73521ff0d5980dcb01a190"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3d92189b498adb1248c61479612a023cb968412df831251c4ca1355b75072cfe"
    sha256 arm64_sonoma:  "3a76a61358d6ada03f16e28677b8176453c92698ca1f46645e4886316641b459"
    sha256 arm64_ventura: "acb2319efe1f02573049a366bf8d43e02d5dbb3f6cce03341f85d19f750092bf"
    sha256 sonoma:        "a006ceab96bfdda0e6dfa8aba7492fc956562ba867fbf51e6917c028b89bc7cb"
    sha256 ventura:       "68ebe7a6e162c95b60a915491dcb04ac22c982f5e2c9468b3c9b5a43b105a634"
    sha256 arm64_linux:   "b9ac8649376b04ad87247ffcfd7e4830747e589370b76ddbb4d1e817bcd9b868"
    sha256 x86_64_linux:  "62eac23692d55dfea5df3ba1ab747954e8af80d0cba72b03c5aacad5ac82da1a"
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