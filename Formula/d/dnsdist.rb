class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.2.tar.bz2"
  sha256 "6fbc10c0cae01a8a177bbbf27b037791e2dc7093902478af529881101afbfc0a"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4e1f5d972080aa1e2ab4134281456feefdb0b126fbc7ad3529aeeb316f754c7"
    sha256 cellar: :any,                 arm64_ventura:  "13421109dddbeec15b1c5378997c2a7c3d728eb65ccf73ca514d11b1675257f6"
    sha256 cellar: :any,                 arm64_monterey: "6e465199310b89182be24974ec20544dca5a92db6425cf2e4a339c4dd655e778"
    sha256 cellar: :any,                 sonoma:         "653b307747ba5b78f24b9ce14bc1959fd2a18b2fcb03d26d211b705b730382f4"
    sha256 cellar: :any,                 ventura:        "d84fdd09632810ce982d13074087c5ec62bd89440f3a201b8ec88a4f2b630a86"
    sha256 cellar: :any,                 monterey:       "07399ed4826d99e0156e19eedceaf9ed719fb426a451d5906fbb11a50f42afc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d2c05456fe391f76f23f1544b5f73504de00a55b208efdc3e581374f7ae62e1"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end