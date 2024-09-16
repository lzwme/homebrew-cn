class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https:www.dnsdist.org"
  url "https:downloads.powerdns.comreleasesdnsdist-1.9.6.tar.bz2"
  sha256 "f6c48d95525693fea6bd9422f3fdf69a77c75b06f02ed14ff0f42072f72082c9"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https:downloads.powerdns.comreleases"
    regex(href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ccb35078f29e90eb19b7fc128861ed883291c38b7f714a1c5c95dae5268d2af3"
    sha256 cellar: :any,                 arm64_sonoma:  "e893a3ef8e07c8ada4afd24f1e2b456cd70d7fdffcb8f23bafb173e0098f441e"
    sha256 cellar: :any,                 arm64_ventura: "eaef182437926870e9cf03be54d9c6d59d248d67747e63e3dd69da25a11359b5"
    sha256 cellar: :any,                 sonoma:        "5bd99ac15d85fcc7927412108ba844c132285c27bc017584a6617b08eff7147c"
    sha256 cellar: :any,                 ventura:       "6a14fbefe30439b1db6155564f625c939a87cf36ebc0eaa7601367f89d3a282c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32770e8c9fbbcf3267ccb182dfcce8e99c20cc19afb4c036a048abbfa5f992e4"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  # Fix build with boost 1.86.0. Remove in next release
  patch :p2 do
    url "https:github.comPowerDNSpdnscommita1026f0c6db7b077d1180096a84f48a85a606d59.patch?full_index=1"
    sha256 "8c8e4dd81af366fdd08182b5f242a054188d46c8ab955ae19843ac64c2f2044f"
  end

  def install
    system ".configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end