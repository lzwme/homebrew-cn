class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.0.tar.xz"
  sha256 "6b9f85b6df17c339cbff448d9824bee6da6a5cf884abd99835d1dafdccdda0e6"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b1eb204ba5badae13514fb5306c443df3a6aa0d99a96f7cd2f17062483933201"
    sha256 arm64_sequoia: "a48c04c065ce45f9e4e9fff9540317701482cfe85260d21a2fa1989b826af4e1"
    sha256 arm64_sonoma:  "b1eaf4b034e953c9eb323b7c93f35cdffa425bba433c8caf5652e486777ba141"
    sha256 sonoma:        "2114a01bd1542640120c895854bc780b18388b1ccda2c2e344a7e9ae6c4291e0"
    sha256 arm64_linux:   "ca9f5534c1c0d8eb5c73e482acb23a0a438bf89dc032d4cb6215814c775b35a7"
    sha256 x86_64_linux:  "d75a475b665395141db5d42726abd61c904b379bd500fa352b4df7a7ad7f031f"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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