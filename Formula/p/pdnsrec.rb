class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.7.tar.xz"
  sha256 "02247a1e633ea1ae8777f933854ff3d0ed024d4e5c01c143af146a0783c7ccf4"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "462d87e0e6a4c0633b1294da881bfb969e58c4ea289069a8aa539f4380c50bec"
    sha256 arm64_tahoe:       "1e2486d07781b140fda05303cf73e5264eca7a0571a7ac5c52a4bcc66c57e4e9"
    sha256 arm64_sequoia:     "2d2ebf2cbb7c428f0bc471216241cff254f7a621d53bbde3a7c8917df9668aed"
    sha256 arm64_linux:       "5b7415824fa4f698eb3d54a305693b511beb4daa94bcad742f3ed2ddf462f02c"
    sha256 x86_64_linux:      "383958d77535979cc8585ccdb16f3522d2b3d0a05c830769a300e6095b48a6ca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
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