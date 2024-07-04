class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.7.tar.bz2"
  sha256 "700a825aa087f3f37888ccb65cec6291a1aa5345838af202dc19ebe5691451b9"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0b53b2309685bf21b636615f96412d9bd73e99bfd4a7a03162ec40bfd1d2ec70"
    sha256 arm64_ventura:  "25b2e0bc6859acc59cb87fac2ea457b32aaf15fb074e935815fff5e882b0042d"
    sha256 arm64_monterey: "b4ef923bce4ef897abcb87d1f983d39c8a17a32427ddd486fc53412ac64c7635"
    sha256 sonoma:         "058703afc8544f98551cd9175c0180a156fb3959929315efd0063fa07a260536"
    sha256 ventura:        "baccc8c4dd7c8658a4c3b5d949e5030be402078630ede99edaa38e06523216c2"
    sha256 monterey:       "656251f745088a92c878a82f7a2e60d8a05b7549e7752cdc7d75a1ad6b6ade89"
    sha256 x86_64_linux:   "be1bfe25c39b2cb4b29029e24670b9c68b1419a2a30970d4d6472ed176f85db9"
  end

  depends_on "pkg-config" => :build
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