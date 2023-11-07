class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.2.tar.bz2"
  sha256 "6688f09b2c52f9bf935f0769f4ee28dd0760e5622dade7b3f4e6fa3776f07ab8"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b39d54cc8879b6feab5254d55b7dbb3d56d7d1ab60ca48229bdf2f6504075f2"
    sha256 cellar: :any,                 arm64_monterey: "cf91fd0c9e8d5e21f9e15cf4c5219a6e9c8cd2b066baa7cb355428ee9c6ba26f"
    sha256 cellar: :any,                 ventura:        "acb7efa3d1f9cd9f3cc0fb137d23446fa252d111f2b404118ef1c59922a5933a"
    sha256 cellar: :any,                 monterey:       "a7c2db4f4fadd3e21a26307230f17f67887b7fc6414b2788fefcf1775d0f6ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d891fba445586bbaf6e65967e6bd0bd92607e3f94883957923417eb8e68d534"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end