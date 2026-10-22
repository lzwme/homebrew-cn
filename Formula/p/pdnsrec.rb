class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.8.tar.xz"
  sha256 "bb2fac755c3c301b6e1b9892e94ccdc652752f2bf88ec970e9358056973fe9bd"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "5db8d96c106dbb42d1cb09bdccbe0e7d28eb906a0b731078e9d7b744e7b6959a"
    sha256 arm64_tahoe:       "e02e768fc746599cf313acfa69805714355dd7793f1c55e5804869883ae19372"
    sha256 arm64_sequoia:     "d0442fd3899f9796643c8be622d77c87002782a5169dba32e38a754056f7f709"
    sha256 arm64_linux:       "bb2fc659ebc3e22e13c44ae25afc35ed473cbb51267e5c1bd5c9a2357d85eb3b"
    sha256 x86_64_linux:      "44e967f7386597489f5d71b598c6d95dd60db0b523a4c2a1dac5b3aa64c713fe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@4"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix("openssl@4")}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end