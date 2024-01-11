class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.1.tar.bz2"
  sha256 "70a3b0bfde350e94cdb0746b06d06e6d2f3dc0e171be3b12caef9f3c38468ca3"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2fc47c11872c972b4b87e5f8cf2d957de84d4698985a95cc3fc6b04c60bb2d39"
    sha256 arm64_ventura:  "1ce23ac1a07aaf729b41cabcf1a08fc2afebc118fbb7c3523c7605b134f532c3"
    sha256 arm64_monterey: "2fc0e65e8cfbe906a3aefa45d91112de57b7749c3b2cf0084b00fbfd8da6b305"
    sha256 sonoma:         "416a0ae9e45a56f9c470731f4626449c654b286b02d9e6eb3f94b136df1d1a14"
    sha256 ventura:        "525911857e67b859a7a69711cee18814bb40f5d2943335c3b7190a73b851d236"
    sha256 monterey:       "ec36d2e4f14ad052fcaaf32373643eff7c24aed6deb12a16e484ff5ea7fcbb6c"
    sha256 x86_64_linux:   "2a7dc2a5ab87a352be4846411fb34e9ec87c69b524fd0d6c49ea67d947dc1edd"
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