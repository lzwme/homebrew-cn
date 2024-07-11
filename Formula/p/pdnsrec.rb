class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.1.0.tar.bz2"
  sha256 "25e1614022f77e81f0b359b0b72b9ae4761ab96681f01f30168f90fa2bbbe152"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4d524e15a8e52e1150f83af94ad873c60aeb9676c451bcf43f303039b4c259fa"
    sha256 arm64_ventura:  "674225511a9c8a8f63eef4d5958e73efedb58f461d9ccd6795395d714d6d8304"
    sha256 arm64_monterey: "98be3e34869e136b91dc59c9d65620897b72e31d8af0ef4082f152f2292695df"
    sha256 sonoma:         "45fae88f41172f274e89d2ce7c5fe677fba2f5e782c187c58aaef24943474f04"
    sha256 ventura:        "3d61429b0e04cdbf2f28566dc40cd8c49c744325e63002b899f492c83ae6b811"
    sha256 monterey:       "3b240b12ba0d77a3f50c74995168e9ef0b2a7d4ed18dab2de91d6fef4167037d"
    sha256 x86_64_linux:   "7b2bade10736724718840aa11bbe66cdbf9bced1a96c6af8e8024cda714307e7"
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