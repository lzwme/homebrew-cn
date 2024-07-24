class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.1.1.tar.bz2"
  sha256 "5b7ab793ace822294a3f38092fe72ee64748ff0cbb8a5283dc77f40780605ae9"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ab187952eee7b8ae9fbbc6fc87da1283e29951e4804dc640f6e732c1ad31ec6c"
    sha256 arm64_ventura:  "e010b61ca330857b4c09df6c77c87477262d7fa1a798a642262085b4463fdd68"
    sha256 arm64_monterey: "653a2217994c382cdbce0a3bc8fd2d7c6a8e344a752f5855021a5f927e0571c4"
    sha256 sonoma:         "ce9698bbf9e3a718aaf5d45bc52155c2c0ab7198beadaca1a459808557766509"
    sha256 ventura:        "85d73276591928c0e7e45e1298571653722af91613b45e234557ace195163ed8"
    sha256 monterey:       "3f8dc89726b528c72775a43c4c97e66818a27e0b908a8af9e5bcb85d0eb1fb58"
    sha256 x86_64_linux:   "46231015a292c8715cdefc7db8abca694f6fb58dd4258e3f240f03361e12a36b"
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