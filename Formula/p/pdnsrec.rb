class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.9.2.tar.bz2"
  sha256 "4cb8180458ecfb528a3d9a34ba2844b6cd2ed69ca1c461dde24a0ebd66829144"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "78329c3e2d520b19f4e7fc2dd26b4213642c38dac10183a75784ce0fd7c571f5"
    sha256 arm64_ventura:  "d9dbb7648a26d2c702d0828f228d60279eb5542a563774462ea9e065b833c9f2"
    sha256 arm64_monterey: "bccbfe0862ae00ea431e1531d337188fc854ad3b61135841ebe8d99dd1623160"
    sha256 sonoma:         "a41780de95da61600d41eb4cb528fb09d67480ce29f24eb9041692ec7707e005"
    sha256 ventura:        "d3aa9cbf485a80a23c8ab77f0fe96935a7035f02e78e284c0146ffb9e80f1a30"
    sha256 monterey:       "887efacd2ac572679a406b3f1a49e0c180ed6ab65198a129e6d72a9a8f8e38fa"
    sha256 x86_64_linux:   "17c4e1b983b2db7a96ab41143b2567837de6b50be06b3745961559290f295d21"
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