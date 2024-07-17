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
    sha256 cellar: :any,                 arm64_sonoma:   "589214929847369c0730f11d568c5f25250fc6f1c87919be631f15e49d9db07d"
    sha256 cellar: :any,                 arm64_ventura:  "b52110d6639296ca40cf444c1e0e5ae6c7760729f2bc57ece278f25aab9050e5"
    sha256 cellar: :any,                 arm64_monterey: "a45cf4f07cbe8ee7d65d85744061a066bb507b3a78155426e8594d7bfd90222e"
    sha256 cellar: :any,                 sonoma:         "ea230e5c6fea39057fb3db53bb703c1089130544165f81b5ada82174a82da041"
    sha256 cellar: :any,                 ventura:        "efba84e59f8cb0a74342139979e49559801aa1516e8a17bd9165c1afa8b5b055"
    sha256 cellar: :any,                 monterey:       "3682d43176077c130a78e588565d9fceaf92e4c2d2b6de464f0bf27112f9d27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55021557883edbb9a2b4608fab76079dfd561ef072a694ef2b7dfe3d88bd72e7"
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