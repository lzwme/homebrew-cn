class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.6.tar.bz2"
  sha256 "f6c48d95525693fea6bd9422f3fdf69a77c75b06f02ed14ff0f42072f72082c9"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "79eb423b52c4b9c65c1e3915be55361e7816d4b94c2f7e778f96bf1d4a213324"
    sha256 cellar: :any,                 arm64_ventura:  "422bd193439fab5251a6eb23f925a828f90a7c25972656b4e8dab870def7d79d"
    sha256 cellar: :any,                 arm64_monterey: "c664c0516264a0c86b1859e0a71f202b5df2d24296a25b48651da6547a3f4caf"
    sha256 cellar: :any,                 sonoma:         "c6bb6b62f9571fe36b1b914813ce8f5fd2ec999a1417c1a95eb6bfd9cf3712cc"
    sha256 cellar: :any,                 ventura:        "3dd4292dff72c00ff19839af8e7de4fc971430dc96447b00084c921b3961d1b6"
    sha256 cellar: :any,                 monterey:       "dca1c8e52fd8f060ff24cc3283e8c0e7136c0d0e8caf91f5d6940ffd7e93f88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7168fd530b763386341cd6fb10546a1bb308eb00f195c119f9277d3bfcca76ce"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "tinycdb" => :build # TODO: make runtime dependency when `tinycdb` formula has a shared library
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
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