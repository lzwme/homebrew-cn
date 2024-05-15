class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.5.tar.bz2"
  sha256 "02b9f053db64b32bd76ce6656cb35772c1d07a21fe0345ec13adb6f0fcfbf9ce"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "47939dff04e341ac99084c93ff96187bd6cba6d88a8ba60166fbbe8e9bc8b1f7"
    sha256 arm64_ventura:  "9e970227852149996a328b190fe2473d441f5559774836e535dbea887132c667"
    sha256 arm64_monterey: "ad21d9d8e6e29a2272e758416b89335b313e44536a0d17846f3b800183919fe8"
    sha256 sonoma:         "5ccf7ebf6e9bea12d24b0319ad8fa6a58c14a99f1204fd5cabc95f890275b134"
    sha256 ventura:        "55b27361c50a3f084058802d9ac17599a6bcfd712a3c2c4e15daf3267ec1719a"
    sha256 monterey:       "20416c045da974b9403329bb3c41269b0c79c1c695bd564e44b8aeeef5bfcdcd"
    sha256 x86_64_linux:   "e3a0c3f7e504fafc470aee78f3c4935fe8dcd6890b5f7d7cec64496c95111884"
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