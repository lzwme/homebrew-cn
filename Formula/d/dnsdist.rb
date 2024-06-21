class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.5.tar.bz2"
  sha256 "4aee9088de5edaeff2a4104f3ea669605ae3e92e5dab9006c725f7775f6d254c"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a60ae4b4451ae3ce059596cbc6890653b5cd4f0714134e7952769f343558b630"
    sha256 cellar: :any,                 arm64_ventura:  "8964a288dd6db09cbd18af9bffc2a6e628cc10d8fef3dca7faad299ff075ebe0"
    sha256 cellar: :any,                 arm64_monterey: "87824e9e6b9dea257c4090c237b84968c16560c7e43b6b4d1adff2ee2267eb27"
    sha256 cellar: :any,                 sonoma:         "2cb279aa5d2303a8dd39a4fd9748f3e6e5cd3ea645227c1279b65c7cd03c9e34"
    sha256 cellar: :any,                 ventura:        "2814e2f0f9cb3efa49c4fa1c1fb300b8f1741e56dcd5e16e7986a552a5160a32"
    sha256 cellar: :any,                 monterey:       "1d8e2586381573a010e9f778815f87c6c3a3c64874a487fd05613923aab681c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afcd3da1b2c82c74f0c6cdc226d51610a68243440c8b35862716dbc36115513b"
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