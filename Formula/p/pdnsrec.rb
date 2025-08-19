class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.5.tar.bz2"
  sha256 "a8a657a7abd6e9d237cdd26753f7dcf5ccd5b8c48ac8120b08d2b8d57a1d856a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1e0efcb1c21eaca7bf16abec6eb9e43cbd17da963d4669c763189991377fa06f"
    sha256 arm64_sonoma:  "61606fb1f5606528a7dd325ee1c27642c8171de28c496e71b6b5b70ff0631ddc"
    sha256 arm64_ventura: "88d613678e19245db2a9c2b5d6a3de11b1be4a7e025b6473879da32ccc676634"
    sha256 sonoma:        "0e7e59c92403c83bb1a74d465e8b8a1dc94d8106f40eac1b596c83a0296fe76d"
    sha256 ventura:       "09acca9ba175876237546e086c418e1b47ebde35de4bcd34b36946447ef7930e"
    sha256 arm64_linux:   "d3402e71b378eca524883be055e4f5bfaef730af75486d57aff3b08d882afb32"
    sha256 x86_64_linux:  "a557ef66ec43351cd659c2936f4dea983f34dc10f77be517261866ef6cce4ac3"
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
    # Workaround for Boost 1.89.0 until fixed upstream.
    # Issue ref: https://github.com/PowerDNS/pdns/issues/15972
    ENV["boost_cv_lib_system"] = "yes"

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